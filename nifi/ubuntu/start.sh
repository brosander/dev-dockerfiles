#!/bin/bash

if [ -e "/opt/nifi/bin/nifi.sh" ]; then
  /opt/nifi/bin/nifi.sh run
else
  echo "Must mount nifi installation at /opt/nifi"
fi
