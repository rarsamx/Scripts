#!/usr/bin/env bash

# This script resizes an image to a particular size, cropping it centered if necessary

# To do multiple files execute
# find *.pdf -type f -exec resizeForBackground '{}' <size> \;
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0


usage="usage: ${0##*/} image size"

IMAGEIN=${1?"${usage}"}
SIZE=${2?"${usage}"}

convert "${IMAGEIN}" -scale ${SIZE}^ -gravity center -extent ${SIZE} ${IMAGEIN%.*}-resized.${IMAGEIN##*.}

