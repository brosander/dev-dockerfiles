#!/bin/bash

TOOLKIT_URL="$1"
TOOLKIT_FILENAME="$(echo "$1" | sed 's/.*\///g')"

echo "$TOOLKIT_URL"
echo "$TOOLKIT_FILENAME"

wget "$TOOLKIT_URL" && unzip "$TOOLKIT_FILENAME" -d /opt && rm "$TOOLKIT_FILENAME"
find /opt -maxdepth 1 -name 'nifi-toolkit*' -exec mv {} /opt/nifi-toolkit \;
