# This Dockerfile is used for localnet multinode testing.
# Simple usage with a mounted data directory:
# > docker build --platform="linux/amd64" -t finschia/finschianode:localnet -f networks/local/finschianode . --build-arg ARCH=amd64
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v networks/local/finschianode fnsad init
# > docker run -it -p 26656:26656 -p 26657:26657 -v ~/.finschia:/root/.finschia -v networks/local/finschianode fnsad start --rpc.laddr=tcp://0.0.0.0:26657 --p2p.laddr=tcp://0.0.0.0:26656

ARG GO_VERSION="1.20"
ARG RUNNER_IMAGE="alpine:3.17"

FROM golang:${GO_VERSION}-alpine AS build-env

ARG FINSCHIA_BUILD_OPTIONS=""
ARG GIT_VERSION
ARG GIT_COMMIT
ARG OST_VERSION

# Set up OS dependencies
RUN apk add --no-cache ca-certificates build-base linux-headers curl

# Set WORKDIR to finschia
WORKDIR /finschia-build/finschia

# Install GO dependencies
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/go/pkg/mod \
    go mod download

# Add source files
COPY . .

# Build fnsad binary
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/go/pkg/mod \
    GOWORK=off go build \
        -mod=readonly \
        -tags "netgo,ledger,muslc,goleveldb" \
        -ldflags \
            "-X github.com/Finschia/finschia-sdk/version.Name=finschia \
            -X github.com/Finschia/finschia-sdk/version.AppName=fnsad \
    		-X github.com/Finschia/finschia-sdk/version.Version=${GIT_VERSION} \
    		-X github.com/Finschia/finschia-sdk/version.Commit=${GIT_COMMIT} \
    		-X github.com/Finschia/ostracon/version.TMCoreSemVer=${OST_VERSION} \
    		-X github.com/Finschia/finschia-sdk/types.DBBackend=goleveldb \
    		-X github.com/Finschia/finschia-sdk/version.BuildTags=netgo,ledger,muslc,goleveldb \
            -w -s -linkmode=external -extldflags '-Wl,-z,muldefs -static'" \
        -trimpath \
        -o /finschia-build/finschia/build/fnsad \
        /finschia-build/finschia/cmd/fnsad

# Final image
FROM ${RUNNER_IMAGE}

# Set up OS dependencies
#RUN apk add --update --no-cache libstdc++ ca-certificates
COPY networks/local/finschianode/wrapper.sh /usr/bin/wrapper.sh

VOLUME /finschia
# Copy over binaries from the build-env
COPY --from=build-env /finschia-build/finschia/build/fnsad /finschia/
WORKDIR /finschia

EXPOSE 26656 26657
ENTRYPOINT ["/usr/bin/wrapper.sh"]
CMD ["start"]
STOPSIGNAL SIGTERM