#!/bin/bash
set -e

cd Dependencies/exr

rm IexConfig.h
rm IexConfigInternal.h
rm IlmThreadConfig.h
rm OpenEXRConfig.h
rm OpenEXRConfigInternal.h

mkdir __build
cd __build
$CMAKE_COMMAND .. $CMAKE_OPTIONS -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DBUILD_SHARED_LIBS=false -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DBUILD_TESTING=false -DOPENEXR_BUILD_TOOLS=false -DOPENEXR_BUILD_EXAMPLES=false $OPENEXR_OPTIONS -DCMAKE_CXX_FLAGS="$FLAGS"
$MAKE install
