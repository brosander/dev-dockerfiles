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

if [ -n "$1" ]; then
  if [ -z "$2" ]; then
    echo "\$2 should be number of NiFi nodes if \$1 is set"
    exit
  fi
  cd /opt/nifi
  mkdir -p state/zookeeper
  echo "$1" > state/zookeeper/myid

  sed -i 's/^\(server\.[0-9]\+\)/#\1/g' /opt/nifi/conf/zookeeper.properties
  echo "" >> /opt/nifi/conf/zookeeper.properties
  ZK_STRING="nifi1.nifi:2181"
  echo "server.1=nifi1.nifi:2888:3888" >> /opt/nifi/conf/zookeeper.properties
  for (( NUM=2; NUM<=$2; NUM++ ))
  do
    ZK_STRING="$ZK_STRING,nifi$NUM.nifi:2181"
    echo "server.$NUM=nifi$NUM.nifi:2888:3888" >> /opt/nifi/conf/zookeeper.properties
  done
  sed -i "s/^nifi.zookeeper.connect.string=.*$/nifi.zookeeper.connect.string=$ZK_STRING/g" /opt/nifi/conf/nifi.properties
  sed -i 's/^nifi.state.management.embedded.zookeeper.start=.*$/nifi.state.management.embedded.zookeeper.start=true/g' /opt/nifi/conf/nifi.properties
  sed -i 's/^nifi.cluster.is.node=.*$/nifi.cluster.is.node=true/g' /opt/nifi/conf/nifi.properties
fi

cd /opt/nifi
/opt/nifi/bin/nifi.sh start
tail -f /opt/nifi/logs/*
