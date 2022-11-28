//go:build exclude
// +build exclude

// This program is used to create a release note from build_report and CHANGELOG.md. It is used to create release builds
// with release-build.yml in Github Actions.
//
// go run ./contrib/generate_release_note/main.go ${{ env.VERSION }} ./artifacts/build_report ./CHANGELOG.md

package main

import (
	"errors"
	"fmt"
	"os"
	"regexp"
	"strings"
)

func main() {
	args := os.Args
	if len(args) != 4 {
		fmt.Println("please add os.Args release version, build_report path and CHANGELOG.md path, example: go run main.go v7.0.0 ../../artifacts/build_report ../../CHANGELOG.md")
		os.Exit(1)
	}

	buildReportPath := args[2]
	changelogPath := args[3]

	buildReport, err := os.ReadFile(buildReportPath)
	if err != nil {
		fmt.Printf("file error: %s\n", err)
	}

	changelog, err := FindChangelog(changelogPath, args[1])
	if err != nil {
		fmt.Printf("cannot find changelog: %s\n", err)
	}

	note := strings.Builder{}
	note.WriteString(fmt.Sprintf("# LBM %s Release Notes\n", args[1]))
	note.WriteString(changelog)
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

// FindChangelog extracts the contents of the first `##` (level-2 section) described in the given markdown file. If the
// section title doesn't contain the `version` string, it's assumed not to be a description of the relevant version.
func FindChangelog(file, version string) (string, error) {
	data, err := os.ReadFile(file)
	if err != nil {
		return "", errors.New("read changelog file failed")
	}

	changelogs := string(data)
	reg := regexp.MustCompile(`(?ms).*?(^##[^#].*?)((^##[^#]).*|\z)`)
	result := reg.FindStringSubmatch(changelogs)
	if len(result) > 1 && strings.Contains(strings.Split(result[1], "\n")[0], version) {
		return result[1], nil
	}
	return fmt.Sprintf("## %s\n_(changes relating to %s aren't described in `CHANGELOG.md`)_\n<!-- See also: contrib/generate_release_note/main.go -->", version, version), nil
}
