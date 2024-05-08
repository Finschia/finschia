package app

import (
	"testing"

	"github.com/golang/protobuf/proto" // nolint: staticcheck
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	codectypes "github.com/Finschia/finschia-sdk/codec/types"
	sdk "github.com/Finschia/finschia-sdk/types"
	banktypes "github.com/Finschia/finschia-sdk/x/bank/types"
	govtypes "github.com/Finschia/finschia-sdk/x/gov/types"
	wasmkeeper "github.com/Finschia/wasmd/x/wasm/keeper"
	wasmtypes "github.com/Finschia/wasmd/x/wasm/types"
	wasmvmtypes "github.com/Finschia/wasmvm/types"
)

func TestFilteredStargateMsgEncoders(t *testing.T) {
	var (
		addr1 = wasmkeeper.RandomAccountAddress(t)
		addr2 = wasmkeeper.RandomAccountAddress(t)
	)
	valAddr := make(sdk.ValAddress, wasmtypes.SDKAddrLen)
	valAddr[0] = 12
	valAddr2 := make(sdk.ValAddress, wasmtypes.SDKAddrLen)
	valAddr2[1] = 123

	bankMsg := &banktypes.MsgSend{
		FromAddress: addr2.String(),
		ToAddress:   addr1.String(),
		Amount: sdk.Coins{
			sdk.NewInt64Coin("uatom", 12345),
			sdk.NewInt64Coin("utgd", 54321),
		},
	}
	bankMsgBin, err := proto.Marshal(bankMsg)
	require.NoError(t, err)

	content, err := codectypes.NewAnyWithValue(wasmtypes.StoreCodeProposalFixture())
	require.NoError(t, err)

	proposalMsg := &govtypes.MsgSubmitProposal{
		Proposer:       addr1.String(),
		InitialDeposit: sdk.NewCoins(sdk.NewInt64Coin("uatom", 12345)),
		Content:        content,
	}
	proposalMsgBin, err := proto.Marshal(proposalMsg)
	require.NoError(t, err)

	cases := map[string]struct {
		sender             sdk.AccAddress
		srcMsg             wasmvmtypes.CosmosMsg
		srcContractIBCPort string
		transferPortSource wasmtypes.ICS20TransferPortSource
		// set if valid
		output []sdk.Msg
		// set if invalid
		isError bool
		errMsg  string
	}{
		"stargate encoded bank msg": {
			sender: addr2,
			srcMsg: wasmvmtypes.CosmosMsg{
				Stargate: &wasmvmtypes.StargateMsg{
					TypeURL: "/cosmos.bank.v1beta1.MsgSend",
					Value:   bankMsgBin,
				},
			},
			output: []sdk.Msg{bankMsg},
		},
		"stargate encoded msg with any type": {
			sender: addr2,
			srcMsg: wasmvmtypes.CosmosMsg{
				Stargate: &wasmvmtypes.StargateMsg{
					TypeURL: "/cosmos.gov.v1beta1.MsgSubmitProposal",
					Value:   proposalMsgBin,
				},
			},
			output: []sdk.Msg{proposalMsg},
		},
		"stargate encoded invalid typeUrl": {
			sender: addr2,
			srcMsg: wasmvmtypes.CosmosMsg{
				Stargate: &wasmvmtypes.StargateMsg{
					TypeURL: "/cosmos.bank.v2.MsgSend",
					Value:   bankMsgBin,
				},
			},
			isError: true,
			errMsg:  "Cannot unpack proto message with type URL: /cosmos.bank.v2.MsgSend: invalid CosmosMsg from the contract",
		},
		"stargate encoded filtered (fswap)": {
			sender: addr1,
			srcMsg: wasmvmtypes.CosmosMsg{
				Stargate: &wasmvmtypes.StargateMsg{
					TypeURL: "/lbm.fswap.v1.MsgSwap",
					Value:   nil,
				},
			},
			isError: true,
			errMsg:  "/lbm.fswap.v1.MsgSwap is not supported by Stargate: unsupported for this contract",
		},
		"stargate encoded filtered (fbridge)": {
			sender: addr1,
			srcMsg: wasmvmtypes.CosmosMsg{
				Stargate: &wasmvmtypes.StargateMsg{
					TypeURL: "/lbm.fbridge.v1.MsgTransfer",
					Value:   nil,
				},
			},
			isError: true,
			errMsg:  "/lbm.fbridge.v1.MsgTransfer is not supported by Stargate: unsupported for this contract",
		},
	}
	encodingConfig := MakeEncodingConfig()
	for name, tc := range cases {
		tc := tc
		t.Run(name, func(t *testing.T) {
			var ctx sdk.Context
			encoder := wasmkeeper.DefaultEncoders(encodingConfig.Marshaler, tc.transferPortSource)
			encoder = encoder.Merge(filteredStargateMsgEncoders(encodingConfig.Marshaler))
			res, err := encoder.Encode(ctx, tc.sender, tc.srcContractIBCPort, tc.srcMsg)
			if tc.isError {
				require.Error(t, err)
				require.Equal(t, err.Error(), tc.errMsg)
			} else {
				require.NoError(t, err)
				assert.Equal(t, tc.output, res)
			}
		})
	}
}
