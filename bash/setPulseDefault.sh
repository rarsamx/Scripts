#!/usr/bin/env bash
#
# Sample script to show a dzen menu with configuration comming from a file
#
# Author: Raul Suarez
# https://www.usingfoss.com/
# License: GPL v3.0

dzen2 -p 5 -w '400' -h '25' -x 540 -y 540 -fg '#000000' -bg '#FFFFFF' -l '3' -ta 'c' -sa 'l' -m < test.config 
