Ambari Dockerfile for centos6

This will install all mpacks found in the mounted /build folder and then start ambari, blocking while tailing the log

Usage (You can specify a different Ambari repo at build time and a different mpack mount point at runtime):
```
docker build --build-arg repo=http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -t ambari .
docker run -t -i -p 8080:8080 -v `pwd`/target:/build --rm ambari
```

There are three convenience scripts to make Ambari development easier.

1. buildStack.sh takes a single (optional argument) of which repo to build the ambari image for, defaulting to http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo if none is specified.
2. runStack.sh run with -h or no args to view usage
3. teardown.sh takes 1 optional argument.  Pass killsquid as arg1 if you want to kill and remove squid also (default false)
