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

  clone 'aom' 'c19547ed5b56fefcded8aa8aaadbd0c05cbe686c'
  clone 'brotli' '6225e7a93b6bcc1f3e3b267e9523a8eaea49eb5e'
  clone 'bzip2' 'abffe764f875f71d051efb19d4c83139375f82d7'
  clone 'cairo' '241f953d2571621baf5d21bca3339158a8eadd5a'
  clone 'croco' '178785cdc6faecad555a4e6fe4fda2b625046e8e'
  clone 'de265' '581e4a1a6fd20a2e9f4d484baa16c48f3bbb529c'
  clone 'exr' 'cb4a243f1d1f1263c2a5e94df27ca9e12133670e'
  clone 'ffi' '5bfbcef8f3a87ae9121bba12164676384c153074'
  clone 'freetype' '6cf8b1a08bdec1d41246f51bcd12e5a62c9845e2'
  clone 'fribidi' 'ef903b6f8c90cba6141afd0f28e1ca6c130317f3'
  clone 'gdk-pixbuf' '18a067b92d009ae310ea6df081f7e6e5af081ab2'
  clone 'glib' '016373fad6b5253d531fc1bb34af23883db75056'
  clone 'harfbuzz' 'bf0f466c755918573a0665b0afe6c218505e70a1'
  clone 'heif' '6b60aba35c90df9983bf4a741083717a80428f94'
  clone 'highway' '50c2b87026be94e83652943a07c1d02ee2e35300'
  clone 'imath' 'da111679be3f9a0fb4b79d5adebfca1546873983'
  clone 'jpeg-turbo' '3f872fc3c7470a2c964e625b1d70d9bc98a03947'
  clone 'jpeg-turbo-12' '633aacbee5a4fba892d54804a16edeaa9ae68dca'
  clone 'jpeg-turbo-16' '362648691acaf65fbbe3cbcd10db30a66df223cb'
  clone 'jpeg-xl' 'a16526a8cc32708ed6f1e7717955af1ad827307f'
  clone 'lcms' 'b269a998c1132449d92b4d2d05fa2515556c3087'
  clone 'lqr' 'c4f9a027386e3e5b00fc55d5d0548341b5184990'
  clone 'lzma' '3eb7dab2a3d6e8f5ebe5f02a657355afe2c6459d'
  clone 'openh264' '5ed6416df5c4eb35e275f759792c9253c5f1f5f3'
  clone 'openjpeg' '5a52e8e0690da686ddb6e98310e7bb5190a9a7c5'
  clone 'openjph' '5b39ae5679fc00b209175a0274a03e77947966a2'
  clone 'pango' '0b1e4536e0005f3c36b523c17ea12322490efd45'
  clone 'pixman' 'f7b55a8d3c39380724da9fbdef72ad70be800efc'
  clone 'png' '4bc877a8110a8feeae7ab76d48a0c1c64af25989'
  clone 'raqm' '5fcf4b2990dfaf999afe2b76f88ccc64ace488c5'
  clone 'raw' 'ad5e16cc8e672705fc3bc1769b5743930da8425b'
  clone 'rsvg' '7415a6765db7554ba6f0f1b3dcb0877f36ff581b'
  clone 'tiff' 'baf5407d932f2bcb93309021bfaee83aafdccf72'
  clone 'webp' 'b981ef267195cb12f2cb97e4dd23e12a1323a4ce'
  clone 'xml' 'c0eaf05d50894f2fcc870ac74e3713ffd0ca36d5'
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

  clone 'fftw' '496292531f968365f88ac48cf6dc72153dd87695'
  clone 'flif' '0c348a60b7ebff57aa8dfb4fc218b1cd90dd4d5a'
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
