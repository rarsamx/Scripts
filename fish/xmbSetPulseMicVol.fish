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
   pactl set-source-mute   @DEFAULT_SOURCE@ toggle
else if test -n "$argv"
   pactl set-source-volume @DEFAULT_SOURCE@ $argv
   pactl set-source-mute   @DEFAULT_SOURCE@ 0
end

set micismuted (pacmd list-sources | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*muted:/s/^.* \(.*\).*/\1/p')

if test $micismuted = 'yes'
    set volDisplay '<icon=MicVol-muted.xpm/>'
else
   set micVol (pacmd list-sources | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*volume:/s/^.* \([0-9]*\)%.*/\1/p')
   if test $micVol -le 33
       set volDisplay '<icon=MicVol-low.xpm/>'
    else if test $micVol -le 67
       set volDisplay '<icon=MicVol-medium.xpm/>'
    else
       set volDisplay '<icon=MicVol-high.xpm/>'
   end

   echo "<fc=lightblue><fn=1>"$micVol"</fn></fc> " > /run/user/1000/micvol_pipe
   sleep .2
end
echo $volDisplay > /run/user/1000/micvol_pipe
