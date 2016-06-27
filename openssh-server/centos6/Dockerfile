from centos:6
run yum update -y
run yum install -y openssh-server openssh-clients syslog

add start.sh /root/
run chmod +x /root/start.sh
entrypoint ["/root/start.sh"]
