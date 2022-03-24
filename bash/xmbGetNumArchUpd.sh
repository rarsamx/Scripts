#!/usr/bin/env bash
# xmobar helper to get the number of arch updates
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

# Create named pipe to write the input method to
if [ ! -p /run/user/1000/archupd_pipe ]
then
    rm -f /run/user/1000/archupd_pipe
    mkfifo /run/user/1000/archupd_pipe
fi

numUpd=$(checkupdates | wc -l)

if [ $numUpd -eq 0 ] 
then 
    echo "<icon=Security-low.xpm/>" > /run/user/1000/archupd_pipe
else
    echo "<icon=Security-high.xpm/> $numUpd" > /run/user/1000/archupd_pipe
fi 
