#!/bin/bash

if [ "$1" == "root" ]; then
  ambari-server setup -s
else
  echo -ne "y\n$1\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" | ambari-server setup
fi

ambari-server setup --jdbc-db=postgres --jdbc-driver=./usr/lib/ambari-server/postgresql-9.3-1101-jdbc4.jar
