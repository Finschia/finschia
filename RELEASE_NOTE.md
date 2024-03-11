# Finschia v2.0.1 Release Note

## Changelog
Check out the [changelog](https://github.com/Finschia/finschia/blob/v2.0.2/RELEASE_CHANGELOG.md) for a list of relevant changes or [compare all changes](https://github.com/Finschia/finschia/compare/v2.0.1...v2.0.2) from last release

## Highlights
* fix compatibility issues with `IBC relayer`

## Base sub modules
* Ostracon: [v1.1.3](https://github.com/Finschia/ostracon/tree/v1.1.3)
* Finschia-sdk: [v0.48.1](https://github.com/Finschia/finschia-sdk/tree/v0.48.1)
* Finschia/wasmd: [v0.3.0](https://github.com/Finschia/wasmd/tree/v0.3.0)
* Finschia/ibc-go: [v4.3.1](https://github.com/Finschia/ibc-go/tree/v4.3.1)


## Build from source
You must use Golang v1.20.x if building from source
```shell
git clone https://github.com/Finschia/finschia
cd finschia && git checkout v2.0.2
make install
```

## Run with Docker
If you want to run fnsad in a Docker container, you can use the Docker images.
* docker image: `finschia/finschianode:2.0.2`
```shell
docker run finschia/finschianode:2.0.2 fnsad version
# 2.0.2
```

## Download binaries

Binaries for linux and darwin are available below.
