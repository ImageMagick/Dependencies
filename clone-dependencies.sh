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

  clone 'aom' 'c265586ed033f334077aa056b68edcd0174a2b21'
  clone 'brotli' '6225e7a93b6bcc1f3e3b267e9523a8eaea49eb5e'
  clone 'bzip2' 'abffe764f875f71d051efb19d4c83139375f82d7'
  clone 'cairo' '241f953d2571621baf5d21bca3339158a8eadd5a'
  clone 'croco' '178785cdc6faecad555a4e6fe4fda2b625046e8e'
  clone 'de265' '581e4a1a6fd20a2e9f4d484baa16c48f3bbb529c'
  clone 'deflate' '01154b3ae484931cddf77edbfbcf83d241c4fd80'
  clone 'exr' 'ce049d9f8fa2d3c58dd492de2076f20f24107be3'
  clone 'ffi' '5bfbcef8f3a87ae9121bba12164676384c153074'
  clone 'freetype' 'a589909aa4766331a06d32b846154af320ec4382'
  clone 'fribidi' 'ef903b6f8c90cba6141afd0f28e1ca6c130317f3'
  clone 'gdk-pixbuf' 'a01fe1d3d1ac0eba9d141bd7aed47da9560df350'
  clone 'glib' '016373fad6b5253d531fc1bb34af23883db75056'
  clone 'harfbuzz' '04a675f075e875cb180fe1988679478542a75192'
  clone 'heif' 'ba938bba4d5ed047f1a2d8518e63a3c0755e8815'
  clone 'highway' '50c2b87026be94e83652943a07c1d02ee2e35300'
  clone 'imath' 'da111679be3f9a0fb4b79d5adebfca1546873983'
  clone 'jpeg-turbo' '755552649b7cb927dd3431b7d94da6d1c268c129'
  clone 'jpeg-turbo-12' '633aacbee5a4fba892d54804a16edeaa9ae68dca'
  clone 'jpeg-turbo-16' '362648691acaf65fbbe3cbcd10db30a66df223cb'
  clone 'jpeg-xl' '1ac672c2c554ae11492dffab7e8b4a30569941a1'
  clone 'lcms' '015c30082877271f155896b76f512d4d50945b28'
  clone 'lqr' 'c4f9a027386e3e5b00fc55d5d0548341b5184990'
  clone 'lzma' 'a0ffcd8d310534fc82ac4c690b0e47f3b9585b64'
  clone 'openh264' '5ed6416df5c4eb35e275f759792c9253c5f1f5f3'
  clone 'openjpeg' '5a52e8e0690da686ddb6e98310e7bb5190a9a7c5'
  clone 'openjph' '0f62862cafbc78481f9317535961bd55377504d9'
  clone 'pango' '0b1e4536e0005f3c36b523c17ea12322490efd45'
  clone 'pixman' 'f7b55a8d3c39380724da9fbdef72ad70be800efc'
  clone 'png' 'c4cb159c9f7a12abfb65b8bf582309e755422ceb'
  clone 'raqm' '737616f8b39df7fe2993da67fac923d506be463f'
  clone 'raw' '61d840a5288f12cdb54026cc77ec8e6e4954dc09'
  clone 'rsvg' '3bae9c17d1880ff60145b6432b4a4772da8dd882'
  clone 'tiff' '7ff6a3dcd0a6ee5817a1bfcbb6633014a0cd3e05'
  clone 'webp' 'b981ef267195cb12f2cb97e4dd23e12a1323a4ce'
  clone 'xml' 'baadf4be7c6b7347060c0fc217a895e59ef4ecc0'
  clone 'zip' '745377bdab21cf5e5fc19d0bbfcde93030d3af5e'
  clone 'zlib' 'c249779e740e43684d352df7a19497bc3a95df89'

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
