#!/bin/bash
set -e

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
SHARED_PATH="$SCRIPT_PATH/../shared"

# Compiler settings
if [[ "${DEBUG_BUILD}" ]]; then
  export FLAGS="-g3 -O0 -fPIC -DDEBUG"
  export CMAKE_BUILD_TYPE="Debug"
  export MESON_BUILD_TYPE="debug"
else
  export FLAGS="-O3 -fPIC -DNDEBUG"
  export CMAKE_BUILD_TYPE="Release"
  export MESON_BUILD_TYPE="release"
fi
export INSTALL_PREFIX="/tmp/dependencies"
export CMAKE_PREFIX_PATH="$INSTALL_PREFIX"
export CPPFLAGS="-I$INSTALL_PREFIX/include"
export LDFLAGS="-L$INSTALL_PREFIX/lib"
export PKG_CONFIG_PATH="$INSTALL_PREFIX/lib/pkgconfig"

# Shared options
export CMAKE_COMMAND="emcmake cmake"
export CMAKE_OPTIONS=""
export CONFIGURE="emconfigure ./configure"
export CONFIGURE_OPTIONS="--host aarch64-linux-gnu"
export MAKE="emmake make -j$(nproc)"
export MESON_OPTIONS="--cross-file=$SCRIPT_PATH/cross-compilation.meson"

# Library specific options
export DE265_OPTIONS="--disable-sse"
export FONTCONFIG_OPTIONS=""
export HEIF_OPTIONS="-DENABLE_MULTITHREADING_SUPPORT=false"
export JPEGTURBO_OPTIONS="-DWITH_SIMD=0"
export LCMS_OPTIONS="--without-threads"
export OPENEXR_OPTIONS="-DZLIB_LIBRARY=/usr/local/lib/libz.a -DZLIB_INCLUDE_DIR=/usr/local/include -DImath_DIR=/usr/local/lib/cmake/Imath"
export WEBP_OPTIONS=""

# Set compiler for cross-compilation
export CC=emcc
export CXX=em++
export EM_PKG_CONFIG_PATH=$PKG_CONFIG_PATH

# Build dependencies
$SHARED_PATH/zlib.sh
$SHARED_PATH/xml.sh
$SHARED_PATH/png.sh
$SHARED_PATH/freetype.sh
$SHARED_PATH/jpeg-turbo.sh
$SHARED_PATH/tiff.sh
$SHARED_PATH/webp.sh
$SHARED_PATH/openjpeg.sh
$SHARED_PATH/lcms.sh
$SHARED_PATH/aom.sh
$SHARED_PATH/de265.sh
$SHARED_PATH/heif.sh
$SHARED_PATH/raw.sh
$SHARED_PATH/deflate.sh
$SHARED_PATH/imath.sh
$SHARED_PATH/exr.sh
$SHARED_PATH/ffi.sh
$SHARED_PATH/glib.sh
$SHARED_PATH/lqr.sh
$SHARED_PATH/highway.sh
$SHARED_PATH/brotli.sh
$SHARED_PATH/jpeg-xl.sh
