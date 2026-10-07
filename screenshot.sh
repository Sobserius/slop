#!/usr/bin/env bash
# Select a region, copy its screenshot to the clipboard and notify.
geometry=$(slurp) || exit 0
[[ -n "$geometry" ]] || exit 0
file=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/sway-shot.XXXXXXXX.png") || exit 1
trap 'rm -f "$file"' EXIT
if grim -g "$geometry" "$file" && wl-copy < "$file"; then
    notify-send "Screenshot" "Region captured" -i camera-photo -r 99
fi
