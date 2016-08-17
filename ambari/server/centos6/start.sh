#!/bin/bash
if [ -n "$YUM_PROXY" ]; then
  echo "Setting yum proxy to $YUM_PROXY"
  echo "proxy=$YUM_PROXY" >> /etc/yum.conf
fi
find /build/ -name '*.tar.gz' -exec ambari-server install-mpack --mpack={} --purge --verbose \;
ambari-server start
tail -f /var/log/ambari-server/ambari-server.log
