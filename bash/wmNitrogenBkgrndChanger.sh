#!/usr/bin/env bash
#
# Change the background every minute from the directory configured in nitrogen

# # Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

while true; do
    nitrogen --set-zoom-fill --random
    sleep 600 
done
