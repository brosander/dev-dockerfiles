#!/bin/bash

if [ -e "/opt/nifi/bin/nifi.sh" ]; then
  tail -f /opt/nifi/logs/* &
  /opt/nifi/bin/nifi.sh run
else
  echo "Must mount nifi installation at /opt/nifi"
fi

