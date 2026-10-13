#!/bin/sh
set -e

apk update

apk add autoconf automake bash binutils-aarch64 clang19 file g++ gcc gettext-tiny git gperf help2man libtool linux-headers make musl-libintl nasm pkgconf python3 py3-lxml py3-pip ragel texinfo zip

pip3 install --break-system-packages --upgrade pip
pip3 install --break-system-packages cmake==4.3.4
pip3 install --break-system-packages meson==1.11.1
pip3 install --break-system-packages ninja==1.13.0

echo '#!/bin/bash' > /usr/local/bin/gtkdocize
chmod 755 /usr/local/bin/gtkdocize

# Install the aarch64 headers, libraries and gcc runtime into a sysroot
apk add --root /usr/aarch64-alpine-linux-musl --arch aarch64 --initdb --no-scripts --no-cache \
  --keys-dir /usr/share/apk/keys/aarch64 --repositories-file /etc/apk/repositories \
  g++ linux-headers musl-dev musl-libintl
