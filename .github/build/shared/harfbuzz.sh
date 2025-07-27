#!/bin/bash
set -e

cd Dependencies/harfbuzz

mkdir __build
cd __build
CXXFLAGS=$FLAGS meson setup .. $MESON_OPTIONS --buildtype=$MESON_BUILD_TYPE --prefix=$INSTALL_PREFIX --default-library=static -Ddocs=disabled -Dtests=disabled -Dcairo=disabled -Dgobject=disabled
ninja install
