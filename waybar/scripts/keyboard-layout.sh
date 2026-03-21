#!/bin/bash

mmsg -g -w -k | while read -r LAYOUT; do
    if [ -n "$LAYOUT" ]; then
        echo "{\"text\": \"${LAYOUT^^}\", \"class\": \"$LAYOUT\"}"
    fi
done
