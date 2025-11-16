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
export LDFLAGS="-L$INSTALL_PREFIX/lib -L$INSTALL_PREFIX/lib64"
export PKG_CONFIG_PATH="$INSTALL_PREFIX/lib/pkgconfig:$INSTALL_PREFIX/lib64/pkgconfig"

# Shared options
export CMAKE_COMMAND="cmake"
export CMAKE_OPTIONS=""
export CONFIGURE="./configure"
export CONFIGURE_OPTIONS=""
export MAKE="make -j$(nproc)"
export MESON_OPTIONS=""
export SED="sed"

# Library specific options
export DE265_OPTIONS=""
export FONTCONFIG_OPTIONS=""
export HEIF_OPTIONS=""
export JPEGTURBO_OPTIONS="-DWITH_SIMD=1"
export LCMS_OPTIONS=""
export OPENEXR_OPTIONS=""
export WEBP_OPTIONS="--enable-libwebpmux --enable-libwebpdemux"

# Build dependencies
$SHARED_PATH/zlib.sh
$SHARED_PATH/lzma.sh
$SHARED_PATH/bzip2.sh
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
$SHARED_PATH/openjph.sh
$SHARED_PATH/imath.sh
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
$SHARED_PATH/gdk-pixbuf.sh
$SHARED_PATH/rsvg.sh
$SHARED_PATH/raqm.sh
$SHARED_PATH/highway.sh
$SHARED_PATH/brotli.sh
$SHARED_PATH/jpeg-xl.sh
