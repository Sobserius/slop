#!/usr/bin/env bash

layout="$(swaymsg -t get_inputs 2>/dev/null | jq -r '[.[] | select(.xkb_active_layout_name)] | .[0].xkb_active_layout_name // empty' 2>/dev/null)" || layout=""

case "$layout" in
    English*|US*)
        printf 'US\n'
        ;;
    Russian*|RU*)
        printf 'RU\n'
        ;;
    '')
        printf 'US\n'
        ;;
    *'('*')')
        printf '%s\n' "${layout##*\(}" | sed 's/)//' | tr '[:lower:]' '[:upper:]'
        ;;
    *)
        printf '%s\n' "$layout"
        ;;
esac
