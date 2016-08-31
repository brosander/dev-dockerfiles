#!/bin/bash

NUM_TARGETS="1"
LOCAL_SSH="2001"
NON_ROOT_AGENT="no"
KERBEROS="no"
GATEWAY="no"
RANGER="no"

printUsageAndExit() {
  echo "usage: $0 -m mpack_dir -p pub_key_file [-n num_target_nodes] [-a] [-h]"
  echo "       -h or --help                    print this message and exit"
  echo "       -m or --mpack                   directory to install mpacks from (required, can be an empty dir)"
  echo "       -p or --pubkey                  public key to use (required)"
  echo "       -n or --numTargets              number of target nodes (default: $NUM_TARGETS)"
  echo "       -l or --localSsh                local port to forward to ssh gateway (default: $LOCAL_SSH)"
  echo "       -a or --nonRootAgent            setup target nodes for non-root ambari agent"
  echo "       -k or --kerberos                start kdc"
  echo "       -g or --gateway                 start gateway container"
  echo "       -r or --ranger                  start ranger container"
  exit 1
}

# see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
while [[ $# -ge 1 ]]; do
  key="$1"
  case $key in
    -m|--mpack)
    MPACK_DIR="$2"
    shift
    ;;
    -p|--pubkey)
    PUB_KEY_FILE="$2"
    shift
    ;;
    -n|--numTargets)
    NUM_TARGETS="$2"
    shift
    ;;
    -l|--localSsh)
    LOCAL_SSH="$2"
    shift
    ;;
    -a|--nonRootAgent)
    NON_ROOT_AGENT="yes"
    ;;
    -k|--kerberos)
    KERBEROS="yes"
    ;;
    -g|--gateway)
    GATEWAY="yes"
    ;;
    -r|--ranger)
    RANGER="yes"
    ;;
    -h|--help)
    printUsageAndExit
    ;;
    *)
    echo "Unknown option: $key"
    echo
    printUsageAndExit
    ;;
  esac
  shift
done

if [ -z "$MPACK_DIR" ]; then
  echo "Expected mpack directory to be specified (can be an empty dir if necessary)"
  echo
  printUsageAndExit
fi

if [ -z "$PUB_KEY_FILE" ]; then
  echo "Expected ssh public key to be specified"
  echo
  printUsageAndExit
fi

PUB_KEY="$(cat "$PUB_KEY_FILE")"

echo "MPACK_DIR='$MPACK_DIR'"
echo "PUB_KEY_FILE='$PUB_KEY_FILE'"
echo "NUM_TARGETS='$NUM_TARGETS'"
echo "LOCAL_SSH='$LOCAL_SSH'"
echo "NON_ROOT_AGENT='$NON_ROOT_AGENT'"
echo "KERBEROS='$KERBEROS'"
echo "RANGER='$RANGER'"

exitOnFail() {
  "$@"
  if [ $? -ne 0 ]; then
    echo "Command: $@ failed"
    exit 1
  fi
}

killContainer() {
  if [ -n "$(docker ps | awk '{print $NF}' | grep "^$1\$")" ]; then
    echo "Killing $1"
    exitOnFail docker kill "$1"
  else
    echo "$1 not running so not killing"
  fi
}

rmContainer() {
  if [ -n "$(docker ps -a | awk '{print $NF}' | grep "^$1\$")" ]; then
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

if [ -z "`docker network ls | awk '{print $2}' | grep '^ambari$'`" ]; then
  echo "Creating ambari network"
  exitOnFail docker network create --gateway 172.18.1.1 --subnet 172.18.1.0/24 ambari
else
  echo "Ambari network already exists, not creating"
fi

if [ -n "`docker ps  | awk '{print $NF}' | grep '^squid$'`" ]; then
  echo "Squid already running, not starting again"
else
  rmContainer squid
  exitOnFail docker run -d --hostname squid.ambari --name squid --net ambari squid
fi

killAndRemoveContainer kdc
if [ "$KERBEROS" == "yes" ]; then
  echo "Creating kdc container"
  exitOnFail docker run -d --hostname kdc.ambari --name kdc --net ambari -v /dev/urandom:/dev/random kdc
fi

killAndRemoveContainer gateway
if [ "$GATEWAY" == "yes" ]; then
  echo "Creating gateway container"
  exitOnFail docker run -d --name gateway --hostname gateway.ambari --net ambari -p "$LOCAL_SSH":22 gateway -p "$PUB_KEY"
fi

killAndRemoveContainer non-root-ranger
killAndRemoveContainer ranger-solr
if [ "$RANGER" == "yes" ]; then
  echo "Creating ranger container"
  exitOnFail docker run -d --name non-root-ranger --hostname ranger.ambari --net ambari -e YUM_PROXY=http://squid:3128 non-root-ranger "$PUB_KEY" ambari
  exitOnFail docker run -d --name ranger-solr --hostname solr.ambari --net ambari ranger-solr
fi

killAndRemoveContainer ambari
echo "Creating ambari container"
exitOnFail docker run -d --hostname ambari.ambari --name ambari --net ambari -v "$MPACK_DIR:/build" -p 8080:8080 -e YUM_PROXY=http://squid:3128 ambari

for i in `docker ps | awk '{print $NF}' | grep "^centos6"`; do
  killContainer "$i"
done

for i in `docker ps -a | awk '{print $NF}' | grep "^centos6"`; do
  rmContainer "$i"
done

for i in $(seq 1 $NUM_TARGETS); do
  if [ "$NON_ROOT_AGENT" == "yes" ]; then
    exitOnFail docker run -d --net ambari --hostname "centos6$i.ambari" --name "centos6$i" -e YUM_PROXY=http://squid:3128 non-root-ambari-agent "$PUB_KEY" ambari
  else
    exitOnFail docker run -d --net ambari --hostname "centos6$i.ambari" --name "centos6$i" -e YUM_PROXY=http://squid:3128 root-ambari-agent "$PUB_KEY" ambari
  fi
  echo "Target node with hostname centos6$i created"
done

