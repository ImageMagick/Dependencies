#!/bin/bash
set -e

cd Dependencies/webp

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS $WEBP_OPTIONS --disable-shared --disable-png --disable-jpeg --disable-tiff --prefix=/dependencies CFLAGS="$FLAGS"
$MAKE install
