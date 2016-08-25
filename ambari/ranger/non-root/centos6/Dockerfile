from non-root-ambari-agent

run yum update -y && yum install -y postgresql postgresql-contrib postgresql-server

run echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
run echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
run sed -i 's/^#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config

run service postgresql initdb

run echo "host all all 0.0.0.0/0 md5" >> /var/lib/pgsql/data/pg_hba.conf
run sed -i "s/#listen_addresses = '[^']\+'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

add start-postgres.sh /root/
run chmod +x /root/start-postgres.sh

run useradd -ms /bin/bash ranger
add run-tls.sh /home/ranger/
run chown ranger:ranger /home/ranger/run-tls.sh
run chmod +x /home/ranger/run-tls.sh

entrypoint ["/root/start-postgres.sh"]
