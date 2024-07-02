# Finschia Mainnet/Testnet

## Public endpoints

| Chain            | Chain ID   | Endpoint                                                                                                                                                                          |
| ---------------- | ---------- |-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Finschia mainnet | finschia-2 | https://finschia-api.finschia.io (REST)<br>https://finschia-rpc.finschia.io/ (RPC)<br>finschia-grpc.finschia.io:443 (gRPC)<br>https://finschia-api.finschia.io/swagger/ (Swagger) |
| Ebony testnet    | ebony-2    | https://ebony-api.finschia.io (REST)<br>https://ebony-rpc.finschia.io (RPC)<br>ebony-grpc.finschia.io:443 (gRPC)<br>https://ebony-api.finschia.io/swagger/  (Swagger)             |

## Genesis/Snapshot files for Finschia mainnet/testnet

* Genesis file
    * Finschia mainnet
        * TBD(link)
    * Ebony testnet
        * TBD(link)
* Snapshot file
    * Finschia mainnet (pruned)
        * TBD(link)
    * Ebony testnet (pruned)
        * TBD(link)

## Current Finschia mainnet/testent environment

* Required software
    * Go v1.22+
    * Docker (Required only when using Docker)
* Required binary versions
    * Finschia mainnet (finschia-2)
        * TBD(finschia v4.0.x)
    * Ebony testnet (ebony-2)
        * TBD(finschia v4.0.x)

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
