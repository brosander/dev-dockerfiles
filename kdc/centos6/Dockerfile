from centos:6
run yum update -y
run yum install -y krb5-server krb5-libs krb5-auth-dialog krb5-workstation

run cp /etc/krb5.conf /etc/krb5.conf.original
add start.sh /root/
run chmod +x /root/start.sh
entrypoint ["/root/start.sh"]
