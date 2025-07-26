#!/bin/bash
set -e

cd Dependencies/freetype

mkdir __build
cd __build
$CMAKE_COMMAND .. -DCMAKE_INSTALL_PREFIX=/dependencies -DCMAKE_DISABLE_FIND_PACKAGE_BZip2=TRUE -DZLIB_INCLUDE_DIR=/dependencies/include -DZLIB_LIBRARY=/dependencies/lib/libz.a -DCMAKE_DISABLE_FIND_PACKAGE_PNG=TRUE -DBUILD_SHARED_LIBS=off -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_C_FLAGS="$FLAGS"
$MAKE install
