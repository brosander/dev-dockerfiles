#!/bin/bash

KAFKA_DIR="$( find /usr/lib -maxdepth 1 -name 'kafka*' )"

echo "JAVA_HOME=$JAVA_HOME"
echo "KAFKA_DIR=$KAFKA_DIR"

SERVER_LOG="$KAFKA_DIR/logs/server.log"

rm -f "$SERVER_LOG"

"$KAFKA_DIR/bin/zookeeper-server-start.sh" -daemon "$KAFKA_DIR/config/zookeeper.properties"
"$KAFKA_DIR/bin/kafka-server-start.sh" -daemon "$KAFKA_DIR/config/server.properties"

until [ -f "$SERVER_LOG" ]; do sleep 1; done
tail -f -n +1 "$SERVER_LOG" &
( tail -f -n +1 "$SERVER_LOG" & ) | timeout 180 grep -q "started (kafka.server.KafkaServer)"

"$KAFKA_DIR/bin/kafka-topics.sh" --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test


( tail -f -n +1 "$SERVER_LOG" & ) | grep -q "shut down completed (kafka.server.KafkaServer)"
