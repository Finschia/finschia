package app

import (
	"strings"

	wasmvmtypes "github.com/Finschia/wasmvm/types"

	wasmkeeper "github.com/Finschia/wasmd/x/wasm/keeper"
	wasmtypes "github.com/Finschia/wasmd/x/wasm/types"

	"github.com/Finschia/finschia-sdk/codec"
	codectypes "github.com/Finschia/finschia-sdk/codec/types"
	sdk "github.com/Finschia/finschia-sdk/types"
	sdkerrors "github.com/Finschia/finschia-sdk/types/errors"
)

func filteredStargateMsgEncoders(cdc codec.Codec) *wasmkeeper.MessageEncoders {
	return &wasmkeeper.MessageEncoders{
		Stargate: wasmFilteredEncodeStargateMsg(cdc),
	}
}

func wasmFilteredEncodeStargateMsg(unpakcer codectypes.AnyUnpacker) wasmkeeper.StargateEncoder {
	// deny list in StargateMsg of wasm
	deniedMsgInStargateMsg := []string{"/lbm.fswap.v1", "/lbm.fbridge.v1"}
	stargateMsgEncoder := wasmkeeper.EncodeStargateMsg(unpakcer)
	return func(sender sdk.AccAddress, msg *wasmvmtypes.StargateMsg) ([]sdk.Msg, error) {
		for _, msgName := range deniedMsgInStargateMsg {
			if strings.HasPrefix(msg.TypeURL, msgName) {
				return nil, sdkerrors.Wrapf(wasmtypes.ErrUnsupportedForContract, "%s is not supported by Stargate", msg.TypeURL)
			}
		}

		return stargateMsgEncoder(sender, msg)
	}
}
