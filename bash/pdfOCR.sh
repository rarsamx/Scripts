#!/usr/bin/env bash
# requires ImageMagick and Tesseract
# $ sudo apt install imagemagick tesseract-ocr
#
# Usage:
# $ ocr-pdf <pdffile>

# find <pattern> -type f -exec bash <pathToScript>/ocr-pdf.sh '{}' \;
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

usage="usage: ${0##*/} inputPDF"

FULLFILENAME=${1?"${usage}"} # set to the file name of the PDF

CURRPATH=$(pwd)

FILENAME="${FULLFILENAME##*/}"
BASENAME="${FILENAME%.*}"
WORKINGDIR=$(mktemp -d -p ~/tmp)

rm -fr "${WORKINGDIR}"
mkdir "${WORKINGDIR}"

#Extract images from PDF
pdfimages  "${FULLFILENAME}" "${WORKINGDIR}"/img

cd "${WORKINGDIR}"

#Convert each extracted image to a text file
i=0
pages=$(ls *.ppm | wc -l)
for imagefile in *.ppm; do
    printf " Page $((++i)) of $pages    \r"
    tesseract "${imagefile}" "${imagefile%.*}" 2> /dev/null  
done

#Concatenate resulting text files
cat *.txt > "${BASENAME}.txt"
printf "$pages Pages                \n"

#Cleanup

mv "${BASENAME}.txt" "${CURRPATH}"/.
cd "${CURRPATH}"
rm -fr "${WORKINGDIR}"


