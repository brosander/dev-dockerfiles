#!/bin/bash

docker build --build-arg uid=`id -u` --build-arg gid=`id -g` -t nifi .
