#!/usr/bin/env bash
#
# Description: Using notify-send, pop-up the current workspace number when changing workspaces
# in window managers which don't do that like LXQt
# Requires: xfce4-notifyd, libnotify, wmctrl
#
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0


CURRENT_WORKSPACE=$(($(wmctrl -d | grep \* | cut -d' ' -f1)+1))
while true
do
        sleep 0.5
        NEW_WORKSPACE=$(($(wmctrl -d | grep \* | cut -d' ' -f1)+1))
        if [ $CURRENT_WORKSPACE -ne $NEW_WORKSPACE ]; then
                notify-send -t 500 " workspace" "<b><span font='50'>$NEW_WORKSPACE</span></b>"
                CURRENT_WORKSPACE=$NEW_WORKSPACE
        fi
done
exit 0
