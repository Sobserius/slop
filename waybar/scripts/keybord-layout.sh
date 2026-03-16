#!/bin/bash

mmsg -g -k 2>/dev/null | awk '{print $NF}' | tr '[:lower:]' '[:upper:]' || echo "US"
