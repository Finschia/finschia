#!/bin/bash

set -eu

GOPATH=$HOME/go
L1_BINARY_NAME=fnsad-darwin-arm64
L2_BINARY_NAME=l2fnsad
L1_BINARY_PATH=./L1/$L1_BINARY_NAME
L2_BINARY_PATH=$GOPATH/bin/$L2_BINARY_NAME

ROLLUP_NAME=test-rollup
L1_CHAIN_ID=l1fnsa
L2_CHAIN_ID=l2fnsa
L1_HOME_DIR=~/.l1fnsa
L2_KEYRING_DIR=~/.l2fnsa
NAMESPACE_ID=$(openssl rand -hex 8)
RPC_URI=http://localhost:26659
TEST_SEQUENCER_ADDRESS=link1twsfmuj28ndph54k4nw8crwu8h9c8mh3rtx705
DA_BLOCK_HEIGHT=1
SEQUENCER_DIR=fnsa0
TEST_MNEMONIC="mind flame tobacco sense move hammer drift crime ring globe art gaze cinnamon helmet cruise special produce notable negative wait path scrap recall have"

# Reset
if [ `pgrep $L2_BINARY_NAME | wc -l` -ne 0 ]; then echo "Stopping L2 process"; pkill $L2_BINARY_NAME; fi
if [ `pgrep $L1_BINARY_NAME | wc -l` -ne 0 ]; then echo "Stopping L1 process"; pkill $L1_BINARY_NAME; fi
if [ -d $L2_KEYRING_DIR ];                    then rm -rf $L2_KEYRING_DIR; fi
if [ -f $L2_BINARY_PATH ];                    then rm $L2_BINARY_PATH; fi

# Run L1 chain
echo "*** Start L1 chain"
L1_BINARY_PATH=$L1_BINARY_PATH \
  L1_CHAIN_ID=$L1_CHAIN_ID \
  L1_HOME_DIR=$L1_HOME_DIR \
  RPC_URI=$RPC_URI \
  ./_run_chain.sh

echo "*** Waiting for L1 Startup..."
sleep 10

# Prepare rollup info
echo "*** Prepare Rollup"
L1_BINARY_PATH=$L1_BINARY_PATH \
  L1_CHAIN_ID=$L1_CHAIN_ID \
  L1_HOME_DIR=$L1_HOME_DIR \
  RPC_URI=$RPC_URI \
  ROLLUP_NAME=$ROLLUP_NAME \
  ./_prepare_rollup.sh


# Build & rename
echo "*** Build New L2 Binary"
cd .. && make build && cp -r build/fnsad $L2_BINARY_PATH
${L2_BINARY_NAME} version

# Init sequencer

echo "*** Initialize L2 Configuration"
${L2_BINARY_NAME} init rollupdemo --home $L2_KEYRING_DIR/$SEQUENCER_DIR --chain-id $L2_CHAIN_ID > /dev/null 2>&1
${L2_BINARY_NAME} keys add validator --keyring-backend=test --home $L2_KEYRING_DIR/$SEQUENCER_DIR --recover --account=0 <<< ${TEST_MNEMONIC} > /dev/null 2>&1
${L2_BINARY_NAME} add-genesis-account $(${L2_BINARY_NAME} --home $L2_KEYRING_DIR/$SEQUENCER_DIR keys show validator -a --keyring-backend=test) 100000000000stake,100000000000tcony --home $L2_KEYRING_DIR/$SEQUENCER_DIR > /dev/null 2>&1
${L2_BINARY_NAME} gentx validator 10000000000stake --keyring-backend=test --home $L2_KEYRING_DIR/$SEQUENCER_DIR --chain-id=$L2_CHAIN_ID > /dev/null 2>&1
${L2_BINARY_NAME} collect-gentxs --home $L2_KEYRING_DIR/$SEQUENCER_DIR > /dev/null 2>&1

# Run L2 sequencer
echo "*** Start Sequencer"
${L2_BINARY_NAME} start --home $L2_KEYRING_DIR/$SEQUENCER_DIR --p2p.laddr "tcp://0.0.0.0:26556" --grpc.address "0.0.0.0:9190" --grpc-web.address "0.0.0.0:9191" --rollkit.sequencer "true" --rollkit.da_layer finschia --rollkit.da_config='{"rpc_uri":"'$RPC_URI'","chain_id":"'$L1_CHAIN_ID'","keyring_dir":"'$L1_HOME_DIR'","from":"'$TEST_SEQUENCER_ADDRESS'", "rollup_name":"'$ROLLUP_NAME'"}' --rollkit.namespace_id $NAMESPACE_ID  --rollkit.da_start_height $DA_BLOCK_HEIGHT > $L2_KEYRING_DIR/$L2_CHAIN_ID.log 2>&1 &
sleep 10

# Send test
${L2_BINARY_NAME} keys add alice --home $L2_KEYRING_DIR/$SEQUENCER_DIR --keyring-backend=test
sleep 1
ALICE_ADDR=$(${L2_BINARY_NAME} keys show alice -a --home $L2_KEYRING_DIR/$SEQUENCER_DIR --keyring-backend=test)
echo $ALICE_ADDR
${L2_BINARY_NAME} tx bank send validator $ALICE_ADDR 100stake --home $L2_KEYRING_DIR/$SEQUENCER_DIR --keyring-backend=test --chain-id $L2_CHAIN_ID -y
sleep 30

# Check alice's balance
BALANCE=$(${L2_BINARY_NAME} query bank balances $ALICE_ADDR --home $L2_KEYRING_DIR/$SEQUENCER_DIR --output json | jq -r '.balances[0].amount')
if [ 100 -eq ${BALANCE} ]; then
    echo "send success!"
else
    echo "send failed..."
fi

# NOTE: There is a bug in the current Ramus that only validators can execute tx.
${L2_BINARY_NAME} keys add bob --home $L2_KEYRING_DIR/$SEQUENCER_DIR --keyring-backend=test
sleep 1
BOB_ADDR=$(${L2_BINARY_NAME} keys show bob -a --home $L2_KEYRING_DIR/$SEQUENCER_DIR --keyring-backend=test)
echo $ALICE_ADDR
${L2_BINARY_NAME} tx bank send $ALICE_ADDR $BOB_ADDR 10stake --home $L2_KEYRING_DIR/$SEQUENCER_DIR --keyring-backend=test --chain-id $L2_CHAIN_ID -y
sleep 30

# Check alice's balance
BALANCE=$(${L2_BINARY_NAME} query bank balances $BOB_ADDR --home $L2_KEYRING_DIR/$SEQUENCER_DIR --output json | jq -r '.balances[0].amount')
if [ 10 -eq ${BALANCE} ]; then
    echo "send success!"
else
    echo "send failed..."
fi
