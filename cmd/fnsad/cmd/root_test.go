package cmd

import (
	"os"
	"testing"

	"github.com/Finschia/ostracon/libs/log"
	"github.com/stretchr/testify/require"
	dbm "github.com/tendermint/tm-db"

	"github.com/Finschia/finschia-sdk/client/flags"
	"github.com/Finschia/finschia-sdk/server"
	"github.com/Finschia/finschia-sdk/store/types"
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
