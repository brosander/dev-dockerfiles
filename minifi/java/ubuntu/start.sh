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

if [ -e "/opt/minifi-conf" ]; then
  cd /opt/minifi-conf
  cp * /opt/minifi/conf/
fi

if [ -e "/opt/minifi-lib" ]; then
  cd /opt/minifi-lib
  cp * /opt/minifi/lib
fi

cd /opt/minifi
echo "Running minifi with following config.yml"
cat /opt/minifi/conf/config.yml
/opt/minifi/bin/minifi.sh start
tail -f /opt/minifi/logs/*
