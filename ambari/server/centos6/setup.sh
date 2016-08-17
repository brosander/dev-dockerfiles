#!/bin/bash

if [ "$1" == "root" ]; then
  ambari-server setup -s
else
  echo -ne "y\n$1\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" | ambari-server setup
fi
