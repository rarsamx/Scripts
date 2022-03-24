#!/usr/bin/env bash
#
# This script monitors the changes to the 
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
    echo $imCode > /run/user/1000/im_pipe
}


#=========
# Start of the script

# Create named pipe to write the input method to
if [ ! -p /run/user/1000/im_pipe ]
then
    rm -f /run/user/1000/im_pipe
    mkfifo /run/user/1000/im_pipe
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
