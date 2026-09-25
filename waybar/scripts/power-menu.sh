#!/usr/bin/env bash

CHOICE=$(printf '%s\n' 'Shutdown' 'Reboot' 'Logout' 'Lock' | fuzzel --dmenu --hide-prompt --lines=4 --width=14)
case "$CHOICE" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) mmsg dispatch quit ;;
    Lock) swaylock ;;
esac
