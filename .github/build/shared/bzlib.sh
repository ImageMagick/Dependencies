#!/bin/bash
set -e

cd Dependencies/bzlib

$MAKE install PREFIX=/dependencies
rm -f /usr/local/bin/bzip2
