#!/bin/bash
set -e

cd Dependencies/rsvg

export GLIB_MKENUMS="$INSTALL_PREFIX/bin/glib-mkenums"
export GLIB_GENMARSHAL="$INSTALL_PREFIX/bin/glib-genmarshal"

cd gdk-pixbuf
rm gdk-pixbuf/config.h

mkdir __build
cd __build
CFLAGS=$FLAGS meson setup .. $MESON_OPTIONS --buildtype=$MESON_BUILD_TYPE --prefix=$INSTALL_PREFIX --default-library=static -Dglycin=disabled -Dandroid=disabled -Ddocumentation=false -Dintrospection=disabled -Dman=false -Drelocatable=false -Dthumbnailer=disabled -Dtests=false -Dinstalled_tests=false -Dtiff=enabled -Dpng=enabled -Dothers=enabled
ninja install

cd ../../librsvg

rm config.h

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --disable-Bsymbolic --disable-introspection --disable-pixbuf-loader --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS -I$INSTALL_PREFIX/include/libcroco-0.6/libcroco"
$MAKE install
