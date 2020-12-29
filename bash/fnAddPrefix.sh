#!/bin/bash
#
# Add a prefix to files which have a particular pattern
# It can be improved by using find instead of ls to list files
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

usage="usage: ${0##*/} pattern prefix"

PATTERN=${1?"${usage}"}
PREFIX=${2?"${usage}"}

echo ${PATTERN}
echo ${PREFIX}

#ls ${PATTERN}*
for FILE in $(ls ${PATTERN}*)
do 
  mv $FILE ${PREFIX}$(basename $FILE)
  echo ${PREFIX}$(basename $FILE)
done

