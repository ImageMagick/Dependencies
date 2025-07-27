#!/bin/bash
set -e

cd Dependencies/lcms

autoreconf -fiv
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared $LCMS_OPTIONS --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS"
$MAKE install
