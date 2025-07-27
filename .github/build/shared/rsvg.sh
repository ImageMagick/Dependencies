#!/bin/bash
set -e

cd Dependencies/rsvg

export GLIB_MKENUMS="$INSTALL_PREFIX/bin/glib-mkenums"
export GLIB_GENMARSHAL="$INSTALL_PREFIX/bin/glib-genmarshal"

cd gdk-pixbuf
rm gdk-pixbuf/config.h

sed -i 's|/usr/local/lib/libtiff.la|$INSTALL_PREFIX/lib/libtiff.la|' configure.ac

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --with-included-loaders=yes --enable-modules=no --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS"
$MAKE install

cd ../librsvg

rm config.h

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --disable-Bsymbolic --disable-introspection --disable-pixbuf-loader --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS -I$INSTALL_PREFIX/include/libcroco-0.6/libcroco"
$MAKE install
