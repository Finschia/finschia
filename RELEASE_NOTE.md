# Finschia v2.0.1 Release Note

## Changelog
Check out the [changelog](https://github.com/Finschia/finschia/blob/v2.0.1/RELEASE_CHANGELOG.md) for a list of relevant changes or [compare all changes](https://github.com/Finschia/finschia/compare/v2.0.0...v2.0.1) from last release

## Highlights
* fix compatible with ledger in MacOS 0.13+

## Base sub modules
* Ostracon: [v1.1.2](https://github.com/Finschia/ostracon/tree/v1.1.2)
* Finschia-sdk: [v0.48.1](https://github.com/Finschia/finschia-sdk/tree/v0.48.1)
* Finschia/wasmd: [v0.2.0](https://github.com/Finschia/wasmd/tree/v0.2.0)
* Finschia/ibc-go: [v4.3.1](https://github.com/Finschia/ibc-go/tree/v4.3.1)


## Build from source
You must use Golang v1.20.x if building from source
```shell
git clone https://github.com/Finschia/finschia
cd finschia && git checkout v2.0.1
make install
```

## Run with Docker
If you want to run fnsad in a Docker container, you can use the Docker images.
* docker image: `finschia/finschianode:2.0.1`
```shell
docker run finschia/finschianode:2.0.1 fnsad version
# 2.0.1
```

## Download binaries

Binaries for linux and darwin are available below.
