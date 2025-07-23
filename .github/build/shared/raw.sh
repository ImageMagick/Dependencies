#!/bin/bash
set -e

cd Dependencies/raw

chmod +x ./version.sh
chmod +x ./shlib-version.sh
autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --disable-examples --disable-openmp --disable-jpeg --disable-jasper --prefix=/dependencies  CFLAGS="$FLAGS" CXXFLAGS="$FLAGS"
$MAKE install
