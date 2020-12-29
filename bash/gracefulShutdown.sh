#!/usr/bin/env bash
#
# Verifies that applications can close before executing the correspoinding
# environment shutdown command
#   graceful_shutdown.sh [command]
# It receives one parametter with the command to execute
# - logout
# - reboot
# - shutdown
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

usage="usage: ${0##*/} action"

ACTION=${1?"${usage}"}
TIMEOUT=10

APPLIST_TO_TERMINATE=(
	# edit this list
  # These are programs which won't close gracefully and must be forced

	qbittorrent
	steam
	Discord
	telegram-desktop
)

close_windows () {
	wmctrl -l > ~/log.txt
	wmctrl -l | awk '{print $1}' | while read -r wId
	do
		wmctrl -i -c $wId
	done
}

window_timeout_countdown () {
	for i in $(seq 1 $TIMEOUT);
	do
		if [[ -z $(wmctrl -l) ]]; then
			return 0
		fi
		sleep 1
	done
	exit 1
}

terminate_processes () {
	pidof ${APPLIST_TO_TERMINATE[@]} | tr ' ' '\n' | while read -r pId
	do
		kill -15 $pId
		tail --pid=$pId -f /dev/null # wait until terminate it
	done
}

close_windows
window_timeout_countdown
terminate_processes

case "$ACTION" in 
	logout)   killall xmonad-x86_64-linux
						;;
	reboot)   systemctl reboot 
						;;
	shutdown) poweroff
						;;
esac


