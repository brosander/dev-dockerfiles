This is a docker image based on [the docker wnameless oracle image](https://hub.docker.com/r/wnameless/oracle-xe-11g/) that contains New York City traffic violation data in a violations table.

Suggested usage:
```
docker build -t nyc_traffic_violations_oracle .
docker run --name nyc_traffic_violations_oracle -d -p 1521:1521 nyc_traffic_violations_oracle
```
