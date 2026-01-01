#!/bin/bash
set -e

cd Dependencies/zip

rm lib/config.h
rm lib/zip_err_str.c
rm lib/zipconf.h

mkdir __build
cd __build
$CMAKE_COMMAND .. -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX  -DBUILD_SHARED_LIBS=false -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_C_FLAGS="$FLAGS"
$MAKE install
