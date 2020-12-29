#!/usr/bin/env bash

# pdfScale.sh
#
# Scale PDF to specified percentage of original size.
# Ref: http://ma.juii.net/blog/scale-page-content-of-pdf-files.


# Validate args.
#echo "=Validating Parameters="
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

usage="usage: ${0##*/} inputPDF scale"

INFILEPDF=${1?"${usage}"}
SCALE=${2?"${usage}"} # scaling factor (0.95 = 95%, e.g.)


[[ "${INFILEPDF}" =~ ^..*\.pdf$ ]] || { echo "${usage}"; exit 99; }

#echo "  Input File = ${INFILEPDF}"
#echo "  Scale = ${SCALE}"

# Dependencies
#echo "=Validating Dependencies="
command -v identify >/dev/null 2>&1 || { echo >&2 "Please install 'imagemagick' (sudo apt-get install imagemagick).  Aborting."; exit 1; }
command -v gs >/dev/null 2>&1 || { echo >&2 "Please install 'ghostscript' (sudo apt-get install ghostscript ?).  Aborting."; exit 1; }
command -v bc >/dev/null 2>&1 || { echo >&2 "Please install 'bc' arbitrary precision calculator language.  Aborting."; exit 1; }

# Set up the working files and directories
#echo "=Setting up environment="
CURRPATH=$(pwd)
FILENAME="${INFILEPDF##*/}"
BASENAME="${FILENAME%.*}"
#WORKINGDIR=$(tempfile)
WORKINGDIR=$(mktemp -d -p ~/tmp)
OUTFILEPDF="${CURRPATH}/${BASENAME}-1.pdf"

rm -fr "${WORKINGDIR}"
mkdir "${WORKINGDIR}"

printf "=Extracting pages="
# Extract images from PDF
pdfimages -j "${INFILEPDF}" "${WORKINGDIR}"/img
cd "${WORKINGDIR}"
printf "\r                  \r"

SMALLDIRNAME="small"
mkdir "${SMALLDIRNAME}"
i=0
pages=$(ls *.ppm | wc -l)
for picture in *.ppm 
do
  printf " Resizing page $((++i)) of $pages    \r"
  IDENTIFY=$(identify "${picture}" | cut -d " " -f 3 | tr "x" " " 2>/dev/null) # bash array

  [ $? -ne 0 ] &GEOMETRY=($(echo "${IDENTIFY}")) # bash array — $IDENTIFY[2] is of the form PGWIDTHxPGHEIGHT

  OLDWIDTH=${GEOMETRY[0]}
  OLDHEIGHT=${GEOMETRY[1]}

  # Compute translation factors (to center page.
  NEWWIDTH=$(echo "scale=0; $SCALE*$OLDWIDTH" | bc)
  NEWHEIGHT=$(echo "scale=0; $SCALE*$OLDHEIGHT" | bc)

  convert "${picture}[${NEWWIDTH}x${NEWHEIGHT}]" "${SMALLDIRNAME}/${picture}"

#  do convert "${picture}" -flip -resize $SCALE "${SMALLDIRNAME}/${picture}"
done
printf "                                          \r"

#convert -flip "img*.ppm[${NEWWIDTH}x${NEWHEIGHT}]" "${SMALLDIRNAME}/img-%03d.ppm"
cd "${SMALLDIRNAME}"

printf "=Generating output="

convert *.ppm output.pdf

cp output.pdf "${OUTFILEPDF}"
printf "\rOutput File = ${OUTFILEPDF##*/}         \n"

# Reduce the resolution 
gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -sOutputFile="${OUTFILEPDF}" "output.pdf"

cd "${CURRPATH}"
rm -fr "${WORKINGDIR}"

