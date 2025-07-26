#!/bin/bash
set -e

cd Dependencies/pango

rm pango/config.h
rm pango/pango-features.h
rm pango/pango-enum-types.c
rm pango/pango-enum-types.h

mkdir __build
cd __build
CFLAGS=$FLAGS meson setup .. $MESON_OPTIONS --buildtype=$MESON_BUILD_TYPE --prefix=/dependencies --default-library=static -Dgtk_doc=false -Dintrospection=false
ninja install
