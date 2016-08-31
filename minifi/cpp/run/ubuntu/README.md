This image run Apache MiNiFi cpp from a volume mounted to /input

To build image:

```
./build.sh
```

or to specify UID and GID of minifi user (need to be the same as your user for volume permission reasons (OSX should be fine without):

```
./build.sh UID GID
```

It expects a built MiNiFi archive (see the ../../build/ubuntu) and a flow.yml folder in the mounted volume.
To run:
```
docker run -ti --rm -v `pwd`/target:/input minifi_cpp_run_ubuntu
```
