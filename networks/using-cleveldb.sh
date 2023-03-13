#!/bin/bash

make install LINK_BUILD_OPTIONS="cleveldb"

fnsad init "t6" --home ./t6 --chain-id t6

fnsad unsafe-reset-all --home ./t6

mkdir -p ./t6/data/snapshots/metadata.db

fnsad keys add validator --keyring-backend test --home ./t6

fnsad add-genesis-account $(fnsad keys show validator -a --keyring-backend test --home ./t6) 100000000stake --keyring-backend test --home ./t6

fnsad gentx validator 100000000stake --keyring-backend test --home ./t6 --chain-id t6

fnsad collect-gentxs --home ./t6

fnsad start --db_backend cleveldb --home ./t6
