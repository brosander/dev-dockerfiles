#!/bin/bash

service postgresql start

if [ -e "/root/started_once" ]; then
  echo "$0 skipping init logic as it has been run before"
else
  sudo -u postgres psql postgres -c "alter user postgres with password 'postpass'"
fi

/root/start-agent.sh "$@"
