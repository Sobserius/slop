#!/bin/bash

while true; do
    mmsg -g -k 2>/dev/null | awk '{print $NF}' | tr '[:lower:]' '[:upper:]' || echo "US"
    sleep 1
done
