#!/bin/bash

if [ -e "/root/started_once" ]; then
  echo "$0 skipping init logic as it has been run before"
else
  if [ -n "$YUM_PROXY" ]; then
    echo "Setting yum proxy to $YUM_PROXY"
    echo "proxy=$YUM_PROXY" >> /etc/yum.conf
  fi

  if [ -z "$1" ]; then
    echo "No public key supplied"
  else
    mkdir -p /root/.ssh
    echo "$1" >> /root/.ssh/authorized_keys
  fi
  touch /root/started_once
fi

service rsyslog start
service sshd start
tail -f /var/log/secure
