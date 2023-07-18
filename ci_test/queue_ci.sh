#!/bin/bash

FROM_ACCOUNT='alice'
TOKEN_NAME='ST1'

# This is a function that checks if executeMsg/quertMsg is successful.
checkRunInfo(){
    local result=$1
    local msg=$2
    if [[ "$result" == *"failed"* ]]; then
        echo -e "$msg\n$result"
        exit 1        
    fi    
}

# This is a function that checks if the result is as expected.
checkResult(){
    local result=$1
    local expected_result=$2
    if [[ "$result" != "$expected_result" ]]; then
        echo -e "expected result is:\n$expected_result"
        echo -e "query result is:\n$result"
        exit 1
    fi
}

# This is a function to execute and check queryMsg.
executeAndCheckQueryMsg() {
    local query_msg=$1
    local expected_result=$2
    query_result=$(fnsad query wasm contract-state smart "$CONTRACT_ADDRESS" "$query_msg")
    checkRunInfo "$query_result" "$query_msg"
    checkResult "$query_result" "$expected_result"
}

# store `queue.wasm`
STORE_RES=$(fnsad tx wasm store contracts/queue.wasm --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia --gas 1500000 -b block -o json -y)
CODE_ID=$(echo "$STORE_RES" | jq '.logs[] | select(.msg_index == 0) | .events[] | select(.type == "store_code") | .attributes[] | select(.key == "code_id") | .value | tonumber')

# instantiate `queue.wasm`
init_msg=$(jq -nc '{}')      
INSTANTIATE_RES=$(fnsad tx wasm instantiate "$CODE_ID" "$init_msg" --label $TOKEN_NAME  --admin "$(fnsad keys show $FROM_ACCOUNT -a --keyring-backend test)" --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia -b block -o json -y)
CONTRACT_ADDRESS=$(echo "$INSTANTIATE_RES" | jq '.logs[] | select(.msg_index == 0) | .events[] | select(.type == "instantiate") | .attributes[] | select(.key == "_contract_address") | .value' | sed 's/"//g')

# check enqueue
# now: {100, 200, 300}
for value in 100 200 300; do
    enqueue_msg=$(jq -nc --arg value $value '{enqueue:{value:($value | tonumber)}}')
    run_info=$(fnsad tx wasm execute "$CONTRACT_ADDRESS" "$enqueue_msg" --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia -b block -y)
    checkRunInfo "$run_info" "$enqueue_msg"
done

# check count
expected_result='data:
  count: 3'
count_msg=$(jq -nc '{count:{}}')
executeAndCheckQueryMsg "$count_msg" "$expected_result"

# check dequeue
# now: {200, 300}
dequeue_msg=$(jq -nc '{dequeue:{}}')      
run_info=$(fnsad tx wasm execute "$CONTRACT_ADDRESS" "$dequeue_msg" --from $FROM_ACCOUNT --keyring-backend test --chain-id finschia -b block -y)
checkRunInfo "$run_info" "$enqueue_msg"

# check sum
expected_result='data:
  sum: 500'
sum_msg=$(jq -nc '{sum:{}}')
executeAndCheckQueryMsg "$sum_msg" "$expected_result"

# check reducer
expected_result='data:
  counters:
  - - 200
    - 300
  - - 300
    - 0'
reducer_msg=$(jq -nc '{reducer:{}}')
executeAndCheckQueryMsg "$reducer_msg" "$expected_result"

# check list
expected_result='data:
  early:
  - 1
  - 2
  empty: []
  late: []'
list_msg=$(jq -nc '{list:{}}')
executeAndCheckQueryMsg "$list_msg" "$expected_result"

# check open_iterators
expected_result='data: {}'
openIterators_msg=$(jq -nc '{open_iterators:{count:3}}')
executeAndCheckQueryMsg "$openIterators_msg" "$expected_result"

