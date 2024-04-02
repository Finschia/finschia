# syntax=docker/dockerfile:1

# Simple usage with a mounted data directory:
# > make docker-build
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v finschia/finschianode fnsad init
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v finschia/finschianode fnsad start --rpc.laddr=tcp://0.0.0.0:26657 --p2p.laddr=tcp://0.0.0.0:26656

ARG GO_VERSION="1.21"
ARG RUNNER_IMAGE="alpine:3.17"

FROM golang:${GO_VERSION}-alpine3.17 AS build-env

ARG FINSCHIA_BUILD_OPTIONS=""
ARG GIT_VERSION
ARG GIT_COMMIT
ARG CMTVERSION

# Set up OS dependencies
RUN apk add --no-cache ca-certificates build-base linux-headers curl

# Set WORKDIR to finschia
WORKDIR /finschia-build/finschia

# Install GO dependencies
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/go/pkg/mod \
    go mod download

# Install libwasmvm.*.a
RUN ARCH=$(uname -m) && WASMVM_VERSION=$(go list -m github.com/Finschia/wasmvm | awk '{print $2}') && \
    curl -L -f -o /lib/libwasmvm_muslc.a  https://github.com/Finschia/wasmvm/releases/download/$WASMVM_VERSION/libwasmvm_muslc.$ARCH.a && ls -al /lib/libwasmvm_muslc.a && \
    # verify checksum
    curl -L -f -o /tmp/checksums.txt https://github.com/Finschia/wasmvm/releases/download/$WASMVM_VERSION/checksums.txt && ls -al /tmp/checksums.txt && \
    sha256sum /lib/libwasmvm_muslc.a | grep $(cat /tmp/checksums.txt | grep libwasmvm_muslc.$ARCH | cut -d ' ' -f 1)

# Add source files
COPY . .

# Build fnsad binary
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/go/pkg/mod \
    GOWORK=off go build \
        -mod=readonly \
        -tags "netgo,ledger,muslc,goleveldb" \
        -ldflags \
            "-X github.com/cosmos/cosmos-sdk/version.Name=finschia \
            -X github.com/cosmos/cosmos-sdk/version.AppName=fnsad \
    		-X github.com/cosmos/cosmos-sdk/version.Version=${GIT_VERSION} \
    		-X github.com/cosmos/cosmos-sdk/version.Commit=${GIT_COMMIT} \
    		-X github.com/cometbft/cometbft/version.TMCoreSemVer=$(CMTVERSION) \
    		-X github.com/cosmos/cosmos-sdk/types.DBBackend=goleveldb \
    		-X github.com/cosmos/cosmos-sdk/version.BuildTags=netgo,ledger,muslc,goleveldb \
            -w -s -linkmode=external -extldflags '-Wl,-z,muldefs -static'" \
        -trimpath \
        -o /finschia-build/finschia/build/fnsad \
        /finschia-build/finschia/cmd/fnsad


# Final image
FROM ${RUNNER_IMAGE}

WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /finschia-build/finschia/build/fnsad /usr/bin/fnsad
