#!/usr/bin/make -f

COMMIT ?= $(shell git log -1 --format='%H')

# ascribe tag only if on a release/ branch, otherwise pick branch name and concatenate commit hash
ifeq (,$(VERSION))
  BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
  VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
  ifeq (, $(findstring release/,$(BRANCH)))
    VERSION = $(subst /,_,$(BRANCH))-$(COMMIT)
  endif
endif

PACKAGES_SIMTEST=$(shell go list ./... | grep '/simulation')
SDK_PACK := $(shell go list -m github.com/Finschia/finschia-sdk | sed  's/ /\@/g')
GO_VERSION := $(shell cat go.mod | grep -E 'go [0-9].[0-9]+' | cut -d ' ' -f 2)
OST_VERSION := $(shell go list -m github.com/Finschia/ostracon | sed 's:.* ::') # grab everything after the space in "github.com/Finschia/ostracon v0.34.7"
WASMVM_VERSION=$(shell go list -m github.com/Finschia/wasmvm | awk '{print $$2}')
DOCKER := $(shell which docker)
LEDGER_ENABLED ?= true
BUILDDIR ?= $(CURDIR)/build
ARCH ?= amd64
TARGET_PLATFORM = linux/amd64
TEMPDIR ?= $(CURDIR)/temp

export GO111MODULE = on

OS_NAME := $(shell uname -s | tr A-Z a-z)
ifeq ($(ARCH), arm64)
	TARGET_PLATFORM = linux/arm64
endif

# process build tags

build_tags = netgo static_wasm muslc
ifeq ($(LEDGER_ENABLED),true)
	build_tags += ledger
endif

build_tags += $(BUILD_TAGS)
build_tags := $(strip $(build_tags))

whitespace :=
whitespace += $(whitespace)
comma := ,
build_tags_comma_sep := $(subst $(whitespace),$(comma),$(build_tags))

# process linker flags

ldflags = -X github.com/Finschia/finschia-sdk/version.Name=finschia \
		  -X github.com/Finschia/finschia-sdk/version.AppName=fnsad \
		  -X github.com/Finschia/finschia-sdk/version.Version=$(VERSION) \
		  -X github.com/Finschia/finschia-sdk/version.Commit=$(COMMIT) \
		  -X github.com/Finschia/finschia-sdk/types.DBBackend=goleveldb \
		  -X "github.com/Finschia/finschia-sdk/version.BuildTags=$(build_tags_comma_sep)" \
		  -X github.com/Finschia/ostracon/version.TMCoreSemVer=$(OST_VERSION) \
		  -linkmode=external \
		  -w -s

ldflags += $(LDFLAGS)
ldflags := $(strip $(ldflags))

BUILD_FLAGS := -tags "$(build_tags)" -ldflags '$(ldflags)'
CGO_CFLAGS  := -I$(TEMPDIR)/include
CGO_LDFLAGS := -L$(TEMPDIR)/lib
ifeq ($(OS_NAME),darwin)
	CGO_LDFLAGS += -lz -lbz2
else
	CGO_LDFLAGS += -static -lwasmvm_muslc -lm
endif


###############################################################################
###                              Documentation                              ###
###############################################################################

all: install lint test

$(TEMPDIR)/:
	mkdir -p $(TEMPDIR)/

wasmvmlib: $(TEMPDIR)/
	@mkdir -p $(TEMPDIR)/lib
    ifeq (",$(wildcard $(TEMPDIR)/lib/libwasmvm*.a)")
        ifeq ($(OS_NAME),darwin)
	        wget https://github.com/Finschia/wasmvm/releases/download/$(WASMVM_VERSION)/libwasmvmstatic_darwin.a -O $(TEMPDIR)/lib/libwasmvmstatic_darwin.a
        else
            ifeq ($(ARCH),amd64)
	            wget https://github.com/Finschia/wasmvm/releases/download/$(WASMVM_VERSION)/libwasmvm_muslc.x86_64.a -O $(TEMPDIR)/lib/libwasmvm_muslc.a
            else
	            wget https://github.com/Finschia/wasmvm/releases/download/$(WASMVM_VERSION)/libwasmvm_muslc.aarch64.a -O $(TEMPDIR)/lib/libwasmvm_muslc.a
            endif
        endif
    endif

# command for make build and make install
build: BUILDARGS=-o $(BUILDDIR)/
build install: go.sum $(BUILDDIR)/ wasmvmlib
	CGO_ENABLED=1 CGO_CFLAGS="$(CGO_CFLAGS)" CGO_LDFLAGS="$(CGO_LDFLAGS)" go $@ -mod=readonly $(BUILD_FLAGS) $(BUILDARGS) ./...

# ensure build directory exists
$(BUILDDIR)/:
	mkdir -p $(BUILDDIR)/

go.sum: go.mod
	@echo "--> Ensure dependencies have not been modified"
	@go mod verify

clean:
	rm -rf $(BUILDDIR)/ $(TEMPDIR)/

distclean: clean
	rm -rf vendor/

build-reproducible: go.sum
	mkdir -p $(BUILDDIR)
	$(DOCKER) buildx create --name finschiabuilder || true
	$(DOCKER) buildx use finschiabuilder
	$(DOCKER) buildx build \
		--build-arg GO_VERSION=$(GO_VERSION) \
		--build-arg GIT_VERSION=$(VERSION) \
		--build-arg GIT_COMMIT=$(COMMIT) \
		--build-arg OST_VERSION=$(OST_VERSION) \
		--build-arg RUNNER_IMAGE=alpine:3.17 \
		--platform $(TARGET_PLATFORM) \
		-t finschia/finschianode:local-$(ARCH) \
		--load \
		-f Dockerfile .
	$(DOCKER) rm -f finschiabinary || true
	$(DOCKER) create -ti --name finschiabinary finschia/finschianode:local-$(ARCH)
	$(DOCKER) cp finschiabinary:/usr/bin/fnsad $(BUILDDIR)/fnsad-linux-$(ARCH)
	$(DOCKER) rm -f finschiabinary

go-mod-cache: go.sum
	@echo "--> Download go modules to local cache"
	@go mod download

.PHONY: all build install clean wasmvmlib build-reproducible


###############################################################################
###                           Tests & Simulation                            ###
###############################################################################

include sims.mk

test: test-unit

test-all: test-race test-cover

test-unit:
	@VERSION=$(VERSION) go test -mod=readonly -tags='ledger test_ledger_mock' ./...

test-race:
	@VERSION=$(VERSION) go test -mod=readonly -race -tags='ledger test_ledger_mock' ./...

test-cover:
	@go test -mod=readonly -timeout 30m -race -coverprofile=coverage.txt -covermode=atomic -tags='ledger test_ledger_mock' ./...

benchmark:
	@go test -mod=readonly -bench=. ./...

test-integration: build
	@go test -mod=readonly -p 4 `go list ./cli_test/...` $(CLI_TEST_BUILD_FLAGS) -v

test-integration-multi-node: docker-build
	@go test -mod=readonly -p 4 `go list ./cli_test/...` $(CLI_MULTI_BUILD_FLAGS) -v

test-upgrade-name:
	@sh contrib/check-upgrade-name.sh

.PHONY: test test-all test-unit test-race test-cover benchmark test-integration test-integration-multi-node


###############################################################################
###                                Docker                                   ###
###############################################################################

RUNNER_BASE_IMAGE_ALPINE := alpine:3.17

docker-build:
	@DOCKER_BUILDKIT=1 docker build \
		-t finschia/finschianode:local \
		-t finschia/finschianode:local-distroless \
		--build-arg GO_VERSION=$(GO_VERSION) \
		--build-arg RUNNER_IMAGE=$(RUNNER_BASE_IMAGE_ALPINE) \
		--build-arg GIT_VERSION=$(VERSION) \
		--build-arg GIT_COMMIT=$(COMMIT) \
		--build-arg OST_VERSION=$(OST_VERSION) \
		--platform=$(TARGET_PLATFORM) \
		-f Dockerfile .
.PHONY: docker-build

###############################################################################
###                                Linting                                  ###
###############################################################################

lint:
	golangci-lint run
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" | xargs gofmt -d -s

format:
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" -not -path "./client/lcd/statik/statik.go" | xargs gofmt -w -s
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" -not -path "./client/lcd/statik/statik.go" | xargs misspell -w
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" -not -path "./client/lcd/statik/statik.go" | xargs goimports -w -local github.com/Finschia/finschia-sdk

.PHONY: lint format


###############################################################################
###                                Localnet                                 ###
###############################################################################

localnet-docker-build:
	@DOCKER_BUILDKIT=1 docker build \
    		-t finschia/finschianode:localnet \
    		--build-arg GO_VERSION=$(GO_VERSION) \
    		--build-arg RUNNER_IMAGE=$(RUNNER_BASE_IMAGE_ALPINE) \
    		--build-arg GIT_VERSION=$(VERSION) \
    		--build-arg GIT_COMMIT=$(COMMIT) \
    		--build-arg OST_VERSION=$(OST_VERSION) \
    		--platform=$(TARGET_PLATFORM) \
    		-f networks/local/finschianode/Dockerfile .

# Run a 4-node testnet locally
localnet-start: localnet-stop localnet-docker-build localnet-build-nodes

localnet-build-nodes:
	docker run --rm -v $(CURDIR)/mytestnet:/data finschia/finschianode:localnet \
			testnet init-files --v 4 -o /data --starting-ip-address 192.168.10.2 --keyring-backend=test
	docker-compose up -d

# Stop testnet
localnet-stop:
	docker-compose down

.PHONY: localnet-docker-build localnet-start localnet-build-nodes localnet-stop


###############################################################################
###                                Proto                                    ###
###############################################################################

proto-swagger-gen:
	@echo "Generating Protobuf Swagger"
	./scripts/generate-docs.sh
	statik -src=client/docs/swagger-ui -dest=client/docs -f -m
.PHONY: proto-swagger-gen
