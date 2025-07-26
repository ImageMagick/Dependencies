#!/bin/bash
set -e

cd Dependencies/jpeg-turbo

rm src/jconfig.h
rm src/jconfigint.h
rm src/jversion.h

$CMAKE_COMMAND . $CMAKE_OPTIONS  $JPEGTURBO_OPTIONS -DCMAKE_INSTALL_PREFIX=/dependencies -DENABLE_SHARED=off -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_C_FLAGS="$FLAGS"
$MAKE install
