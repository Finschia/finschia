<!--
order: 1
-->

# What is lbm?

`lbm` is the name of the LBM SDK application for a LINE Blockchain Mainnet. It comes with 2 main entrypoints:

- `lbm`: The LBM Daemon and command-line interface (CLI). runs a full-node of the `lbm` application.

`lbm` is built on the LBM SDK using the following modules:

- `x/auth`: Accounts and signatures.
- `x/bank`: Token transfers.
- `x/staking`: Staking logic.
- `x/mint`: Inflation logic.
- `x/distribution`: Fee distribution logic.
- `x/slashing`: Slashing logic.
- `x/gov`: Governance logic.
- `x/ibc`: Inter-blockchain transfers.
- `x/params`: Handles app-level parameters.

About a LINE Blockchain Mainnet: A LINE Blockchain Mainnet is a blockchain mainnet network using LBM. Any LINE Blockchain Mainnet can connects to each other via IBC, it automatically gains access to all the other blockchains that are connected to it. A LINE Blockchain Mainnet is a public Proof-of-Stake chain. Its staking token is called the Link.

Next, learn how to [install LBM](./installation.md).
