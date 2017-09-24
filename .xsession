#if [ $DESKTOP_SESSION = "custom-i3" ]; then
    # set keyboard
    xkbcomp -I$HOME/.config/xkb $HOME/.config/xkb/keymap.xkb $DISPLAY

    # set screen delay dimming to 30 mins
    xset s 1800 1800 -dpms

    # load Xresources
    xrdb -I$HOME ~/.Xresources

    # start i3
    i3
#fi
