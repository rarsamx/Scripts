#!/bin/bash
# This script renames in bulk files by replacing the sufix matching the old prefix
# and replacing it with the new prefix
# the patterns must follow bash file pattern rules
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0


usage="usage: ${0##*/} oldprefix prefix"

OLDPREFIX=${1?"${usage}"}
NEWPREFIX=${2?"${usage}"}

ls ${OLDPREFIX}* | while read FILE
do 
#  mv "${FILE}" $(echo "${FILE}" | sed "s/${OLDPREFIX}/${NEWPREFIX}/")
  echo "${FILE} -> ${FILE/${OLDPREFIX}/${NEWPREFIX}}"
  mv "${FILE}" "${FILE/${OLDPREFIX}/${NEWPREFIX}}"
done

