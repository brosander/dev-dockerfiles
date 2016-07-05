#!/bin/bash

ZIP_FILE="$(find /opt/nifi-archive/ -maxdepth 1 -name 'nifi*.zip' | head -n 1)"

if [ -e "/opt/nifi/bin/nifi.sh" ]; then
  echo "Using nifi installation mounted at /opt/nifi"
elif [ -n "$ZIP_FILE" ]; then
  echo "Using nifi archive $ZIP_FILE"
  unzip -d ~/ "$ZIP_FILE"
  SCRIPT="`find ~/ -name nifi.sh`"
  NIFI_DIR="`dirname \"$SCRIPT\"`/.."
  cd "$NIFI_DIR" && mv * /opt/nifi/
else
  echo "Must mount nifi installation at /opt/nifi"
  exit 1
fi

cd /opt/nifi-conf
cp * /opt/nifi/conf/

cd /opt/nifi
/opt/nifi/bin/nifi.sh start
tail -f /opt/nifi/logs/*
