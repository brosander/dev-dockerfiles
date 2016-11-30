#!/bin/bash

set -e

cd ~

tar -zxf "$(find /input -name '*minifi-*-bin.tar.gz')"

cd "$(dirname "$(dirname "$(find ./ -name minifi.sh)")")"

cp /input/config.yml ./conf/
./bin/minifi.sh start
sleep 1
tail -f *.log.txt
