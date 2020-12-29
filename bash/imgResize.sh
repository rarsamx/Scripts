#!/usr/bin/env bash
#
#Creates a subfolder with thumbnails of the jpg files in each of the directores passed as parameters

##Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

processParameter ()
{
  if [ -f "${1}" ] ; then
    basepath="$(dirname "${1}")"
    echo "${basepath}"
    smallDirName="small$(basename "${basepath}")"
    pushd "${basepath}"
    pwd
    mkdir "${smallDirName}"
    picture="$(basename "${1}")"
    processPicture "${picture}"
    popd
  else
    basepath="${1}"
    smallDirName="small$(basename "${basepath}")"
    processFolder "${basepath}"
  fi
}

processFolder ()
{
  cd "${1}"
  pwd
  mkdir "${smallDirName}"
  for picture in *.jpg *.Jpg *.JPg *.JPG *.jpeg *.Jpeg *.JPeg *.JPEg *.JPEG
  do
    if [ -f "${picture}" ] ; then
      processPicture "${picture}"
    fi
  done
}

processPicture ()
{
  echo "${smallDirName}/$1"
  convert "$1[640x480]" "${smallDirName}/$1"
}

#=== main code ===

for parameter in "$@"
do
  echo "parameter=${parameter}"
  processParameter "${parameter}"
done
