#!/bin/bash

{ mmsg -g -k; mmsg -w -k; } | awk '{print $NF}' | while read -r LAYOUT; do
    if [ -z "$LAYOUT" ]; then continue; fi
    UPPER_LAYOUT=$(echo "$LAYOUT" | tr '[:lower:]' '[:upper:]')
    echo "{\"text\": \"$UPPER_LAYOUT\", \"class\": \"$LAYOUT\"}"
done
