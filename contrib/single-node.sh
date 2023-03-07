#!/bin/sh

set -o errexit -o nounset

CHAINID=$1

if [ -z "$1" ]; then
  echo "Need to input chain id..."
  exit 1
fi

# Build genesis file incl account for passed address
coins="10000000000stake,100000000000samoleans"
fnsad init --chain-id $CHAINID $CHAINID
fnsad keys add validator --keyring-backend="test"
fnsad add-genesis-account $(fnsad keys show validator -a --keyring-backend="test") $coins
fnsad gentx validator 5000000000stake --keyring-backend="test" --chain-id $CHAINID
fnsad collect-gentxs

# Set proper defaults and change ports
sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:26657"#g' ~/.fisnchia/config/config.toml
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/g' ~/.fisnchia/config/config.toml
sed -i 's/timeout_propose = "3s"/timeout_propose = "1s"/g' ~/.fisnchia/config/config.toml
sed -i 's/index_all_keys = false/index_all_keys = true/g' ~/.fisnchia/config/config.toml

# Start the link
fnsad start --pruning=nothing
