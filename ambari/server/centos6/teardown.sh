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

killAndRemoveContainer gateway
killAndRemoveContainer non-root-ranger
killAndRemoveContainer ranger-solr
killAndRemoveContainer kdc
killAndRemoveContainer ambari

for i in `docker ps | awk '{print $NF}' | grep "^centos6"`; do
  killAndRemoveContainer "$i"
done

for i in `docker ps -a | awk '{print $NF}' | grep "^centos6"`; do
  rmContainer "$i"
done

if [ "killsquid" = "$1" ]; then
  killAndRemoveContainer squid
else
  echo "If you want to kill and remove your squid container as well, use killsquid as the value for arg 1"
fi
