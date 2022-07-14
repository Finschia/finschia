#!/usr/bin/env sh

##
## Input parameters
##
BINARY=/lbm/${BINARY:-lbm}
ID=${ID:-0}
LOG=${LOG:-lbm.log}

##
## Assert linux binary
##
if ! [ -f "${BINARY}" ]; then
	echo "The binary $(basename "${BINARY}") cannot be found. Please add the binary to the shared folder. Please use the BINARY environment variable if the name of the binary is not 'lbm' E.g.: -e BINARY=lbm_my_test_version"
	exit 1
fi

##
## Run binary with all parameters
##
export LBMHOME="/data/node${ID}/lbm"

if [ -d "$(dirname "${LBMHOME}"/"${LOG}")" ]; then
  "${BINARY}" --home "${LBMHOME}" "$@" | tee "${LBMHOME}/${LOG}"
else
  "${BINARY}" --home "${LBMHOME}" "$@"
fi

