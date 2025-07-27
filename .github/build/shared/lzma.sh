#!/bin/bash
set -e

cd Dependencies/lzma

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --disable-doc --disable-nls --disable-xz --disable-xzdec --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS"
$MAKE install
