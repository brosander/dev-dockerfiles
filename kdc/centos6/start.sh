#!/bin/bash

HOST_NAME="$(hostname -f)"
DOMAIN="$(hostname -f | sed 's/^[^.]\+//g' | sed 's/^\.//g')"
REALM="$(echo "$DOMAIN" | tr '[:lower:]' '[:upper:]')"
PASSWORD="BadPass#1"

printUsageAndExit() {
  echo "usage: $0 [-h] [-r REALM] [-d DOMAIN]"
  echo "       -h or --help                    print this message and exit"
  echo "       -r or --realm                   realm to use (default: $REALM)"
  echo "       -d or --domain                  domain to use (default: $DOMAIN)"
  echo "       -p or --password                password to use (default: $PASSWORD)"
  exit 1
}

# see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
while [[ $# -ge 1 ]]; do
  key="$1"
  case $key in
    -r|--realm)
    REALM="$2"
    shift
    ;;
    -d|--domain)
    DOMAIN="$2"
    shift
    ;;
    -p|--password)
    PASSWORD="$2"
    shift
    ;;
    -h|--help)
    printUsageAndExit
    ;;
    *)
    echo "Unknown option: $key"
    echo
    printUsageAndExit
    ;;
  esac
  shift
done

echo "HOST_NAME: $HOST_NAME"
echo "REALM:     $REALM"
echo "DOMAIN:    $DOMAIN"

cp /etc/krb5.conf.original /etc/krb5.conf
sed -i "s/kerberos\.example\.com/$HOST_NAME/g" /etc/krb5.conf
sed -i "s/EXAMPLE\.COM/$REALM/g" /etc/krb5.conf
sed -i "s/example\.com/$DOMAIN/g" /etc/krb5.conf

echo "$PASSWORD" > passwd
echo "$PASSWORD" >> passwd
kdb5_util create -s < passwd

service krb5kdc start
service kadmin start

kadmin.local -q "addprinc admin/admin" < passwd
rm -f passwd

echo "*/admin@$REALM     *" > /var/kerberos/krb5kdc/kadm5.acl

service krb5kdc restart
service kadmin restart

tail -f -n+1 /var/log/k*.log
