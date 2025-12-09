#!/usr/bin/env bash
#
# Script to unmount the NexStar encrypted backup disk

sudo umount /dev/vg1/backup
sudo lvchange -an vg1/backup
sudo cryptsetup close cryptns
