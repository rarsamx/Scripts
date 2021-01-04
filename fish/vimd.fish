#!/usr/bin/env fish

# If there is a server instance of vim created here, we use it, 
# otherwise we open a session. If we are inside a tmux session, weopen a split
# window, if we are not, we open a new xterm window
#

function vimd -w 'vim --servername VIMCLI' -d 'Open vim in a terminal in server mode'
    
    set -l vimcmd vim
    set -l vimsrv VIMCLI
    set -l cmdclose 
    set -l clisession
    
    if test "$TERM" != "screen" -a -z "$TMUX" 
        set clisession (vim --serverlist | grep -i 'VIMCLI$')
        if test -z $clisession
            set vimcmd xterm -e vim
            set cmdclose '&'
        end
    else
        # tmux session running
        set vimsrv VIMCLIX
        set clisession (vim --serverlist | grep -i 'VIMCLIX$')
        if test -z $clisession
            set vimcmd tmuxc split-window -h vim
        end
    end

    if test -z "$clisession"
        $vimcmd --servername $vimsrv $argv &; disown 
    else if test -n "$clisession" -a -n "$argv"
        $vimcmd --servername $vimsrv --remote-silent $argv &; disown
    end
end

vimd $argv
