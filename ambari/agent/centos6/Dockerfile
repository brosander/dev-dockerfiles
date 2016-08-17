from centos6-ssh

arg repo=http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo

run yum update -y
run yum install -y wget openssh-clients sudo
run wget $repo -O /etc/yum.repos.d/ambari.repo
run yum clean all

run yum install -y ambari-agent

add https://raw.githubusercontent.com/apache/ambari/trunk/contrib/utils/non_root/setup_and_start_non_root_agent.sh /root/setup_and_start_non_root_agent.sh
run sed -i 's/^su/#su/g' /root/setup_and_start_non_root_agent.sh
run sed -i "s/echo 'ambari.*/echo 'ambari  ALL=(ALL) NOPASSWD: ALL' >> \/etc\/sudoers/g" /root/setup_and_start_non_root_agent.sh
run chmod +x /root/setup_and_start_non_root_agent.sh
run /root/setup_and_start_non_root_agent.sh

run mkdir /home/ambari/.ssh/
run chown -R ambari:ambari /home/ambari

add start-agent.sh /root/
run chmod +x /root/start-agent.sh

entrypoint ["/root/start-agent.sh"]
