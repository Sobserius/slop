#!/usr/bin/env bash

layout="$(mmsg get keyboardlayout 2>/dev/null | jq -r '.layout // empty' 2>/dev/null)" || layout=""

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
