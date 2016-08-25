from openjdk:8

run curl https://issues.apache.org/jira/secure/attachment/12761323/solr_for_audit_setup_v3.tgz | tar zxf - -C /usr/local
run useradd -ms /bin/bash solr
run sed -i 's/^SOLR_INSTALL=false/SOLR_INSTALL=true/g' /usr/local/solr_for_audit_setup/install.properties
run sed -i 's/^SOLR_DOWNLOAD_URL=/#SOLR_DOWNLOAD_URL=/g' /usr/local/solr_for_audit_setup/install.properties
run sed -i 's/^#SOLR_DOWNLOAD_URL=http/SOLR_DOWNLOAD_URL=http/g' /usr/local/solr_for_audit_setup/install.properties
workdir /usr/local/solr_for_audit_setup
run ./setup.sh

add start.sh /root/
run chmod +x /root/start.sh

CMD ["/root/start.sh"]
