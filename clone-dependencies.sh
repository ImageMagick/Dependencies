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

  clone 'aom' '40cbab47001229b6acf2aa6ed90975e1fe36d7cd'
  clone 'brotli' '43c232677bd14288efb73c000634100ca02c6615'
  clone 'bzlib' 'eb86d8f8273b733860f16b58fc5577e786dfea02'
  clone 'cairo' '1398155a2c59bf1a7a3414087f29a4d6175e511e'
  clone 'croco' '3c35df989a2011f692ee8914b6f054c9f79dc9eb'
  clone 'de265' 'c65aa04018209b75f4d86d5207f67d6396d11973'
  clone 'deflate' '318cc8e7cea3cc7bb6ee76e3da5608ce2883897a'
  clone 'exr' 'cb29166e333c6b6b7860363263d54bf8ae9ed19d'
  clone 'ffi' '105d636cc093a96b72903bf4ed63dbaced09cace'
  clone 'freetype' '16c2ff88b9b7dc3b7749074c514a30a2aa990dd7'
  clone 'fribidi' '3c8dc6bb1f668563601c4f470702c2caba02e5a9'
  clone 'glib' '7c18f9c92bd9442ce1924cedd126fe50029416a5'
  clone 'harfbuzz' '6ebe66be79875f47793d8af2e13b93c20334dc2a'
  clone 'heif' '17ff512b1b6c554ec6ec461891d23ea47c3e9e15'
  clone 'highway' '4a82c1faed7179648bc8419ffcb12b27a638c99e'
  clone 'imath' '7df9a8daf0eed0873f97a166b59b7caf24dbd5b1'
  clone 'jpeg-turbo' 'd6c716ad35e2b8b3366d07a5c6a2dd746daae0af'
  clone 'jpeg-turbo-12' '633aacbee5a4fba892d54804a16edeaa9ae68dca'
  clone 'jpeg-turbo-16' '362648691acaf65fbbe3cbcd10db30a66df223cb'
  clone 'jpeg-xl' '0eb0e12ed9cfe95e35e88f8e144517d5f6e4e093'
  clone 'lcms' '0a4d60e188083f207b59784397ecca88b91ed410'
  clone 'lqr' '7d8cd9ce2109b99774b9d10d614c396a3cc2aacd'
  clone 'lzma' 'd2d42e04f7aa9c49ba0cbaaecbe8557d20acda38'
  clone 'openh264' 'e88db93e997c4c69f224aefc33d35c4b26578f80'
  clone 'openjpeg' 'ae7744d2680e126abf93eaa6191996db446c04fb'
  clone 'pango' '9b019fb87547855243b148dee4e782658f56225e'
  clone 'pixman' '1c8b41cc9f38f5a018ada19b32da641f5782be11'
  clone 'png' '4742e03a92b910ad869da14dd96b9c096e853326'
  clone 'raqm' '34097e0be59f4db28bf7d57d336876fce124d0b5'
  clone 'raw' 'a91ae551812a270b3a4331de8dc1468a3485272c'
  clone 'rsvg' '43096573ec5cb9cc9e4e7bf4def55637cea51b4c'
  clone 'tiff' 'd1d17ce3f9f5ba2215edabd3d54ea0f46bb7538c'
  clone 'webp' '444cf23c2e177105bc876611ec3d82b7d23502a0'
  clone 'xml' '132d758d137345cbebd80417f26a216ac01ac168'
  clone 'zip' '987138bb74e6f18b464246b1f025de82c52167f9'
  clone 'zlib' '42998011c390732967bf56316c6dd0cb3872e589'

  cd ..
}

clone_optional_dependencies()
{
  if [ ! -d "OptionalDependencies" ]; then
    mkdir -p "OptionalDependencies"
  fi

  cd "OptionalDependencies"

  clone 'fftw' '7abecb64d47dda58bd38e693dbf076990fe412c8'
  clone 'flif' '9e2914970aa662ad18aad72c9e29860b31a2914e'
  clone 'jbig' '7fd88607724f7c39e264bb4812ca0976a81c04e6'

  cd ..
}

clone_non_windows_dependencies()
{
  if [ ! -d "NonWindowsDependencies" ]; then
    mkdir -p "NonWindowsDependencies"
  fi

  cd "NonWindowsDependencies"

  clone 'fontconfig' '9f848be61d3dfcafcc76e083499123153c525e0b'

  cd ..
}

clone_dependencies
clone_optional_dependencies
clone_non_windows_dependencies
