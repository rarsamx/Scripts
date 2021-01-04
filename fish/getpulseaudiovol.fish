#!/usr/bin/env fish
#
# xmobar helper
# returns the volum levels for teh default speakers and microphone

# Speakers levels
set speakerismuted (pacmd list-sinks | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*muted:/s/^.* \(.*\).*/\1/p')

if test $speakerismuted = 'yes'
    set speakerVol 'Ø'
else
   set speakerVol (pacmd list-sinks | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*volume:/s/^.* \([0-9]*%\).*/\1/p')
end

# Mic levels
set micismuted (pacmd list-sources | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*muted:/s/^.* \(.*\).*/\1/p')

if test $micismuted = 'yes'
    set micVol 'Ø'
else
   set micVol (pacmd list-sources | sed -n -e '/* index:/,/muted:/p' | sed -n -e '/^\s*volume:/s/^.* \([0-9]*%\).*/\1/p')
end

echo "S:<fc=lightblue><fn=1>"$speakerVol"</fn></fc> M:<fc=lightblue><fn=1>"$micVol"</fn></fc>"
