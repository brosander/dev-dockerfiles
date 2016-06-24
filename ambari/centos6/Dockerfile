from centos:6

arg repo=http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo

volume /build

run yum update -y
run yum install -y wget
run wget $repo -O /etc/yum.repos.d/ambari.repo
run yum clean all

run yum install -y ambari-server
run ambari-server setup -s

add start.sh /root/start.sh
run chmod +x /root/start.sh

expose 8080
cmd ["/root/start.sh"]
