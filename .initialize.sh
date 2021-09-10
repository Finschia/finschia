#!/usr/bin/env bash
set -ex

mode="mainnet"

if [[ $1 == "docker" ]]
then
    if [[ $2 == "testnet" ]]
    then
        mode="testnet"
    fi
    LBM="docker run -i -p 26656:26656 -p 26657:26657 -v ${HOME}/.lbm:/root/.lbm line/lbm lbm"
elif [[ $1 == "testnet" ]]
then
    mode="testnet"
fi

LBM=${LBM:-lbm}

# initialize
rm -rf ~/.lbm

# TODO
# Configure your CLI to eliminate need for chain-id flag
#${LBM} config chain-id lbm
#${LBM} config output json
#${LBM} config indent true
#${LBM} config trust-node true
#${LBM} config keyring-backend test

# Initialize configuration files and genesis file
# moniker is the name of your node
${LBM} init solo --chain-id=lbm

# configure for testnet
if [[ ${mode} == "testnet" ]]
then
    if [[ $1 == "docker" ]]
    then
        docker run -i -p 26656:26656 -p 26657:26657 -v ${HOME}/.lbm:/root/.lbm line/lbm sh -c "export LBM_TESTNET=true"
    else
       export LBM_TESTNET=true
    fi
fi

# Please do not use the TEST_MNEMONIC for production purpose
TEST_MNEMONIC="mind flame tobacco sense move hammer drift crime ring globe art gaze cinnamon helmet cruise special produce notable negative wait path scrap recall have"

${LBM} keys add jack --keyring-backend=test --recover --account=0 <<< ${TEST_MNEMONIC}
${LBM} keys add alice --keyring-backend=test --recover --account=1 <<< ${TEST_MNEMONIC}
${LBM} keys add bob --keyring-backend=test --recover --account=2 <<< ${TEST_MNEMONIC}
${LBM} keys add rinah --keyring-backend=test --recover --account=3 <<< ${TEST_MNEMONIC}
${LBM} keys add sam --keyring-backend=test --recover --account=4 <<< ${TEST_MNEMONIC}
${LBM} keys add evelyn --keyring-backend=test --recover --account=5 <<< ${TEST_MNEMONIC}

# TODO
#if [[ ${mode} == "testnet" ]]
#then
#   ${LBM} add-genesis-account tlink15la35q37j2dcg427kfy4el2l0r227xwhc2v3lg 9223372036854775807link,1stake
#else
#   ${LBM} add-genesis-account link15la35q37j2dcg427kfy4el2l0r227xwhuaapxd 9223372036854775807link,1stake
#fi
# Add both accounts, with coins to the genesis file
${LBM} add-genesis-account $(${LBM} keys show jack -a --keyring-backend=test) 1000link,1000000000000stake
${LBM} add-genesis-account $(${LBM} keys show alice -a --keyring-backend=test) 1000link,1000000000000stake
${LBM} add-genesis-account $(${LBM} keys show bob -a --keyring-backend=test) 1000link,1000000000000stake
${LBM} add-genesis-account $(${LBM} keys show rinah -a --keyring-backend=test) 1000link,1000000000000stake
${LBM} add-genesis-account $(${LBM} keys show sam -a --keyring-backend=test) 1000link,1000000000000stake
${LBM} add-genesis-account $(${LBM} keys show evelyn -a --keyring-backend=test) 1000link,1000000000000stake

${LBM} gentx jack 100000000stake --keyring-backend=test --chain-id=lbm

${LBM} collect-gentxs

${LBM} validate-genesis

# ${LBM} start --log_level *:debug --rpc.laddr=tcp://0.0.0.0:26657 --p2p.laddr=tcp://0.0.0.0:26656

