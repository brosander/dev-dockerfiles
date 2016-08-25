from ubuntu-ssh

run apt-get update && apt-get install -y firefox krb5-user krb5-config x11-apps openjdk-8-jdk

run useradd -ms /bin/bash gateway

add krb5.conf.original /etc/

add update-kerb-and-start.sh /root/
run chmod +x /root/update-kerb-and-start.sh

entrypoint ["/root/update-kerb-and-start.sh"]
