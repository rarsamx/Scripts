#!/usr/bin/env bash
#
# Change the background every minute from the directory configured in nitrogen

# # Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0
if ! pgrep -x "swww-daemon" > /dev/null
then
    swww-daemon &
    sleep 1
fi

while true; do
#    nitrogen --set-zoom-fill --random
    swww img $(find ~/Pictures/Backgrounds/ -type f | shuf -n 1) --transition-type fade --outputs HDMI-A-1 
    swww img $(find ~/Pictures/Backgrounds/ -type f | shuf -n 1) --transition-type fade --outputs VGA-1 
#    nitrogen --set-zoom-fill --random --head=1
    sleep 300 
done
