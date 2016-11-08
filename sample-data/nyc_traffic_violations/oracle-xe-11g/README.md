This is a docker image based on [the docker hub mysql image](https://hub.docker.com/_/mysql/) that contains New York City traffic violation data in a violations table.

Suggested usage:
```
docker build -t nyc_traffic_violations_mysql .
docker run --name nyc_traffic_violations_mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=test -d -p 3306:3306 nyc_traffic_violations_mysql
```
