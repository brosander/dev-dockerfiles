#!/bin/bash

/opt/solr/ranger_audit_server/scripts/start_solr.sh
sleep 5
tail -f /var/log/solr/ranger_audits/*
