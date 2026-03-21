#!/bin/bash

[[ "$1" == "--watch" ]] || { "$0" --watch & exit; }
[[ -p /dev/stdin ]] && exec cat >/dev/null
while sleep 1; do
    cur=$(mmsg -g -k 2>/dev/null | awk '{print $NF}' | tr '[:lower:]' '[:upper:]')
    [[ "$cur" != "$prev" ]] && prev="$cur"
done
