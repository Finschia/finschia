# Finschia v3.0.0 Release Note

## Changelog
Check out the [changelog](https://github.com/Finschia/finschia/blob/v3.0.0/RELEASE_CHANGELOG.md) for a list of relevant changes or [compare all changes](https://github.com/Finschia/finschia/compare/v2.0.0...v3.0.0) from last release

## Highlights
* patch [CWA-2023-004 issue](https://forum.cosmos.network/t/high-severity-security-patch-upcoming-on-wed-10th-cwa-2023-004-brought-to-you-by-certik-and-confio/12840)
* Ensure smart contracts compiled with Rust v1.70 run without errors.
* disable custom querier in wasm

## Base sub modules
* Ostracon: [v1.1.2](https://github.com/Finschia/ostracon/tree/v1.1.2)
* Finschia-sdk: [v0.48.1](https://github.com/Finschia/finschia-sdk/tree/v0.48.1)
* Finschia/wasmd: [v0.3.0](https://github.com/Finschia/wasmd/tree/v0.3.0)
* Finschia/ibc-go: [v4.3.1](https://github.com/Finschia/ibc-go/tree/v4.3.1)


## Build from source
You must use Golang v1.20.x if building from source
```shell
git clone https://github.com/Finschia/finschia
cd finschia && git checkout v3.0.0
make install
```

## Run with Docker
If you want to run fnsad in a Docker container, you can use the Docker images.
* docker image: `finschia/finschianode:3.0.0`
```shell
docker run finschia/finschianode:3.0.0 fnsad version
# 3.0.0
```

## Download binaries

Binaries for linux and darwin are available below.
