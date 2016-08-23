from ubuntu-ssh

run apt-get update && apt-get install -y firefox krb5-user krb5-config x11-apps

run useradd -ms /bin/bash gateway

add krb5.conf.original /etc/

add update-kerb-and-start.sh /root/
run chmod +x /root/update-kerb-and-start.sh

# NOTE: This is not a secure cipher but we'll only be connecting internally
run echo "Ciphers arcfour" >> /etc/ssh/sshd_config
entrypoint ["/root/update-kerb-and-start.sh"]
