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
  local platform=$1

  if [ ! -d "Dependencies" ]; then
    mkdir -p "Dependencies"
  fi

  cd "Dependencies"

  clone 'aom' '949b2083094619a8cf6491938d47e6c4804ed108'
  clone 'brotli' '62877063ab55b3494bdee9d1239156754aed6413'
  clone 'bzip2' 'abffe764f875f71d051efb19d4c83139375f82d7'
  clone 'de265' '5a0bf9f624d810de6af20e41ac3cfd92bf7de508'
  clone 'exr' '85a96b21d3cdcae99fbea6f32f62eba9ca4a9fdd'
  clone 'ffi' '91982d4ac97b179dd1fb878caef2ed2847bc38b6'
  clone 'freetype' 'c872866d7b45c6926d82a636c3f9055472e6c334'
  clone 'glib' 'ea0118ca0d408473d320b21262a1cdc6ce3e5f40'
  clone 'heif' '498042a72e805c50e5e84b57e15327f3cfdf6a63'
  clone 'highway' 'e1a586af5be6358bb983ff608f9678a622209ca3'
  clone 'imath' '1ec391453dd33f3432018d3a266e3d177a705235'
  clone 'jpeg-turbo' 'ea2dd9d26a47da90c87a3ab57f6ac7f85977be83'
  clone 'jpeg-xl' '8503118ff13ab8b11680296900da3361d6703dc1'
  clone 'lcms' 'd261ab6fda30fd7578a2ce7ace5c0b2c7d3fc0b8'
  clone 'lqr' 'a2e9e8b5b41bf0569f51482707a12d354a086f3a'
  clone 'openjpeg' '97ce1d10749b1a02d657eae491e80c572ca183b2'
  clone 'openjph' 'c1a1ffc1e3f90eb9397407f1f545a47e01390aef'
  clone 'png' '1ccb8b78643c7ad5360f00719a1e952ce0be7a53'
  clone 'raw' '71399d76efc3fa915bf3fb01ddede994b549a80a'
  clone 'tiff' '3021cd03440ba6954f8bdf2b7ad4557a36092cd8'
  clone 'webp' 'b981ef267195cb12f2cb97e4dd23e12a1323a4ce'
  clone 'xml' '3ba73c8312b7ac88adc1a2e62df13d0827e93a0f'
  clone 'zlib' 'e42706934e4e7564d960031ae62ff29d918ee06d'
  clone 'zstd' '4d5752ffeca8defb48ad744274f4f76b2866d71d'

  if [ "$platform" = "wasm" ]; then
    cd ..
    return
  fi

  clone 'cairo' '4334da83d8f44abe5aab1a11956e3f8e6e58eac7'
  clone 'croco' '178785cdc6faecad555a4e6fe4fda2b625046e8e'
  clone 'fribidi' 'a51f6765d9bfafab1f7bd3f5f507ccf1eac6be6b'
  clone 'gdk-pixbuf' '92a234886a0337480770ef93dc74ea920bf39ab3'
  clone 'harfbuzz' 'c77409b255cbce3e39210681dfad9ba93eadbcbe'
  clone 'lzma' '131e9a49425f51b8dd8710c57fbaa527baed3989'
  clone 'openh264' '8f7d29ca929a6b66682c0a5889a62a68c0cfa486'
  clone 'pango' '0b1e4536e0005f3c36b523c17ea12322490efd45'
  clone 'pixman' 'f7b55a8d3c39380724da9fbdef72ad70be800efc'
  clone 'raqm' 'a699b8b7838acb4ac8d5891f42ecf3d84a00a9ad'
  clone 'rsvg' '7415a6765db7554ba6f0f1b3dcb0877f36ff581b'
  clone 'zip' '4fb2753af4c718080b62fbadda0e99fd9178ab6a'

  case "$platform" in
    "" | windows) ;;
    *) cd ..; return ;;
  esac

  clone 'jpeg-turbo-12' 'e4c325c9f2ea22198174c14cfaec6982249f819d'
  clone 'jpeg-turbo-16' '1048733eff5403a3a3610155b457ec54a548a1af'

  cd ..
}

clone_optional_dependencies()
{
  local platform=$1

  case "$platform" in
    "" | windows) ;;
    *) return ;;
  esac

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
  local platform=$1

  if [ "$platform" = "wasm" ]; then
    return
  fi

  if [ ! -d "NonWindowsDependencies" ]; then
    mkdir -p "NonWindowsDependencies"
  fi

  cd "NonWindowsDependencies"

  clone 'fontconfig' '943048d94dfa3d7d4a213f36f9ef7af988397cd4'

  cd ..
}

clone_dependencies "$1"
clone_optional_dependencies "$1"
clone_non_windows_dependencies "$1"
