from ubuntu

arg uid
arg gid

ENV DEBIAN_FRONTEND noninteractive

run apt-get update && apt-get install -y apt-utils libxml2-dev

run groupadd -g $gid minifi || echo "$gid already assigned to: $(getent group $gid | cut -d: -f1)"
run useradd --shell /bin/bash -u $uid -g $gid -m minifi

add start.sh /home/minifi/
run mkdir /input
run chown -R minifi:"$(getent group $gid | cut -d: -f1)" /input /home/minifi

user minifi

run chmod +x /home/minifi/start.sh

entrypoint ["/home/minifi/start.sh"]
