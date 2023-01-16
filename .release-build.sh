#!/bin/bash

# NOTE: This script is used by lbm/build-artifact Docker container to build release binaries for the platforms listed
# in TARGET_PLATFORMS. If you want to build locally, please run `make distclean build-reproducible` instead of using
# this directly.

set -ue

# Expect the following envvars to be set:
# - APP
# - VERSION
# - COMMIT
# - TARGET_PLATFORMS
# - LEDGER_ENABLED
# - DEBUG

BASEDIR="$(mktemp -d)"
BASENAME="${APP}-${VERSION}"

OUTDIR="${HOME}/artifacts"
rm -rfv ${OUTDIR}/
mkdir -p ${OUTDIR}/

FILE_EXT=""
if [ $(go env GOOS) = windows ]
then
  FILE_EXT=".exe"
fi

# Prepare a taball for release.
TARBALL="${BASEDIR}/${BASENAME}.tgz"
git archive --format=tar --prefix "${BASENAME}/" HEAD | gzip -9n > "${TARBALL}"

# Setup a directory to build from the taball.
BUILDDIR="${BASEDIR}/build"
mkdir -p ${BUILDDIR}
cd ${BUILDDIR}
tar zxf "${TARBALL}" --strip-components=1
go mod download

# Add the tarball to artifacts
mv "${TARBALL}" "${OUTDIR}"

setup_env(){
  local PLATFORM="$1"
  _GOOS="$(go env GOOS)"
  _GOARCH="$(go env GOARCH)"
  # slash-separated identifiers such as linux/amd64
  go env -w GOOS="${PLATFORM%%/*}"
  go env -w GOARCH="${PLATFORM##*/}"

  if [[ -v CC ]]; then _CC="${CC}"; fi
  if [[ -v CXX ]]; then _CXX="${CXX}"; fi
  case "${PLATFORM}" in
  "linux/amd64")
    export CC=x86_64-linux-gnu-gcc
    export CXX=x86_64-linux-gnu-g++
    echo "Using Linux AMD64 (x86_64) cross-compiler: ${CC}"
    ;;
  "linux/arm64")
    export CC=aarch64-linux-gnu-gcc
    export CXX=aarch64-linux-gnu-g++
    echo "Using Linux ARM64 cross-compiler: ${CC}"
    ;;
  *)
    echo "WARN: Unknown platform \"${PLATFORM}\", using platform default compiler: ${CC:-unknown}"
  esac
}

restore_env() {
  go env -w GOOS="${_GOOS}"
  go env -w GOARCH="${_GOARCH}"
  unset _GOOS
  unset _GOARCH
  if [[ -v _CC ]]; then export CC="${_CC}"; unset _CC; fi
  if [[ -v _CXX ]]; then export CXX="${_CXX}"; unset _CXX; fi
}

# Build for each os-architecture pair
for platform in ${TARGET_PLATFORMS} ; do
    # This function sets GOOS, GOARCH, and FILE_EXT environment variables
    # according to the build target platform. FILE_EXT is empty in all
    # cases except when the target platform is 'windows'.
    setup_env "${platform}"

    make clean
    echo Building for $(go env GOOS)/$(go env GOARCH) >&2
    GOROOT_FINAL="$(go env GOROOT)" \
    make build \
        LDFLAGS=-buildid=${VERSION} \
        VERSION=${VERSION} \
        COMMIT=${COMMIT} \
        LEDGER_ENABLED=${LEDGER_ENABLED} \
        CC=${CC} CXX=${CXX}
    mv ./build/${APP}${FILE_EXT} ${OUTDIR}/${BASENAME}-$(go env GOOS)-$(go env GOARCH)${FILE_EXT}

    # This function restore the build environment variables to their
    # original state.
    restore_env
done

# Generate and display build report.
REPORT_FILE="$(mktemp)"
pushd "${OUTDIR}"
cat > "${REPORT_FILE}" <<EOF
App: ${APP}
Version: ${VERSION}
Commit: ${COMMIT}
EOF
echo "Files:" >> "${REPORT_FILE}"
md5sum * | sed 's/^/ /' >> "${REPORT_FILE}"
echo 'Checksums-Sha256:' >> "${REPORT_FILE}"
sha256sum * | sed 's/^/ /' >> "${REPORT_FILE}"
popd
mv "${REPORT_FILE}" "${OUTDIR}/build_report"
cat "${OUTDIR}/build_report"
