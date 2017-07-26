
if [ -x /usr/bin/dircolors ]
then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias l='ls'
alias ll='ls -lF'
alias la='ll -A'

# this looks handy
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# I'm clumsy
alias gti='git'

# run gui apps from shell without forcing them to close when closing term
alias gui=">/dev/null 2>/dev/null nohup"
# e.g. `gui firefox google.co.uk &` will now run as if firefox ha been opened
# from a WM shortcut
