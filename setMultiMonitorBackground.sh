#!/bin/bash

# This script creates an image to span multiple monitors under Cinnamon
# It receives only one parameter which can be
# - A single file name : The script resizes and shaves the image to fit the screeens
# - A directory with potential files: the script selects randomly one file per monitor.
#
# Note: Files are scaled and shaved to fit the display area without loosing aspect radio.
#
#Requires:
#  ImageMagick
#  xrandr
#
# Author: Raul Suarez
# https://www.usingfoss.com/

SCRIPTNAME=$_
#====== VALIDATE DEPENDENCIES ===

command -v gsettings >/dev/null 2>&1 || { echo >&2 "This script only works on systems which rely on gsettings.  Aborting."; exit 1; }
command -v xrandr >/dev/null 2>&1 || { echo >&2 "This script only works on systems which rely on xrandr.  Aborting."; exit 1; }
command -v identify >/dev/null 2>&1 || { echo >&2 "Please install 'imagemagick'.  Aborting."; exit 1; }

#====== GLOBAL VARIABLES ===
VERSION=0.2.0
VALID=true

OUTIMG=/home/papa/.cinnamon/backgrounds/multiMonitorBackground.jpg

MONITORS=()
SCREENGEOMETRY=""
DIRECTORY=""
SINGLEIMG=false
VERBOSE=false

declare -a FILES=()

#====== FUNCTIONS ===

showHelp () {
    echo 'Usage: multiMonitorBackground [OPTIONS] [FILE]

This script to set up a background image spaning multiple monitors 
under Cinnamon. If no parameters are specified: A random file per monitor is 
selected from current directory as per the default.

It can receive the following parameters:
 [FILE]        File to display across monitors. If no file is passed and 
               the parameter -s is specified, the script will display a random
               image from the DIRECTORY. FILE paths must be relative to the
               DIRECTORY unless they have an absolute path
 -d DIRECTORY  A directory containing image files (jpg, jpeg and png). The 
               default is the current directory
 -s            Expand a single file. The script resizes and shaves the image to
               fit all the screeens. If no IMAGEFILE is passed, and the
               parameter -s is present, a random file from the IMAGEDIRECTORY
               is displayed. If a FILE is present, -s is assumed
 -version      Displays the version number
 -verbose      Displays additional information
    
Examples
  setMultimonitorBackground mypicture.jpg
 
  setMultimonitorBackground "~/Pictures"
    
Note: Files are scaled and shaved to fit the display area without loosing aspect radio.
    
Requires:
  ImageMagick
  xrandr
    
Author: Raul Suarez
https://www.usingfoss.com/
'
}

readParameters () {
    while [ $# -gt 0 ]
    do
        unset OPTIND
        unset OPTARG
        while getopts hsv:d:  options
        do
        case $options in
            h)  showHelp
                exit 0
                ;;
            v)  local SECONDPART="$OPTARG"
                [ "${SECONDPART}" != "ersion" ] && [ "${SECONDPART}" != "erbose" ] && 
                    echo "Invalid parameter -v$SECONDPART. Use parameter -h for help." && 
                    exit 1
                [ ${SECONDPART} == "ersion" ] && 
                    echo Version ${VERSION} && 
                    exit 0
                [ ${SECONDPART} == "erbose" ] && 
                    VERBOSE=true
                ;;
            d)  DIRECTORY="$OPTARG"
                ;;
            s)  SINGLEIMG=true
                ;;
            *)  exit 1
        esac
     done
     shift $((OPTIND-1))
     FILES+=(${1})
     shift
    done

    [ -n "${DIRECTORY}" ] && [ -n "${FILES}" ] && assembleFullFileNames

    ${VERBOSE} && echo "Directory : ${DIRECTORY}"
    ${VERBOSE} && [ -n "${FILES}" ] && echo "Files : ${FILES[@]}"
    ${VERBOSE} && echo "Single image : ${SINGLEIMG}"

    validateParameters
    [ -z "${DIRECTORY}" ] && DIRECTORY="."
}

assembleFullFileNames () {

    declare -i i=0
    for FILE in "${FILES[@]}"
    do
        if [ "$(readlink -f ${FILE})" != "${FILE}" ]; then
            FILES[$i]="${DIRECTORY}/${FILES[$i]}"
        fi
        i+=1
    done
}

countImagesInDir () {
    local TESTDIR="${1}"
    echo $(ls "${TESTDIR}"/*.jpg "${TESTDIR}"/*.jpeg "${TESTDIR}"/*.png 2>/dev/null | wc -l)
}

validateParameters () {
    # Validate directory
    if [ -n "${DIRECTORY}" ] ; then
        [ $(countImagesInDir "${DIRECTORY}") -le 0 ] && VALID=false 
        ! ${VALID}  &&  
            echo "ERROR: Invalid directory name \"${DIRECTORY}\" or directory does not contain image files " && 
            return 1
    fi

    # Validate files
    if [ -n "${FILES}" ] ; then
        for FILE in "${FILES[@]}"
        do
            [ -f "${FILE}" ] && identify "${FILE}" &>> /dev/null 
            [ "$?" -ne 0 ] && VALID=false
            ! ${VALID} && 
                echo "ERROR: Invalid file name ${FILE} or file is not an image file" && 
                return 1
        done
    fi

    # Validate current directory if no directory or files were passed
    if [ -z "${DIRECTORY}" ] && [ -z "${FILES}" ] ; then
        [ $(countImagesInDir ".") -le 0 ] && VALID=false 
        ! ${VALID} &&  
            echo "ERROR: Current directory does not contain image files " && 
            return 1
    fi

    ${SINGLEIMG} && [ ${#FILES[@]} -gt 1 ] && echo "Warning single file parameter but two files specified"

    return 0
}

getScreenGeometry () {
    SCREENGEOMETRY=$(xrandr | grep "Screen 0: " | sed "s/.*current \([0-9]*\) x \([0-9]*\).*/\1x\2/")
}

getMonitorsGeometry () {
    local MONITOR
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")

    for MONITOR in $(xrandr --listmonitors | grep "^ [0-9]" | cut -s -d " " -f 4)
    do
        VARARRAY=($(echo ${MONITOR} | tr '/' '\n' | tr 'x' '\n' | tr '+' '\n'))
        MONITORS+=($(echo ${VARARRAY[0]}x${VARARRAY[2]} +${VARARRAY[4]}+${VARARRAY[5]}))
    done
    IFS=$SAVEIFS
}

assembleBackgroundImage () {
    local MONITOR
    local TEMPIMG=$(mktemp --suffix=.jpg -p /tmp tmpXXX)
    local TEMPOUT=$(mktemp --suffix=.jpg -p /tmp tmpXXX)

    # Creates the blank base image
    convert -size ${SCREENGEOMETRY} xc:skyblue ${TEMPOUT}

    # From the directory select as many random files as there are monitors
    NUMMONITORS=${#MONITORS[@]}
    FILES=($(ls "${DIRECTORY}"/*.jpg "${DIRECTORY}"/*.jpeg "${DIRECTORY}"/*.png 2>/dev/null | sort -R | tail -n ${NUMMONITORS} | sed "s/\n/ /"))

    i=0
    for MONITOR in "${MONITORS[@]}"
    do
        GEOMETRY=$(echo ${MONITOR} | cut -s -d " " -f 1)
        OFFSET=$(echo ${MONITOR} | cut -s -d " " -f 2)
        ${VERBOSE} && echo "Monitor $i : ${GEOMETRY}${OFFSET} : ${FILES[$i]}"
        convert "${FILES[$i]}" -auto-orient -scale ${GEOMETRY}^ -gravity center -extent ${GEOMETRY} ${TEMPIMG}
        composite -geometry ${OFFSET} ${TEMPIMG} ${TEMPOUT} ${TEMPOUT}
        i+=1
    done
    rm "${TEMPIMG}"
    mv "${TEMPOUT}" "${OUTIMG}"
}

setBackground () {
    gsettings set org.cinnamon.desktop.background picture-options "spanned"
    gsettings set org.cinnamon.desktop.background picture-uri "file://$(readlink -f ${OUTIMG})"
}

expandSingleImage () {
    local FILE="${1}"
    ${VERBOSE} && echo "File : ${FILE}"

    convert "${FILE}" -auto-orient -scale ${SCREENGEOMETRY}^ -gravity center -extent ${SCREENGEOMETRY} "${OUTIMG}"
}

expandRandomImage () {
    local FILE=($(ls "${DIRECTORY}"/*.jpg "${DIRECTORY}"/*.jpeg "${DIRECTORY}"/*.png 2>/dev/null | sort -R | tail -n 1 | sed "s/\n/ /"))
    expandSingleImage ${FILE}
}

assembleOneImagePerMonitor () {
    getMonitorsGeometry
    assembleBackgroundImage
}

#====== MAIN BODY OF THE SCRIPT ===

readParameters $@

if ${VALID} ; then
    getScreenGeometry
    if [ -f "${FILES[0]}" ] ; then expandSingleImage "${FILES[0]}"
    elif ${SINGLEIMG} ; then expandRandomImage 
    else assembleOneImagePerMonitor 
    fi
    [ -f "${OUTIMG}" ] && setBackground
else
    echo "Use -h parameter to read the help"
    exit 1
fi

