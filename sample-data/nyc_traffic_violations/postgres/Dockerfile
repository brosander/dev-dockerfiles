from postgres

run apt-get update && apt-get install -y curl

add get_data.sh /root/
run chmod +x /root/get_data.sh && /root/get_data.sh
add import.sh /docker-entrypoint-initdb.d/

run chmod a+x /docker-entrypoint-initdb.d/import.sh
run mkdir /home/postgres
run chown -R postgres:postgres /home/postgres
