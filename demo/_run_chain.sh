#!/bin/bash

set -eu

# Remove data
rm -rf $L1_HOME_DIR

# Prepare chain
TEST_MNEMONIC="mind flame tobacco sense move hammer drift crime ring globe art gaze cinnamon helmet cruise special produce notable negative wait path scrap recall have"

$L1_BINARY_PATH init rollupdemo --home $L1_HOME_DIR --chain-id $L1_CHAIN_ID > /dev/null 2>&1
$L1_BINARY_PATH keys add validator --keyring-backend=test --home $L1_HOME_DIR --recover --account=0 <<< ${TEST_MNEMONIC} > /dev/null 2>&1
$L1_BINARY_PATH keys add sequencer --keyring-backend=test --home $L1_HOME_DIR --recover --account=1 <<< ${TEST_MNEMONIC} > /dev/null 2>&1
$L1_BINARY_PATH keys add challenger --keyring-backend=test --home $L1_HOME_DIR --recover --account=2 <<< ${TEST_MNEMONIC} > /dev/null 2>&1
$L1_BINARY_PATH add-genesis-account $($L1_BINARY_PATH --home $L1_HOME_DIR keys show validator -a --keyring-backend=test) 100000000000stake,100000000000tcony --home $L1_HOME_DIR > /dev/null 2>&1
$L1_BINARY_PATH add-genesis-account $($L1_BINARY_PATH --home $L1_HOME_DIR keys show sequencer -a --keyring-backend=test) 100000000000stake,100000000000tcony --home $L1_HOME_DIR > /dev/null 2>&1
$L1_BINARY_PATH add-genesis-account $($L1_BINARY_PATH --home $L1_HOME_DIR keys show challenger -a --keyring-backend=test) 100000000000stake,100000000000tcony --home $L1_HOME_DIR > /dev/null 2>&1
$L1_BINARY_PATH gentx validator 10000000000stake --keyring-backend=test --home $L1_HOME_DIR --chain-id=$L1_CHAIN_ID > /dev/null 2>&1
$L1_BINARY_PATH collect-gentxs --home $L1_HOME_DIR > /dev/null 2>&1

# Run chain
$L1_BINARY_PATH start --rpc.laddr "tcp://127.0.0.1:26659" --home $L1_HOME_DIR > $L1_HOME_DIR/$L1_CHAIN_ID.log 2>&1 &
