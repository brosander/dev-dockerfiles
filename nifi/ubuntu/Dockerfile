from java:8

arg uid
arg gid

run groupadd -g $gid nifi || groupmod -n nifi `getent group $gid | cut -d: -f1`
run useradd --shell /bin/bash -u $uid -g $gid -m nifi

volume /opt/nifi

add start.sh /home/nifi/
run chown nifi:nifi /home/nifi/start.sh
run chmod +x /home/nifi/start.sh

user nifi

expose 8080

cmd ["/home/nifi/start.sh"]
