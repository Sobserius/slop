#!/bin/bash

while true; do
    mmsg -w -k > /dev/null
    mmsg -g -k 2>/dev/null | awk '{print $NF}' | tr '[:lower:]' '[:upper:]' || echo "US"
done
