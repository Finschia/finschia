# Finschia

[![codecov](https://codecov.io/gh/Finschia/finschia/branch/main/graph/badge.svg?token=JFFuUevpzJ)](https://codecov.io/gh/Finschia/finschia)
[![license](https://img.shields.io/github/license/Finschia/finschia.svg)](https://github.com/Finschia/finschia/blob/main/LICENSE)
[![LoC](https://tokei.rs/b1/github/Finschia/finschia)](https://github.com/Finschia/finschia)
[![Go Report Card](https://goreportcard.com/badge/github.com/Finschia/finschia)](https://goreportcard.com/report/github.com/Finschia/finschia)
[![GolangCI](https://golangci.com/badges/github.com/Finschia/finschia.svg)](https://golangci.com/r/github.com/Finschia/finschia)


This repository hosts `Finschia`. This repository is forked from [gaia](https://github.com/cosmos/gaia) at 2021-03-15. Finschia is a mainnet app implementation using [finschia-sdk](https://github.com/Finschia/finschia-sdk), [ostracon](https://github.com/Finschia/ostracon), [wasmd](https://github.com/Finschia/wasmd) and [ibc-go](https://github.com/Finschia/ibc-go).

**Node**: Requires [Go 1.18+](https://golang.org/dl/)

**Warnings**: Initial development is in progress, but there has not yet been a stable.

# Quick Start

## Docker
**Build Docker Image**
```
make docker-build                # build docker image
```
or
```
make docker-build WITH_CLEVELDB=yes GITHUB_TOKEN=${YOUR_GITHUB_TOKEN}  # build docker image with cleveldb
```

_Note1_

If you are using M1 mac, you need to specify build args like this:
```
make docker-build ARCH=arm64
```

**Configure**
```
sh init_single.sh docker          # prepare keys, validators, initial state, etc.
```
or
```
sh init_single.sh docker testnet  # prepare keys, validators, initial state, etc. for testnet
```

**Run**
```
docker run -i -p 26656:26656 -p 26657:26657 -v ${HOME}/.finschia:/root/.finschia finschia/finschianode fnsad start
```

## Local

**Build**
```
make build
make install 
```

**Configure**
```
sh init_single.sh
```
or
```
sh init_single.sh testnet  # for testnet
```

**Run**
```
fnsad start                # Run a node
```

**visit with your browser**
* Node: http://localhost:26657/

## Localnet with 4 nodes

**Run**
```
make localnet-start
```

**Stop**
```
make localnet-stop
```


# How to contribute
check out [CONTRIBUTING.md](CONTRIBUTING.md) for our guidelines & policies for how we develop Finschia. Thank you to all those who have contributed!

