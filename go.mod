module github.com/line/lbm

go 1.15

require (
	github.com/gorilla/mux v1.8.0
	github.com/line/lbm-sdk v0.46.0-rc6.0.20220823042107-45ac9cc04e03
	github.com/line/ostracon v1.0.7-0.20220902083123-8bacec680916
	github.com/prometheus/client_golang v1.12.2
	github.com/rakyll/statik v0.1.7
	github.com/spf13/cast v1.5.0
	github.com/spf13/cobra v1.5.0
	github.com/spf13/viper v1.12.0
	github.com/stretchr/testify v1.8.0
	github.com/tendermint/tm-db v0.6.7
)

replace (
	github.com/gogo/protobuf => github.com/regen-network/protobuf v1.3.3-alpha.regen.1
	github.com/line/lbm-sdk => github.com/zemyblue/lbm-sdk v1.0.0-init.1.0.20220918125551-c0d7193d6a51
	github.com/line/ostracon => github.com/zemyblue/ostracon v1.0.5-0.20220906115006-7fde9eabbdbb
	google.golang.org/grpc => google.golang.org/grpc v1.33.2
)
