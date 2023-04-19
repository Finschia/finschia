#!/usr/bin/env bash

# This script is used in the Dockerfiles and installs the Finschia dependency libwasmvm.*.a into the container image.
# See also https://github.com/Finschia/wasmvm/releases

set -e

WASMVM_VERSION=`go list -m github.com/Finschia/wasmvm | awk '{print $2}' | grep -o 'v\d\+\.\d\+\.\d\+-\d\+\.\d\+\.\d\+'`
curl -L -f -o ./checksums.txt https://github.com/Finschia/wasmvm/releases/download/${WASMVM_VERSION}/checksums.txt
for arch in x86_64 aarch64
do
  curl -L -f -o /lib/libwasmvm_muslc.${arch}.a  https://github.com/Finschia/wasmvm/releases/download/${WASMVM_VERSION}/libwasmvm_muslc.$arch.a
  CHECKSUM=`grep libwasmvm_muslc.${arch}.a ./checksums.txt | awk '{print $1}'`
  if [ -z "${CHECKSUM}" ]
  then
    echo "ERROR: libwasmvm_muslc.${arch}.a"
    cat ./checksums.txt
    exit 1
  fi
  sha256sum /lib/libwasmvm_muslc.${arch}.a | grep "${CHECKSUM}"
done
rm ./checksums.txt
