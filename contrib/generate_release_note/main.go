//go:build exclude
// +build exclude

// This program is used to create a release note from build_report and RELEASE_NOTE.md. It is used to create release builds
// with release-build.yml in Github Actions.
//
// go run ./contrib/generate_release_note/main.go ${{ env.VERSION }} ./artifacts/build_report ./RELEASE_NOTE.md

package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	args := os.Args
	if len(args) != 4 {
		fmt.Println("please add os.Args release version, build_report path and RELEASE_NOTE.md path, example: go run main.go v7.0.0 ../../artifacts/build_report ../../RELEASE_NOTE.md")
		os.Exit(1)
	}

	buildReportPath := args[2]
	changelogPath := args[3]

	buildReport, err := os.ReadFile(buildReportPath)
	if err != nil {
		fmt.Printf("file error: %s\n", err)
	}

	changelog, err := os.ReadFile(changelogPath)
	if err != nil {
		fmt.Printf("cannot find release note: %s\n", err)
	}

	note := strings.Builder{}
	note.Write(changelog)
	note.WriteString("\n")
	note.WriteString("```\n")
	note.Write(buildReport)
	note.WriteString("```\n")

	f, err := os.Create("./releasenote")
	if err != nil {
		fmt.Printf("cannot create a release note: %s\n", err)
	}
	defer f.Close()

	_, err = f.WriteString(note.String())
	if err != nil {
		fmt.Printf("cannot write to releasenote: %s\n", err)
	}
}
