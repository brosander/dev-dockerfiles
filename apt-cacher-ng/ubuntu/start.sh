#!/bin/bash

service apt-cacher-ng start && tail -f /var/log/apt-cacher-ng/*
