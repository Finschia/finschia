#!/bin/bash

make install LINK_BUILD_OPTIONS="cleveldb"

lbm init "t6" --home ./t6 --chain-id t6

lbm unsafe-reset-all --home ./t6

mkdir -p ./t6/data/snapshots/metadata.db

lbm keys add validator --keyring-backend test --home ./t6

lbm add-genesis-account $(lbm keys show validator -a --keyring-backend test --home ./t6) 100000000stake --keyring-backend test --home ./t6

lbm gentx validator 100000000stake --keyring-backend test --home ./t6 --chain-id t6

lbm collect-gentxs --home ./t6

lbm start --db_backend cleveldb --home ./t6
