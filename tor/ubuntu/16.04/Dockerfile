from ubuntu:xenial

add tor.list /etc/apt/sources.list.d/
add start.sh /root/

run chmod +x /root/start.sh

run gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 && gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

run apt-get update && apt-get install -y tor deb.torproject.org-keyring && rm -rf /var/lib/apt/lists/*

run sed -i 's/#SOCKSPort 192.168.0.1:9100/SOCKSPort 0.0.0.0:9050/g' /etc/tor/torrc

expose 9050

entrypoint ["/root/start.sh"]
