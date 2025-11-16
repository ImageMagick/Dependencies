#!/bin/bash
set -e

cd NonWindowsDependencies/fontconfig

autoreconf -fiv
chmod +x ./configure
pip3 install --break-system-packages lxml
pip3 install --break-system-packages six
$CONFIGURE $CONFIGURE_OPTIONS --enable-libxml2 --enable-static=yes --disable-nls --disable-shared $FONTCONFIG_OPTIONS  --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS"
$MAKE install
