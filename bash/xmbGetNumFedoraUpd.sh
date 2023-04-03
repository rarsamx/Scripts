#!/usr/bin/env bash
# xmobar helper to get the number of arch updates
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

# Create named pipe to write the input method to
if [ ! -p /run/user/1000/fedoraupd_pipe ]
then
    rm -f /run/user/1000/fedoraupd_pipe
    mkfifo /run/user/1000/fedoraupd_pipe
fi
numUpd=$(sudo dnf check-update | grep -c ' updates[[:space:]]*$')

if [ $numUpd -eq 0 ] 
then 
    echo "<icon=Security-low.xbm/>" > /run/user/1000/fedoraupd_pipe
else
    echo "<icon=Security-high.xbm/> $numUpd" > /run/user/1000/fedoraupd_pipe
fi 
