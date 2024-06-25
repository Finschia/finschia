package main

import (
	"errors"
	"os"

	"github.com/Finschia/finschia-sdk/server"
	svrcmd "github.com/Finschia/finschia-sdk/server/cmd"

	"github.com/Finschia/finschia/v4/app"
	"github.com/Finschia/finschia/v4/cmd/fnsad/cmd"
)

func main() {
	rootCmd, _ := cmd.NewRootCmd()

	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		var e server.ErrorCode
		switch {
		case errors.As(err, &e):
			os.Exit(e.Code)
		default:
			os.Exit(1)
		}
	}
}
