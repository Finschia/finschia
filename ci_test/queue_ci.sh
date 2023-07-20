#!/bin/bash

FROM_ACCOUNT='alice'
TOKEN_NAME='ST1'

# This is a function that checks if executeMsg/quertMsg is successful.
check_run_info() {
	local result="$1"
	local msg="$2"
	if [[ "$result" == *"failed"* ]]; then
		echo -e "$msg\n$result"
		exit 1
	fi
}

# This is a function that checks if the result is as expected.
check_result() {
	local result="$1"
	local expected_result="$2"
	if [[ "$result" != "$expected_result" ]]; then
		echo -e "expected result is:\n$expected_result"
		echo -e "query result is:\n$result"
		exit 1
	fi
}

# This is a function to execute and check a query message.
execute_and_check_query_msg() {
	local query_msg="$1"
	local expected_result="$2"
	query_result=$(fnsad query wasm contract-state smart "$CONTRACT_ADDRESS" "$query_msg")
	check_run_info "$query_result" "$query_msg"
	check_result "$query_result" "$expected_result"
}

# store `queue.wasm`
STORE_RES=$(fnsad tx wasm store contracts/queue.wasm --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia --gas 1500000 -b block -o json -y)
CODE_ID=$(echo "$STORE_RES" | jq '.logs[] | select(.msg_index == 0) | .events[] | select(.type == "store_code") | .attributes[] | select(.key == "code_id") | .value | tonumber')

# instantiate `queue.wasm`
INIT_MSG=$(jq -nc '{}')
INSTANTIATE_RES=$(fnsad tx wasm instantiate "$CODE_ID" "$INIT_MSG" --label $TOKEN_NAME --admin "$(fnsad keys show $FROM_ACCOUNT -a --keyring-backend test)" --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia -b block -o json -y)
CONTRACT_ADDRESS=$(echo "$INSTANTIATE_RES" | jq '.logs[] | select(.msg_index == 0) | .events[] | select(.type == "instantiate") | .attributes[] | select(.key == "_contract_address") | .value' | sed 's/"//g')

# check enqueue
# now: {100, 200, 300}
for value in 100 200 300; do
	ENQUEUE_MSG=$(jq -nc --arg value $value '{enqueue:{value:($value | tonumber)}}')
	RUN_INFO=$(fnsad tx wasm execute "$CONTRACT_ADDRESS" "$ENQUEUE_MSG" --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia -b block -y)
	check_run_info "$RUN_INFO" "$ENQUEUE_MSG"
done

# check count
EXPECTED_RESULT='data:
  count: 3'
COUNT_MSG=$(jq -nc '{count:{}}')
execute_and_check_query_msg "$COUNT_MSG" "$EXPECTED_RESULT"

# check dequeue
# now: {200, 300}
DEQUEUE_MSG=$(jq -nc '{dequeue:{}}')
RUN_INFO=$(fnsad tx wasm execute "$CONTRACT_ADDRESS" "$DEQUEUE_MSG" --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia -b block -y)
check_run_info "$RUN_INFO" "$ENQUEUE_MSG"

# check sum
EXPECTED_RESULT='data:
  sum: 500'
SUM_MSG=$(jq -nc '{sum:{}}')
execute_and_check_query_msg "$SUM_MSG" "$EXPECTED_RESULT"

# check reducer
EXPECTED_RESULT='data:
  counters:
  - - 200
    - 300
  - - 300
    - 0'
REDUCER_MSG=$(jq -nc '{reducer:{}}')
execute_and_check_query_msg "$REDUCER_MSG" "$EXPECTED_RESULT"

# check list
EXPECTED_RESULT='data:
  early:
  - 1
  - 2
  empty: []
  late: []'
LIST_MSG=$(jq -nc '{list:{}}')
execute_and_check_query_msg "$LIST_MSG" "$EXPECTED_RESULT"

# check open_iterators
EXPECTED_RESULT='data: {}'
OPENITERATORS_MSG=$(jq -nc '{open_iterators:{count:3}}')
execute_and_check_query_msg "$OPENITERATORS_MSG" "$EXPECTED_RESULT"
