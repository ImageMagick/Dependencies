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
export PKG_CONFIG_PATH="/dependencies/lib/pkgconfig:/dependencies/lib/x86_64-linux-gnu/pkgconfig"
export CPPFLAGS="-I/dependencies/include"
export LDFLAGS="-L/dependencies/lib -L/dependencies/lib/x86_64-linux-gnu"

# Shared options
export CMAKE_COMMAND="cmake"
export CMAKE_OPTIONS=""
export CONFIGURE="./configure"
export CONFIGURE_OPTIONS=""
export MAKE="make -j$(nproc)"

# Library specific options
export DE265_OPTIONS=""
export FFI_OPTIONS="--disable-exec-static-tramp"
export FONTCONFIG_OPTIONS=""
export HEIF_OPTIONS=""
export JPEGTURBO_OPTIONS="-DWITH_SIMD=1"
export LCMS_OPTIONS=""
export OPENEXR_OPTIONS=""
export WEBP_OPTIONS="--enable-libwebpmux --enable-libwebpdemux"
