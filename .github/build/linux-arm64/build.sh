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
export CMAKE_PREFIX_PATH="/dependencies"
export CPPFLAGS="-I/dependencies/include"
export LDFLAGS="-L/dependencies/lib -L/dependencies/lib/x86_64-linux-gnu"
export PKG_CONFIG_PATH="/dependencies/lib/pkgconfig:/dependencies/lib/x86_64-linux-gnu/pkgconfig"

# Shared options
export CMAKE_COMMAND="cmake"
export CMAKE_OPTIONS="-DCMAKE_TOOLCHAIN_FILE=$SCRIPT_PATH/cross-compilation.cmake"
export CONFIGURE="./configure"
export CONFIGURE_OPTIONS="--host aarch64-linux-gnu"
export MAKE="make -j$(nproc)"
export MESON_OPTIONS="--cross-file=$SCRIPT_PATH/cross-compilation.meson"

# Library specific options
export DE265_OPTIONS=""
export FFI_OPTIONS="--disable-exec-static-tramp"
export FONTCONFIG_OPTIONS=""
export HEIF_OPTIONS=""
export JPEGTURBO_OPTIONS="-DWITH_SIMD=0"
export LCMS_OPTIONS=""
export OPENEXR_OPTIONS=""
export WEBP_OPTIONS="--enable-libwebpmux --enable-libwebpdemux"

# Set compiler for cross-compilation
export CC=aarch64-linux-gnu-gcc
export CXX=aarch64-linux-gnu-g++

# Build dependencies
$SHARED_PATH/zlib.sh
$SHARED_PATH/lzma.sh
$SHARED_PATH/bzlib.sh
$SHARED_PATH/zip.sh
$SHARED_PATH/xml.sh
$SHARED_PATH/png.sh
$SHARED_PATH/freetype.sh
$SHARED_PATH/fontconfig.sh
$SHARED_PATH/jpeg-turbo.sh
$SHARED_PATH/tiff.sh
$SHARED_PATH/webp.sh
$SHARED_PATH/openjpeg.sh
$SHARED_PATH/lcms.sh
$SHARED_PATH/aom.sh
$SHARED_PATH/de265.sh
$SHARED_PATH/openh264.sh
$SHARED_PATH/heif.sh
$SHARED_PATH/raw.sh
$SHARED_PATH/deflate.sh
$SHARED_PATH/exr.sh
$SHARED_PATH/ffi.sh
$SHARED_PATH/glib.sh
$SHARED_PATH/lqr.sh
$SHARED_PATH/pixman.sh
$SHARED_PATH/cairo.sh
$SHARED_PATH/fribidi.sh
$SHARED_PATH/harfbuzz.sh
$SHARED_PATH/pango.sh
$SHARED_PATH/croco.sh
$SHARED_PATH/rsvg.sh
$SHARED_PATH/raqm.sh
$SHARED_PATH/highway.sh
$SHARED_PATH/brotli.sh
$SHARED_PATH/jpeg-xl.sh
