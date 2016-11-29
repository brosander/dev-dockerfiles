#!/bin/bash

if [ -e "/root/started_once" ]; then
  echo "$0 skipping init logic as it has been run before"
else
  if [ -z "$1" ]; then
    echo "No public key supplied"
  else
    mkdir -p /root/.ssh
    echo "$1" >> /root/.ssh/authorized_keys
  fi
  touch /root/started_once
fi

service rsyslog start
service ssh start
until [ -e "/var/log/auth.log" ]; do sleep 1; echo "Waiting for auth log"; done
tail -f /var/log/auth.log
