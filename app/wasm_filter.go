package app

import (
	"strings"

	"github.com/Finschia/finschia-sdk/codec"
	codectypes "github.com/Finschia/finschia-sdk/codec/types"
	sdk "github.com/Finschia/finschia-sdk/types"
	sdkerrors "github.com/Finschia/finschia-sdk/types/errors"
	wasmkeeper "github.com/Finschia/wasmd/x/wasm/keeper"
	wasmtypes "github.com/Finschia/wasmd/x/wasm/types"
	wasmvmtypes "github.com/Finschia/wasmvm/types"
)

func filteredStargateMsgEncoders(cdc codec.Codec) *wasmkeeper.MessageEncoders {
	return &wasmkeeper.MessageEncoders{
		Stargate: wasmFilteredEncodeStargateMsg(cdc),
	}
}

func wasmFilteredEncodeStargateMsg(unpakcer codectypes.AnyUnpacker) wasmkeeper.StargateEncoder {
	// deny list in StargateMsg of wasm
	deniedModulesInStargateMsg := []string{"/lbm.fswap.v1", "/lbm.fbridge.v1"}
	stargateMsgEncoder := wasmkeeper.EncodeStargateMsg(unpakcer)
	return func(sender sdk.AccAddress, msg *wasmvmtypes.StargateMsg) ([]sdk.Msg, error) {
		for _, moduleName := range deniedModulesInStargateMsg {
			if strings.HasPrefix(msg.TypeURL, moduleName) {
				return nil, sdkerrors.Wrap(wasmtypes.ErrUnsupportedForContract, moduleName+" not supported by Stargate")
			}
		}

		return stargateMsgEncoder(sender, msg)
	}
}
