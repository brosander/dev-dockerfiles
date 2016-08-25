#!/bin/bash

service postgresql start

sudo -u postgres psql postgres -c "alter user postgres with password 'postpass'"

/root/start-agent.sh "$@"
