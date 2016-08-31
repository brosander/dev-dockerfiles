#!/bin/bash

docker build --build-arg uid=1000 --build-arg gid=50 -t minifi_cpp_build_ubuntu .
