# LBM(LINE Blockchain Mainnet)

[![codecov](https://codecov.io/gh/line/lbm/branch/main/graph/badge.svg?token=JFFuUevpzJ)](https://codecov.io/gh/line/lbm)

This repository hosts `LBM(LINE Blockchain Mainnet)`. This repository is forked from [gaia](https://github.com/cosmos/gaia) at 2021-03-15. LBM is a mainnet app implementation using [lbm-sdk](https://github.com/line/lbm-sdk) and [ostracon](https://github.com/line/ostracon).

**Node**: Requires [Go 1.15+](https://golang.org/dl/)

**Warnings**: Initial development is in progress, but there has not yet been a stable.

# Quick Start
**Run**
```
make localnet-start
```

**Stop**
```
make localnet-stop
```

**visit with your browser**
* Node: http://localhost:26657/
* REST: http://localhost:1317/swagger-ui/

## Local
**Set up permissions**
```
go env -w GOPRIVATE="github.com/line/*"
git config --global url."https://${YOUR_GITHUB_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"
```

_Note1_

You have to replace ${YOUR_GITHUB_TOKEN} with your token.

To create a token, 
see: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token

_Note2_

Please check `GOPRIVATE` is set by run export and check the result. 
```
go env
```
if you can see `GOPRIVATE`, then you're good to go. 

Otherwise you need to set `GOPRIVATE` as environment variable.

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
lbm start                # Run a node
```

**visit with your browser**
* Node: http://localhost:26657/
* REST: http://localhost:1317/swagger-ui/
