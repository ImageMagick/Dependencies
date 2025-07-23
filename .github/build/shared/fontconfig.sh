#!/bin/bash
set -e

cd LinuxDependencies/fontconfig

autoreconf -fiv
chmod +x ./configure
pip3 install lxml
pip3 install six
$CONFIGURE $CONFIGURE_OPTIONS --enable-libxml2 --enable-static=yes --disable-nls --disable-shared $FONTCONFIG_OPTIONS  --prefix=/dependencies CFLAGS="$FLAGS"
$MAKE install
