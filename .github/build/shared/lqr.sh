#!/bin/bash
set -e

cd Dependencies/lqr

autoreconf -fiv
chmod +x ./configure
mkdir $INSTALL_PREFIX/include/lqr-1
mkdir $INSTALL_PREFIX/include/lqr-1/lqr
$CONFIGURE $CONFIGURE_OPTIONS --prefix=$INSTALL_PREFIX --disable-shared CFLAGS="$FLAGS"
$MAKE install
