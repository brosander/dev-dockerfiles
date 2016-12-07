#!/usr/bin/env sh

if [ -e "/opt/squid-conf" ]; then
  cp /opt/squid-conf/* /etc/squid/
fi

squid && tail -f /var/log/squid/*
