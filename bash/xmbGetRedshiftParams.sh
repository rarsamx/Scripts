#!/usr/bin/env bash
# xmobar helper to get the Redshift period
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0


if [ $(ps -aux | grep redshift | wc -l) -gt 1 ]
then
    echo `redshift -p | sed -n 's/Period: \(\w\)\w*/\1/p'` `redshift -p | sed -n 's/Color temperature: //p'`
else
    echo 'off'
fi

