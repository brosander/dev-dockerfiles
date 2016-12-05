FROM alpine

arg uid
arg gid

RUN apk --no-cache --update add apache2-utils

RUN addgroup -g $gid apache || groupmod -n apache `getent group $gid | cut -d: -f1`
RUN adduser -s /bin/sh -u $uid -G apache -D apache

USER apache
