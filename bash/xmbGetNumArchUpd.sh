#!/usr/bin/env bash
# xmobar helper to get the number of arch updates
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

uid=$(id -u)

pipeName="/run/user/${uid}/archupd_pipe"

# Create named pipe to write the input method to
if [ ! -p ${pipeName} ]
then
    rm -f ${pipeName}
    mkfifo ${pipeName}
fi

numUpd=$(checkupdates | wc -l)

if [ $numUpd -eq 0 ] 
then 
    echo "<icon=Security-low.xpm/>" > ${pipeName}
else
    echo "<icon=Security-high.xpm/> $numUpd" > ${pipeName}
fi 
