#!/bin/bash

TOKEN=token

if [ -n "$1" ]; then
  TOKEN="$1"
fi

wget http://ambari.ambari:8080/resources/common-services/NIFI/1.0.0/package/archive.zip
unzip archive.zip
JAVA_HOME=/usr/jdk64/jdk1.8.0_60 ./files/nifi-toolkit-1.0.0.2.0.0.0-494/bin/tls-toolkit.sh client -c centos61.ambari -p 10443 -t "$TOKEN"
