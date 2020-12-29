#!/usr/bin/env bash
#
# Restores the mbr from a backup
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0


dd if=/home/aku/mbr_backup of=/dev/hda bs=512 count=1
