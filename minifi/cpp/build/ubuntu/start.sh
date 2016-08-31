#!/bin/bash

set -e

BUILD_URL="https://github.com/apache/nifi-minifi-cpp/archive/master.zip"
GPG_KEYS_URL="https://dist.apache.org/repos/dist/dev/nifi/KEYS"
CHECK_GPG_AND_CHECKSUMS="no"

printUsageAndExit() {
  echo "usage: $0 [-h] [-b BUILD_URL] [-g GPG_KEYS_URL] [-c]"
  echo "       -h or --help                    print this message and exit"
  echo "       -b or --buildUrl                url of build archive (default: $BUILD_URL)"
  echo "       -g or --gpgKeysUrl              url of gpg keys (default: $GPG_KEYS_URL)"
  echo "       -c or --checkRelease            run release verification (default: $CHECK_GPG_AND_CHECKSUMS)"
  exit 1
}

# see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
while [[ $# -ge 1 ]]; do
  key="$1"
  case $key in
    -b|--buildUrl)
    BUILD_URL="$2"
    shift
    ;;
    -g|--gpgKeysUrl)
    GPG_KEYS_URL="$2"
    shift
    ;;
    -c|--checkRelease)
    CHECK_GPG_AND_CHECKSUMS="yes"
    ;;
    -h|--help)
    printUsageAndExit
    ;;
    *)
    echo "Unknown option: $key"
    echo
    printUsageAndExit
    ;;
  esac
  shift
done

echo "Build Url: $BUILD_URL"
echo "GPG Keys Url: $GPG_KEYS_URL"
echo "Check release checksums and gpg signature: $CHECK_GPG_AND_CHECKSUMS"

mkdir ~/minifi-cpp
BUILD_FILE="$(echo "$BUILD_URL" | sed 's/.*\///g')"
cd ~/minifi-cpp
wget -q -O "$BUILD_FILE" "$BUILD_URL"

if [ "$CHECK_GPG_AND_CHECKSUMS" = "yes" ]; then
  wget -O KEYS "$GPG_KEYS_URL"
  gpg --import KEYS
  wget -O "$BUILD_FILE.asc" "$BUILD_URL.asc"
  gpg --verify "$BUILD_FILE.asc"
  function verifyChecksum() {
    local EXPECTED="$(curl -s "$BUILD_URL.$1")"
    local ACTUAL="$("$1sum" "$BUILD_FILE")"
    local RESULT="$(echo "$ACTUAL" | grep "$EXPECTED")"
    if [ -z "$RESULT" ]; then
      echo "Expected to find $EXPECTED but was $"
      exit 1
    else
      echo "$1: found $EXPECTED in $ACTUAL"
    fi
  }
  verifyChecksum md5
  verifyChecksum sha1
  verifyChecksum sha256
  read -p "Review gpg and checksum output, hit return to continue"
fi

if [[ "$BUILD_FILE" =~ \.t?gz$ ]]; then
  tar -xf "$BUILD_FILE"
elif [[ "$BUILD_FILE" =~ \.zip$ ]]; then 
  unzip "$BUILD_FILE"
else
  echo "Expected tar or zip file for $BUILD_FILE"
  printUsageAndExit
fi

cd "$(dirname "$(find ./ -name NOTICE | head -n 1)")"
make
rm -f /out/*
cp ./assemblies/*.tar.gz /out/
echo "Done building, copied output to output directory"
