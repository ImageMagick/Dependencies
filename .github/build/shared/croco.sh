#!/bin/bash
set -e

cd Dependencies/croco

autoreconf -fiv
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --disable-Bsymbolic --prefix=/dependencies CFLAGS="$FLAGS"
$MAKE install
