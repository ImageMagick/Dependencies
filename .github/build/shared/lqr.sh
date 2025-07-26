#!/bin/bash
set -e

cd Dependencies/lqr

autoreconf -fiv
chmod +x ./configure
mkdir /dependencies/include/lqr-1
mkdir /dependencies/include/lqr-1/lqr
$CONFIGURE $CONFIGURE_OPTIONS --prefix=/dependencies --disable-shared CFLAGS="$FLAGS"
$MAKE install
