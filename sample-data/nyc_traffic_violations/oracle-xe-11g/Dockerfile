from wnameless/oracle-xe-11g

run apt-get update && apt-get install -y curl

add get_data.sh /root/
run mkdir /var/lib/oracle-files
run chmod +x /root/get_data.sh && /root/get_data.sh
add import.sh /docker-entrypoint-initdb.d/
add loader.ctl /var/lib/oracle-files/

run chmod a+x /docker-entrypoint-initdb.d/import.sh
