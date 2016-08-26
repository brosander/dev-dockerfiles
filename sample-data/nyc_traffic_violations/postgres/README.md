This is a docker image based on [the docker hub postgres image](https://hub.docker.com/_/postgres/) that contains New York City traffic violation data in a violations table.

Suggested usage:
```
docker build -t nyc_traffic_violations_postgres .
docker run --name nyc_traffic_violations_postgres -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DB=test -d -p 5432:5432 nyc_traffic_violations_postgres
```
