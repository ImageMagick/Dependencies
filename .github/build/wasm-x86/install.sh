#!/bin/bash
set -e

apt-get update -y

apt-get install -y autogen autoconf gperf libtool locales pkg-config shtool

locale-gen en_US.UTF-8

pip3 install --break-system-packages cmake==4.3.4
pip3 install --break-system-packages meson==1.11.1
pip3 install --break-system-packages ninja==1.13.0

emconfigure || true
