package helpers

import (
	"encoding/json"
	"testing"
	"time"

	abci "github.com/line/ostracon/abci/types"
	"github.com/line/ostracon/libs/log"
	ocproto "github.com/line/ostracon/proto/ostracon/types"
	octypes "github.com/line/ostracon/types"
	"github.com/stretchr/testify/require"
	dbm "github.com/tendermint/tm-db"

	linkapp "github.com/line/lbm/app"
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
	Evidence: &ocproto.EvidenceParams{
		MaxAgeNumBlocks: 302400,
		MaxAgeDuration:  504 * time.Hour, // 3 weeks is the max duration
		MaxBytes:        10000,
	},
	Validator: &ocproto.ValidatorParams{
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
