#!/usr/bin/env fish

# If there is a server instance of vim created here, we use it, 
# otherwise we open a session. If we are inside a tmux session, weopen a split
# window, if we are not, we open a new xterm window
#

function gvimd -w 'gvim --servername VIMCLI' -d 'Open a single instance of gvim'
    
    set -l vimcmd gvim
    set -l vimsrv GVIM
    set -l gsession
    
    set gsession (gvim --serverlist | grep -i 'GVIM$')

    if test -z "$gsession"
        gvim --servername GVIM $argv
    else if test -n "$gsession" -a -n "$argv"
        gvim --servername GVIM --remote-silent $argv 
    end
end

gvimd $argv
