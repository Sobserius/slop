#!/usr/bin/env bash
CHOICE=$(echo -e "Shutdown\nReboot\nLogout\nLock" | fuzzel --dmenu --lines=4 --width=14)
case "$CHOICE" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) swaymsg exit ;;
    Lock) swaylock ;;
esac
