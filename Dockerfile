# Simple usage with a mounted data directory:
# > docker build --platform="linux/amd64" -t line/lbm . --build-arg ARCH=x86_64
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v line/lbm fnsad init
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v line/lbm fnsad start --rpc.laddr=tcp://0.0.0.0:26657 --p2p.laddr=tcp://0.0.0.0:26656
FROM golang:1.18-alpine AS build-env
ARG ARCH=$ARCH
ARG LBM_BUILD_OPTIONS=""

# Set up OS dependencies
ENV PACKAGES curl wget make cmake git libc-dev bash gcc g++ linux-headers eudev-dev python3 perl
RUN apk add --update --no-cache $PACKAGES

# Set WORKDIR to finschia
WORKDIR /finschia-build/finschia

# prepare dbbackend before building; this can be cached
COPY ./Makefile ./
COPY ./contrib ./contrib
COPY ./sims.mk ./
RUN make dbbackend LBM_BUILD_OPTIONS="$(LBM_BUILD_OPTIONS)"

# Install GO dependencies
COPY ./go.mod /finschia-build/finschia/go.mod
COPY ./go.sum /finschia-build/finschia/go.sum
RUN go mod download

# See https://github.com/line/wasmvm/releases
ADD https://github.com/line/wasmvm/releases/download/v1.1.1-0.11.1/libwasmvm_muslc.x86_64.a /lib/libwasmvm_muslc.x86_64.a
ADD https://github.com/line/wasmvm/releases/download/v1.1.1-0.11.1/libwasmvm_muslc.aarch64.a /lib/libwasmvm_muslc.aarch64.a
RUN sha256sum /lib/libwasmvm_muslc.aarch64.a | grep e03e401e58f72d40a08a99a81bb05123146bb1d6f68b9afbede5481b3ea460f7
RUN sha256sum /lib/libwasmvm_muslc.x86_64.a | grep 06fcd14950c5014e35cc4af39090cb7161b5594d398a7d8fb05525d991370a18

RUN ln -s /lib/libwasmvm_muslc.${ARCH}.a /usr/lib/libwasmvm_muslc.a

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
COPY --from=build-env /go/bin/fnsad /usr/bin/fnsad

