#!/bin/bash

exitOnFail() {
  "$@"
  if [ $? -ne 0 ]; then
    echo "Command: $@ failed"
    exit 1
  fi
}

killContainer() {
  if [ -n "`docker ps | awk '{print $NF}' | grep \"^$1\$\"`" ]; then
    echo "Killing $1"
    exitOnFail docker kill "$1"
  else
    echo "$1 not running so not killing"
  fi
}

rmContainer() {
  if [ -n "`docker ps -a | awk '{print $NF}' | grep \"^$1\$\"`" ]; then
    echo "Removing $1"
    exitOnFail docker rm "$1"
  else
    echo "$1 doesn't exist so not removing"
  fi
}

killAndRemoveContainer() {
  killContainer "$1"
  rmContainer "$1"
}

if [ -z "$1" ]; then
  echo "Expected mpack directory to be specified as first arg (can be an empty dir if necessary)"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Expected ssh public key to be specified as second arg"
  exit 1
fi

PUB_KEY="`cat \"$2\"`"

if [ -z "`docker network ls | awk '{print $2}' | grep '^ambari$'`" ]; then
  echo "Creating ambari network"
  exitOnFail docker network create --gateway 172.17.1.1 --subnet 172.17.1.0/24 ambari
else
  echo "Ambari network already exists, not creating"
fi

if [ -z "$4" ]; then
  echo "Expected local ssh port as fourth arg, defaulting to 2001"
  LOCAL_SSH="2001"
else
  echo "Using $4 as local ssh port"
  LOCAL_SSH="$4"
fi

killAndRemoveContainer ambari-ssh-gateway
exitOnFail docker run -d --net ambari -p "$LOCAL_SSH":22 --name ambari-ssh-gateway centos6-ssh "$PUB_KEY"

if [ -n "`docker ps  | awk '{print $NF}' | grep '^squid$'`" ]; then
  echo "Squid already running, not starting again"
else
  rmContainer squid
  exitOnFail docker run -d --name squid --hostname squid --net ambari squid
fi

killAndRemoveContainer ambari

echo "Creating ambari container"
exitOnFail docker run -d --name ambari --hostname ambari --net ambari -v "$1":/build -e YUM_PROXY=http://squid:3128 ambari

for i in `docker ps | awk '{print $NF}' | grep "^centos6"`; do
  echo "Killing container $i"
  killContainer "$i"
done

for i in `docker ps -a | awk '{print $NF}' | grep "^centos6"`; do
  echo "Removing container $i"
  rmContainer "$i"
done

if [ -z "$3" ]; then
  echo "Expected number of target nodes as third arg, defaulting to 1"
  NUM_TARGETS="1"
  docker run -d --net ambari --name centos61 --hostname centos61 -e YUM_PROXY=http://squid:3128 centos6-ssh "$PUB_KEY"
  if [ $? -ne 0 ]; then
    echo "Failed to create only target node"
    exit 1
  else 
    echo "Target node with hostname centos61 created"
  fi
else
  echo "Creating $3 target nodes"
  NUM_TARGETS="$3"
fi

for i in $(seq 1 $3); do
  exitOnFail docker run -d --net ambari --name "centos6$i" --hostname "centos6$i" -e YUM_PROXY=http://squid:3128 centos6-ssh "$PUB_KEY"
  echo "Target node with hostname centos6$i created"
done

