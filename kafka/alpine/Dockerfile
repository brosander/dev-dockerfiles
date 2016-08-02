from java:8-alpine

run apk update && apk add bash && apk add coreutils

arg kafka_url=http://mirrors.ocf.berkeley.edu/apache/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
workdir /usr/lib
run wget -qO- "$kafka_url" | tar -zxvf -

add start.sh /root/
run chmod +x /root/start.sh

entrypoint ["/root/start.sh"]
