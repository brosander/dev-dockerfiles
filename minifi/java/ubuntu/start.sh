#!/bin/bash

ZIP_FILE="$(find /opt/minifi-archive/ -maxdepth 1 -name 'minifi*.zip' | head -n 1)"

if [ -e "/opt/minifi/bin/minifi.sh" ]; then
  echo "Using minifi at /opt/minifi"
elif [ -n "$ZIP_FILE" ]; then
  echo "Using minifi archive $ZIP_FILE"
  unzip -d ~/ "$ZIP_FILE"
  SCRIPT="`find ~/ -name minifi.sh`"
  MINIFI_DIR="`dirname \"$SCRIPT\"`/.."
  cd "$MINIFI_DIR" && mv * /opt/minifi/
else
  echo "Must mount minifi installation at /opt/minifi"
fi

cd /opt/minifi-conf
cp * /opt/minifi/conf/

cd /opt/minifi
echo "Running minifi with following config.yml"
cat /opt/minifi/conf/config.yml
/opt/minifi/bin/minifi.sh start
tail -f /opt/minifi/logs/*
