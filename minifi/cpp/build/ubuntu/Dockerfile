from ubuntu

arg uid
arg gid

ENV DEBIAN_FRONTEND noninteractive

run apt-get update && apt-get install -y apt-utils sgml-base xml-core wget build-essential unzip libboost-dev libxml2-dev gnupg curl cmake libleveldb-dev uuid-dev

run groupadd -g $gid minifi || echo "$gid already assigned to: $(getent group $gid | cut -d: -f1)"
run useradd --shell /bin/bash -u $uid -g $gid -m minifi

add start.sh /home/minifi/
run mkdir /out
run chown -R minifi:"$(getent group $gid | cut -d: -f1)" /out /home/minifi

user minifi

run chmod +x /home/minifi/start.sh

entrypoint ["/home/minifi/start.sh"]
