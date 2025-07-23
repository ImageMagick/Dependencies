#!/bin/bash
set -e

cd Dependencies/zlib

chmod +x ./configure
$CONFIGURE --static --prefix=/dependencies
$MAKE install CFLAGS="$FLAGS"
