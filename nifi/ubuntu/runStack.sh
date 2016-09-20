#!/bin/bash

NUM_TARGETS="1"
LOCAL_SSH="2001"
GATEWAY="no"
NIFI=""

printUsageAndExit() {
  echo "usage: $0 -p pub_key_file [-n num_target_nodes] [-l LOCAL_SSH_PORT] [-g] [-h]"
  echo "       -h or --help                    print this message and exit"
  echo "       -p or --pubkey                  public key to use (required)"
  echo "       -a or --archive                 nifi archive to use (required)"
  echo "       -n or --numNodes                number of nifi nodes (default: $NUM_TARGETS)"
  echo "       -l or --localSsh                local port to forward to ssh gateway (default: $LOCAL_SSH)"
  echo "       -g or --gateway                 start gateway container"
  exit 1
}

# see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
while [[ $# -ge 1 ]]; do
  key="$1"
  case $key in
    -p|--pubkey)
    PUB_KEY_FILE="$2"
    shift
    ;;
    -a|--archive)
    NIFI="$2"
    shift
    ;;
    -n|--numNodes)
    NUM_TARGETS="$2"
    shift
    ;;
    -l|--localSsh)
    LOCAL_SSH="$2"
    shift
    ;;
    -g|--gateway)
    GATEWAY="yes"
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

if [ -z "$PUB_KEY_FILE" ]; then
  echo "Expected ssh public key to be specified"
  echo
  printUsageAndExit
fi

if [ -z "$NIFI" ]; then
  echo "Expected nifi archive to be specified"
  echo
  printUsageAndExit
fi

PUB_KEY="$(cat "$PUB_KEY_FILE")"

echo "PUB_KEY_FILE='$PUB_KEY_FILE'"
echo "NIFI='$NIFI'"
echo "NUM_TARGETS='$NUM_TARGETS'"
echo "LOCAL_SSH='$LOCAL_SSH'"
echo "GATEWAY='$GATEWAY'"

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

if [ -z "`docker network ls | awk '{print $2}' | grep '^nifi$'`" ]; then
  echo "Creating nifi network"
  exitOnFail docker network create --gateway 172.18.24.1 --subnet 172.18.24.0/24 nifi
else
  echo "Nifi network already exists, not creating"
fi

killAndRemoveContainer nifi-gateway
if [ "$GATEWAY" == "yes" ]; then
  echo "Creating gateway container"
  exitOnFail docker run -d --name nifi-gateway --hostname gateway.nifi --net nifi -p "$LOCAL_SSH":22 ubuntu-openssh-server -p "$PUB_KEY"
fi

for i in `docker ps | awk '{print $NF}' | grep "^nifi" | grep -v nifi-gateway`; do
  killContainer "$i"
done

for i in `docker ps -a | awk '{print $NF}' | grep "^nifi" | grep -v nifi-gateway`; do
  rmContainer "$i"
done

for i in $(seq 1 $NUM_TARGETS); do
  exitOnFail docker run -d --net nifi --hostname "nifi$i.nifi" --name "nifi$i" -v "$NIFI:/opt/nifi-archive/nifi-archive.zip" nifi
  echo "Target node with hostname nifi$i created"
done

