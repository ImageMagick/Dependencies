#!/bin/bash
set -e

cd Dependencies/bzlib

$MAKE install PREFIX=/dependencies
