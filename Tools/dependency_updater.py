#!/usr/bin/env python3
"""Reusable helpers for updating an ImageMagick dependency to a new release.

A dependency specific script (Dependencies/<name>/.ImageMagick/update.py)
creates an Updater and passes it a list of Step objects. Each step performs
some work and can ask the user to create a commit before continuing.

Only the Python standard library is used.
"""
import datetime
import json
import os
import re
import shutil
import stat
import subprocess
import sys
import tarfile
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request
import zipfile
from pathlib import Path, PurePosixPath

BUILD_FOLDER = "__build"
KEEP_ENTRIES = (".git", ".ImageMagick")


class UpdateError(Exception):
    pass


class Step:
    """A single action of an update.

    action is called with the Updater instance. When commit_message is set
    the user is asked to commit the changes in commit_repo (default: the
    dependency repository) and the message is copied to the clipboard. When
    wait is True the script waits until the commit has been made before the
    next step is started. The message can contain {version}, {release_date}
    and {name} placeholders.
    """

    def __init__(self, title, action, commit_message=None, commit_repo=None, commit_paths=None,
                 wait=True):
        self.title = title
        self.action = action
        self.commit_message = commit_message
        self.commit_repo = commit_repo
        self.commit_paths = commit_paths
        self.wait = wait


class Updater:
    def __init__(self, script_file, name, url=None):
        self.imagemagick_dir = Path(script_file).resolve().parent
        self.dependency_dir = self.imagemagick_dir.parent
        self.name = name
        self.url = url
        self.root_dir = Path(__file__).resolve().parent.parent
        self.build_dir = self.dependency_dir / BUILD_FOLDER
        self.version = None
        self.release_date = None

    # ------------------------------------------------------------------ run

    def run(self, steps):
        try:
            self.version = _read_input("Version: ", _is_version)
            default_date = self._find_release_date()
            if default_date:
                self.release_date = _read_input(f"Release date (YYYY-MM-DD) [{default_date}]: ",
                    _is_date, default_date)
            else:
                self.release_date = _read_input("Release date (YYYY-MM-DD): ", _is_date)

            print()
            print(f"Updating {self.name} to {self.version} (released {self.release_date})")
            print(f"Dependency folder: {self.dependency_dir}")

            self._ensure_clean(self.dependency_dir)

            for index, step in enumerate(steps, start=1):
                print()
                print(f"=== Step {index}/{len(steps)}: {step.title}")
                step.action(self)
                self.apply_checkout_line_endings()

                if step.commit_message:
                    self.request_commit(
                        self._format(step.commit_message),
                        step.commit_repo or self.dependency_dir,
                        step.commit_paths,
                        step.wait)
        except UpdateError as e:
            print()
            print(f"ERROR: {e}")
            sys.exit(1)
        except (KeyboardInterrupt, EOFError):
            print()
            print("Aborted.")
            sys.exit(1)

        print()
        print(f"Finished updating {self.name} to {self.version}.")

    def _format(self, text):
        return text.format(version=self.version, release_date=self.release_date, name=self.name)

    def _find_release_date(self):
        """Returns the date of the GitHub release, or of the tag when there is no release.
        For googlesource.com (gitiles) urls the date of the tag is used."""
        if not self.url:
            return None
        gitiles = re.match(r"(https://[^/]+\.googlesource\.com/.+?)/\+archive/(.+?)\.tar\.gz$",
            self._format(self.url))
        if gitiles:
            return self._find_git_tag_date(gitiles.group(1), gitiles.group(2))
        match = re.match(
            r"https://github\.com/([^/]+)/([^/]+)/(?:archive/refs/tags/(.+?)\.(?:tar\.gz|tar\.xz|zip)"
            r"|releases/download/([^/]+)/)",
            self._format(self.url))
        if not match:
            return None
        repo = f"{match.group(1)}/{match.group(2)}"
        tag = urllib.parse.quote(match.group(3) or match.group(4), safe="")
        print(f"Looking up the release date of {repo} {urllib.parse.unquote(tag)}")
        try:
            release = _github_api(f"repos/{repo}/releases/tags/{tag}")
            if release and release.get("published_at"):
                return release["published_at"][:10]
            ref = _github_api(f"repos/{repo}/git/ref/tags/{tag}")
            if not ref:
                return None
            obj = ref["object"]
            if obj["type"] == "tag":
                tag_object = _github_api(f"repos/{repo}/git/tags/{obj['sha']}")
                if tag_object.get("tagger"):
                    return tag_object["tagger"]["date"][:10]
                obj = tag_object["object"]
            commit = _github_api(f"repos/{repo}/git/commits/{obj['sha']}")
            return commit["committer"]["date"][:10]
        except (OSError, KeyError, TypeError, ValueError) as e:
            print(f"Unable to find the release date: {e}")
            return None

    def _find_git_tag_date(self, repo_url, tag):
        """Fetches only the tag (no trees) into a temporary repository and returns its date."""
        print(f"Looking up the release date of {repo_url} {tag}")
        ref = f"refs/tags/{tag}"
        with tempfile.TemporaryDirectory() as temp_dir:
            try:
                self.git("init", "--quiet", cwd=temp_dir)
                self.git("fetch", "--quiet", "--depth=1", "--filter=tree:0", "--no-tags",
                    repo_url, f"{ref}:{ref}", cwd=temp_dir)
                date = self.git("for-each-ref", "--format=%(taggerdate:short)", ref, cwd=temp_dir)
                if not date:
                    date = self.git("log", "-1", "--format=%cd", "--date=short", ref, cwd=temp_dir)
                return date or None
            except UpdateError as e:
                print(f"Unable to find the release date: {e}")
                return None

    # ------------------------------------------------------------------ git

    def git(self, *args, cwd=None):
        result = subprocess.run(["git", *args], cwd=cwd or self.dependency_dir,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if result.returncode != 0:
            raise UpdateError(f"git {' '.join(args)} failed:\n{result.stderr.strip()}")
        return result.stdout.strip()

    def apply_checkout_line_endings(self, repo=None):
        """Gives the files the line endings of a git checkout with the git settings of the
        user (core.autocrlf and .gitattributes). Uses a temporary index, the index and
        branch of the repository are not changed."""
        repo = Path(repo or self.dependency_dir)
        listed = subprocess.run(["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
            cwd=repo, stdout=subprocess.PIPE, check=True).stdout
        paths = [p for p in dict.fromkeys(listed.split(b"\0")) if p and (repo / os.fsdecode(p)).is_file()]
        if not paths:
            return

        with tempfile.TemporaryDirectory() as temp_dir:
            changed = self._checkout_line_endings(repo, paths, temp_dir)
        if changed:
            print(f"Applied the git checkout line endings to {changed} file(s)")

    def _checkout_line_endings(self, repo, paths, temp_dir):
        changed = 0
        try:
            env = dict(os.environ, GIT_INDEX_FILE=os.path.join(temp_dir, "index"))
            subprocess.run(["git", "-c", "core.safecrlf=false", "update-index", "--add", "-z", "--stdin"],
                cwd=repo, env=env, stderr=subprocess.DEVNULL,
                input=b"\0".join(paths) + b"\0", stdout=subprocess.DEVNULL, check=True)
            checkout_dir = Path(temp_dir, "checkout")
            checkout_dir.mkdir()
            subprocess.run(["git", "checkout-index", "--all", "--force",
                f"--prefix={checkout_dir.as_posix()}/"],
                cwd=repo, env=env, check=True)
            for path in paths:
                name = os.fsdecode(path)
                content = Path(checkout_dir, name).read_bytes()
                target = repo / name
                if target.read_bytes() != content:
                    _write(target, content)
                    changed += 1
        except subprocess.CalledProcessError as e:
            raise UpdateError(f"unable to apply the git checkout line endings: {e}")
        return changed

    def force_add(self, *paths):
        """Stages files that are ignored by .gitignore."""
        for path in paths:
            print(f"Adding {path} to git (ignored by .gitignore)")
        self.git("add", "--force", "--", *paths)

    def _status(self, repo, paths=None):
        return self.git("status", "--porcelain", "--", *(paths or ["."]), cwd=repo)

    def _ensure_clean(self, repo):
        if self._status(repo):
            raise UpdateError(f"{repo} has uncommitted changes, commit or stash them first.")

    def request_commit(self, message, repo=None, paths=None, wait=True):
        repo = Path(repo or self.dependency_dir)
        if not self._status(repo, paths):
            print("No changes detected, nothing to commit.")
            return

        print()
        if _copy_to_clipboard(message):
            print("Please commit the changes, the commit message has been copied to your clipboard:")
        else:
            print("Please commit the changes with the following commit message:")
        print(message)
        if not wait:
            return

        while True:
            input("Press Enter when the commit has been made...")
            pending = self._status(repo, paths)
            if not pending:
                return
            print("There are still uncommitted changes:")
            print(pending)

    # --------------------------------------------------------------- source

    def download(self, url):
        url = self._format(url)
        file_name = url.rstrip("/").split("/")[-1]
        target = Path(tempfile.gettempdir()) / f"{self.name}-{file_name}"
        print(f"Downloading {url}")
        request = urllib.request.Request(url, headers={"User-Agent": "ImageMagick-Dependencies"})
        try:
            with urllib.request.urlopen(request) as response, open(target, "wb") as f:
                shutil.copyfileobj(response, f)
        except OSError as e:
            raise UpdateError(f"failed to download {url}: {e}")
        return target

    def clean_source(self, keep=KEEP_ENTRIES):
        """Removes everything in the dependency folder except the kept entries."""
        print("Removing the old source files")
        for entry in self.dependency_dir.iterdir():
            if entry.name not in keep:
                _remove(entry)

    def extract(self, archive, strip_components=1):
        """Extracts a .tar.* or .zip archive into the dependency folder.

        Symbolic links are written as empty files because they cannot be
        reliably created on Windows.
        """
        print(f"Extracting {Path(archive).name}")
        archive = str(archive)
        if zipfile.is_zipfile(archive):
            self._extract_zip(archive, strip_components)
        else:
            self._extract_tar(archive, strip_components)

    def replace_source(self, url=None, strip_components=None):
        """Downloads the release archive and replaces the current source with it.
        The url can contain {version}, {release_date} and {name} placeholders.
        Archives of googlesource.com (gitiles) have no top level folder."""
        url = url or self.url
        if not url:
            raise UpdateError("no url specified for the release archive")
        if strip_components is None:
            strip_components = 0 if "/+archive/" in url else 1
        archive = self.download(url)
        try:
            self.clean_source()
            self.extract(archive, strip_components)
        finally:
            os.remove(archive)

    def _target(self, name, strip_components):
        parts = PurePosixPath(name.replace("\\", "/")).parts
        if parts and parts[0] == "/":
            raise UpdateError(f"unsafe path in archive: {name}")
        parts = [part for part in parts[strip_components:] if part != "."]
        if not parts:
            return None
        if ".." in parts or ":" in parts[0]:
            raise UpdateError(f"unsafe path in archive: {name}")
        return self.dependency_dir.joinpath(*parts)

    def _extract_tar(self, archive, strip_components):
        with tarfile.open(archive) as tar:
            for member in tar:
                target = self._target(member.name, strip_components)
                if target is None:
                    continue
                if member.isdir():
                    target.mkdir(parents=True, exist_ok=True)
                    continue
                target.parent.mkdir(parents=True, exist_ok=True)
                if member.issym() or member.islnk():
                    _write(target, b"")
                elif member.isfile():
                    with tar.extractfile(member) as source:
                        _write(target, source.read())

    def _extract_zip(self, archive, strip_components):
        with zipfile.ZipFile(archive) as zip_file:
            for info in zip_file.infolist():
                target = self._target(info.filename, strip_components)
                if target is None:
                    continue
                if info.is_dir():
                    target.mkdir(parents=True, exist_ok=True)
                    continue
                target.parent.mkdir(parents=True, exist_ok=True)
                is_link = stat.S_ISLNK(info.external_attr >> 16)
                _write(target, b"" if is_link else zip_file.read(info))

    def remove(self, *paths):
        """Removes files or folders (relative to the dependency folder)."""
        for path in paths:
            target = self.dependency_dir / path
            if target.exists():
                print(f"Removing {path}")
                _remove(target)

    def apply_patches(self, folder="patches"):
        """Applies all .ImageMagick/<folder>/*.patch files in alphabetical order."""
        patch_dir = self.imagemagick_dir / folder
        if not patch_dir.is_dir():
            return
        for patch in sorted(patch_dir.glob("*.patch")):
            print(f"Applying {patch.name}")
            self.git("apply", "--whitespace=nowarn", str(patch))

    def replace_in_file(self, path, old, new):
        """Replaces text in a file and fails when the text cannot be found. The text is
        matched with \\n line endings and the line endings of the file are kept."""
        target = self.dependency_dir / path
        text = target.read_bytes().decode("utf-8")
        crlf = "\r\n" in text
        text = text.replace("\r\n", "\n")
        if old not in text:
            raise UpdateError(f"unable to find the text to replace in {path}:\n{old}")
        print(f"Patching {path}")
        text = text.replace(old, new)
        if crlf:
            text = text.replace("\n", "\r\n")
        _write(target, text.encode("utf-8"))

    def read_file(self, path):
        """Returns the text of a file with \\n line endings."""
        return (self.dependency_dir / path).read_bytes().decode("utf-8").replace("\r\n", "\n")

    def write_file(self, path, text):
        """Creates or overwrites a file (UTF-8) in the dependency folder."""
        target = self.dependency_dir / path
        print(f"Writing {path}")
        target.parent.mkdir(parents=True, exist_ok=True)
        _write(target, text.encode("utf-8"))

    def copy(self, source, destination):
        """Copies a file inside the dependency folder."""
        source_path = self.dependency_dir / source
        if not source_path.is_file():
            raise UpdateError(f"unable to find {source}")
        print(f"Copying {source} -> {destination}")
        _write(self.dependency_dir / destination, source_path.read_bytes())

    # --------------------------------------------------------------- config

    def update_config(self, **sections):
        """Updates the VERSION and RELEASE_DATE (and other) sections in Config.txt."""
        sections.setdefault("VERSION", self.version)
        sections.setdefault("RELEASE_DATE", self.release_date)

        config = self.imagemagick_dir / "Config.txt"
        # latin-1 keeps the original bytes because Config.txt is not always utf-8.
        text = config.read_bytes().decode("latin-1")
        for section, value in sections.items():
            pattern = re.compile(r"(^\[" + re.escape(section) + r"\]\r?\n)[^\r\n]*", re.MULTILINE)
            text, found = pattern.subn(lambda m: m.group(1) + value, text, count=1)
            if not found:
                raise UpdateError(f"unable to find [{section}] in {config}")
            print(f"Config.txt: [{section}] = {value}")
        _write(config, text.encode("latin-1"))

    # ---------------------------------------------------------------- cmake

    def cmake(self, *options, allow_errors=False):
        """Configures the project with cmake in the __build folder using the
        Visual Studio 2026 Developer Command Prompt. With allow_errors a failing
        configure step is reported but does not stop the update."""
        if self.build_dir.exists():
            _remove(self.build_dir)

        result = self._run_cmake("-S", str(self.dependency_dir), "-B", str(self.build_dir), *options)
        if result.returncode != 0:
            if not allow_errors:
                raise UpdateError("cmake failed")
            print("WARNING: cmake reported errors, continuing because this is expected.")

    def cmake_build(self, *targets, config="Release"):
        """Builds the specified targets in the __build folder, for example to run
        the custom commands that generate header files."""
        args = ["--build", str(self.build_dir), "--config", config]
        for target in targets:
            args += ["--target", target]
        if self._run_cmake(*args).returncode != 0:
            raise UpdateError(f"cmake --build failed for: {', '.join(targets)}")

    def _run_cmake(self, *args):
        command = "cmake " + " ".join(_quote(arg) for arg in args)
        print(command)

        if os.name != "nt" or os.environ.get("VSCMD_VER", "").startswith("18."):
            return subprocess.run(command, shell=True, cwd=self.dependency_dir)

        vs_dev_cmd = _find_vs_dev_cmd()
        print(f"Using {vs_dev_cmd}")
        return subprocess.run(
            f'cmd /d /s /c ""{vs_dev_cmd}" -arch=amd64 -host_arch=amd64 -no_logo && {command}"',
            cwd=self.dependency_dir)

    def copy_from_build(self, folder, files, destination="."):
        """Copies generated files from __build/<folder> to the dependency folder."""
        for file_name in files:
            source = self.build_dir / folder / file_name
            if not source.is_file():
                raise UpdateError(f"unable to find generated file {source}")
            target = self.dependency_dir / destination / file_name
            print(f"Copying {BUILD_FOLDER}/{folder}/{file_name} -> {destination}/{file_name}")
            _write(target, source.read_bytes())

    def remove_build(self):
        if self.build_dir.exists():
            print(f"Removing {BUILD_FOLDER}")
            _remove(self.build_dir)

    # ------------------------------------------------- clone-dependencies.sh

    def update_clone_dependencies(self):
        """Updates the commit of this dependency in clone-dependencies.sh."""
        commit = self.git("rev-parse", "HEAD")
        script = self.root_dir / "clone-dependencies.sh"
        text = script.read_bytes().decode("utf-8")
        pattern = re.compile(r"(clone '" + re.escape(self.dependency_dir.name) + r"' ')[0-9a-f]{40}(')")
        text, found = pattern.subn(lambda m: m.group(1) + commit + m.group(2), text, count=1)
        if not found:
            raise UpdateError(f"unable to find {self.dependency_dir.name} in {script}")
        _write(script, text.encode("utf-8"))
        print(f"clone-dependencies.sh: {self.dependency_dir.name} -> {commit}")

    def clone_dependencies_step(self):
        return Step("Update the commit in clone-dependencies.sh",
            lambda updater: updater.update_clone_dependencies())


def _github_api(path):
    request = urllib.request.Request(f"https://api.github.com/{path}", headers={
        "User-Agent": "ImageMagick-Dependencies",
        "Accept": "application/vnd.github+json"})
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None
        raise


def _read_input(prompt, validate, default=None):
    while True:
        value = input(prompt).strip()
        if not value and default:
            return default
        if validate(value):
            return value
        print(f"Invalid value: {value}")


def _is_version(value):
    return re.fullmatch(r"\d+(\.\d+)*", value) is not None


def _is_date(value):
    try:
        datetime.datetime.strptime(value, "%Y-%m-%d")
        return True
    except ValueError:
        return False


def _copy_to_clipboard(text):
    if os.name != "nt":
        return False
    try:
        result = subprocess.run(["clip"], input=text, text=True, stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL)
        return result.returncode == 0
    except OSError:
        return False


def _find_vs_dev_cmd():
    vswhere = Path(os.environ.get("ProgramFiles(x86)", r"C:\Program Files (x86)"),
        "Microsoft Visual Studio", "Installer", "vswhere.exe")
    if not vswhere.is_file():
        raise UpdateError(f"unable to find {vswhere}")

    for extra in ([], ["-prerelease"]):
        result = subprocess.run([str(vswhere), "-version", "[18.0,19.0)", "-products", "*",
            "-latest", "-property", "installationPath", *extra],
            stdout=subprocess.PIPE, text=True)
        paths = result.stdout.strip().splitlines()
        if paths:
            vs_dev_cmd = Path(paths[0], "Common7", "Tools", "VsDevCmd.bat")
            if vs_dev_cmd.is_file():
                return vs_dev_cmd

    raise UpdateError("unable to find Visual Studio 2026")


def _quote(arg):
    return f'"{arg}"' if " " in arg else arg


def _write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not os.access(path, os.W_OK):
        os.chmod(path, os.stat(path).st_mode | stat.S_IWRITE)
    for attempt in range(20):
        try:
            with open(path, "wb") as f:
                f.write(data)
            return
        except PermissionError:
            if attempt == 19:
                raise UpdateError(f"unable to write {path}, it is in use by another program")
            time.sleep(0.5)


def _make_writable_and_retry(function, path, _):
    os.chmod(path, stat.S_IWRITE)
    function(path)


def _remove(path):
    if path.is_dir() and not path.is_symlink():
        if sys.version_info >= (3, 12):
            shutil.rmtree(path, onexc=_make_writable_and_retry)
        else:
            shutil.rmtree(path, onerror=_make_writable_and_retry)
    else:
        os.chmod(path, stat.S_IWRITE)
        path.unlink()
