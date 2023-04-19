package ante

import (
	sdk "github.com/Finschia/finschia-sdk/types"
	sdkerrors "github.com/Finschia/finschia-sdk/types/errors"
	"github.com/Finschia/finschia-sdk/x/auth/ante"
	ibcante "github.com/Finschia/ibc-go/v3/modules/core/ante"
	ibckeeper "github.com/Finschia/ibc-go/v3/modules/core/keeper"
	wasmkeeper "github.com/Finschia/wasmd/x/wasm/keeper"
	wasmtypes "github.com/Finschia/wasmd/x/wasm/types"
)

// HandlerOptions extend the SDK's AnteHandler options by requiring the IBC
// channel keeper.
type HandlerOptions struct {
	ante.HandlerOptions

	IBCkeeper  *ibckeeper.Keeper
	WasmConfig *wasmtypes.WasmConfig
}

func NewAnteHandler(opts HandlerOptions) (sdk.AnteHandler, error) {
	if opts.AccountKeeper == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrLogic, "account keeper is required for AnteHandler")
	}
	if opts.BankKeeper == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrLogic, "bank keeper is required for AnteHandler")
	}
	if opts.SignModeHandler == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrLogic, "sign mode handler is required for AnteHandler")
	}
	if opts.WasmConfig == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrLogic, "wasm config is required for ante builder")
	}

	sigGasConsumer := opts.SigGasConsumer
	if sigGasConsumer == nil {
		sigGasConsumer = ante.DefaultSigVerificationGasConsumer
	}

	anteDecorators := []sdk.AnteDecorator{
		ante.NewSetUpContextDecorator(),
		wasmkeeper.NewLimitSimulationGasDecorator(opts.WasmConfig.SimulationGasLimit), // after setup context to enforce limits early
		ante.NewRejectExtensionOptionsDecorator(),
		ante.NewMempoolFeeDecorator(),
		ante.NewValidateBasicDecorator(),
		ante.NewTxTimeoutHeightDecorator(),
		ante.NewValidateMemoDecorator(opts.AccountKeeper),
		ante.NewConsumeGasForTxSizeDecorator(opts.AccountKeeper),
		ante.NewDeductFeeDecorator(opts.AccountKeeper, opts.BankKeeper, opts.FeegrantKeeper),
		// SetPubKeyDecorator must be called before all signature verification decorators
		ante.NewSetPubKeyDecorator(opts.AccountKeeper),
		ante.NewValidateSigCountDecorator(opts.AccountKeeper),
		ante.NewSigGasConsumeDecorator(opts.AccountKeeper, sigGasConsumer),
		ante.NewSigVerificationDecorator(opts.AccountKeeper, opts.SignModeHandler),
		ante.NewIncrementSequenceDecorator(opts.AccountKeeper),
		ibcante.NewAnteDecorator(opts.IBCkeeper),
	}

	return sdk.ChainAnteDecorators(anteDecorators...), nil
}
