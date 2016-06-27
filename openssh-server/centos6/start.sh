#!/bin/bash

if [ -n "$YUM_PROXY" ]; then
  echo "Setting yum proxy to $YUM_PROXY"
  echo "proxy=$YUM_PROXY" >> /etc/yum.conf
fi

service rsyslog start

if [ -z "$1" ]; then
  echo "No public key supplied"
else
  mkdir -p /root/.ssh
  echo "$1" >> /root/.ssh/authorized_keys
fi

service sshd start
tail -f /var/log/secure
