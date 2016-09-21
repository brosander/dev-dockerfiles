#!/bin/bash

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in#answer-246128
BUILD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOCKER_UID=1000
if [ -n "$1" ]; then
  DOCKER_UID="$1"
fi

DOCKER_GID=50
if [ -n "$2" ]; then
  DOCKER_GID="$2"
fi

TOOLKIT_URL="http://apache.cs.utah.edu/nifi/1.0.0/nifi-toolkit-1.0.0-bin.zip"
if [ -n "$3" ]; then
  TOOLKIT_URL="$3"
fi

echo "Executing build with nifi uid of $DOCKER_UID and gid of $DOCKER_GID"
cd "$BUILD_DIR" && docker build --build-arg uid="$DOCKER_UID" --build-arg gid="$DOCKER_GID" --build-arg toolkit_url="$TOOLKIT_URL" -t nifi-toolkit .
