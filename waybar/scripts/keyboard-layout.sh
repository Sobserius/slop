#!/bin/bash

mmsg -g -k 2>/dev/null | awk '{print $NF}' | tr '[:lower:]' '[:upper:]' || echo "US"
mmsg -w -k 2>/dev/null | while read -r; do
    mmsg -g -k 2>/dev/null | awk '{print $NF}' | tr '[:lower:]' '[:upper:]' || echo "US"
done
