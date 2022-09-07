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

## [v0.5.0]

This version based on [lbm-sdk v0.46.0-rc6](https://github.com/line/lbm-sdk/releases/tag/v0.46.0-rc6)

### Features
* (x/collection) [\#72](https://github.com/line/lbm/pull/72) add x/collection
* (x/wasm) [\#79](https://github.com/line/lbm/pull/79) chore: add iterator feature for wasm module

### Improvements
* (ci) [\#76](https://github.com/line/lbm/pull/76) fix Dockerfile.static to build lbm instead of building wasmvm in the Dockerfile

### Bug Fixes
* (command) [\#81](https://github.com/line/lbm/pull/81) add wrong address to genesis file in add-genesis-account command
* (x/collection) [\#86](https://github.com/line/lbm/pull/86) add omitted cli commands on x/collection and fix Query/Balance
* (x/collection) [\#90](https://github.com/line/lbm/pull/90) fix bugs in x/collection MsgModify


## [v0.4.0]

This version based on lbm-sdk v0.46.0-rc2

### Features
* (cosmos-sdk) [\#56](https://github.com/line/lbm/pull/56) bump up cosmos-sdk v0.45.1
* (x/foundation) [\#62](https://github.com/line/lbm/pull/62) add `x/foundation` module of lbm-sdk

### Improvements

### Bug Fixes
* (app) [\#60](https://github.com/line/lbm/pull/60) register authz module store key


## [v0.3.0]

### Bug Fixes
* (build) [\#47](https://github.com/line/lbm/pull/47) fix Docker build error

### Features
* (x/wasm) [\#41](https://github.com/line/lbm/pull/41) upgrade x/wasm (merged original 0.19.0)
* (x/upgrade) [\#42](https://github.com/line/lbm/pull/42) add token module and bump cosmos-sdk v0.42.11


## [v0.2.0]

### Features
* (x/upgrade) [\#33](https://github.com/line/lbm/pull/33) To smoothen the update to the latest stable release, the SDK includes version map for managing migrations between SDK versions.
* (x/consortium) [\#34](https://github.com/line/lbm/pull/34) add feegrant, consortium and stakingplus module
* (x/bank) [\#36](https://github.com/line/lbm/pull/36) apply a feature that preventing sending coins to inactive contract (related to [lbm-sdk #400](https://github.com/line/lbm-sdk/pull/400))

### Improvements
* (slashing) [\#31] (https://github.com/line/lbm/pull/31) Apply VoterSetCounter

## [v0.1.0]

### Features
* (app) Revise bech32 prefix cosmos to link and tlink

### Improvements
* (sdk) Use fastcache for inter block cache and iavl cache
* (sdk) Enable signature verification cache
* (ostracon) Apply asynchronous receiving reactor
* (sdk) [\#21](https://github.com/line/lbm/pull/21) Use lbm-sdk v0.43.0

### Bug Fixes

### Breaking Changes
* (sdk) (auth) [\#16](https://github.com/line/lfb/pull/16) Introduce sig block height for the new replay protection
* (ostracon/sdk) [\#26](https://github.com/line/lfb/pull/26) Use vrf-based consensus, address string treatment
* (global) [\#10](https://github.com/line/lbm/pull/10) Re-brand lfb to lbm

### Build, CI
* (build) [\#25](https://github.com/line/lbm/pull/25) Fix localnet-start

## [gaia v4.0.4] - 2021-03-15
Initial lbm is based on the tendermint v0.34.9+, cosmos-sdk v0.42.0+, gaia v4.0.4

* (tendermint) [v0.34.9](https://github.com/tendermint/tendermint/releases/tag/v0.34.9).
* (cosmos-sdk) [v0.42.0](https://github.com/cosmos/cosmos-sdk/releases/tag/v0.42.0).
* (gaia) [v4.0.4](https://github.com/cosmos/gaia/releases/tag/v4.0.4).

Please refer [CHANGELOG_OF_GAIA_v4.0.4](https://github.com/cosmos/gaia/blob/v4.0.4/CHANGELOG.md)


<!-- Release links -->
[v0.5.0]: https://github.com/line/lbm/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/line/lbm/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/line/lbm/compare/v0.2.0-rc0...v0.3.0
[v0.2.0]: https://github.com/line/lbm/compare/v0.1.0-rc0...v0.2.0-rc0
[v0.1.0]: https://github.com/line/lbm/commits/v0.1.0
[gaia v4.0.4]: https://github.com/cosmos/gaia/releases/tag/v4.0.4