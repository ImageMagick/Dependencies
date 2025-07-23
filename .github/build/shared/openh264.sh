#!/bin/bash
set -e

cd Dependencies/openh264

mkdir __build
cd __build
CFLAGS=$FLAGS CXXFLAGS=$FLAGS meson setup $MESON_OPTIONS --prefix=/dependencies --buildtype=$MESON_BUILD_TYPE --default-library=static -Dtests=disabled ..
ninja install
