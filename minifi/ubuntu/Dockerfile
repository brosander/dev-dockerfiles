from java:8

arg uid
arg gid

run groupadd -g $gid minifi-user || groupmod -n minifi-user getent group $gid | cut -d: -f1
run useradd --shell /bin/bash -u $uid -g $gid -m minifi-user

volume /opt/minifi

expose 8080

add start.sh /root/
run chmod +x /root/start.sh

cmd ["/root/start.sh"]
