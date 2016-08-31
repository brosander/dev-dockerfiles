#!/bin/bash

set -e

cd ~

tar -zxf "$(find /input -name 'minifi-*-bin.tar.gz')"

cd "$(dirname "$(dirname "$(find ./ -name minifi.sh)")")"

cp /input/flow.yml ./conf/
./bin/minifi.sh run
