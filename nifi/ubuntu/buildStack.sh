#!/bin/bash

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in#answer-246128
BUILD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$BUILD_DIR" && ./build.sh && cd "$BUILD_DIR/../../openssh-server/ubuntu/" && docker build -t ubuntu-openssh-server .
