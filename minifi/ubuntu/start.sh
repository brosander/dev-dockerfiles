#!/bin/bash

if [ -e "/opt/nifi/bin/nifi.sh" ]; then
  /opt/minifi/bin/minifi.sh start
else
  echo "Must mount minifi installation at /opt/minifi"
fi

tail -f /opt/minifi/logs/*
