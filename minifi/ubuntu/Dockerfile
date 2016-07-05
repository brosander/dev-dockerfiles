from java:8

arg uid
arg gid

run groupadd -g $gid minifi || groupmod -n minifi `getent group $gid | cut -d: -f1`
run useradd --shell /bin/bash -u $uid -g $gid -m minifi

run mkdir /opt/minifi
run chown -R minifi:minifi /opt/minifi

run mkdir /opt/minifi-conf
run chown -R minifi:minifi /opt/minifi-conf

run mkdir /opt/minifi-archive
run chown -R minifi:minifi /opt/minifi-archive

add start.sh /home/minifi/
run chown minifi:minifi /home/minifi/start.sh
run chmod +x /home/minifi/start.sh

user minifi

expose 8081

cmd ["/home/minifi/start.sh"]
