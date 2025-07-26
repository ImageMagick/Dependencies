#!/bin/bash
set -e

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
SHARED_PATH="$SCRIPT_PATH/../shared"

. $SCRIPT_PATH/settings.sh

$SHARED_PATH/zlib.sh
$SHARED_PATH/lzma.sh
$SHARED_PATH/bzlib.sh
$SHARED_PATH/zip.sh
$SHARED_PATH/xml.sh
$SHARED_PATH/png.sh
$SHARED_PATH/freetype.sh
$SHARED_PATH/fontconfig.sh
$SHARED_PATH/jpeg-turbo.sh
$SHARED_PATH/tiff.sh
$SHARED_PATH/webp.sh
$SHARED_PATH/openjpeg.sh
$SHARED_PATH/lcms.sh
$SHARED_PATH/aom.sh
$SHARED_PATH/de265.sh
$SHARED_PATH/openh264.sh
$SHARED_PATH/heif.sh
$SHARED_PATH/raw.sh
$SHARED_PATH/deflate.sh
$SHARED_PATH/exr.sh
$SHARED_PATH/ffi.sh
$SHARED_PATH/glib.sh
$SHARED_PATH/lqr.sh
$SHARED_PATH/pixman.sh
$SHARED_PATH/cairo.sh
$SHARED_PATH/fribidi.sh
$SHARED_PATH/harfbuzz.sh
$SHARED_PATH/pango.sh
$SHARED_PATH/croco.sh
$SHARED_PATH/rsvg.sh
$SHARED_PATH/raqm.sh
$SHARED_PATH/highway.sh
$SHARED_PATH/brotli.sh
$SHARED_PATH/jpeg-xl.sh
