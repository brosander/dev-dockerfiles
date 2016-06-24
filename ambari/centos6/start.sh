#!/bin/bash
find /build/ -name '*.tar.gz' -exec ambari-server install-mpack --mpack={} --purge --verbose \;
ambari-server start
tail -f /var/log/ambari-server/ambari-server.log
