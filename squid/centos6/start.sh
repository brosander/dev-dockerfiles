#!/bin/bash

service squid start && tail -f /var/log/squid/*
