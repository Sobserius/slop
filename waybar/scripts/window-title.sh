#!/usr/bin/env bash

mmsg get focusing-client 2>/dev/null | jq -r '.title // empty' 2>/dev/null
