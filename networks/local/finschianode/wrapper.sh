#!/usr/bin/env sh

##
## Input parameters
##
BINARY=/finschia/${BINARY:-fnsad}
ID=${ID:-0}
LOG=${LOG:-finschia.log}

##
## Assert linux binary
##
if ! [ -f "${BINARY}" ]; then
	echo "The binary $(basename "${BINARY}") cannot be found. Please add the binary to the shared folder. Please use the BINARY environment variable if the name of the binary is not 'fnsad' E.g.: -e BINARY=fnsad_my_test_version"
	exit 1
fi

##
## Run binary with all parameters
##
export FINSCHIAHOME="/data/node${ID}/finschia"

if [ -d "$(dirname "${FINSCHIAHOME}"/"${LOG}")" ]; then
  "${BINARY}" --home "${FINSCHIAHOME}" "$@" | tee "${FINSCHIAHOME}/${LOG}"
else
  "${BINARY}" --home "${FINSCHIAHOME}" "$@"
fi

