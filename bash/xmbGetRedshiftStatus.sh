#!/bin/sh
# xmobar helper to get the Redshift period
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

event=${1}
oldperiod=${2}
newperiod=${3}
if [ ! -p /run/user/1000/redshift_pipe ]
then
    rm -f  /run/user/1000/redshift_pipe
    mkfifo /run/user/1000/redshift_pipe
fi


if [ $(ps -aux | grep redshift | wc -l) -gt 1 ]
then
    if [ "${newperiod}" ==  "none" ]
    then
        echo 'off' > /run/user/1000/redshift_pipe
    else
        echo ${newperiod} `redshift -p | sed -n 's/Color temperature: //p'` > /run/user/1000/redshift_pipe
    fi
else
    echo 'off' > /run/user/1000/redshift_pipe
fi


