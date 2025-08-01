#!/bin/bash
set -e

cd Dependencies/cairo

rm src/cairo-features.h
rm src/config.h

mkdir __build
cd __build
CFLAGS=$FLAGS meson setup .. $MESON_OPTIONS --buildtype=$MESON_BUILD_TYPE --prefix=$INSTALL_PREFIX --default-library=static -Dxlib=disabled -Dquartz=disabled -Dfontconfig=enabled -Dfreetype=enabled -Dtests=disabled

sed -i 's/#define CAIRO_HAS_PTHREAD 1/#define CAIRO_NO_MUTEX 1/' config.h

ninja install
