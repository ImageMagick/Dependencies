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
export SED="sed"

# Library specific options
export DE265_OPTIONS="--disable-sse"
export FONTCONFIG_OPTIONS=""
export HEIF_OPTIONS="-DENABLE_MULTITHREADING_SUPPORT=false"
export JPEGTURBO_OPTIONS="-DWITH_SIMD=0"
export LCMS_OPTIONS="--without-threads"
export OPENEXR_OPTIONS="-DImath_DIR=$INSTALL_PREFIX/lib/cmake/Imath -Dopenjph_DIR=$INSTALL_PREFIX/lib/cmake/openjph"
export WEBP_OPTIONS=""

# Set compiler for cross-compilation
export CC=emcc
export CXX=em++
export EM_PKG_CONFIG_PATH=$PKG_CONFIG_PATH

# Build dependencies
DEPENDENCIES=(
  "zlib"
  "xml"
  "png"
  "freetype"
  "jpeg-turbo"
  "tiff"
  "webp"
  "openjpeg"
  "lcms"
  "aom"
  "de265"
  "heif"
  "raw"
  "openjph"
  "imath"
  "exr"
  "ffi"
  "glib"
  "lqr"
  "highway"
  "brotli"
  "jpeg-xl"
)

for dependency in "${DEPENDENCIES[@]}"; do
  $SHARED_PATH/$dependency.sh
done

# Create license files
license_folder="$INSTALL_PREFIX/license"
mkdir -p "$license_folder"
for dependency in "${DEPENDENCIES[@]}"; do
  config_file="Dependencies/$dependency/.ImageMagick/Config.txt"
  if [ ! -f "$config_file" ]; then
    echo "Unable to find .ImageMagick/Config.txt for $dependency"
    exit 1
  fi

  version=$(sed -n '/^\[VERSION\]/{n;p;}' "$config_file")
  release_date=$(sed -n '/^\[RELEASE_DATE\]/{n;p;}' "$config_file")
  license_file=$(sed -n '/^\[LICENSE_FILE\]/{n;p;}' "$config_file")
  license_file="Dependencies/$dependency/${license_file//\\//}"

  echo -e "[ $dependency $version ($release_date) ]\n" > "$license_folder/$dependency.txt"
  sed -z '$ s/\n\+$/\n/' $license_file >> "$license_folder/$dependency.txt"
done
