from java:8-alpine

run apk update && apk add bash && apk add coreutils

arg kafka_url=http://mirrors.ocf.berkeley.edu/apache/kafka/0.10.0.0/kafka_2.11-0.10.0.0.tgz
workdir /usr/lib
run wget -qO- "$kafka_url" | tar -zxvf -

run mkdir /conf/

add start.sh /root/
run chmod +x /root/start.sh

entrypoint ["/root/start.sh"]
