<!--
order: 1
-->

# What is Finschia?

`fnsad` is the name of the LBM SDK application for a Finschia Mainnet. It comes with 2 main entrypoints:

- `fnsad`: The Finschia Daemon and command-line interface (CLI). runs a full-node of the `fnsad` application.

`fnsad` is built on `x/wasm` module of WASMD, `x/ibc` module of IBC-GO and the LBM SDK using the following modules:

- `x/auth`: Accounts and signatures.
- `x/bank`: Token transfers.
- `x/staking`: Staking logic.
- `x/mint`: Inflation logic.
- `x/distribution`: Fee distribution logic.
- `x/slashing`: Slashing logic.
- `x/gov`: Governance logic.
- `x/params`: Handles app-level parameters.

About a Finschia Mainnet: A Finschia Mainnet is a blockchain mainnet network using Finschia. Any Finschia Mainnet can connect to each other via IBC, it automatically gains access to all the other blockchains that are connected to it. A Finschia Mainnet is a public Proof-of-Stake chain. Its staking token is called the Link.

Next, learn how to [install Finschia](./installation.md).
