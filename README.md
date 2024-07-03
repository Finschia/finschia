# Finschia

[![codecov](https://codecov.io/gh/Finschia/finschia/branch/main/graph/badge.svg?token=JFFuUevpzJ)](https://codecov.io/gh/Finschia/finschia)
[![license](https://img.shields.io/github/license/Finschia/finschia.svg)](https://github.com/Finschia/finschia/blob/main/LICENSE)
[![LoC](https://tokei.rs/b1/github/Finschia/finschia)](https://github.com/Finschia/finschia)
[![Go Report Card](https://goreportcard.com/badge/github.com/Finschia/finschia)](https://goreportcard.com/report/github.com/Finschia/finschia)
[![GolangCI](https://golangci.com/badges/github.com/Finschia/finschia.svg)](https://golangci.com/r/github.com/Finschia/finschia)


This repository hosts `Finschia`. This repository is forked from [gaia](https://github.com/cosmos/gaia) at 2021-03-15. Finschia is a mainnet app implementation using [finschia-sdk](https://github.com/Finschia/finschia-sdk), [ostracon](https://github.com/Finschia/ostracon), [wasmd](https://github.com/Finschia/wasmd) and [ibc-go](https://github.com/Finschia/ibc-go).

**Node**: Requires [Go 1.22+](https://golang.org/dl/)

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

# Finschia Mainnet/Testnet

## Public endpoints

| Chain            | Chain ID   | Endpoint                                                                                                                                                                          |
| ---------------- | ---------- |-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Finschia mainnet | finschia-2 | https://finschia-api.finschia.io (REST)<br>https://finschia-rpc.finschia.io/ (RPC)<br>finschia-grpc.finschia.io:443 (gRPC)<br>https://finschia-api.finschia.io/swagger/ (Swagger) |
| Ebony testnet    | ebony-2    | https://ebony-api.finschia.io (REST)<br>https://ebony-rpc.finschia.io (RPC)<br>ebony-grpc.finschia.io:443 (gRPC)<br>https://ebony-api.finschia.io/swagger/  (Swagger)             |

## Genesis/Snapshot files for Finschia mainnet/testnet

* Genesis file
    * Finschia mainnet
        * [finschia-genesis.tgz](https://vos.line-scdn.net/finschia-2-fileshare/datafile/finschia-prod-2/finschia-2-genesis.tgz)
    * Ebony testnet
        * [ebony-genesis.tgz](https://vos.line-scdn.net/finschia-2-fileshare/ebony-prod-2/genesis-file.tgz)
* Snapshot file
    * Finschia mainnet (pruned)
        * [finschia-2-pruned.tgz](https://finschia-quicksync.line-scdn.net/finschia-2/pruned/finschia-2-pruned.tgz)
    * Ebony testnet (pruned)
        * [ebony-2-pruned.tgz](https://finschia-quicksync.line-scdn.net/ebony-2/pruned/ebony-2-pruned.tgz)

## Current Finschia mainnet/testent environment

* Required binary versions
    * Finschia mainnet (finschia-2)
        * [finschia@v4.0.1](https://github.com/Finschia/finschia/releases/tag/v4.0.1)
    * Ebony testnet (ebony-2)
        * [finschia@v4.0.1](https://github.com/Finschia/finschia/releases/tag/v4.0.1)
    * Docker container image
      * [finschia/finschianode:4.0.1](https://hub.docker.com/layers/finschia/finschianode/4.0.1/images/sha256-73a25e3e1f4343d5a048c8709977335caa1d3b32234b7d5b39217ef237a61649?context=explore)

## Testnet Faucet

* Check faucet status

```shell
curl -X GET https://faucet-ebonynw.line-apps.com/status
```
* How to get coins for Ebony testnet

```shell
curl --header "Content-Type: application/json" \
     --request POST \
     --data '{"denom":"tcony","address":"REPLACE WITH YOUR ADDRESS tlink1..."}' \
     https://faucet-ebonynw.line-apps.com/credit
```

## CLI Examples

### Account

* Create an account
    * `fnsad keys add <account_name>`
* Manage an account key
    * Key information
        * `fnsad keys show <account_name>`
    * Address of validator node operator
        * `fnsad keys show <account_name> --bech=val`
    * Available keys
        * `fnsad keys list`

### Transaction

* Send coins Tx
    * `fnsad tx bank send <from_address> <to_address> <amount> <flags> --chain-id=<chain_id>`
    * example
        * `fnsad tx bank send <from_address> <to_address> 1000000cony --chain-id finschia-2 --gas-prices=0.015cony --gas auto --gas-adjustment 1.3`
* Query Tx
    * Search a transaction matching a hash
        * `fnsad query tx <tx_hash>`

### Query

* Query an account
    * `fnsad query account <account_address>`
* Check balance
    * `fnsad query bank balances <account_address>`
* Check module parameters
    * `fnsad query gov params`

## REST API Examples

* Query the current state

```shell
curl \
    -X GET \
    -H "Content-Type: application/json" \
    http://localhost:1317/cosmos/bank/v1beta1/balances/<address>
```

* Query the past state
    * Use the HTTP header x-cosmos-block-height to make a query for the past state.

```shell
curl \
    -X GET \
    -H "Content-Type: application/json" \
    -H "x-cosmos-block-height: 279256"
    http://localhost:1317/cosmos/bank/v1beta1/balances/<address>
```


# How to contribute
check out [CONTRIBUTING.md](CONTRIBUTING.md) for our guidelines & policies for how we develop Finschia. Thank you to all those who have contributed!

