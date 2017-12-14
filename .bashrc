#
# ~/.bashrc
#

# exit if not running interactively
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# check number of supported colours
# lifted from https://github.com/l0b0/xterm-color-count/blob/master/xterm-color-count.sh
# which was in turn created using info from http://unix.stackexchange.com/a/23789/3645
# First, test if terminal supports OSC 4 at all.
printf '\e]4;%d;?\a' 0
read -d $'\a' -s -t 0.1 </dev/tty
if [ -z "$REPLY" ]
then
    # OSC 4 not supported, so we'll fall back to terminfo
    max_colours=$(tput colors)
else
    # OSC 4 is supported, so use it for a binary search
    min_colours=0
    max_colours=256
    while [[ $((min_colours+1)) -lt $max_colours ]]
    do
	i=$(( (min_colours+max_colours)/2 ))
	printf '\e]4;%d;?\a' $i
	read -d $'\a' -s -t 0.1 </dev/tty
	if [ -z "$REPLY" ]
	then
        max_colours=$i
	else
	    min_colours=$i
	fi
    done
fi
unset min_colours

# I don't know what to do for < 256 colour terminals yet, so make 256-colour == colour_prompt
if [ $max_colours -eq 256 ]
then
    colour_prompt=yes
fi
unset max_colours

# Set prompt
if [ "$colour_prompt" = yes ]
then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $(printf '%.*s' $? $?) \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $(printf '%.*s' $? $?) \$ '
fi
unset colour_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions
# Aliases are defined in .bash_aliases (limit clutter in bashrc!)
if [ -f ~/.bash_aliases ]
then
    . ~/.bash_aliases
fi

if [ -r /usr/share/bash-completion/bash_completion ]
then
    . /usr/share/bash-completion/bash_completion
fi

# default editors
export VISUAL=vim
export EDITOR="$VISUAL"

# nvm
export NVM_DIR="/home/andrew/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# virtualenvwrapper
if [ -r /usr/local/bin/virtualenvwrapper.sh ]
then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Devel
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    source /usr/local/bin/virtualenvwrapper.sh
fi

# golang
GOVERSION=1.9.1
if [ -d $HOME/go/$GOVERSION ]
then
    export GOPATH=$HOME/go
    export GOROOT=$GOPATH/$GOVERSION
    export PATH=$PATH:$GOROOT/bin
fi

#rust
if [ -d $HOME/.cargo ]
then
    export PATH=$PATH:$HOME/.cargo/bin
fi

[ "x$COLORTERM" = "xxfce4-terminal" ] && [ "x$TERM" = "xxterm" ] && export TERM="xterm-256color"
