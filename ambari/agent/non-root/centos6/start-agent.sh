#!/bin/bash

if [ -e "/root/started_once" ]; then
  echo "$0 skipping init logic as it has been run before"
else
  cp -r /var/lib/ambari-agent/data /tmp/data
  rm -r /var/lib/ambari-agent/data
  cp -r /tmp/data /var/lib/ambari-agent
  chown ambari:root /var/lib/ambari-agent/data
  chmod 700 /var/lib/ambari-agent/data
  echo "$1" > /home/ambari/.ssh/authorized_keys
  chown ambari:ambari /home/ambari/.ssh/authorized_keys
  sed -i "s/^hostname=.*/hostname=$2/g" /etc/ambari-agent/conf/ambari-agent.ini
  cp /var/lib/ambari-agent/data/version /home/ambari/
fi

sudo -u ambari /usr/sbin/ambari-agent restart
/root/start.sh "$1"
