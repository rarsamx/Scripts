#!/usr/bin/env bash
# xmobar helper to get the Redshift period
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

redshift -p | sed -n 's/Period: //p'
