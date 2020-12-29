#!/usr/bin/env bash
# Shows the filesystem changes between two snapshots 
# for example:
# sudo btrfs-diff /.snapshots/10/snapshot /.snapshots/11/snapshot/ | less
#
# copied and modified from
# https://serverfault.com/questions/399894/does-btrfs-have-an-efficient-way-to-compare-snapshots
#
# This is similar to using snapper
# sudo snapper -c root status 10..11  | less
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

[ "$(id -u)" -eq "0" ] || { echo "Please run as root or with sudo"; exit 1; }

usage="usage: ${0##*/} old-snapshot-path new-snapshot-path"

SNAPSHOT_OLD=${1?"${usage}"}
SNAPSHOT_NEW=${2?"${usage}"}

[ -d $SNAPSHOT_OLD ] || usage "$SNAPSHOT_OLD does not exist";
[ -d $SNAPSHOT_NEW ] || usage "$SNAPSHOT_NEW does not exist";

OLD_TRANSID=`btrfs subvolume find-new "$SNAPSHOT_OLD" 9999999`
OLD_TRANSID=${OLD_TRANSID#transid marker was }
[ -n "$OLD_TRANSID" -a "$OLD_TRANSID" -gt 0 ] || usage "Failed to find generation for $SNAPSHOT_NEW"

btrfs subvolume find-new "$SNAPSHOT_NEW" $OLD_TRANSID | sed '$d' | cut -f17- -d' ' | sort | uniq



