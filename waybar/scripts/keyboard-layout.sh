#!/bin/bash

while true; do
    echo "$(mmsg -g -k 2>/dev/null | awk '{print $NF}' | tr '[:lower:]' '[:upper:]' || echo "US")"
    mmsg -w -k > /dev/null
done
