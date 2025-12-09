#!/usr/bin/env bash
#
# Script to unmount the NexStar encrypted backup disk

sudo umount /dev/mapper/cryptib
sudo cryptsetup close cryptib
