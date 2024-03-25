package params

// Default simulation operation weights for messages and gov proposals
const (
	DefaultWeightMsgStoreCode           int = 50
	DefaultWeightMsgInstantiateContract int = 100
	DefaultWeightMsgExecuteContract     int = 100
	DefaultWeightMsgUpdateAdmin         int = 25
	DefaultWeightMsgClearAdmin          int = 10
	DefaultWeightMsgMigrateContract     int = 50

	DefaultWeightStoreCodeProposal                   int = 5
	DefaultWeightInstantiateContractProposal         int = 5
	DefaultWeightUpdateAdminProposal                 int = 5
	DefaultWeightExecuteContractProposal             int = 5
	DefaultWeightClearAdminProposal                  int = 5
	DefaultWeightMigrateContractProposal             int = 5
	DefaultWeightSudoContractProposal                int = 5
	DefaultWeightPinCodesProposal                    int = 5
	DefaultWeightUnpinCodesProposal                  int = 5
	DefaultWeightUpdateInstantiateConfigProposal     int = 5
	DefaultWeightStoreAndInstantiateContractProposal int = 5
)
