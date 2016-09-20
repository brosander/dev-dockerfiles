#!/bin/bash

DOCKER_UID=1000
if [ -n "$1" ]; then
  DOCKER_UID="$1"
fi

DOCKER_GID=50
if [ -n "$2" ]; then
  DOCKER_GID="$2"
fi

echo "Executing build with nifi uid of $DOCKER_UID and gid of $DOCKER_GID"
docker build --build-arg uid="$DOCKER_UID" --build-arg gid="$DOCKER_GID" -t nifi .
