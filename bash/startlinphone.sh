#!/usr/bin/env bash
#
# Launch Linphone and try to close it to the tray

# # Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

#linphone & sleep 2 && wmctrl -c "Linphone"
nohup Linphone-4.2.5.AppImage & 
sleep 5 
wmctrl -Fc "Linphone"

#linphone & sleep 2 && xdotool search --onlyvisible --name "Linphone" windowminimize

