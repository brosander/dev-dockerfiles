FROM alpine

RUN apk --no-cache --update add squid

ADD start.sh /root/

ENTRYPOINT ["/root/start.sh"]
