#!/bin/bash
set -e

cd Dependencies/tiff

rm libtiff/tif_config.h
rm libtiff/tiffconf.h

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --prefix=/dependencies CFLAGS="$FLAGS" CXXFLAGS="$FLAGS"
echo '' > version
$MAKE install
