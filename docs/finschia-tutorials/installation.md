<!--
order: 2
-->

# Install Finschia

This guide will explain how to install the `fnsad` entrypoint
onto your system. With these installed on a server, you can participate in the
mainnet as either a [Full Node](./join-mainnet.md) or a
[Validator](../validators/validator-setup.md).

## Install Go

Install `go` by following the [official docs](https://golang.org/doc/install).
Remember to set your `$PATH` environment variable, for example:

```bash
mkdir -p $HOME/go/bin
echo "export PATH=$PATH:$(go env GOPATH)/bin" >> ~/.bash_profile
source ~/.bash_profile
```

::: tip
**Go 1.22+** is required for the Finschia SDK.
:::

## Static build(Optional)

* Install static library(Optional)
  * For CentOS, you may need to install static library

```bash
# Optional: If you don't have library installed
$ sudo yum install glibc-static.x86_64 libstdc++-static -y
```

* Build statically

```bash
# Build statically
LINK_STATICALLY=true make build
```

## Install the binaries

Next, let's install the latest version of Finschia. Make sure you `git checkout` the
correct [released version](https://github.com/Finschia/finschia/releases).

```bash
git clone -b <latest-release-tag> https://github.com/Finschia/finschia
cd finschia && make install
```

If this command fails due to the following error message, you might have already set `LDFLAGS` prior to running this step.

```
# github.com/Finschia/finschia/cmd/fnsad
flag provided but not defined: -L
usage: link [options] main.o
...
make: *** [install] Error 2
```

Unset this environment variable and try again.

```
LDFLAGS="" make install
```

> _NOTE_: If you still have issues at this step, please check that you have the latest stable version of GO installed.

That will install the `fnsad` binary. Verify that everything is OK:

```bash
fnsad version --long
```

`fnsad` for instance should output something similar to:

```bash
name: finschia
server_name: finschia
version: 1.0.0
commit: 8692310a5361006f8c02d44cd7df2d41f130089b
build_tags: netgo,goleveldb
go: go version go1.18.5 darwin/amd64
build_deps:
- github.com/...
- github.com/...
...
```

### Build Tags

Build tags indicate special features that have been enabled in the binary.

| Build Tag | Description                                     |
| --------- | ----------------------------------------------- |
| netgo     | Name resolution will use pure Go code           |
| goleveldb | DB backend used for persistent DB               |
| ledger    | Ledger devices are supported (hardware wallets) |

### Install binary distribution via snap (Linux only)

**Do not use snap at this time to install the binaries for production until we have a reproducible binary system.**

## Developer Workflow

To test any changes made in the SDK or Ostracon, a `replace` clause needs to be added to `go.mod` providing the correct import path.

- Make appropriate changes
- Add `replace github.com/Finschia/finschia-sdk => /path/to/clone/finschia-sdk` to `go.mod`
- Run `make clean install` or `make clean build`
- Test changes
