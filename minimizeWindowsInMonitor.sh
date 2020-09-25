#!/bin/bash

#This script minimizes all the windows from a given monitor. If they are already
#minimized, it restores them
#
#Requires:
#  wmctrl
#  xrandr
#  xdotool
#    
#Author: Raul Suarez
#https://www.usingfoss.com/


SCRIPTNAME=$(basename $_)

#====== VALIDATE DEPENDENCIES ===

command -v xrandr >/dev/null 2>&1 || 
    { echo >&2 "This script only works on systems which rely on xrandr.  Aborting."; exit 1; }
command -v wmctrl >/dev/null 2>&1 || 
    { echo >&2 "Please install wmctrl.  Aborting."; exit 1; }
command -v xdotool >/dev/null 2>&1 || 
    { echo >&2 "Please install xdotool.  Aborting."; exit 1; }

#====== GLOBAL VARIABLES ===
VERSION=0.0.1

declare VALID=true
declare -a MONITORS=()
declare -a WINDOWS=()
declare SAVEFILE="${HOME}/.mwfm"
declare DESKTOPNUM=0
declare MONITORNUM=0

#====== FUNCTIONS ===

showHelp () {
    echo "Usage: ${SCRIPTNAME} [MONITORNUM]

This script minimizes all the windows from a given monitor. If they are already
minimized, it restores them

It can receive the following parameters:
 MONITORNUM          Integer reprsenting the monitor number starting from zero.
                     It defaults to zero
    
Examples
: minimize all windows on monitor 1
  ${SCRIPTNAME} 1     
    
Requires:
  wmctrl
  xrandr
  xdotool
    
Author: Raul Suarez
https://www.usingfoss.com/
"
}

readParameters () {
    MONITORNUM="${1}"
    SAVEFILE+=${MONITORNUM}
    validateParameters
}

validateParameters () {
    return 0
}

getMonitorsGeometry () {
    local MONITOR
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    MONITORS=()

    for MONITOR in $(xrandr --listmonitors | grep "^ [0-9]" | cut -s -d " " -f 4)
    do
        VARARRAY=($(echo ${MONITOR} | tr '/' '\n' | tr 'x' '\n' | tr '+' '\n'))
        MONITORS+=($(echo ${VARARRAY[0]},${VARARRAY[2]},${VARARRAY[4]},${VARARRAY[5]}))
    done
    IFS=$SAVEIFS
}

getWindowList () {
    local WINDOW
    for WINDOW in $(wmctrl -lG | grep -e "^[0-9a-fx]*  0 " | sed "s:^\([0-9a-fx]*\)[ ]*\([0-9]*\)[ ]*\([-0-9]*\)[ ]*\([-0-9]*\)[ ]*\([-0-9]*\)[ ]*\([-0-9]*\).*:\1,\2,\3,\4,\5,\6:")
    do
        WINDOWS+=(${WINDOW})
    done
}

minimizeWindows () {
    local MONITOR
    local WINDOW

    echo "${SAVEFILE}"
    > "${SAVEFILE}"
    getWindowList
    getMonitorsGeometry
   
    MONITOR=${MONITORS[${MONITORNUM}]}
    MONLEFT=$(echo ${MONITOR} | cut -d "," -f 3)
    MONTOP=$(echo ${MONITOR} | cut -d "," -f 4)
    MONRIGHT=$(( MONLEFT + $(echo ${MONITOR} | cut -d "," -f 1)))
    MONBOTTOM=$(( MONTOP + $(echo ${MONITOR} | cut -d "," -f 2)))

    i=0
    for WINDOW in "${WINDOWS[@]}"
    do
        WINID=$(echo ${WINDOW} | cut -s -d "," -f 1)
        WINLEFT=$(echo ${WINDOW} | cut -s -d "," -f 3)
        WINTOP=$(echo ${WINDOW} | cut -s -d "," -f 4)
        [ ${MONLEFT} -le ${WINLEFT} ] &&
            [ ${WINLEFT} -lt ${MONRIGHT} ] &&
            [ ${MONTOP} -le ${WINTOP} ] &&
            [ ${WINTOP} -lt ${MONBOTTOM} ] &&
            echo ${WINDOW} >> "${SAVEFILE}" &&
            xdotool windowminimize ${WINID}
            
        i+=1
    done
    
#    minimize windows which have the xgeometry >= geometry of selected monitor
}

restoreWindows () {
    echo "${SAVEFILE}"

    local CURRENTWIN=$(xdotool getactivewindow)
    while read LINE; do
        WINID=$(echo ${LINE} | cut -s -d "," -f 1)
        wmctrl -ia ${WINID}
    done < "${SAVEFILE}"
    xdotool windowactivate ${CURRENTWIN}
    rm "${SAVEFILE}"    
}

#====== MAIN BODY OF THE SCRIPT ===

readParameters $@

if ${VALID} ; then
    if  [ -f "${SAVEFILE}" ] ; then
        restoreWindows
    else
        minimizeWindows
    fi
else
    echo "Use -h parameter to read the help"
    exit 1
fi

