#!/usr/bin/env bash
#
# Empty a read/write CD
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

cdrecord -v dev=ATA:1,0,0 blank=fast
