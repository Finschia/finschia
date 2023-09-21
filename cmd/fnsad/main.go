package main

import (
	"os"

	"github.com/Finschia/finschia-rdk/server"
	svrcmd "github.com/Finschia/finschia-rdk/server/cmd"

	"github.com/Finschia/finschia/app"
	"github.com/Finschia/finschia/cmd/fnsad/cmd"
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
