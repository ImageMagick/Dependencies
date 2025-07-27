#!/bin/bash
set -e

cd Dependencies/fribidi

rm lib/fribidi-config.h

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS"
$MAKE install
