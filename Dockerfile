# Simple usage with a mounted data directory:
# > docker build -t line/lbm .
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.lbm:/root/.lbm -v line/lbm lbm init
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.lbm:/root/.lbm -v line/lbm lbm start --rpc.laddr=tcp://0.0.0.0:26657 --p2p.laddr=tcp://0.0.0.0:26656
FROM golang:1.15-alpine3.13 AS build-env
ARG LBM_BUILD_OPTIONS=""

# Set up OS dependencies
ENV PACKAGES curl wget make cmake git libc-dev bash gcc g++ linux-headers eudev-dev python3 perl
RUN apk add --update --no-cache $PACKAGES

# Set WORKDIR to lbm
WORKDIR /lbm-build/lbm

# prepare dbbackend before building; this can be cached
COPY ./Makefile ./
COPY ./contrib ./contrib
COPY ./sims.mk ./
RUN make dbbackend LBM_BUILD_OPTIONS="$LBM_BUILD_OPTIONS"

# Install GO dependencies
COPY ./go.mod /lbm-build/lbm/go.mod
COPY ./go.sum /lbm-build/lbm/go.sum
RUN go mod download

# Build cosmwasm
RUN cd $(go list -f "{{ .Dir }}" -m github.com/line/wasmvm) && \
    RUSTFLAGS='-C target-feature=-crt-static' cargo build --release --example muslc && \
    mv target/release/examples/libmuslc.a /usr/lib/libwasmvm_muslc.a && \
    rm -rf target

# Add source files
COPY . .

# Make install
RUN BUILD_TAGS=muslc make install CGO_ENABLED=1 LBM_BUILD_OPTIONS="$LBM_BUILD_OPTIONS"

# Final image
FROM alpine:edge

WORKDIR /root

# Set up OS dependencies
RUN apk add --update --no-cache libstdc++ ca-certificates

# Copy over binaries from the build-env
COPY --from=build-env /go/bin/lbm /usr/bin/lbm

