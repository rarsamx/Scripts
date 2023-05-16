#!/usr/bin/env fish
#
# xmobar helper
# Sets the pulse volume and sets the volume or the volume icon to a pipe
# xmobar should read that pipe using the PipeReader plugin
#
# This scrpit receives the parameters of pacmd
# If no parameters are sent, then it just outputs the current volume

# Create named pipe to write the input method to
if test ! -p /run/user/1000/volume_pipe 
    rm -f /run/user/1000/volume_pipe
    mkfifo /run/user/1000/volume_pipe
end

if test "$argv" = "toggle"
   wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
else if test -n "$argv"
   wpctl set-volume @DEFAULT_AUDIO_SINK@ $argv
   wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
end

set speakerismuted (wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o MUTED)

if test "$speakerismuted" = 'MUTED'
    set volDisplay '<icon=Volume-muted.xbm/>'
else
   set speakerVol (math (echo  (wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o '[0-9.]*') \* 100))
   if test $speakerVol -le 33
       set volDisplay '<icon=Volume-low.xbm/>'
    else if test $speakerVol -le 67
       set volDisplay '<icon=Volume-medium.xbm/>'
    else
       set volDisplay '<icon=Volume-high.xbm/>'
   end

   echo "<fc=lightblue><fn=1>"$speakerVol"</fn></fc> " > /run/user/1000/volume_pipe

   sleep .2
end
echo $volDisplay > /run/user/1000/volume_pipe
