#!/bin/bash

if [ -z "$1" ]; then
  echo "No public key supplied"
else
  mkdir -p /root/.ssh
  echo "$1" >> /root/.ssh/authorized_keys
fi

service rsyslog start
service ssh start
until [ -e "/var/log/auth.log" ]; do sleep 1; echo "Waiting for auth log"; done
tail -f /var/log/auth.log
