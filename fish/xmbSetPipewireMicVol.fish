#!/usr/bin/env fish
#
# xmobar helper
# Sets the pulse volume and sets the volume or the volume icon to a pipe
# xmobar should read that pipe using the PipeReader plugin
#
# This scrpit receives the parameters of pacmd
# If no parameters are sent, then it just outputs the current volume

# Create named pipe to write the input method to
if test ! -p /run/user/1000/micvol_pipe 
    rm -f /run/user/1000/micvol_pipe
    mkfifo /run/user/1000/micvol_pipe
end

if test "$argv" = "toggle"
   wpctl set-mute   @DEFAULT_AUDIO_SOURCE@ toggle
else if test -n "$argv"
   wpctl set-volume @DEFAULT_AUDIO_SOURCE@ $argv
   wpctl set-mute   @DEFAULT_AUDIO_SOURCE@ 0
end

set micismuted (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -o MUTED)

if test "$micismuted" = 'MUTED'
    set volDisplay '<icon=MicVol-muted.xbm/>'
else
   set micVol (math (echo  (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -o '[0-9.]*') \* 100))
   if test $micVol -le 33
       set volDisplay '<icon=MicVol-low.xbm/>'
    else if test $micVol -le 67
       set volDisplay '<icon=MicVol-medium.xbm/>'
    else
       set volDisplay '<icon=MicVol-high.xbm/>'
   end

   echo "<fc=lightblue><fn=1>"$micVol"</fn></fc> " > /run/user/1000/micvol_pipe
   sleep .2
end
echo $volDisplay > /run/user/1000/micvol_pipe
