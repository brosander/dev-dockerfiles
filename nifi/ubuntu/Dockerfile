from java:8

arg uid
arg gid

run groupadd -g $gid nifi || groupmod -n nifi `getent group $gid | cut -d: -f1`
run useradd --shell /bin/bash -u $uid -g $gid -m nifi

run mkdir -p /opt/nifi
run chown -R nifi:nifi /opt/nifi

run mkdir -p /opt/nifi-archive
run chown -R nifi:nifi /opt/nifi-archive

run mkdir -p /opt/nifi-conf
run chown -R nifi:nifi /opt/nifi-conf

add start.sh /home/nifi/
run chown -R nifi:nifi /home/nifi

user nifi

run chmod +x /home/nifi/start.sh

expose 8080

cmd ["/home/nifi/start.sh"]
