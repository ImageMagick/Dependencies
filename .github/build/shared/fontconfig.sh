#!/bin/bash
set -e

cd NonWindowsDependencies/fontconfig

mkdir __build
cd __build
CFLAGS=$FLAGS meson setup .. $MESON_OPTIONS --buildtype=$MESON_BUILD_TYPE --prefix=$INSTALL_PREFIX --default-library=static -Dnls=disabled -Dtests=disabled -Dtools=disabled $FONTCONFIG_OPTIONS
ninja install
