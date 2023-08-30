package app

import (
	"encoding/json"
	"os"
	"testing"

	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/require"

	"github.com/Finschia/ostracon/libs/log"
	abci "github.com/tendermint/tendermint/abci/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"
	dbm "github.com/tendermint/tm-db"

	"github.com/Finschia/finschia-sdk/baseapp"
	"github.com/Finschia/finschia-sdk/simapp"
	"github.com/Finschia/finschia-sdk/tests/mocks"
	sdk "github.com/Finschia/finschia-sdk/types"
	"github.com/Finschia/finschia-sdk/types/module"
	"github.com/Finschia/finschia-sdk/x/auth"
	"github.com/Finschia/finschia-sdk/x/auth/vesting"
	authz_m "github.com/Finschia/finschia-sdk/x/authz/module"
	"github.com/Finschia/finschia-sdk/x/bank"
	banktypes "github.com/Finschia/finschia-sdk/x/bank/types"
	"github.com/Finschia/finschia-sdk/x/capability"
	collectionmodule "github.com/Finschia/finschia-sdk/x/collection/module"
	"github.com/Finschia/finschia-sdk/x/crisis"
	"github.com/Finschia/finschia-sdk/x/distribution"
	"github.com/Finschia/finschia-sdk/x/evidence"
	feegrantmodule "github.com/Finschia/finschia-sdk/x/feegrant/module"
	foundationmodule "github.com/Finschia/finschia-sdk/x/foundation/module"
	"github.com/Finschia/finschia-sdk/x/genutil"
	"github.com/Finschia/finschia-sdk/x/gov"
	"github.com/Finschia/wasmd/x/wasmplus"

	"github.com/Finschia/finschia-sdk/x/mint"
	"github.com/Finschia/finschia-sdk/x/params"
	"github.com/Finschia/finschia-sdk/x/slashing"
	"github.com/Finschia/finschia-sdk/x/staking"
	tokenmodule "github.com/Finschia/finschia-sdk/x/token/module"
	"github.com/Finschia/finschia-sdk/x/upgrade"
	"github.com/cosmos/ibc-go/v4/modules/apps/transfer"
	ibc "github.com/cosmos/ibc-go/v4/modules/core"
)

func TestSimAppExportAndBlockedAddrs(t *testing.T) {
	encCfg := MakeEncodingConfig()
	db := dbm.NewMemDB()
	app := NewLinkApp(log.NewOCLogger(log.NewSyncWriter(os.Stdout)), db, nil, true, map[int64]bool{}, DefaultNodeHome, 0, encCfg, simapp.EmptyAppOptions{}, nil)

	for acc := range maccPerms {
		require.Equal(t, !allowedReceivingModAcc[acc], app.BankKeeper.BlockedAddr(app.AccountKeeper.GetModuleAddress(acc)),
			"ensure that blocked addresses are properly set in bank keeper")
	}

	genesisState := NewDefaultGenesisState(encCfg.Marshaler)
	stateBytes, err := json.MarshalIndent(genesisState, "", "  ")
	require.NoError(t, err)

	// Initialize the chain
	app.InitChain(
		abci.RequestInitChain{
			Validators:    []abci.ValidatorUpdate{},
			AppStateBytes: stateBytes,
		},
	)
	app.Commit()

	// Making a new app object with the db, so that initchain hasn't been called
	app2 := NewLinkApp(log.NewOCLogger(log.NewSyncWriter(os.Stdout)), db, nil, true, map[int64]bool{}, DefaultNodeHome, 0, encCfg, simapp.EmptyAppOptions{}, nil)
	_, err = app2.ExportAppStateAndValidators(false, []string{})
	require.NoError(t, err, "ExportAppStateAndValidators should not have an error")
}

func TestGetMaccPerms(t *testing.T) {
	dup := GetMaccPerms()
	require.Equal(t, maccPerms, dup, "duplicated module account permissions differed from actual module account permissions")
}

func TestRunMigrations(t *testing.T) {
	db := dbm.NewMemDB()
	encCfg := MakeEncodingConfig()
	logger := log.NewOCLogger(log.NewSyncWriter(os.Stdout))
	app := NewLinkApp(logger, db, nil, true, map[int64]bool{}, DefaultNodeHome, 0, encCfg, simapp.EmptyAppOptions{}, nil)

	// Create a new baseapp and configurator for the purpose of this test.
	bApp := baseapp.NewBaseApp(appName, logger, db, encCfg.TxConfig.TxDecoder())
	bApp.SetCommitMultiStoreTracer(nil)
	bApp.SetInterfaceRegistry(encCfg.InterfaceRegistry)
	app.BaseApp = bApp
	app.configurator = module.NewConfigurator(app.appCodec, app.MsgServiceRouter(), app.GRPCQueryRouter())

	// We register all modules on the Configurator, except x/bank. x/bank will
	// serve as the test subject on which we run the migration tests.
	//
	// The loop below is the same as calling `RegisterServices` on
	// ModuleManager, except that we skip x/bank.
	for _, module := range app.mm.Modules {
		if module.Name() == banktypes.ModuleName {
			continue
		}

		module.RegisterServices(app.configurator)
	}

	// Initialize the chain
	app.InitChain(abci.RequestInitChain{})
	app.Commit()

	testCases := []struct {
		name         string
		moduleName   string
		expRegErrMsg string
		expRunErrMsg string
		forVersion   uint64
		expCalled    int
		expRegErr    bool // errors while registering migration
		expRunErr    bool // errors while running migration
	}{
		{
			"cannot register migration for version 0",
			"bank", "module migration versions should start at 1: invalid version", "",
			0, 0,
			true, false,
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			var err error

			// Since it's very hard to test actual in-place store migrations in
			// tests (due to the difficulty of maintaining multiple versions of a
			// module), we're just testing here that the migration logic is
			// called.
			called := 0

			if tc.moduleName != "" {
				// Register migration for module from version `forVersion` to `forVersion+1`.
				err = app.configurator.RegisterMigration(tc.moduleName, tc.forVersion, func(sdk.Context) error {
					called++

					return nil
				})

				if tc.expRegErr {
					require.EqualError(t, err, tc.expRegErrMsg)

					return
				}
			}
			require.NoError(t, err)

			// Run migrations only for bank. That's why we put the initial
			// version for bank as 1, and for all other modules, we put as
			// their latest ConsensusVersion.
			_, err = app.mm.RunMigrations(
				app.NewContext(true, tmproto.Header{Height: app.LastBlockHeight()}), app.configurator,
				module.VersionMap{
					"bank":         1,
					"auth":         auth.AppModule{}.ConsensusVersion(),
					"authz":        authz_m.AppModule{}.ConsensusVersion(),
					"staking":      staking.AppModule{}.ConsensusVersion(),
					"mint":         mint.AppModule{}.ConsensusVersion(),
					"distribution": distribution.AppModule{}.ConsensusVersion(),
					"slashing":     slashing.AppModule{}.ConsensusVersion(),
					"gov":          gov.AppModule{}.ConsensusVersion(),
					"params":       params.AppModule{}.ConsensusVersion(),
					"ibc":          ibc.AppModule{}.ConsensusVersion(),
					"upgrade":      upgrade.AppModule{}.ConsensusVersion(),
					"vesting":      vesting.AppModule{}.ConsensusVersion(),
					"feegrant":     feegrantmodule.AppModule{}.ConsensusVersion(),
					"transfer":     transfer.AppModule{}.ConsensusVersion(),
					"evidence":     evidence.AppModule{}.ConsensusVersion(),
					"crisis":       crisis.AppModule{}.ConsensusVersion(),
					"genutil":      genutil.AppModule{}.ConsensusVersion(),
					"capability":   capability.AppModule{}.ConsensusVersion(),
					"foundation":   foundationmodule.AppModule{}.ConsensusVersion(),
					"token":        tokenmodule.AppModule{}.ConsensusVersion(),
					"collection":   collectionmodule.AppModule{}.ConsensusVersion(),
					"wasm":         wasmplus.AppModule{}.ConsensusVersion(),
				},
			)
			if tc.expRunErr {
				require.EqualError(t, err, tc.expRunErrMsg)
			} else {
				require.NoError(t, err)
				// Make sure bank's migration is called.
				require.Equal(t, tc.expCalled, called)
			}
		})
	}
}

func TestInitGenesisOnMigration(t *testing.T) {
	db := dbm.NewMemDB()
	encCfg := MakeEncodingConfig()
	logger := log.NewOCLogger(log.NewSyncWriter(os.Stdout))
	app := NewLinkApp(logger, db, nil, true, map[int64]bool{}, DefaultNodeHome, 0, encCfg, simapp.EmptyAppOptions{}, nil)
	ctx := app.NewContext(true, tmproto.Header{Height: app.LastBlockHeight()})

	// Create a mock module. This module will serve as the new module we're
	// adding during a migration.
	mockCtrl := gomock.NewController(t)
	t.Cleanup(mockCtrl.Finish)
	mockModule := mocks.NewMockAppModule(mockCtrl)
	mockDefaultGenesis := json.RawMessage(`{"key": "value"}`)
	mockModule.EXPECT().DefaultGenesis(gomock.Eq(app.appCodec)).Times(1).Return(mockDefaultGenesis)
	mockModule.EXPECT().InitGenesis(gomock.Eq(ctx), gomock.Eq(app.appCodec), gomock.Eq(mockDefaultGenesis)).Times(1).Return(nil)
	mockModule.EXPECT().ConsensusVersion().Times(1).Return(uint64(0))

	app.mm.Modules["mock"] = mockModule

	// Run migrations only for "mock" module. We exclude it from
	// the VersionMap to simulate upgrading with a new module.
	_, err := app.mm.RunMigrations(ctx, app.configurator,
		module.VersionMap{
			"bank":         bank.AppModule{}.ConsensusVersion(),
			"auth":         auth.AppModule{}.ConsensusVersion(),
			"authz":        authz_m.AppModule{}.ConsensusVersion(),
			"staking":      staking.AppModule{}.ConsensusVersion(),
			"mint":         mint.AppModule{}.ConsensusVersion(),
			"distribution": distribution.AppModule{}.ConsensusVersion(),
			"slashing":     slashing.AppModule{}.ConsensusVersion(),
			"gov":          gov.AppModule{}.ConsensusVersion(),
			"params":       params.AppModule{}.ConsensusVersion(),
			"ibc":          ibc.AppModule{}.ConsensusVersion(),
			"upgrade":      upgrade.AppModule{}.ConsensusVersion(),
			"vesting":      vesting.AppModule{}.ConsensusVersion(),
			"transfer":     transfer.AppModule{}.ConsensusVersion(),
			"evidence":     evidence.AppModule{}.ConsensusVersion(),
			"crisis":       crisis.AppModule{}.ConsensusVersion(),
			"genutil":      genutil.AppModule{}.ConsensusVersion(),
			"capability":   capability.AppModule{}.ConsensusVersion(),
			"foundation":   foundationmodule.AppModule{}.ConsensusVersion(),
			"token":        tokenmodule.AppModule{}.ConsensusVersion(),
			"collection":   collectionmodule.AppModule{}.ConsensusVersion(),
		},
	)

	require.NoError(t, err)
}

func TestUpgradeStateOnGenesis(t *testing.T) {
	encCfg := MakeEncodingConfig()
	db := dbm.NewMemDB()
	app := NewLinkApp(log.NewOCLogger(log.NewSyncWriter(os.Stdout)), db, nil, true, map[int64]bool{}, DefaultNodeHome, 0, encCfg, simapp.EmptyAppOptions{}, nil)
	genesisState := NewDefaultGenesisState(encCfg.Marshaler)
	stateBytes, err := json.MarshalIndent(genesisState, "", "  ")
	require.NoError(t, err)

	// Initialize the chain
	app.InitChain(
		abci.RequestInitChain{
			Validators:    []abci.ValidatorUpdate{},
			AppStateBytes: stateBytes,
		},
	)

	// make sure the upgrade keeper has version map in state
	ctx := app.NewContext(false, tmproto.Header{})
	vm := app.UpgradeKeeper.GetModuleVersionMap(ctx)
	for v, i := range app.mm.Modules {
		require.Equal(t, vm[v], i.ConsensusVersion())
	}
}
