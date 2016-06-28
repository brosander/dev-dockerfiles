from centos:6

run yum update -y
run yum install -y squid
run sed -i 's/#cache_dir ufs \/var\/spool\/squid 100 /cache allow all\nmaximum_object_size 1048576 KB\ncache_dir ufs \/var\/spool\/squid 16000 /' /etc/squid/squid.conf

add start.sh /root/
run chmod +x /root/start.sh

expose 3128
cmd ["/root/start.sh"]
