#!/usr/bin/env bash
#
# Script to unmount the NexStar encrypted backup disk

# sudo umount /dev/mapper/cryptib
# sudo cryptsetup close cryptib


device=${1}

udisksctl unmount -b /dev/mapper/c${device} &&
    sudo cryptsetup close c${device}
