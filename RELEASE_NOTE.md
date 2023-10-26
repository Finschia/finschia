# Finschia v2.0.0 Release Note

## Changelog
Check out the [changelog](https://github.com/Finschia/finschia/blob/v2.0.0/RELEASE_CHANGELOG.md) for a list of relevant changes or [compare all changes](https://github.com/Finschia/finschia/compare/v1.0.0...v2.0.0) from last release

## Highlights
* Upgrade to Ostracon [v1.1.2](https://github.com/Finschia/ostracon/tree/v1.1.2)
  * Change vrf library from `libsodium` to `curve25519-voi`'s VRF
  * Apply changes up to tendermint v0.34.24
  * Improve KMS features of IP filter and multiple allow IPs
* Upgrade finschia-sdk to [v0.48.0](https://github.com/Finschia/finschia-sdk/releases/tag/v0.48.0)
  * Migrate x/foundation FoundationTax into x/params
  * Add tendermint query apis for compatibility with cosmos-sdk
  * Support custom r/w gRPC options
  * Make x/foundation MsgExec propagate events
  * Fix `MsgMintFT` bug in x/collection module
  * Fix bug where nano S plus ledger could not be connected in Ubuntu
* Upgrade wasmd to [v0.2.0](https://github.com/Finschia/wasmd/releases/tag/v0.2.0)
* Upgrade ibc-go to [v4.3.1](https://github.com/Finschia/ibc-go/releases/tag/v4.3.1)
* Upgrade to Golang v1.20
* Integrate swagger of all submodules
* Support static binary compile

## Base sub modules
* Ostracon: [v1.1.2](https://github.com/Finschia/ostracon/tree/v1.1.2)
* Finschia-sdk: [v0.48.0](https://github.com/Finschia/finschia-sdk/tree/v0.48.0)
* Finschia/wasmd: [v0.2.0](https://github.com/Finschia/wasmd/tree/v0.2.0)
* Finschia/ibc-go: [v4.3.1](https://github.com/Finschia/ibc-go/tree/v4.3.1)


## Build from source
You must use Golang v1.20.x if building from source
```shell
git clone https://github.com/Finschia/finschia
cd finschia && git checkout v2.0.0
make install
```

## Run with Docker
If you want to run fnsad in a Docker container, you can use the Docker images.
* docker image: `finschia/finschianode:2.0.0`
```shell
docker run finschia/finschianode:2.0.0 fnsad version
# 2.0.0
```

## Download binaries

Binaries for linux and darwin are available below.
