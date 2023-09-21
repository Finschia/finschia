#!/bin/bash

set -eu

#
DENOM="stake"
DEPOSIT="20"
WITHDRAW="10"

# Get address which want to register for sequencer
SEQUENCER=$($L1_BINARY_PATH keys list --keyring-backend=test --home $L1_HOME_DIR --output json | jq -r '.[1]'.name)
SEQUENCERADDRESS=$($L1_BINARY_PATH keys list --keyring-backend=test --home $L1_HOME_DIR --output json | jq -r '.[1]'.address)
SEQUENCERPUBKEY=$($L1_BINARY_PATH keys list --keyring-backend=test --home $L1_HOME_DIR --output json | jq -r '.[1]'.pubkey)
echo "Sequencer Info"
echo "SEQUENCER: $SEQUENCER"
echo "SEQUENCER ADDRESS: $SEQUENCERADDRESS"
echo "SEQUENCER PUBKEY: $SEQUENCERPUBKEY"

echo "# Check init balance"
INITIAL_BALANCE=$($L1_BINARY_PATH query bank balances $SEQUENCERADDRESS --node "$RPC_URI" --home $L1_HOME_DIR --output json | jq -r '.balances[0].amount')
echo "INITIAL BALANCE: $INITIAL_BALANCE"

echo "# Create rollup"
$L1_BINARY_PATH tx rollup create-rollup $ROLLUP_NAME 5 --from $SEQUENCER --keyring-backend=test --node "$RPC_URI" --home $L1_HOME_DIR --chain-id $L1_CHAIN_ID -y

sleep 5

echo "# Check created rollup"
$L1_BINARY_PATH query rollup show-rollup $ROLLUP_NAME --node "$RPC_URI"

echo "# Check rollup list"
$L1_BINARY_PATH query rollup list --node "$RPC_URI"

echo "# Register sequencer"
$L1_BINARY_PATH tx rollup register-sequencer "$ROLLUP_NAME" ${SEQUENCERPUBKEY} $DEPOSIT$DENOM --from $SEQUENCER --keyring-backend test --node "$RPC_URI" --home $L1_HOME_DIR --chain-id $L1_CHAIN_ID -y

echo "# Check balance after registered sequencer"
while [ 1 ]
do
  sleep 2
  BALANCE_AFTER_REGISTER=$($L1_BINARY_PATH query bank balances $SEQUENCERADDRESS --node "$RPC_URI" --home $L1_HOME_DIR --output json | jq -r '.balances[0].amount')
  if [ $((${INITIAL_BALANCE}-${DEPOSIT})) -ne ${BALANCE_AFTER_REGISTER} ]; then
    echo "$((${INITIAL_BALANCE}-${DEPOSIT})) expected, but got ${BALANCE_AFTER_REGISTER}"
  else
    echo "Register sequencer done"
    break
  fi
done

echo "# Check sequencer by rollup name"
$L1_BINARY_PATH query rollup show-sequencers-by-rollup $ROLLUP_NAME --node "$RPC_URI" --output json

echo "# Check sequencer"
$L1_BINARY_PATH query rollup show-sequencer $SEQUENCERADDRESS --node "$RPC_URI" --home $L1_HOME_DIR --output json

echo "# Withdraw deposit"
$L1_BINARY_PATH tx rollup withdraw-by-sequencer $ROLLUP_NAME $WITHDRAW$DENOM --from $SEQUENCER --keyring-backend test --node "$RPC_URI" --home $L1_HOME_DIR --chain-id $L1_CHAIN_ID -y

sleep 5

echo "# Check balance after withdraw"
BALANCEAFTERWITHDRAW=$($L1_BINARY_PATH query bank balances $SEQUENCERADDRESS --node "$RPC_URI" --home $L1_HOME_DIR --output json | jq -r '.balances[0].amount')

if [ $((${INITIAL_BALANCE}-${DEPOSIT}+${WITHDRAW})) -ne ${BALANCEAFTERWITHDRAW} ]; then
    echo "The balance after withdraw does not match."
    echo "$((${INITIAL_BALANCE}-${DEPOSIT}+${WITHDRAW})) expected, but got $BALANCEAFTERWITHDRAW"
    exit 1
else
    echo "Withdraw done"
fi

echo "# Deposit by sequencer again"
$L1_BINARY_PATH tx rollup deposit-by-sequencer "$ROLLUP_NAME" $DEPOSIT$DENOM --from $SEQUENCER --keyring-backend=test --node "$RPC_URI" --home $L1_HOME_DIR --chain-id $L1_CHAIN_ID -y

sleep 5

echo "# Check balance after deposit again"
BALANCEAFTERDEPOSITAGAIN=$($L1_BINARY_PATH query bank balances $SEQUENCERADDRESS --node "$RPC_URI" --home $L1_HOME_DIR --output json | jq -r '.balances[0].amount')

if [ $((${INITIAL_BALANCE}-2*${DEPOSIT}+${WITHDRAW})) -ne ${BALANCEAFTERDEPOSITAGAIN} ]; then
    echo "The balance after deposit again does not match."
    echo "$((${INITIAL_BALANCE}-2*${DEPOSIT}+${WITHDRAW})) expected, but got ${BALANCEAFTERDEPOSITAGAIN}"
    exit 1
else
    echo "Deposit again done"
fi

echo "Prepare rollup all done."
