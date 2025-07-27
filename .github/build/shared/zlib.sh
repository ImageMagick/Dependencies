#!/bin/bash
set -e

cd Dependencies/zlib

chmod +x ./configure
$CONFIGURE --static --prefix=$INSTALL_PREFIX
$MAKE install CFLAGS="$FLAGS"
