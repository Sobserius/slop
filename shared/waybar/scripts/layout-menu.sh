#!/usr/bin/env bash

# Mango's layout names (scroller, monocle, deck, center_tile...) do not exist in
# sway, so this is sway's real set: container layouts plus split direction.
CHOICE=$(printf '%s\n' \
    'Tiling' \
    'Stacking' \
    'Tabbed' \
    'Dwindle' \
    'Flip' \
    'Split Horizontal' \
    'Split Vertical' | fuzzel --dmenu --hide-prompt --lines=7 --width=18)

case "$CHOICE" in
    'Tiling') swaymsg '[con_id=__focused__] layout tiling' ;;
    'Stacking') swaymsg '[con_id=__focused__] layout stacking' ;;
    'Tabbed') swaymsg '[con_id=__focused__] layout tabbed' ;;
    'Dwindle') swaymsg '[con_id=__focused__] layout dwindle' ;;
    'Flip') swaymsg '[con_id=__focused__] layout flip' ;;
    'Split Horizontal') swaymsg '[con_id=__focused__] layout splith' ;;
    'Split Vertical') swaymsg '[con_id=__focused__] layout splitv' ;;
esac