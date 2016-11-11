#!/bin/bash
DOMAIN="$(hostname -f | sed 's/^[^.]\+//g' | sed 's/^\.//g')"
KDC_HOST="kdc.$DOMAIN"
REALM="$(echo "$DOMAIN" | tr '[:lower:]' '[:upper:]')"

printUsageAndExit() {
  echo "usage: $0 [-h] [-r REALM] [-d DOMAIN]"
  echo "       -h or --help                    print this message and exit"
  echo "       -r or --realm                   realm to use (default: $REALM)"
  echo "       -d or --domain                  domain to use (default: $DOMAIN)"
  echo "       -k or --kdc                     kdc hostname (defaults: $KDC_HOST)"
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
    -k|--kdc)
    KDC_HOST="$2"
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

echo "KDC_HOST: $KDC_HOST"
echo "REALM:     $REALM"
echo "DOMAIN:    $DOMAIN"

# save vars for later sourcing if container is getting restarted
varsFile="scriptVars"
if [ ! -e "$varsFile" ] ; then
  echo "KDC_HOST=$KDC_HOST" >> $varsFile
  echo "REALM=$REALM" >> $varsFile
  echo "DOMAIN=$DOMAIN" >> $varsFile
else
  source $varsFile
fi

cp /etc/krb5.conf.original /etc/krb5.conf
sed -i "s/kerberos\.example\.com/$KDC_HOST/g" /etc/krb5.conf
sed -i "s/EXAMPLE\.COM/$REALM/g" /etc/krb5.conf
sed -i "s/example\.com/$DOMAIN/g" /etc/krb5.conf
cp -f /etc/krb5.conf /var/lib/ambari-server/resources/scripts/krb5.conf

if [ -n "$YUM_PROXY" ]; then
  echo "Setting yum proxy to $YUM_PROXY"
  echo "proxy=$YUM_PROXY" >> /etc/yum.conf
fi

ambari-server start
ambari-server stop
startedFile="container-was-started"
if [ ! -e "$startedFile" ] ; then
  find /build/ -name '*.tar.gz' -exec bash -c 'echo yes | ambari-server install-mpack --mpack=$0 --purge --verbose' {} \;
fi
ambari-server start
if [ ! -e "$startedFile" ] ; then
  touch $startedFile
fi
tail -f /var/log/ambari-server/ambari-server.log
