package interchaintest_test

import (
	"context"
	"testing"

	interchaintest "github.com/strangelove-ventures/interchaintest/v7"
	"github.com/strangelove-ventures/interchaintest/v7/conformance"
	"github.com/strangelove-ventures/interchaintest/v7/ibc"
	"github.com/strangelove-ventures/interchaintest/v7/testreporter"
	"go.uber.org/zap/zaptest"
)

func TestConformance(t *testing.T) {
	// Arrange
	numOfValidators := 2
	numOfFullNodes := 0

	cf := interchaintest.NewBuiltinChainFactory(zaptest.NewLogger(t), []*interchaintest.ChainSpec{
		latestFinschiaChain(numOfValidators, numOfFullNodes),
		builtinCosmosChainV13(numOfValidators, numOfFullNodes),
	})

	rlyFactory := interchaintest.NewBuiltinRelayerFactory(
		ibc.CosmosRly,
		zaptest.NewLogger(t),
	)

	// Act & Assert
	conformance.Test(t, context.Background(), []interchaintest.ChainFactory{cf}, []interchaintest.RelayerFactory{rlyFactory}, testreporter.NewNopReporter())
}

func latestFinschiaChain(numOfValidators, numOfFullNodes int) *interchaintest.ChainSpec {
	return &interchaintest.ChainSpec{
		Version: "local",
		ChainConfig: ibc.ChainConfig{
			Type:    "cosmos",
			Name:    "finschia-2",
			ChainID: "finschia-2",
			Images: []ibc.DockerImage{
				{
					Repository: "finschia",
					Version:    "local",
					UidGid:     "1025:1025",
				},
			},
			Bin:            "fnsad",
			Bech32Prefix:   "link",
			Denom:          "cony",
			GasPrices:      "0.015cony",
			GasAdjustment:  1.3,
			TrustingPeriod: "336h",
		},
		NumValidators: &numOfValidators,
		NumFullNodes:  &numOfFullNodes,
	}
}

func builtinCosmosChainV13(numOfValidators, numOfFullNodes int) *interchaintest.ChainSpec {
	return &interchaintest.ChainSpec{
		Name:          "gaia",
		ChainName:     "cosmoshub-2",
		Version:       "v13.0.1",
		NumValidators: &numOfValidators,
		NumFullNodes:  &numOfFullNodes,
	}
}
