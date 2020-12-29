#!/usr/bin/env bash
# This script renames in bulk files by replacing the matching pattern 
# with the replacement pattern
# the patterns must follow bash file pattern rules
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0


usage="usage: ${0##*/} pattern replacement"

PATTERN=${1?"${usage}"}
REPLACEMENT=${2?"${usage}"}

ls *${PATTERN}* | while read FILE
do 
#  mv "${FILE}" $(echo "${FILE}" | sed "s/${PATTERN}/${PREFIX}/")
  echo "${FILE} -> ${FILE//${PATTERN}/${REPLACEMENT}}"
  mv "${FILE}" "${FILE/${PATTERN}/${REPLACEMENT}}"
done
