This image will pull down an Apache MiNiFi archive, optionally verify checksums, build it, and copy the assemblies to the /out folder

To build image:

```
./build.sh
```

or to specify UID and GID of minifi user (need to be the same as your user for volume permission reasons (OSX should be fine without):

```
./build.sh UID GID
```

To print usage:
```
docker run -ti --rm minifi_cpp_build_ubuntu -h
```

To run a build of current master (no args, replace volume with where you want the output on your host system):
```
docker run -ti --rm -v `pwd`/target:/out minifi_cpp_build_ubuntu
```

To run an RC build and verify checksums (replace volume with where you want the output on your host system):
```
docker run -ti --rm -v `pwd`/target:/out minifi_cpp_build_ubuntu -b https://dist.apache.org/repos/dist/dev/nifi/nifi-minifi-cpp/0.0.1/nifi-minifi-cpp-0.0.1-source.tar.gz -c
```
