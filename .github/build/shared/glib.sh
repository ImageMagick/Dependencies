#!/bin/bash
set -e

cd Dependencies/glib

rm gio/gioenumtypes.c
rm gio/gioenumtypes.h
rm gio/gnetworking.h
rm glib/config.h
rm glib/glibconfig.h
rm glib/gnulib/gnulib_math.h
rm gmodule/gmoduleconf.h
rm gobject/glib-enumtypes.h

mkdir __build
cd __build
export CFLAGS="$FLAGS"
meson $MESON_OPTIONS --prefix=$INSTALL_PREFIX --buildtype=$MESON_BUILD_TYPE --default-library=static -Dselinux=disabled -Dxattr=false -Dlibmount=disabled -Dnls=disabled -Dinternal_pcre=true -Dgtk_doc=false -Dman=false ..
ninja install

chmod 755 $INSTALL_PREFIX/bin/glib-genmarshal
chmod 755 $INSTALL_PREFIX/bin/glib-mkenums

cp $INSTALL_PREFIX/bin/glib-genmarshal /usr/local/bin/glib-genmarshal
cp $INSTALL_PREFIX/bin/glib-mkenums /usr/local/bin/glib-mkenums
