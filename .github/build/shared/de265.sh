#!/bin/bash
set -e

cd Dependencies/de265

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS $DE265_OPTIONS --disable-shared --disable-dec265 --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS" CXXFLAGS="$FLAGS"
$MAKE install
