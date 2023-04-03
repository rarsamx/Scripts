#!/bin/bash
#
doUpdate=$(dnf check-update | grep -Ec ' updates[[:space:]]$')
#doUpdate=$(dnf check-update | grep -Ec ' updates$')
#doUpdate=1
if [ $doUpdate -eq 0 ]
then
    read -n1 -p "System is up to date, Press Enter to continue"
else
    echo "sudo dnf up" $argv 
    sudo dnf up $argv
    if [ $? -eq 0 ]
    then
        echo "xmonad --recompile; xmonad --restart"
        xmonad --recompile; xmonad --restart
        systemctl --user start getNumFedoraUpd.service       

        read -n1 -p "Update finished, Enter to continue"
    else
       read -n1 -p "Error updating. Enter to continue"
    fi
fi


