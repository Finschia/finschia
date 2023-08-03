RLY_VERSION := 2.3.1
GAIA_VERSION := 10.0.2
ARCH := $(shell dpkg --print-architecture)
PATH := $(shell pwd)/bin:$(PATH)
MAKE := $(shell which make)
DOCKER := $(shell which docker)
HOME_DIR := $(shell cd .. && pwd)

bin/fnsad: 
	@mkdir -p bin && \
	cd ../ && \
	make build && \
	mv build/fnsad ibc_e2e/bin
	@fnsad version --long

bin/gaiad:
	@mkdir -p bin/gaia && \
	cd bin/gaia && \
	curl -L https://github.com/cosmos/gaia/releases/download/v$(GAIA_VERSION)/gaiad-v$(GAIA_VERSION)-linux-$(ARCH) --output gaiad && \
	chmod 755 gaiad && \
	mv gaiad ../gaiad
	@gaiad version --long

bin/rly:
	@mkdir -p bin/relayer && \
	cd bin/relayer && \
	curl -L https://github.com/cosmos/relayer/releases/download/v$(RLY_VERSION)/Cosmos.Relayer_$(RLY_VERSION)_linux_$(ARCH).tar.gz --output relayer.tar.gz && \
	tar -xf relayer.tar.gz  --transform 's!^[^/]*!relayer_archive!' && \
	mv relayer_archive/rly ../
	@rly version

test-fnsa-fnsa: bin/rly bin/fnsad
	@./e2e fnsa-fnsa fnsa-0 fnsad 438 fnsa-1 fnsad 438 "skip" 

test-fnsa-gaia: bin/rly bin/fnsad bin/gaiad
	@./e2e fnsa-gaia fnsa-0 fnsad 438 gaia-1 gaiad 118 "skip" 

test-fnsa-fnsa-in-docker:
	@$(DOCKER) run --rm -v ${HOME_DIR}:/workspace -w /workspace/ibc_e2e ibc-e2e:latest make test-fnsa-fnsa

test-fnsa-gaia-in-docker:
	@$(DOCKER) run --rm -v ${HOME_DIR}:/workspace -w /workspace/ibc_e2e ibc-e2e:latest make test-fnsa-gaia

build-docker:
	@$(DOCKER) build . -t ibc-e2e:latest

clean-all:
	@rm -rf bin data

clean-data:
	@rm -rf data

.PHONY: test-fnsa-fnsa test-fnsa-gaia clean-all clean-data
