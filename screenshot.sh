#!/bin/bash
LOCKFILE="/tmp/screenshot.lock"
if [ -f "$LOCKFILE" ]; then
    exit 0
fi
touch "$LOCKFILE"
FILE="/tmp/screenshot_check.png"
rm -f "$FILE"
pkill slurp 2>/dev/null
grim -g "$(slurp)" "$FILE"
if [ -f "$FILE" ]; then
    wl-copy < "$FILE"
    notify-send "Screenshot" "Region captured" -i camera-photo -r 99
    rm "$FILE"
else
    notify-send "Screenshot" "Selection cancelled" -i dialog-information -r 99
fi
rm -f "$LOCKFILE"
