#!/usr/bin/env bash
# xmobar helper to get the cpu temperature
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

sensors | sed -n -e 's/CPU Temperature:[[:space:]]*+\([0-9]*\).*/\1/p'
