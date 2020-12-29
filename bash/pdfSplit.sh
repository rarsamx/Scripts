#!/usr/bin/env bash
#
# Extract pages from a PDF 
#   SplitPDF.sh inputpdf outputpdf pagerange
# It requires 3 parameter
# - Input file
# - Output file
# - Page range: see pdftk --help 
# Example:
#    splitPDF input.pdf output output.pdf 13-15
# will extract pages 13,14,15 
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

usage="usage: ${0##*/} inputpdf outputpdf range"

INPUT=${1?"${usage}"}
OUTPUT=${2?"${usage}"}
RANGE=${3?"${usage}"}

pdftk "${INPUT}" cat ${RANGE}  output "${OUTPUT}"
