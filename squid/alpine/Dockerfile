FROM alpine

EXPOSE 3128

RUN apk --no-cache --update add squid

ADD start.sh /root/

ENTRYPOINT ["/root/start.sh"]
