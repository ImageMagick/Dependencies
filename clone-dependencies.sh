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

  clone 'aom' '79de389e4abced53cb6e85b7574826dbc227cd9c'
  clone 'brotli' '6225e7a93b6bcc1f3e3b267e9523a8eaea49eb5e'
  clone 'bzip2' 'abffe764f875f71d051efb19d4c83139375f82d7'
  clone 'de265' '80e57d4a56dd9bd725e1d937be8060fbffc36ca1'
  clone 'exr' 'b11aebb092cd429408ed519d8d5608a9f93cace1'
  clone 'ffi' '91982d4ac97b179dd1fb878caef2ed2847bc38b6'
  clone 'freetype' '6cf8b1a08bdec1d41246f51bcd12e5a62c9845e2'
  clone 'glib' 'ea0118ca0d408473d320b21262a1cdc6ce3e5f40'
  clone 'heif' '83b203facff83cced6776fcad00963ece4896952'
  clone 'highway' 'e1a586af5be6358bb983ff608f9678a622209ca3'
  clone 'imath' '692409f6868d9371aae7ce17bb94f634e24fa201'
  clone 'jpeg-turbo' 'b91492930ceb23c0b5282e8b9fc21de54182d92e'
  clone 'jpeg-xl' '8503118ff13ab8b11680296900da3361d6703dc1'
  clone 'lcms' 'd261ab6fda30fd7578a2ce7ace5c0b2c7d3fc0b8'
  clone 'lqr' 'a2e9e8b5b41bf0569f51482707a12d354a086f3a'
  clone 'openjpeg' '5a52e8e0690da686ddb6e98310e7bb5190a9a7c5'
  clone 'openjph' 'a8d14ac14a3ea23067ef140dced2e53691a697fa'
  clone 'png' '88ee938ef91b0289339be463b29003f65d486210'
  clone 'raw' '9f7613ef48877180225b9377c87b0f3a65a2ca8e'
  clone 'tiff' 'a00846bca0212faca9306ae7bdd1c89e3e46bf82'
  clone 'webp' 'b981ef267195cb12f2cb97e4dd23e12a1323a4ce'
  clone 'xml' '4509bf0d7b7a501b682da8635527cd77525b0ec9'
  clone 'zlib' 'e42706934e4e7564d960031ae62ff29d918ee06d'

  if [ "$platform" = "wasm" ]; then
    cd ..
    return
  fi

  clone 'cairo' '95c037dd6c455d314d12a2fad76b07b0a34c171b'
  clone 'croco' '178785cdc6faecad555a4e6fe4fda2b625046e8e'
  clone 'fribidi' 'ef903b6f8c90cba6141afd0f28e1ca6c130317f3'
  clone 'gdk-pixbuf' '92a234886a0337480770ef93dc74ea920bf39ab3'
  clone 'harfbuzz' 'dee829272780ed0b0cedf3f1261411cef8c01509'
  clone 'lzma' '3eb7dab2a3d6e8f5ebe5f02a657355afe2c6459d'
  clone 'openh264' '5ed6416df5c4eb35e275f759792c9253c5f1f5f3'
  clone 'pango' '0b1e4536e0005f3c36b523c17ea12322490efd45'
  clone 'pixman' 'f7b55a8d3c39380724da9fbdef72ad70be800efc'
  clone 'raqm' 'a699b8b7838acb4ac8d5891f42ecf3d84a00a9ad'
  clone 'rsvg' '7415a6765db7554ba6f0f1b3dcb0877f36ff581b'
  clone 'zip' '745377bdab21cf5e5fc19d0bbfcde93030d3af5e'

  case "$platform" in
    "" | windows) ;;
    *) cd ..; return ;;
  esac

  clone 'jpeg-turbo-12' '9837071e8c0e5fba6daa03f31aba4416ff5eaf7c'
  clone 'jpeg-turbo-16' 'd16d0839d655478b4d517ebe2aeabfecce8192d9'

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
