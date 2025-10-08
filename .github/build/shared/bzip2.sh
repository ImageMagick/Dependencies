#!/bin/bash
set -e

cd Dependencies/bzip2

$MAKE install PREFIX=$INSTALL_PREFIX
