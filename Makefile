#!/usr/bin/make -f

COMMIT ?= $(shell git log -1 --format='%H')

# ascribe tag only if on a release/ branch, otherwise pick branch name and concatenate commit hash
ifeq (, $(VERSION))
  BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
  VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
  ifeq (, $(findstring release/,$(BRANCH)))
    VERSION = $(subst /,_,$(BRANCH))-$(COMMIT)
  endif
endif

PACKAGES_SIMTEST=$(shell go list ./... | grep '/simulation')
LEDGER_ENABLED ?= true
SDK_PACK := $(shell go list -m github.com/line/lbm-sdk | sed  's/ /\@/g')
OST_VERSION := $(shell go list -m github.com/line/ostracon | sed 's:.* ::') # grab everything after the space in "github.com/line/ostracon v0.34.7"
DOCKER := $(shell which docker)
BUILDDIR ?= $(CURDIR)/build
TEST_DOCKER_REPO=jackzampolin/linktest
CGO_ENABLED ?= 1
ARCH ?= aarch64
PLATFORM ?= arm64

export GO111MODULE = on

# process build tags

build_tags = netgo
ifeq ($(LEDGER_ENABLED),true)
  ifeq ($(OS),Windows_NT)
    GCCEXE = $(shell where gcc.exe 2> NUL)
    ifeq ($(GCCEXE),)
      $(error gcc.exe not installed for ledger support, please install or set LEDGER_ENABLED=false)
    else
      build_tags += ledger
    endif
  else
    UNAME_S = $(shell uname -s)
    ifeq ($(UNAME_S),OpenBSD)
      $(warning OpenBSD detected, disabling ledger support (https://github.com/cosmos/cosmos-sdk/issues/1988))
    else
      GCC = $(shell command -v gcc 2> /dev/null)
      ifeq ($(GCC),)
        $(error gcc not installed for ledger support, please install or set LEDGER_ENABLED=false)
      else
        build_tags += ledger
      endif
    endif
  endif
endif

# DB backend selection; use default for testing; use rocksdb or cleveldb for performance; build automation is not ready for boltdb and badgerdb yet.
ifeq (,$(filter $(LBM_BUILD_OPTIONS), cleveldb rocksdb boltdb badgerdb))
  BUILD_TAGS += goleveldb
  DB_BACKEND = goleveldb
else
  ifeq (cleveldb,$(findstring cleveldb,$(LBM_BUILD_OPTIONS)))
    CGO_ENABLED=1
    BUILD_TAGS += gcc cleveldb
    DB_BACKEND = cleveldb
    CLEVELDB_DIR = leveldb
    CGO_CFLAGS=-I$(shell pwd)/$(CLEVELDB_DIR)/include
    CGO_LDFLAGS="-L$(shell pwd)/$(CLEVELDB_DIR)/build -L$(shell pwd)/snappy/build -lleveldb -lm -lstdc++ -lsnappy"
  endif
  ifeq (badgerdb,$(findstring badgerdb,$(LBM_BUILD_OPTIONS)))
    BUILD_TAGS += badgerdb
    DB_BACKEND = badgerdb
  endif
  ifeq (rocksdb,$(findstring rocksdb,$(LBM_BUILD_OPTIONS)))
    CGO_ENABLED=1
    BUILD_TAGS += gcc rocksdb
    DB_BACKEND = rocksdb
    ROCKSDB_DIR=$(shell pwd)/rocksdb
    CGO_CFLAGS=-I$(ROCKSDB_DIR)/include
    CGO_LDFLAGS="-L$(ROCKSDB_DIR) -lrocksdb -lm -lstdc++ $(shell awk '/PLATFORM_LDFLAGS/ {sub("PLATFORM_LDFLAGS=", ""); print}' < $(ROCKSDB_DIR)/make_config.mk)"
  endif
  ifeq (boltdb,$(findstring boltdb,$(LBM_BUILD_OPTIONS)))
    BUILD_TAGS += boltdb
    DB_BACKEND = boltdb
  endif
endif

# VRF library selection
ifeq (libsodium,$(findstring libsodium,$(LBM_BUILD_OPTIONS)))
  CGO_ENABLED=1
  BUILD_TAGS += gcc libsodium
  LIBSODIUM_TARGET = libsodium
  CGO_CFLAGS += "-I$(LIBSODIUM_OS)/include"
  CGO_LDFLAGS += "-L$(LIBSODIUM_OS)/lib -lsodium"
endif

# secp256k1 implementation selection
ifeq (libsecp256k1,$(findstring libsecp256k1,$(LBM_BUILD_OPTIONS)))
  CGO_ENABLED=1
  BUILD_TAGS += libsecp256k1
endif

build_tags += $(BUILD_TAGS)
build_tags := $(strip $(build_tags))

whitespace :=
whitespace += $(whitespace)
comma := ,
build_tags_comma_sep := $(subst $(whitespace),$(comma),$(build_tags))

# process linker flags

ldflags = -X github.com/line/lbm-sdk/version.Name=lbm \
		  -X github.com/line/lbm-sdk/version.AppName=lbm \
		  -X github.com/line/lbm-sdk/version.Version=$(VERSION) \
		  -X github.com/line/lbm-sdk/version.Commit=$(COMMIT) \
		  -X github.com/line/lbm-sdk/types.DBBackend=$(DB_BACKEND) \
		  -X "github.com/line/lbm-sdk/version.BuildTags=$(build_tags_comma_sep)" \
		  -X github.com/line/ostracon/version.TMCoreSemVer=$(OST_VERSION)

ifeq ($(LINK_STATICALLY),true)
	ldflags += -linkmode=external -extldflags "-Wl,-z,muldefs -static"
endif

ifeq (,$(findstring nostrip,$(LBM_BUILD_OPTIONS)))
  ldflags += -w -s
endif
ldflags += $(LDFLAGS)
ldflags := $(strip $(ldflags))

BUILD_FLAGS := -tags "$(build_tags)" -ldflags '$(ldflags)'
CLI_TEST_BUILD_FLAGS := -tags "cli_test $(build_tags)"
CLI_MULTI_BUILD_FLAGS := -tags "cli_multi_node_test $(build_tags)"
# check for nostrip option
ifeq (,$(findstring nostrip,$(LBM_BUILD_OPTIONS)))
  BUILD_FLAGS += -trimpath
endif

#$(info $$BUILD_FLAGS is [$(BUILD_FLAGS)])

# The below include contains the tools target.
include contrib/devtools/Makefile

###############################################################################
###                              Documentation                              ###
###############################################################################

all: install lint test

build: BUILD_ARGS=-o $(BUILDDIR)/

build: go.sum $(BUILDDIR)/ dbbackend $(LIBSODIUM_TARGET)
	CGO_CFLAGS=$(CGO_CFLAGS) CGO_LDFLAGS=$(CGO_LDFLAGS) CGO_ENABLED=$(CGO_ENABLED) go build -mod=readonly $(BUILD_FLAGS) $(BUILD_ARGS) ./...

build-static: go.sum $(BUILDDIR)/
	docker build -t line/lbmnode:latest -f builders/Dockerfile.static . --build-arg ARCH=$(ARCH) --platform="linux/$(PLATFORM)"

build-static-centos7: go.sum $(BUILDDIR)/
	docker build -t line/lbm-builder:static_centos7 -f builders/Dockerfile.static_centos7 .
	docker run -it --rm -v $(shell pwd):/code -e LBM_BUILD_OPTIONS="$(LBM_BUILD_OPTIONS)" line/lbm-builder:static_centos7

install: go.sum $(BUILDDIR)/ dbbackend $(LIBSODIUM_TARGET)
	CGO_CFLAGS=$(CGO_CFLAGS) CGO_LDFLAGS=$(CGO_LDFLAGS) CGO_ENABLED=$(CGO_ENABLED) go install $(BUILD_FLAGS) $(BUILD_ARGS) ./cmd/lbm

$(BUILDDIR)/:
	mkdir -p $(BUILDDIR)/

.PHONY: dbbackend
# for more faster building use -j8; but it will be failed in docker building because of low memory
ifeq ($(DB_BACKEND), rocksdb)
dbbackend:
	@if [ ! -e $(ROCKSDB_DIR) ]; then          \
		sh ./contrib/get_rocksdb.sh;         \
	fi
	@if [ ! -e $(ROCKSDB_DIR)/librocksdb.a ]; then    \
		cd $(ROCKSDB_DIR) && make -j2 static_lib; \
	fi
	@if [ ! -e $(ROCKSDB_DIR)/libsnappy.a ]; then    \
                cd $(ROCKSDB_DIR) && make libsnappy.a DEBUG_LEVEL=0; \
        fi
else ifeq ($(DB_BACKEND), cleveldb)
dbbackend:
	@if [ ! -e $(CLEVELDB_DIR) ]; then         \
		sh contrib/get_cleveldb.sh;        \
	fi
	@if [ ! -e $(CLEVELDB_DIR)/libcleveldb.a ]; then   \
		cd $(CLEVELDB_DIR);                        \
		mkdir build;                               \
		cd build;                                  \
		cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DLEVELDB_BUILD_TESTS=OFF -DLEVELDB_BUILD_BENCHMARKS=OFF ..; \
		make;                                      \
	fi
	@if [ ! -e snappy ]; then \
		sh contrib/get_snappy.sh; \
		cd snappy; \
		mkdir build && cd build; \
		cmake -DBUILD_SHARED_LIBS=OFF -DSNAPPY_BUILD_TESTS=OFF -DSNAPPY_REQUIRE_AVX2=ON ..;\
		make; \
	fi
else
dbbackend:
endif

build-docker:
	docker build --build-arg LBM_BUILD_OPTIONS="$(LBM_BUILD_OPTIONS)" --build-arg ARCH=$(ARCH) -t line/lbm . --platform="linux/$(PLATFORM)"

build-contract-tests-hooks:
	mkdir -p $(BUILDDIR)
	go build -mod=readonly $(BUILD_FLAGS) -o $(BUILDDIR)/ ./cmd/contract_tests

go-mod-cache: go.sum
	@echo "--> Download go modules to local cache"
	@go mod download

go.sum: go.mod
	@echo "--> Ensure dependencies have not been modified"
	@go mod verify

draw-deps:
	@# requires brew install graphviz or apt-get install graphviz
	go get github.com/RobotsAndPencils/goviz
	@goviz -i ./cmd/lbm -d 2 | dot -Tpng -o dependency-graph.png

clean:
	rm -rf $(BUILDDIR)/ artifacts/
	@ROCKSDB_DIR=rocksdb;				\
	if [ -e $${ROCKSDB_DIR}/Makefile ]; then	\
		cd $${ROCKSDB_DIR};			\
		make clean;				\
	fi

distclean: clean
	rm -rf vendor/

###############################################################################
###                                 Devdoc                                  ###
###############################################################################

build-docs:
	@cd docs && \
	while read p; do \
		(git checkout $${p} && npm install && VUEPRESS_BASE="/$${p}/" npm run build) ; \
		mkdir -p ~/output/$${p} ; \
		cp -r .vuepress/dist/* ~/output/$${p}/ ; \
		cp ~/output/$${p}/index.html ~/output ; \
	done < versions ;
.PHONY: build-docs

sync-docs:
	cd ~/output && \
	echo "role_arn = ${DEPLOYMENT_ROLE_ARN}" >> /root/.aws/config ; \
	echo "CI job = ${CIRCLE_BUILD_URL}" >> version.html ; \
	aws s3 sync . s3://${WEBSITE_BUCKET} --profile terraform --delete ; \
	aws cloudfront create-invalidation --distribution-id ${CF_DISTRIBUTION_ID} --profile terraform --path "/*" ;
.PHONY: sync-docs


###############################################################################
###                           Tests & Simulation                            ###
###############################################################################

include sims.mk

test: test-unit test-build

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

test-integration-multi-node: build-docker
	@go test -mod=readonly -p 4 `go list ./cli_test/...` $(CLI_MULTI_BUILD_FLAGS) -v


###############################################################################
###                                Linting                                  ###
###############################################################################

lint:
	golangci-lint run
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" | xargs gofmt -d -s

format:
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" -not -path "./client/lcd/statik/statik.go" | xargs gofmt -w -s
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" -not -path "./client/lcd/statik/statik.go" | xargs misspell -w
	find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" -not -path "./client/lcd/statik/statik.go" | xargs goimports -w -local github.com/line/lbm-sdk

###############################################################################
###                                Localnet                                 ###
###############################################################################

build-docker-lbmnode:
	$(MAKE) -C networks/local

# Run a 4-node testnet locally
localnet-start: localnet-stop build-static localnet-build-nodes

localnet-build-nodes:
	docker run --rm -v $(CURDIR)/mytestnet:/data line/lbmnode \
			testnet init-files --v 4 -o /data --starting-ip-address 192.168.10.2 --keyring-backend=test
	docker-compose up -d

# Stop testnet
localnet-stop:
	docker-compose down

test-docker:
	@docker build -f contrib/Dockerfile.test -t ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) .
	@docker tag ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) ${TEST_DOCKER_REPO}:$(shell git rev-parse --abbrev-ref HEAD | sed 's#/#_#g')
	@docker tag ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) ${TEST_DOCKER_REPO}:latest

test-docker-push: test-docker
	@docker push ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD)
	@docker push ${TEST_DOCKER_REPO}:$(shell git rev-parse --abbrev-ref HEAD | sed 's#/#_#g')
	@docker push ${TEST_DOCKER_REPO}:latest

.PHONY: all install format lint \
	go-mod-cache draw-deps clean build \
	setup-transactions setup-contract-tests-data start-link run-lcd-contract-tests contract-tests \
	test test-all test-build test-cover test-unit test-race \
	benchmark \
	build-docker-lbmnode localnet-start localnet-stop \
	docker-single-node

###############################################################################
###                                  tools                                  ###
###############################################################################

VRF_ROOT = $(shell pwd)/tools
LIBSODIUM_ROOT = $(VRF_ROOT)/libsodium
LIBSODIUM_OS = $(VRF_ROOT)/sodium/$(shell go env GOOS)_$(shell go env GOARCH)
ifneq ($(TARGET_HOST), "")
LIBSODIUM_HOST = "--host=$(TARGET_HOST)"
endif

libsodium:
	@if [ ! -f $(LIBSODIUM_OS)/lib/libsodium.a ]; then \
		rm -rf $(LIBSODIUM_ROOT) && \
		mkdir $(LIBSODIUM_ROOT) && \
		git submodule update --init --recursive && \
		cd $(LIBSODIUM_ROOT) && \
		./autogen.sh && \
		./configure --disable-shared --prefix="$(LIBSODIUM_OS)" $(LIBSODIUM_HOST) && \
		$(MAKE) && \
		$(MAKE) install; \
	fi
.PHONY: libsodium
