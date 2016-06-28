#!/bin/bash

BUILD_DIR="`pwd`"
if [ -z "$1" ]; then
  docker build -t ambari .
else
  docker build --build-arg repo="$1" -t ambari .
fi && cd "$BUILD_DIR/../../squid/centos6/" && docker build -t squid . && cd "$BUILD_DIR/../../openssh-server/centos6/" && docker build -t centos6-ssh .
