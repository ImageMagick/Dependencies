#!/bin/bash
set -e

cd Dependencies/pixman

mkdir __build
cd __build
CFLAGS=$FLAGS meson setup .. $MESON_OPTIONS --buildtype=$MESON_BUILD_TYPE --prefix=$INSTALL_PREFIX --default-library=static -Dtests=disabled -Ddemos=disabled
ninja install
