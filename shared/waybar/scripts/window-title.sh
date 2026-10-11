#!/usr/bin/env bash

swaymsg -t get_tree -r 2>/dev/null | jq -r '.. | objects | select(.focused? == true) | .name // empty' 2>/dev/null | head -1