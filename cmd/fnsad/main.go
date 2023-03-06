package main

import (
	"os"

	"github.com/line/lbm-sdk/server"
	svrcmd "github.com/line/lbm-sdk/server/cmd"

	"github.com/line/finschia/app"
	"github.com/line/finschia/cmd/fnsad/cmd"
)

func main() {
	rootCmd, _ := cmd.NewRootCmd()

	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)

		default:
			os.Exit(1)
		}
	}
}
