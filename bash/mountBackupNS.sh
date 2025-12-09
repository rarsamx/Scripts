#!/usr/bin/env bash
#
# Script to mount the NexStar encrypted backup disk

device=${1}

sudo cryptsetup open /dev/${device} cryptns &&
sudo lvchange -ay vg1/backup &&
sudo mkdir -p /run/media/papa/Backup-NS &&
sudo chown -R papa:papa /run/media/papa/Backup-NS &&
sudo mount /dev/vg1/backup /run/media/papa/Backup-NS
