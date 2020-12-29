#!/usr/bin/env bash
# This scripts reloads the alsa sink module specific for the device 
# corresponding to the monitor HDMI
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

LANG=en_us_8859_1

$(aplay -l | grep HDMI | sed 's/^card \([0-9]\).*device \([0-9]\).*$/pacmd load-module module-alsa-sink device=hw:\1,\2/')
