#!/usr/bin/env bash
#
# Example of how to set the exif data in a jpg file
# In this example it sets the time to the file actual time plus 12 hours
# for all the files in a directory.
# This is for when the camera had the wrong time
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

usage="usage: ${0##*/} imagesDir"

DIRNAME=${1?"${usage}"}

cd "${DIRNAME}"
#ls "${1}"
echo "dsft"
jhead -q -dsft * | grep -Eo "'.*'" | tr "'" " " | while read FILE; do jhead -q -mkexif "${FILE}"; done
#jhead -dsft *
echo "ta"
jhead -ta+12 *
echo "ft"
jhead -ft *
read a

