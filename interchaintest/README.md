# IBC conformance test suite

# Quick Start

* Install and Build docker image for conformance test
```bash
# From finschia root folder
make get-heighliner
make local-image
```
* Run conformance test and other custom IBC tests
```bash
cd interchaintest
go test -v ./...
```