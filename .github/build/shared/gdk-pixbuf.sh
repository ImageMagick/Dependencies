#!/bin/bash
set -e

cd gdk-pixbuf
rm gdk-pixbuf/config.h

mkdir __build
cd __build
CFLAGS=$FLAGS meson setup .. $MESON_OPTIONS --buildtype=$MESON_BUILD_TYPE --prefix=$INSTALL_PREFIX --default-library=static -Dglycin=disabled -Dandroid=disabled -Ddocumentation=false -Dintrospection=disabled -Dman=false -Drelocatable=false -Dthumbnailer=disabled -Dtests=false -Dinstalled_tests=false -Dtiff=enabled -Dpng=enabled -Dothers=enabled
ninja install
