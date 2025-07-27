#!/bin/bash
set -e

cd Dependencies/png

autoreconf -fiv
$CONFIGURE $CONFIGURE_OPTIONS --disable-mips-msa --disable-arm-neon --disable-powerpc-vsx --disable-shared --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS"
$MAKE install
