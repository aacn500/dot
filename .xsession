if [ $DESKTOP_SESSION = "custom-i3" ]; then
    xkbcomp -I$HOME/.config/xkb $HOME/.config/xkb/keymap.xkb $DISPLAY

    i3
fi
