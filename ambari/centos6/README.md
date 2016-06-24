Ambari Dockerfile for centos6

This will install all mpacks found in the mounted /build folder and then start ambari, blocking while tailing the log

Usage (You can specify a different Ambari repo at build time and a different mpack mount point at runtime):
```
docker build --build-arg repo=http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -t ambari .
docker run -t -i -p 8080:8080 -v `pwd`/target:/build --rm ambari
```
