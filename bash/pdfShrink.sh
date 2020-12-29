#!/usr/bin/env bash
# This script reduces the resolution on a PDF file. For a higher compression, change the PDFSETTINGS to /screen
# Currently /ebook
#To do multiple files execute
# find *.pdf -type f -exec bash /home/papa/Development/Scripts/shrinkPDF.sh '{}' \;
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

usage="usage: ${0##*/} inputPDF"

FILENAME=${1?"${usage}"}


#FILENAME="${FULLFILENAME%.*}"

echo "${FILENAME}"
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -sOutputFile="${FILENAME%.*}-new.pdf" "${FILENAME}"

