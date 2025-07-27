#!/bin/bash
set -e

cd Dependencies/bzlib

$MAKE install PREFIX=$INSTALL_PREFIX
