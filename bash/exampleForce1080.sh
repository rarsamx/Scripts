# Snippet to force a monitor to use full HD 1920x1080
# If we want to force it at boot, the file to edit is 
#   /etc/mdm/Init/Default
# or whatever initialization file for the display manager
#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode VGA1 "1920x1080_60.00"
#
#Author: Raul Suarez
#https://www.usingfoss.com/
#License: GPL v3.0

xrandr --output VGA1 --mode 1920x1080

