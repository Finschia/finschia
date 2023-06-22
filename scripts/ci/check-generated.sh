#!/usr/bin/env bash

set -euo pipefail

go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@v1.16.0
go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@v1.16.0
go get github.com/rakyll/statik

echo "[go mod tidy]"
go mod tidy

echo "[check versions]"
yarn --version

echo "[Run proto-swagger-gen]"
make proto-swagger-gen

#Specificially ignore all differences in go.mod / go.sum.
if ! git diff --stat --exit-code . ':(exclude)*.mod' ':(exclude)*.sum'; then
    echo ">> ERROR:"
    echo ">>"
    echo ">> swagger docs requires update (query.proto or service.proto of some related module may have changed)."
    echo ">> Ensure your docs are up-to-date, re-run 'make proto-swagger-gen' and update this PR."
    echo ">>"
    exit 1
fi
