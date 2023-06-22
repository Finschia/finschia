#!/usr/bin/env bash

set -euo pipefail

go mod tidy
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
