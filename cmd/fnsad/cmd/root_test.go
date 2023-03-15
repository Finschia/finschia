package cmd

import (
	"os"
	"testing"

	"github.com/line/lbm-sdk/client/flags"
	"github.com/line/lbm-sdk/server"
	"github.com/line/lbm-sdk/store/types"
	"github.com/line/ostracon/libs/log"
	"github.com/stretchr/testify/require"
	dbm "github.com/tendermint/tm-db"
)

func TestNewApp(t *testing.T) {
	db := dbm.NewMemDB()
	tempDir := t.TempDir()
	ctx := server.NewDefaultContext()
	ctx.Viper.Set(flags.FlagHome, tempDir)
	ctx.Viper.Set(server.FlagPruning, types.PruningOptionNothing)
	app := newApp(log.NewOCLogger(log.NewSyncWriter(os.Stdout)), db, nil, ctx.Viper)
	require.NotNil(t, app)
}
