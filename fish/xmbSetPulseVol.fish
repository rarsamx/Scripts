#!/usr/bin/env fish
#
# xmobar helper
# Sets the pulse volume and sets the volume or the volume icon to a pipe
# xmobar should read that pipe using the PipeReader plugin
#
# This scrpit receives the parameters of pacmd
# If no parameters are sent, then it just outputs the current volume

set uid (id -u)

set pipeName "/run/user/$uid/volume_pipe"


# Create named pipe to write the input method to
if test ! -p $pipeName 
    rm -f $pipeName
    mkfifo $pipeName
end

if test "$argv" = "toggle"
   pactl set-sink-mute @DEFAULT_SINK@ toggle
else if test -n "$argv"
   pactl set-sink-volume @DEFAULT_SINK@ $argv
   pactl set-sink-mute @DEFAULT_SINK@ 0
end

set speakerismuted (pacmd list-sinks | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*muted:/s/^.* \(.*\).*/\1/p')

if test $speakerismuted = 'yes'
    set volDisplay '<icon=Volume-muted.xpm/>'
else
   set speakerVol (pacmd list-sinks | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*volume:/s/^.* \([0-9]*\)%.*/\1/p')
   if test $speakerVol -le 33
       set volDisplay '<icon=Volume-low.xpm/>'
    else if test $speakerVol -le 67
       set volDisplay '<icon=Volume-medium.xpm/>'
    else
       set volDisplay '<icon=Volume-high.xpm/>'
   end

   echo "<fc=lightblue><fn=1>"$speakerVol"</fn></fc> " > $pipeName
   sleep .2
end
echo $volDisplay > $pipeName
