package clitest

import (
	"errors"
	"fmt"
	"testing"
	"time"

	sdk "github.com/line/lbm-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestLBMQueryTxPagination(t *testing.T) {
	t.Parallel()
	f := InitFixtures(t)
	defer f.Cleanup()

	// start lbm server
	n := f.LBMStart(minGasPrice.String())
	defer n.Cleanup()

	fooAddr := f.KeyAddress(keyFoo)
	barAddr := f.KeyAddress(keyBar)

	accFoo := f.QueryAccount(fooAddr)
	seq := accFoo.GetSequence()

	for i := 1; i <= 4; i++ {
		_, err := f.TxSend(keyFoo, barAddr, sdk.NewInt64Coin(fooDenom, int64(i)), fmt.Sprintf("--sequence=%d", seq), "-y")
		require.NoError(t, err)
		seq++
	}
	time.Sleep(time.Second * 1)

	// perPage = 15, 2 pages
	txsPage1 := f.QueryTxs(1, 2, fmt.Sprintf("--events='message.sender=%s'", fooAddr))
	require.Len(t, txsPage1.Txs, 2)
	require.Equal(t, txsPage1.Count, uint64(2))
	txsPage2 := f.QueryTxs(2, 2, fmt.Sprintf("--events='message.sender=%s'", fooAddr))
	require.Len(t, txsPage2.Txs, 2)
	require.NotEqual(t, txsPage1.Txs, txsPage2.Txs)

	// perPage = 16, 2 pages
	txsPage1 = f.QueryTxs(1, 3, fmt.Sprintf("--events='message.sender=%s'", fooAddr))
	require.Len(t, txsPage1.Txs, 3)
	txsPage2 = f.QueryTxs(2, 3, fmt.Sprintf("--events='message.sender=%s'", fooAddr))
	require.Len(t, txsPage2.Txs, 1)
	require.NotEqual(t, txsPage1.Txs, txsPage2.Txs)

	// perPage = 50
	txsPageFull := f.QueryTxs(1, 50, fmt.Sprintf("--events='message.sender=%s'", fooAddr))
	require.Len(t, txsPageFull.Txs, 4)
	require.Equal(t, txsPageFull.Txs, append(txsPage1.Txs, txsPage2.Txs...))

	// perPage = 0
	f.QueryTxsInvalid(errors.New("page must greater than 0"), 0, 50, fmt.Sprintf("--events='message.sender=%s'", fooAddr))

	// limit = 0
	f.QueryTxsInvalid(errors.New("limit must greater than 0"), 1, 0, fmt.Sprintf("--events='message.sender=%s'", fooAddr))

	// no events
	f.QueryTxsInvalid(errors.New("required flag(s) \"events\" not set"), 1, 30)
}
