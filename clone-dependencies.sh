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
  clone 'brotli' '6cd28a4611516a24ad19d5e918052d1ebe47902d'
  clone 'bzlib' 'abffe764f875f71d051efb19d4c83139375f82d7'
  clone 'cairo' '241f953d2571621baf5d21bca3339158a8eadd5a'
  clone 'croco' '178785cdc6faecad555a4e6fe4fda2b625046e8e'
  clone 'de265' '581e4a1a6fd20a2e9f4d484baa16c48f3bbb529c'
  clone 'deflate' 'fa019db28ac64f7370998ae12a32dbc1430e0da2'
  clone 'exr' 'df9089aad1f6021cff6226e1b9120d835e15a3a6'
  clone 'ffi' '83d3f582185ce04456e9458a1a700231b87aa254'
  clone 'freetype' '3ffcf3840a1796c650d835e47901a33461b6f516'
  clone 'fribidi' 'ef903b6f8c90cba6141afd0f28e1ca6c130317f3'
  clone 'gdk-pixbuf' '33d446bed1e3909e1875e03ed614960f3af85028'
  clone 'glib' '016373fad6b5253d531fc1bb34af23883db75056'
  clone 'harfbuzz' 'e67ff976b83d99b81bd565cdd9a6c865f370d26c'
  clone 'heif' 'ba938bba4d5ed047f1a2d8518e63a3c0755e8815'
  clone 'highway' '50c2b87026be94e83652943a07c1d02ee2e35300'
  clone 'imath' 'd6358163268a63d525d5b5a73b250023b5036a1e'
  clone 'jpeg-turbo' '755552649b7cb927dd3431b7d94da6d1c268c129'
  clone 'jpeg-turbo-12' '633aacbee5a4fba892d54804a16edeaa9ae68dca'
  clone 'jpeg-turbo-16' '362648691acaf65fbbe3cbcd10db30a66df223cb'
  clone 'jpeg-xl' '1ac672c2c554ae11492dffab7e8b4a30569941a1'
  clone 'lcms' '015c30082877271f155896b76f512d4d50945b28'
  clone 'lqr' 'c4f9a027386e3e5b00fc55d5d0548341b5184990'
  clone 'lzma' 'a0ffcd8d310534fc82ac4c690b0e47f3b9585b64'
  clone 'openh264' '5ed6416df5c4eb35e275f759792c9253c5f1f5f3'
  clone 'openjpeg' '24e8ce92a85662b086b8fb593cb75c22385f1147'
  clone 'pango' '0b1e4536e0005f3c36b523c17ea12322490efd45'
  clone 'pixman' 'f7b55a8d3c39380724da9fbdef72ad70be800efc'
  clone 'png' 'c4cb159c9f7a12abfb65b8bf582309e755422ceb'
  clone 'raqm' '737616f8b39df7fe2993da67fac923d506be463f'
  clone 'raw' '61d840a5288f12cdb54026cc77ec8e6e4954dc09'
  clone 'rsvg' '3bae9c17d1880ff60145b6432b4a4772da8dd882'
  clone 'tiff' '7a2fbd04879f15620586dd9cabf7dbd1e4048308'
  clone 'webp' 'b981ef267195cb12f2cb97e4dd23e12a1323a4ce'
  clone 'xml' 'd0b79073a947c746bdfe3ff80e0f968527a1d404'
  clone 'zip' 'cc173a0e926871f9bb331ad1a3915d079e9ae836'
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
