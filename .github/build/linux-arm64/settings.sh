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
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
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
