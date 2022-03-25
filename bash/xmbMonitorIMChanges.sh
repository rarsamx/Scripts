#!/usr/bin/env bash
#
# This script monitors the changes to the 

uid=$(id -u)

pipeName="/run/user/${uid}/im_pipe"

outputIM () {
    IM=$(gdbus call -e -d org.fcitx.Fcitx -o "/inputmethod" -m "org.fcitx.Fcitx.InputMethod.GetCurrentIM" | sed -e "s/('\(.*\)',)/\1/")
    
    case $IM in
        fcitx-keyboard-us)
            imCode="US"
            ;;
        fcitx-keyboard-us-intl)
            imCode="US intl"
            ;;
        pinyin | sunpinyin)
            imCode="CH"
            ;;
        fcitx-keyboard-cn-altgr-pinyin)
            imCode="PY"
            ;;
    esac
    echo $imCode > ${pipeName}
}


#=========
# Start of the script

# Create named pipe to write the input method to
if [ ! -p ${pipeName} ]
then
    rm -f ${pipeName}
    mkfifo ${pipeName}
fi

# Pouplate the pipe with the current Input Method
outputIM

# only monitor if there isn't another script already running
if [ $(ps -aux | grep "bash /home/papa/bin/xmbMonitorIMChanges" | wc -l) -le 3 ]
then

# Monitor the dbus for changes to the current input method
    dbus-monitor  --session "type='signal',interface='org.freedesktop.DBus.Properties'" | 
        while read x
        do   
            echo $x | grep -q CurrentIM 
            cont=$?
            if [ $cont -eq 0 ] 
            then 
                outputIM
            fi 
        done
fi
