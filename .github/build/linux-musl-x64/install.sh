#!/bin/sh
set -e

apk update

apk add autoconf automake bash file g++ gcc gettext-tiny git gperf libtool linux-headers make musl-libintl nasm pkgconf python3 py3-lxml py3-pip ragel texinfo zip

pip3 install --no-cache-dir --upgrade pip
pip3 install --no-cache-dir cmake==3.30.3
pip3 install --no-cache-dir meson==1.5.1
pip3 install --no-cache-dir ninja==1.11.1.1

echo '#!/bin/bash' > /usr/local/bin/gtkdocize
chmod 755 /usr/local/bin/gtkdocize
