#!/usr/bin/env bash

# This script update swagger.yml from proto of finschia-sdk, wasmd and ibc-go. And also update statik file.
#
# requirements
# go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@v1.16.0
# go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@v1.16.0

set -eo pipefail

# move the vendor folder to a temp dir so that go list works properly
temp_dir=""
if [ -d vendor ]; then
  temp_dir=$(mktemp -d)
  mv ./vendor "${temp_dir}"
fi

# Get the path of the finschia-sdk repo and wasmd and ibc-go from go/pkg/mod
finschia_sdk_dir=$(go list -f '{{ .Dir }}' -m github.com/Finschia/finschia-sdk) || { echo "Error: Failed to find github.com/Finschia/finschia-sdk"; exit 1; }
wasmd_dir=$(go list -f '{{ .Dir }}' -m github.com/Finschia/wasmd) || { echo "Error: Failed to find github.com/Finschia/wasmd"; exit 1; }
ibc_dir=$(go list -f '{{ .Dir }}' -m github.com/Finschia/ibc-go/v3) || { echo "Error: Failed to find github.com/Finschia/ibc-go/v3"; exit 1; }

# move the vendor folder back to ./vendor
if [ -d "${temp_dir}" ]; then
  mv "${temp_dir}" ./vendor
fi

# create temp dir
mkdir -p ./client/docs/tmp-swagger-gen

if [ -d "${finschia_sdk_dir}/proto" -a -d "${wasmd_dir}/proto" -a -d "${ibc_dir}/proto" ]; then
  proto_dirs=$(find "${finschia_sdk_dir}/proto" "${wasmd_dir}/proto" "${ibc_dir}/proto" -name '*.proto' -print0 | xargs -0 -n1 dirname | sort | uniq)
  for dir in $proto_dirs; do
    # generate swagger files (filter query files)
    query_file=$(find "${dir}" -maxdepth 1 \( -name 'query.proto' -o -name 'service.proto' \))
    if [[ ! -z "$query_file" ]]; then
      protoc \
      -I "${finschia_sdk_dir}/proto" \
      -I "${wasmd_dir}/proto" \
      -I "${ibc_dir}/proto" \
      -I "${finschia_sdk_dir}/third_party/proto" \
        "${query_file}" \
      --swagger_out=./client/docs/tmp-swagger-gen \
      --swagger_opt=logtostderr=true --swagger_opt=fqn_for_swagger_name=true --swagger_opt=simple_operation_ids=true
    fi
  done
fi


if [ -d "./client/docs" ]; then
  cd ./client/docs
  yarn install
  yarn combine

  cd ../../
fi

# clean swagger files
rm -rf ./client/docs/tmp-swagger-gen

# remove temporary directory
rm -rf "${temp_dir}"
