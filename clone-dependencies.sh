#/bin/bash
set -e

clone()
{
  local repo=$1
  local commit=$2

  echo ''
  echo "Cloning $repo"

  if [ -d "$repo" ]; then
    cd $repo
  else
    git clone https://github.com/ImageMagick/$repo.git $repo

    cd $repo
    git remote add sshpush git@github.com:ImageMagick/$repo.git
    git config remote.pushDefault sshpush
  fi

  git reset --hard
  git checkout main
  git pull origin main
  git reset --hard $commit

  cd ..
}

clone_dependencies()
{
  if [ ! -d "Dependencies" ]; then
    mkdir -p "Dependencies"
  fi

  cd "Dependencies"

  clone 'aom' 'f74a4670353c01c194379a7ef922858c530acbd2'
  clone 'brotli' '6225e7a93b6bcc1f3e3b267e9523a8eaea49eb5e'
  clone 'bzip2' 'abffe764f875f71d051efb19d4c83139375f82d7'
  clone 'cairo' '95c037dd6c455d314d12a2fad76b07b0a34c171b'
  clone 'croco' '178785cdc6faecad555a4e6fe4fda2b625046e8e'
  clone 'de265' '80e57d4a56dd9bd725e1d937be8060fbffc36ca1'
  clone 'exr' '93cdfc71e4778d1e5aeabc567dd60f9181b7029f'
  clone 'ffi' '0c09578ec41bcddaa51318036a980cf5467a3489'
  clone 'freetype' '6cf8b1a08bdec1d41246f51bcd12e5a62c9845e2'
  clone 'fribidi' 'ef903b6f8c90cba6141afd0f28e1ca6c130317f3'
  clone 'gdk-pixbuf' '57b955e47bfa3634a310368816cb829d7812e430'
  clone 'glib' '016373fad6b5253d531fc1bb34af23883db75056'
  clone 'harfbuzz' 'c3c87e2190b0363edc0744079b50a4ae22989915'
  clone 'heif' '5def4181577ada890da9b8cb0b913f93f24c715e'
  clone 'highway' 'e1a586af5be6358bb983ff608f9678a622209ca3'
  clone 'imath' 'da111679be3f9a0fb4b79d5adebfca1546873983'
  clone 'jpeg-turbo' '3f872fc3c7470a2c964e625b1d70d9bc98a03947'
  clone 'jpeg-turbo-12' '633aacbee5a4fba892d54804a16edeaa9ae68dca'
  clone 'jpeg-turbo-16' '362648691acaf65fbbe3cbcd10db30a66df223cb'
  clone 'jpeg-xl' 'e44084885835d64a16d0746f7d004cf30849bc0f'
  clone 'lcms' 'd261ab6fda30fd7578a2ce7ace5c0b2c7d3fc0b8'
  clone 'lqr' 'a2e9e8b5b41bf0569f51482707a12d354a086f3a'
  clone 'lzma' '3eb7dab2a3d6e8f5ebe5f02a657355afe2c6459d'
  clone 'openh264' '5ed6416df5c4eb35e275f759792c9253c5f1f5f3'
  clone 'openjpeg' '5a52e8e0690da686ddb6e98310e7bb5190a9a7c5'
  clone 'openjph' '5bc35760730b4d4e644954455b5253e7caf8ae2d'
  clone 'pango' '0b1e4536e0005f3c36b523c17ea12322490efd45'
  clone 'pixman' 'f7b55a8d3c39380724da9fbdef72ad70be800efc'
  clone 'png' '88ee938ef91b0289339be463b29003f65d486210'
  clone 'raqm' '7f93ce05cc25aa2e9aa5baea732b0bad210bb722'
  clone 'raw' 'e806d361d2348e2f01a66594efd396002b7c9b94'
  clone 'rsvg' '7415a6765db7554ba6f0f1b3dcb0877f36ff581b'
  clone 'tiff' '978181b6c999ee013f1b6df0a010d8c550d378cf'
  clone 'webp' 'b981ef267195cb12f2cb97e4dd23e12a1323a4ce'
  clone 'xml' '4509bf0d7b7a501b682da8635527cd77525b0ec9'
  clone 'zip' '745377bdab21cf5e5fc19d0bbfcde93030d3af5e'
  clone 'zlib' 'e42706934e4e7564d960031ae62ff29d918ee06d'

  cd ..
}

clone_optional_dependencies()
{
  if [ ! -d "OptionalDependencies" ]; then
    mkdir -p "OptionalDependencies"
  fi

  cd "OptionalDependencies"

  clone 'fftw' '6d33fb83ae4f2014834b1f506b444916e9a19ef7'
  clone 'flif' '2f4c78d6c88025de551d461a9981be2004b36beb'
  clone 'jbig' 'c431166292d1590280b30a8edefee4d36c7a6219'

  cd ..
}

clone_non_windows_dependencies()
{
  if [ ! -d "NonWindowsDependencies" ]; then
    mkdir -p "NonWindowsDependencies"
  fi

  cd "NonWindowsDependencies"

  clone 'fontconfig' '52aa8b9cdc14afef519fca8aa06c7360aed8644d'

  cd ..
}

clone_dependencies
clone_optional_dependencies
clone_non_windows_dependencies
