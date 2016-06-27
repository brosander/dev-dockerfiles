#!/bin/bash

service rsyslog start
if [ -z "$1" ]; then
  echo "No public key supplied"
else
  mkdir -p /root/.ssh
  echo "$1" >> /root/.ssh/authorized_keys
fi
service sshd start
tail -f /var/log/secure
