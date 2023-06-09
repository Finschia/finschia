# Simple usage with a mounted data directory:
# > docker build --platform="linux/amd64" -t finschia/finschianode . --build-arg ARCH=x86_64
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v finschia/finschianode fnsad init
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v finschia/finschianode fnsad start --rpc.laddr=tcp://0.0.0.0:26657 --p2p.laddr=tcp://0.0.0.0:26656
FROM golang:1.18-bullseye AS build-env
ARG ARCH=$ARCH
ARG FINSCHIA_BUILD_OPTIONS=""

# Set WORKDIR to finschia
WORKDIR /finschia-build/finschia

# prepare dbbackend before building; this can be cached
COPY ./Makefile ./
COPY ./contrib ./contrib
COPY ./sims.mk ./
RUN make dbbackend FINSCHIA_BUILD_OPTIONS="$(FINSCHIA_BUILD_OPTIONS)"

# Install GO dependencies
COPY ./go.mod /finschia-build/finschia/go.mod
COPY ./go.sum /finschia-build/finschia/go.sum
RUN go mod download

# Add source files
COPY . .

# Make release bundle
RUN make build-release-bundle FINSCHIA_BUILD_OPTIONS="$FINSCHIA_BUILD_OPTIONS"
RUN cd build && tar -xzf finschia-*.tgz

# Final image
FROM debian:bullseye
ARG ARCH=$ARCH

WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /finschia-build/finschia/build/libwasmvm.${ARCH}.so /usr/lib/
COPY --from=build-env /finschia-build/finschia/build/fnsad /usr/bin/
