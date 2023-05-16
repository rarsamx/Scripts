#!/usr/bin/env bash
#
# Script to mount the NexStar encrypted backup disk

device=${1}

# sudo cryptsetup open /dev/${device} cryptib &&
# sudo mkdir -p /run/media/papa/Backup-IB &&
# sudo chown -R papa:papa /run/media/papa/Backup-IB &&
# sudo mount /dev/mapper/cryptib /run/media/papa/Backup-IB
sudo cryptsetup open /dev/${device} c${device} &&
    udisksctl mount -b /dev/mapper/c${device}
# sudo mkdir -p /run/media/papa/Backup-IB &&
# sudo chown -R papa:papa /run/media/papa/Backup-IB &&
# sudo mount /dev/mapper/cryptib /run/media/papa/Backup-IB
