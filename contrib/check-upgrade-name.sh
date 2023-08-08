#!/bin/sh

set -e

# get module version from go.mod
module_version=$(grep -E '^module github\.com/Finschia/finschia/v.*$' go.mod | cut -d / -f 4)
if [ -z "$module_version" ]
then
	echo module version not found: you must update the script >&2
	false
fi

# get upgrade version from the upgrade name
upgrade_name=$(sed -nE -e 's/^(const)?[[:blank:]]+upgradeName[[:blank:]]+=[[:blank:]]+"([[:digit:][:alpha:]-]+)"$/\2/p' app/app.go)
upgrade_version=$(printf $upgrade_name | cut -d - -f 1)
if [ -z "$upgrade_version" ]
then
	echo upgrade version not found: you must update the script >&2
	false
fi

if [ $upgrade_version != $module_version ]
then
	echo different upgrade version found: you must update the upgrade name >&2
	echo wanted: $module_version-Xxx, got: $upgrade_name
	false
fi
