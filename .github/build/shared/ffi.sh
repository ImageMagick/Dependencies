#!/bin/bash
set -e

cd Dependencies/ffi

sed -i 's/AC_PREREQ(\[2.71\])//' configure.ac
sed -i 's/AC_CHECK_INCLUDES_DEFAULT//' configure.ac
rm include/ffi.h
rm include/fficonfig.h

autoreconf -fiv
chmod +x ./configure
$CONFIGURE $CONFIGURE_OPTIONS --disable-shared --disable-docs --disable-exec-static-tramp --prefix=$INSTALL_PREFIX CFLAGS="$FLAGS"
$MAKE install
