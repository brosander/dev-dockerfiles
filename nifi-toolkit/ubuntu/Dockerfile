from java:8

arg uid
arg gid
arg toolkit_url

run groupadd -g $gid nifi || groupmod -n nifi `getent group $gid | cut -d: -f1`
run useradd --shell /bin/bash -u $uid -g $gid -m nifi

add provision.sh /root/
run chmod +x /root/provision.sh
run /root/provision.sh "$toolkit_url"
run chown -R nifi:nifi /opt/nifi-toolkit

add start.sh /home/nifi/
run chown -R nifi:nifi /home/nifi

run mkdir /opt/toolkit-output
run chown -R nifi:nifi /opt/toolkit-output

user nifi

run chmod +x /home/nifi/start.sh

entrypoint ["/home/nifi/start.sh"]
