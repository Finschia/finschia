<!--
Guiding Principles:

Changelogs are for humans, not machines.
There should be an entry for every single version.
The same types of changes should be grouped.
Versions and sections should be linkable.
The latest version comes first.
The release date of each version is displayed.
Mention whether you follow Semantic Versioning.

Usage:

Change log entries are to be added to the Unreleased section under the
appropriate stanza (see below). Each entry should ideally include a tag and
the Github issue reference in the following format:

* (<tag>) \#<issue-number> message

The issue numbers will later be link-ified during the release process so you do
not have to worry about including a link manually, but you can if you wish.

Types of changes (Stanzas):

"Features" for new features.
"Improvements" for changes in existing functionality.
"Deprecated" for soon-to-be removed features.
"Bug Fixes" for any bug fixes.
"Client Breaking" for breaking CLI commands and REST routes.
"State Machine Breaking" for breaking the AppState

Ref: https://keepachangelog.com/en/1.0.0/
-->

# Changelog

## [Unreleased]

### Features
* (feat) [\#243](https://github.com/Finschia/finschia/pull/243) Bump github.com/Finschia/finschia-sdk from v0.47.0 to v0.47.1-rc1
* (ibc) [\#246](https://github.com/Finschia/finschia/pull/246) Update ibc-go to v4
* (build) [\#248](https://github.com/Finschia/finschia/pull/248) Rename namespace to v2
* (app) [\#250](https://github.com/Finschia/finschia/pull/250) Set upgrade handler for v2-Daisy
* (feat) [\#255](https://github.com/Finschia/finschia/pull/255) Bump up finschia-sdk from v0.48.0-rc1 to da331c01fa
* (feat) [\#262](https://github.com/Finschia/finschia/pull/262) Bump up finschia-sdk from v0.48.0-rc2 to `0a27aef22921` and bump up ostracon from `449aa3148b12` to `fc29846c918d`

### Improvements
* (build) [\#221](https://github.com/Finschia/finschia/pull/221) compile static binary as release assets and docker image
* (swagger) [\#223](https://github.com/Finschia/finschia/pull/223) add integrated swagger for finschia
* (wasm) [\#258](https://github.com/Finschia/finschia/pull/258) Bump up wasmd from dedcd9ec to 053c7e43

### Bug Fixes
* (build) [\#236](https://github.com/Finschia/finschia/pull/236) fix compile error when the build_tags is multiple.
* (wasm) [\#249](https://github.com/Finschia/finschia/pull/249) revert removing wasm configs
* (finschia-sdk) [\#264](https://github.com/Finschia/finschia/pull/264) Bump up finschia-sdk from `0a27aef22921` to `022614f80a0d`

### Breaking Changes
* (ostracon) [\#240](https://github.com/Finschia/finschia/pull/240) remove `libsodium` vrf library

### Build, CI
* (ci) [\#185](https://github.com/Finschia/finschia/pull/185) update `tag.yml` github action
* (ci) [\#189](https://github.com/Finschia/finschia/pull/189) add dependabot github action
* (ci) [\#213](https://github.com/Finschia/finschia/pull/213) add mergify ci
* (ci) [\#233](https://github.com/Finschia/finschia/pull/233) add smart contract CI test
* (build) [\#237](https://github.com/Finschia/finschia/pull/237) rearrange Dockerfile and Makefile commands
* (build) [\#241](https://github.com/Finschia/finschia/pull/241) Update golang version to 1.20
* (build) [\#259](https://github.com/Finschia/finschia/pull/259) change default build to be compiled as static binary

### Docs

<!-- Release links -->
[Unreleased]: https://github.com/Finschia/finschia/compare/v1.0.0...HEAD
