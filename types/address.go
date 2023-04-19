package types

import (
	sdk "github.com/Finschia/finschia-sdk/types"
)

const (
	Bech32MainPrefix    = "link"
	Bech32TestnetPrefix = "tlink"

	// CoinType is the LINK coin type as defined in [SLIP-044](https://github.com/satoshilabs/slips/blob/master/slip-0044.md)
	CoinType = 438
)

func Bech32PrefixAcc(testnet bool) (prefix string) {
	prefix = Bech32MainPrefix
	if testnet {
		prefix = Bech32TestnetPrefix
	}
	return
}

func Bech32PrefixAccPub(testnet bool) string {
	return Bech32PrefixAcc(testnet) + sdk.PrefixPublic
}

func Bech32PrefixValAddr(testnet bool) string {
	return Bech32PrefixAcc(testnet) + sdk.PrefixValidator + sdk.PrefixOperator
}

func Bech32PrefixValPub(testnet bool) string {
	return Bech32PrefixAcc(testnet) + sdk.PrefixValidator + sdk.PrefixOperator + sdk.PrefixPublic
}

func Bech32PrefixConsAddr(testnet bool) string {
	return Bech32PrefixAcc(testnet) + sdk.PrefixValidator + sdk.PrefixConsensus
}

func Bech32PrefixConsPub(testnet bool) string {
	return Bech32PrefixAcc(testnet) + sdk.PrefixValidator + sdk.PrefixConsensus + sdk.PrefixPublic
}
