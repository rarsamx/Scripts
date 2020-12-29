#!/usr/bin/env bash
# This scripts launches an application and minimizes it after the defined time
# Usage
#   startMinimized.sh program title action delay
# program: the program to execute
# title: the title of the window
# action: can be "close" or "minimize".
#   close : for applications which close to the tray
#   minimize : for applications which must be minimized 
# delay: time in seconds to minimize it after launch
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

usage="usage: ${0##*/} program title action delay"

PROGRAM=${1?"${usage}"}
TITLE=${2?"${usage}"}
ACTION=${3?"${usage}"}
DELAY=${4?"${usage}"}

${PROGRAM} & 
sleep ${DELAY} 

case "$ACTION" in 
	close)    wmctrl -Fc "${TITLE}"
						;;
	minimize) xdotool search --onlyvisible --name "${TITLE}" windowminimize 
						;;
esac
