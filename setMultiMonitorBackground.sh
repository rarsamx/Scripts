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

SCRIPTNAME=$(basename $_)

#====== VALIDATE DEPENDENCIES ===

command -v gsettings >/dev/null 2>&1 || 
    { echo >&2 "This script only works on systems which rely on gsettings.  Aborting."; exit 1; }
command -v xrandr >/dev/null 2>&1 || 
    { echo >&2 "This script only works on systems which rely on xrandr.  Aborting."; exit 1; }
command -v identify >/dev/null 2>&1 || 
    { echo >&2 "Please install 'imagemagick'.  Aborting."; exit 1; }

#====== GLOBAL VARIABLES ===
VERSION=0.2.0
VALID=true

OUTIMG=/home/papa/.cinnamon/backgrounds/multiMonitorBackground.jpg

MONITORS=()
SCREENGEOMETRY=""
DIRECTORY=""
SINGLEIMG=false
VERBOSE=false
LOOP=false
INTERVAL=""

declare -a FILES=()

#====== FUNCTIONS ===

showHelp () {
    echo "Usage: multiMonitorBackground [OPTIONS] [FILE] [FILE] ...

This script to set up a background image spaning multiple monitors 
under Cinnamon. If no parameters are specified: A random file per monitor is 
selected from current directory.

Note: Files are scaled and shaved to fit the display area without loosing aspect radio.

It can receive the following parameters:
 FILE          Files to set as background. FILE paths must be relative to the
               DIRECTORY unless they have an absolute path. Each FILE must be 
               an image file.
               - If the script receives less files than the number of monitors
                 it will cycle through the files repeating them until all
                 monitors have a file
               - If the script receives no files and the parameter -s is not 
                 specified the script will select one random image per active 
                 monitor
 -d DIRECTORY  A directory containing image files (jpg, jpeg and png). The 
               default is the current directory
 -s            Span a single FILE across monitors.  
               If no FILE is passed, and the parameter -s is present, a random
               file from the DIRECTORY is displayed.
 -t MINUTES    Time in MINUTES to refresh the background       
 -version      Displays the version number
 -verbose      Displays additional information
    
Examples
: put the same image in each monitor
  ${SCRIPTNAME} mypic.jpg     
: span an image across all the monitors  
  ${SCRIPTNAME} mypic.jpg     
: select one random image per monitor from the directory indicated
  ${SCRIPTNAME} -d ~/Pics
: assign each image received to one or more monitors
  ${SCRIPTNAME} -d ~/Pics pic1.jpg pic2.jpg 
   
    
Requires:
  ImageMagick
  xrandr
    
Author: Raul Suarez
https://www.usingfoss.com/
"
}

readParameters () {
    DIRECTORY=""
    SINGLEIMG=false
    VERBOSE=false
    LOOP=false
    INTERVAL=""
    FILES=()

    while [ $# -gt 0 ]
    do
        unset OPTIND
        unset OPTARG
        while getopts hsv:d:t:  options
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
            t)  INTERVAL=$((OPTARG * 60))
                LOOP=true
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
    ${VERBOSE} && ${LOOP} && echo "Refresh every : $((INTERVAL / 60)) minutes"

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
    MONITORS=()

    for MONITOR in $(xrandr --listmonitors | grep "^ [0-9]" | cut -s -d " " -f 4)
    do
        VARARRAY=($(echo ${MONITOR} | tr '/' '\n' | tr 'x' '\n' | tr '+' '\n'))
        MONITORS+=($(echo ${VARARRAY[0]}x${VARARRAY[2]} +${VARARRAY[4]}+${VARARRAY[5]}))
    done
    IFS=$SAVEIFS
    NUMMONITORS=${#MONITORS[@]}
}

# From the directory select as many random files as requested in the input parameter
selectRandomImages () {
    local NUMIMAGES=$1
    FILES=($(ls "${DIRECTORY}"/*.jpg "${DIRECTORY}"/*.jpeg "${DIRECTORY}"/*.png 2>/dev/null | sort -R | tail -n ${NUMIMAGES} | sed "s/\n/ /"))
}

assembleBackgroundImage () {
    local MONITOR
    local TEMPIMG=$(mktemp --suffix=.jpg -p /tmp tmpXXX)
    local TEMPOUT=$(mktemp --suffix=.jpg -p /tmp tmpXXX)

    # Creates the blank base image
    convert -size ${SCREENGEOMETRY} xc:skyblue ${TEMPOUT}

    i=0
    for MONITOR in "${MONITORS[@]}"
    do
        GEOMETRY=$(echo ${MONITOR} | cut -s -d " " -f 1)
        OFFSET=$(echo ${MONITOR} | cut -s -d " " -f 2)
        ${VERBOSE} && echo "Monitor $i : ${GEOMETRY}${OFFSET} : ${FILES[$i]}"
        convert "${FILES[$i]}" -auto-orient -scale ${GEOMETRY}^ -gravity center -extent ${GEOMETRY} ${TEMPIMG}
        composite -geometry ${OFFSET} ${TEMPIMG} ${TEMPOUT} ${TEMPOUT}
        i+=1
        [ $i -ge ${#FILES[@]} ] && i=0
    done
    rm "${TEMPIMG}"
    mv "${TEMPOUT}" "${OUTIMG}"
}

applyBackground () {
    gsettings set org.cinnamon.desktop.background picture-options "spanned"
    gsettings set org.cinnamon.desktop.background picture-uri "file://$(readlink -f ${OUTIMG})"
}

spanSingleImage () {
    [ -z "${FILES}" ] && selectRandomImages 1
    ${VERBOSE} && echo "File : ${FILES[0]}"

    convert "${FILES[0]}" -auto-orient -scale ${SCREENGEOMETRY}^ -gravity center -extent ${SCREENGEOMETRY} "${OUTIMG}"
}

assembleOneImagePerMonitor () {
    getMonitorsGeometry
    [ -z "${FILES}" ] && selectRandomImages ${NUMMONITORS}
    assembleBackgroundImage
}

setBackground () {
    local ORIGFILES=${FILES}
    getScreenGeometry
    if ${SINGLEIMG} ; then spanSingleImage 
    else assembleOneImagePerMonitor 
    fi
    [ -f "${OUTIMG}" ] && applyBackground
    FILES=${ORIGFILES}
}
#====== MAIN BODY OF THE SCRIPT ===

readParameters $@

if ${VALID} ; then
    if ${LOOP} ; then
        while true; do setBackground ; sleep ${INTERVAL}; done
    else
        setBackground
    fi
else
    echo "Use -h parameter to read the help"
    exit 1
fi

