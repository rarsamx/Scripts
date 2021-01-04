#!/usr/bin/env fish

function cmus-play 
    if test ! (pgrep -x cmus)
        xterm -e cmus &
        sleep 1
    end
    cmus-remote -f $argv;
end

cmus-play $argv
