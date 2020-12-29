#!/usr/bin/env bash
#
# Restores the mbr from a backup
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0


[ "$(id -u)" -eq "0" ] || { echo "Please run as root or with sudo"; exit 1; }

usage=$(echo -e "\nusage: \033[1;32m${0##*/} mode device backupFile\033[0m\nWhere:\n  mode: boot|full\n  device: \\dev\\xxx\n  backupFile: Fully qualified file name")

MODE=${1?"${usage}"}
DEVICE=${2?"${usage}"}
BACKUPFILE=${3?"${usage}"}
FAILSAFEFILE=$(mktemp XXXX.mbr)

echo -e "WARNING. THIS IS A HIGHLY DESTRUCTIVE ACTION.\nA BACKUP OF THE CURRENT MBR WILL BE SAVED TO ${FAILSAFEFILE}." 
read -p "Are you shure you want to continue (YES,no)?: " CONTINUE

[[ "${CONTINUE}" != "YES" ]] && { echo Cancelling; exit 0 ; }

case "$MODE" in 
	full) dd if=${DEVICE} of=${FAILSAFEFILE} bs=512 count=1
        echo -e "\033[1;32mBackup file saved to ${FAILSAFEFILE}\033[0m"
        dd if=${BACKUPFILE} of=${DEVICE} bs=512 count=1
				;;
	boot) dd if=${DEVICE} of=${FAILSAFEFILE} bs=466 count=1
        echo -e "\033[1;32mBackup file saved to ${FAILSAFEFILE}\033[0m"
        dd if=${BACKUPFILE} of=${DEVICE} bs=466 count=1
				;;
     *) echo -e "ERROR: mode should be \033[1;32mfull\033[0m or \033[1;32mboot\033[0m"
        ;;
esac

