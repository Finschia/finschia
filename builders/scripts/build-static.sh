#!/usr/bin/env sh

PROJECT_ROOT=$(realpath "$(dirname "$0")/../..")

# install dependencies
go mod download

# build wasmvm static
cd "$(go list -f "{{ .Dir }}" -m github.com/line/wasmvm)" || exit 1
cd ./libwasmvm

echo "Starting aarch64-unknown-linux-musl build"
export CC=/opt/aarch64-linux-musl-cross/bin/aarch64-linux-musl-gcc
RUSTFLAGS='-C target-feature=-crt-static' cargo build --release --target aarch64-unknown-linux-musl --example staticlib
unset CC

echo "Starting x86_64-unknown-linux-musl build"
RUSTFLAGS='-C target-feature=-crt-static' cargo build --release --target x86_64-unknown-linux-musl --example staticlib

mv -f target/aarch64-unknown-linux-musl/release/examples/libstaticlib.a /usr/lib/libwasmvm_static.aarch64.a
mv -f target/x86_64-unknown-linux-musl/release/examples/libstaticlib.a /usr/lib/libwasmvm_static.a

rm -rf target

cd "${PROJECT_ROOT}" || exit 1

# build lbm
BUILD_TAGS=static LINK_STATICALLY=true make build LBM_BUILD_OPTIONS="${LBM_BUILD_OPTIONS}"
