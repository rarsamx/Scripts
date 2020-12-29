#!/usr/bin/env bash
# When scanning in a single side scanner, it is easy to first scann all the
# front pages (odd pages) into one document and all the back pages (even pages)
# into another document. This script merges them to get the final document
#
#   mergeFrontBack frontfile backfile outputfile
#
# Do not include the extension. the script assumes they are .pdf
#
# The Front/odd pages should be scanned in ascending order
# The back/even pages shoudl be scanned in descending order 
# you can accieve this by just fliping the stack after scanning the front
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

usage="usage: ${0##*/} frontFile backFile outputFile"

FRONT=${1?"${usage}"}
BACK=${2?"${usage}"}
OUTPUT=${3?"${usage}"}

pdftk A="${FRONT}.pdf" B="${BACK}.pdf" shuffle A Bend-1 output "${OUTPUT}.pdf"
