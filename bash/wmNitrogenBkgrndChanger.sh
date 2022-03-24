#!/usr/bin/env bash
#
# Change the background every minute from the directory configured in nitrogen

# # Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

while true; do
#    nitrogen --set-zoom-fill --random
    nitrogen --set-zoom-fill --random --head=0
    nitrogen --set-zoom-fill --random --head=1
    sleep 60 
done
