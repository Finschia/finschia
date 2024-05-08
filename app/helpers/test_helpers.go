package helpers

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	abci "github.com/tendermint/tendermint/abci/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"
	dbm "github.com/tendermint/tm-db"

	"github.com/Finschia/ostracon/libs/log"
	octypes "github.com/Finschia/ostracon/types"

	linkapp "github.com/Finschia/finschia/v4/app"
)

// SimAppChainID hardcoded chainID for simulation
const (
	SimAppChainID = "link-app"
)

// DefaultConsensusParams defines the default Tendermint consensus params used
// in linkapp testing.
var DefaultConsensusParams = &abci.ConsensusParams{
	Block: &abci.BlockParams{
		MaxBytes: 200000,
		MaxGas:   2000000,
	},
	Evidence: &tmproto.EvidenceParams{
		MaxAgeNumBlocks: 302400,
		MaxAgeDuration:  504 * time.Hour, // 3 weeks is the max duration
		MaxBytes:        10000,
	},
	Validator: &tmproto.ValidatorParams{
		PubKeyTypes: []string{
			octypes.ABCIPubKeyTypeEd25519,
		},
	},
}

type EmptyAppOptions struct{}

func (EmptyAppOptions) Get(o string) interface{} { return nil }

func Setup(t *testing.T, isCheckTx bool, invCheckPeriod uint) *linkapp.LinkApp {
	t.Helper()

	app, genesisState := setup(!isCheckTx, invCheckPeriod)
	if !isCheckTx {
		// InitChain must be called to stop deliverState from being nil
		stateBytes, err := json.MarshalIndent(genesisState, "", " ")
		require.NoError(t, err)

		// Initialize the chain
		app.InitChain(
			abci.RequestInitChain{
				Validators:      []abci.ValidatorUpdate{},
				ConsensusParams: DefaultConsensusParams,
				AppStateBytes:   stateBytes,
			},
		)
	}

	return app
}

func setup(withGenesis bool, invCheckPeriod uint) (*linkapp.LinkApp, linkapp.GenesisState) {
	db := dbm.NewMemDB()
	encCdc := linkapp.MakeEncodingConfig()
	app := linkapp.NewLinkApp(
		log.NewNopLogger(),
		db,
		nil,
		true,
		map[int64]bool{},
		linkapp.DefaultNodeHome,
		invCheckPeriod,
		encCdc,
		EmptyAppOptions{},
		nil,
	)
	if withGenesis {
		return app, linkapp.NewDefaultGenesisState(encCdc.Marshaler)
	}

	return app, linkapp.GenesisState{}
}
