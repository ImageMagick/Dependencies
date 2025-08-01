#!/bin/bash
set -e

cd Dependencies/imath

rm ImathConfig.h

$CMAKE_COMMAND . $CMAKE_OPTIONS -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DBUILD_SHARED_LIBS=off -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DBUILD_TESTING=off -DCMAKE_CXX_FLAGS="$FLAGS"
$MAKE install
