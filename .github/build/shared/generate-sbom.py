#!/usr/bin/env python3
import json
import os
import sys

SECTION_FIELDS = (
    "VERSION",
    "RELEASE_DATE",
    "PRODUCT_NAME",
    "COMPANY_NAME",
    "URL",
    "COPYRIGHT",
    "LICENSE_IDENTIFIER",
)

GROUPS = ("Dependencies", "NonWindowsDependencies")


def read_config_lines(config_file):
    with open(config_file, "rb") as f:
        data = f.read()

    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError:
        text = data.decode("windows-1252")

    return text.splitlines()


def parse_config(config_file):
    fields = {name: "" for name in SECTION_FIELDS}
    section = ""

    for line in read_config_lines(config_file):
        line = line.strip("\r")

        if line.startswith("[") and line.endswith("]"):
            section = line[1:-1]
            continue

        if not line:
            continue

        if section in fields and not fields[section]:
            fields[section] = line

    return fields


def build_component(dep_dir, fields):
    name = fields["PRODUCT_NAME"] or os.path.basename(dep_dir.rstrip(os.sep))

    return {
        "type": "library",
        "bom-ref": name,
        "name": name,
        "version": fields["VERSION"],
        "publisher": fields["COMPANY_NAME"],
        "copyright": fields["COPYRIGHT"],
        "licenses": [
            {
                "license": {
                    "id": fields["LICENSE_IDENTIFIER"],
                }
            }
        ],
        "externalReferences": [
            {
                "type": "website",
                "url": fields["URL"],
            }
        ],
        "properties": [
            {
                "name": "releaseDate",
                "value": fields["RELEASE_DATE"],
            }
        ],
    }


def collect_components(root_dir):
    components = []

    for group in GROUPS:
        group_dir = os.path.join(root_dir, group)
        if not os.path.isdir(group_dir):
            continue

        for dep_name in sorted(os.listdir(group_dir)):
            dep_dir = os.path.join(group_dir, dep_name)
            if not os.path.isdir(dep_dir):
                continue

            config_file = os.path.join(dep_dir, ".ImageMagick", "Config.txt")
            if not os.path.isfile(config_file):
                continue

            fields = parse_config(config_file)

            if fields["VERSION"]:
                components.append(build_component(dep_dir, fields))

    return components


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <output-file>", file=sys.stderr)
        sys.exit(1)

    output_file = sys.argv[1]
    root_dir = os.getcwd()

    output_dir = os.path.dirname(output_file)
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)

    components = collect_components(root_dir)

    sbom = {
        "bomFormat": "CycloneDX",
        "specVersion": "1.5",
        "serialNumber": "[SERIAL]",
        "version": 1,
        "metadata": {
            "timestamp": "[BUILD_TIMESTAMP]",
            "component": {
                "type": "application",
                "bom-ref": "imagemagick",
                "name": "ImageMagick",
                "version": "[MAGICK_VERSION]",
            },
        },
        "components": components,
    }

    with open(output_file, "w", encoding="utf-8", newline="\n") as f:
        json.dump(sbom, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"Generated SBOM with {len(components)} component(s) at {output_file}")


if __name__ == "__main__":
    main()
