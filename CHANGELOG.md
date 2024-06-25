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
* (fswap, fbridge) [\#354](https://github.com/Finschia/finschia/pull/354) Bump finschia-sdk v0.48.1 to v0.49.0-rc1
* (fbridge) [\#355](https://github.com/Finschia/finschia/pull/355) Bump finschia-sdk v0.49.0-rc1 to v0.49.0-rc2
* (build) [\#357](https://github.com/Finschia/finschia/pull/357) Upgrade to v4
* (fswap, fbridge) [\#359](https://github.com/Finschia/finschia/pull/359) Bump finschia-sdk v0.49.0-rc2 to v0.49.0-rc3
* (fswap, fbridge) [\#365](https://github.com/Finschia/finschia/pull/365) Load fbridge & fswap stores
* (fswap) [\#366](https://github.com/Finschia/finschia/pull/366) Bump github.com/Finschia/finschia-sdk from v0.49.0-rc3 to v0.49.0-rc4
* (fswap, fbridge) [\#373](https://github.com/Finschia/finschia/pull/373) Bump github.com/Finschia/finschia-sdk from v0.49.0-rc4 to v0.49.0-rc5
* (fswap) [\#378](https://github.com/Finschia/finschia/pull/378) Bump github.com/Finschia/finschia-sdk from v0.49.0-rc5 to v0.49.0-rc6
* (fswap, fbridge) [\#380](https://github.com/Finschia/finschia/pull/380) Bump github.com/Finschia/finschia-sdk from v0.49.0-rc6 to v0.49.0-rc7

### Improvements
* (ci) [\#385](https://github.com/Finschia/finschia/pull/385) Force user to follow the rule of release note generation

### Bug Fixes

### Breaking Changes
* (app) [\#352](https://github.com/Finschia/finschia/pull/352) Add filtering function in StargateMsg of wasm

### Build, CI
* (build) [\#340](https://github.com/Finschia/finschia/pull/340) Set Finschia/ostracon version
* (ci) [\#361](https://github.com/Finschia/finschia/pull/361) Replace deprecated linters with new ones
* (ci) [\#362](https://github.com/Finschia/finschia/pull/362) Add RELEASE_NOTE.md to .gitignore
* (swagger) [\#371](https://github.com/Finschia/finschia/pull/371) Add fswap and fbridge swagger settings in swagger config
* (build) [\#388](https://github.com/Finschia/finschia/pull/388) Modify the way the binary version is set when compiling
* (build) [\#395](https://github.com/Finschia/finschia/pull/395) Apply Go 1.22, finschia-sdk 0.49.1 and update outdated dependencies

### Docs

## [v3.0.0] - 2024-03-04

### Features
* (build) [\#329](https://github.com/Finschia/finschia/pull/329) rename namespace to v3

### Improvements
* (improvements) [\#230](https://github.com/Finschia/finschia/pull/230) fix Makefile for format and execute make format #230
* (chore) [\#299](https://github.com/Finschia/finschia/pull/299) remove x/token and x/collection apis in swagger

### Bug Fixes
* (finschia-sdk) [\#297](https://github.com/Finschia/finschia/pull/297) bump up finschia-sdk from v0.48.0 to v0.48.1
* (ostracon) [\#333](https://github.com/Finschia/finschia/pull/333) bump up ostracon from v1.1.2 to v1.1.3

### Breaking Changes
* (wasmd) [\#328](https://github.com/Finschia/finschia/pull/328) bump up wasmd from v0.2.0 to v0.3.0

### Build, CI
* (ci) [\#290](https://github.com/Finschia/finschia/pull/290) remove autopr ci
* (ci) [\#291](https://github.com/Finschia/finschia/pull/291) fix goreleaser ci error and replace release-build
* (repo) [\#295](https://github.com/Finschia/finschia/pull/295) setup CODEOWNERS and backport action
* (ci) [\#296](https://github.com/Finschia/finschia/pull/296) bump actions/checkout from 3 to 4
* (ci) [\#305](https://github.com/Finschia/finschia/pull/305) add e2e-ibc ci
* (build) [\#316](https://github.com/Finschia/finschia/pull/316) change docker image version to fix build error

## [v2.0.0] - 2023-10-19

### Features
* (finschia-sdk) Bump github.com/Finschia/finschia-sdk from v0.47.0 to v0.48.0
  * (feat) [\#243](https://github.com/Finschia/finschia/pull/243) Bump github.com/Finschia/finschia-sdk from v0.47.0 to v0.47.1-rc1
  * (feat) [\#255](https://github.com/Finschia/finschia/pull/255) Bump up finschia-sdk from v0.48.0-rc1 to da331c01fa
  * (feat) [\#262](https://github.com/Finschia/finschia/pull/262) Bump up finschia-sdk from v0.48.0-rc2 to `0a27aef22921` and bump up ostracon from `449aa3148b12` to `fc29846c918d`
  * (finschia-sdk) [\#264](https://github.com/Finschia/finschia/pull/264) Bump up finschia-sdk from `0a27aef22921` to `022614f80a0d`
  * (finschia-sdk, ostracon, wasmd) [\#286](https://github.com/Finschia/finschia/pull/286) bump up fisnchia-sdk to v0.48.0 and Ostracon to v1.1.2 and wasmd to v0.2.0
* (ostracon) Bump up Ostracon from v1.1.0 to v1.1.2
  * (feat) [\#262](https://github.com/Finschia/finschia/pull/262) Bump up finschia-sdk from v0.48.0-rc2 to `0a27aef22921` and bump up ostracon from `449aa3148b12` to `fc29846c918d`
  * (finschia-sdk, ostracon, wasmd) [\#286](https://github.com/Finschia/finschia/pull/286) bump up fisnchia-sdk to v0.48.0 and Ostracon to v1.1.2 and wasmd to v0.2.0
* (wasmd) bump up wasmd from v0.1.3 to v0.2.0
  * (wasm) [\#258](https://github.com/Finschia/finschia/pull/258) Bump up wasmd from dedcd9ec to 053c7e43
  * (finschia-sdk, ostracon, wasmd) [\#286](https://github.com/Finschia/finschia/pull/286) bump up fisnchia-sdk to v0.48.0 and Ostracon to v1.1.2 and wasmd to v0.2.0
* (ibc) [\#246](https://github.com/Finschia/finschia/pull/246) Update ibc-go to v4
* (build) [\#248](https://github.com/Finschia/finschia/pull/248) Rename namespace to v2
* (app) [\#250](https://github.com/Finschia/finschia/pull/250) Set upgrade handler for v2-Daisy

### Improvements
* (build) [\#221](https://github.com/Finschia/finschia/pull/221) compile static binary as release assets and docker image
* (swagger) [\#223](https://github.com/Finschia/finschia/pull/223) add integrated swagger for finschia

### Bug Fixes
* (build) [\#236](https://github.com/Finschia/finschia/pull/236) fix compile error when the build_tags is multiple.
* (wasm) [\#249](https://github.com/Finschia/finschia/pull/249) revert removing wasm configs
* (build) [\#277](https://github.com/Finschia/finschia/pull/277) change to the default build method that uses a shared library

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
* (build) [\#284](https://github.com/Finschia/finschia/pull/284) use curl instead of wget on MacOS

### Docs
* (docs) [\#281](https://github.com/Finschia/finschia/pull/281) Update guide for static build on CentOS


## [v1.0.0] - 2023-04-24

### Features
* (build) [\#126](https://github.com/Finschia/finschia/pull/126) Automatically generates release note and binaries
* (x/wasmd) [\#129](https://github.com/Finschia/finschia/pull/129) chore: apply detached x/wasmd
* (build) [\#130](https://github.com/Finschia/finschia/pull/130) Add a release build for the linux/arm64, darwin/amd64, and darwin/arm64 platform
* (finschia-sdk) [\#137](https://github.com/Finschia/finschia/pull/137) Bump finschia-sdk to 6c84a4cffa
* (x/collection,token) [\#138](https://github.com/Finschia/finschia/pull/138) Add x/token and x/collection
* (ibc-go) [\#140](https://github.com/Finschia/finschia/pull/140) apply ibc-go
* (x/wasmplus) [\#141](https://github.com/Finschia/finschia/pull/141) change wasm module to wrapped `x/wasmplus`
* (finschia-sdk) [\#144](https://github.com/Finschia/finschia/pull/144) bump finschia-sdk v0.47.0-alpha1 (11966d1234155ebef20b64f2ae7a905beffdb33f)
* (build) [\#150](https://github.com/Finschia/finschia/pull/150) Modify the Makefile to build release bundles
* (build) [\#153](https://github.com/Finschia/finschia/pull/153) rename cli name to `fnsad`
* (finschia-sdk) [\#154](https://github.com/Finschia/finschia/pull/154) Bump finschia-sdk from v0.47.0-alpha1.0.20230214070148-11966d123415 to v0.47.0-rc1

### Improvements
* (x/wasmd) [\#147](https://github.com/Finschia/finschia/pull/147) update wasmd version
* (x/wasmd) [\#158](https://github.com/Finschia/finschia/pull/158) bump up wasmd version to v0.1.0
* (finschia-sdk) [\#159](https://github.com/Finschia/finschia/pull/159) Bump finschia-sdk from v0.47.0-rc1 to v0.47.0-rc2
* (wasmd) [\#171](https://github.com/Finschia/finschia/pull/171) bump up wasmd from v0.1.2-0.20230403061848-514953c0b244 to v0.1.2

### Bug Fixes
* (finschia-sdk) [\#162](https://github.com/Finschia/finschia/pull/162) Bump finschia-sdk from v0.47.0-rc2 to v0.47.0-rc3
* (finschia-sdk) [\#167](https://github.com/Finschia/finschia/pull/167) Bump finschia-sdk from v0.47.0-rc3 to v0.47.0-rc4
* (finschia-sdk) [\#178](https://github.com/Finschia/finschia/pull/178) Bump github.com/Finschia/finschia-sdk from v0.47.0-rc6 to v0.47.0-rc7
* (finschia-sdk) [\#168](https://github.com/Finschia/finschia/pull/168) Bump finschia-sdk from v0.47.0-rc4 to v0.47.0-rc4.0.20230410115856-b8421116b3f2
* (finschia-sdk) [\#172](https://github.com/Finschia/finschia/pull/172) Bump finschia-sdk from v0.47.0-rc4.0.20230410115856-b8421116b3f2 to v0.47.0-rc5
* (finschia-sdk) [\#174](https://github.com/Finschia/finschia/pull/174) bump up finschia-sdk from v0.47.0-rc5 to v0.47.0-rc5.0.20230414034539-489c442416cd

### Breaking Changes
* (api) [\#123](https://github.com/Finschia/finschia/pull/123) remove legacy REST API routes
* (ibc-go)[\#164](https://github.com/Finschia/finschia/pull/164) bump up ibc-go v3.3.2 for change ibc light client of Ostracon to Tendermint

### Build, CI
* (ci) [\#145](https://github.com/Finschia/finschia/pull/145) add github action to push docker image to docker.io
* (build) [\#157](https://github.com/Finschia/finschia/pull/157) add build args
* (ci)[\#163](https://github.com/Finschia/finschia/pull/163) fix `release-build` ci error occurred when adding assets after tagging
* (finschia-sdk,ostracon,wasmd,ibc-go) [\#176](https://github.com/Finschia/finschia/pull/176) Rename and bump up dependencies
* (ci) [\#180](https://github.com/Finschia/finschia/pull/180) add a CI to build darwin version when add tag

### Docs
* (doc) [\#156](https://github.com/Finschia/finschia/pull/156) modify broken link or typo doc file and add issue and pr template
* (doc)[\#165](https://github.com/Finschia/finschia/pull/165) update license notice and code_of_conduct
* (license) [\#170](https://github.com/Finschia/finschia/pull/170) fix license copyright holder and typo


## [v0.7.0] - 2022-11-29

### Features
* [\#108](https://github.com/Finschia/finschia/pull/108) Bump github.com/line/lbm-sdk from e19f863a8 to a389b6330
* [\#110](https://github.com/Finschia/finschia/pull/110) apply GovMint on x/foundation
* [\#111](https://github.com/Finschia/finschia/pull/111) Bump github.com/line/lbm-sdk from 66988a235 to 0.46.0-rc9
* (build) [\#113](https://github.com/Finschia/finschia/pull/113) enable to use libsodium version ostracon

### Improvements

### Bug Fixes
* (global) [\#103](https://github.com/Finschia/finschia/pull/103) replace deprecated functions of ioutil package
* (app) [\#107](https://github.com/Finschia/finschia/pull/107) change module order in `init genesis`
* (ci) [\#115](https://github.com/Finschia/finschia/pull/115) fix test flow to install libsodium
* (build) [\#118](https://github.com/Finschia/finschia/pull/118) fix docker build in Mac M1 device

### Improvements
* (app) [\#114](https://github.com/Finschia/finschia/pull/114) change the default compile setting to support ledger


## [v0.6.0] - 2022-10-05

### Bug Fixes
* (app) [\#96](https://github.com/Finschia/finschia/pull/96) fix the bug not setting `iavl-cache-size` value of the `app.toml`
* (baseapp) [\#97](https://github.com/Finschia/finschia/pull/97) fix max gas validation bug of lbm-sdk

### Breaking Changes
* (app) [\#87](https://github.com/Finschia/finschia/pull/87) remove unused modules from app
* (finschia-sdk) [\#95](https://github.com/Finschia/finschia/pull/95) apply the changes of lbm-sdk v0.46.0-rc8

### Build, CI
* (ci) [\#80](https://github.com/Finschia/finschia/pull/80) remove stale github action
* (ci) [\#83](https://github.com/Finschia/finschia/pull/83) enable tests on CI
* (build) [\#89](https://github.com/Finschia/finschia/pull/89) upgrade golang to 1.18


## [v0.5.0] - 2022-09-08

### Features
* (x/collection) [\#72](https://github.com/Finschia/finschia/pull/72) add x/collection
* (x/wasm) [\#79](https://github.com/Finschia/finschia/pull/79) chore: add iterator feature for wasm module

### Improvements
* (ci) [\#76](https://github.com/Finschia/finschia/pull/76) fix Dockerfile.static to build lbm instead of building wasmvm in the Dockerfile

### Bug Fixes
* (command) [\#81](https://github.com/Finschia/finschia/pull/81) add wrong address to genesis file in add-genesis-account command
* (x/collection) [\#86](https://github.com/Finschia/finschia/pull/86) add omitted cli commands on x/collection and fix Query/Balance
* (x/collection) [\#90](https://github.com/Finschia/finschia/pull/90) fix bugs in x/collection MsgModify


## [v0.4.0] - 2022-06-13

### Features
* (cosmos-sdk) [\#56](https://github.com/Finschia/finschia/pull/56) bump up cosmos-sdk v0.45.1
* (x/foundation) [\#62](https://github.com/Finschia/finschia/pull/62) add `x/foundation` module of lbm-sdk

### Improvements

### Bug Fixes
* (app) [\#60](https://github.com/Finschia/finschia/pull/60) register authz module store key


## [v0.3.0] - 2022-03-31

### Bug Fixes
* (build) [\#47](https://github.com/Finschia/finschia/pull/47) fix Docker build error

### Features
* (x/wasm) [\#41](https://github.com/Finschia/finschia/pull/41) upgrade x/wasm (merged original 0.19.0)
* (x/upgrade) [\#42](https://github.com/Finschia/finschia/pull/42) add token module and bump cosmos-sdk v0.42.11


## [v0.2.0] - 2022-02-04

### Features
* (x/upgrade) [\#33](https://github.com/Finschia/finschia/pull/33) To smoothen the update to the latest stable release, the SDK includes version map for managing migrations between SDK versions.
* (x/consortium) [\#34](https://github.com/Finschia/finschia/pull/34) add feegrant, consortium and stakingplus module
* (x/bank) [\#36](https://github.com/Finschia/finschia/pull/36) apply a feature that preventing sending coins to inactive contract (related to [finschia-sdk #400](https://github.com/Finschia/finschia-sdk/pull/400))

### Improvements
* (slashing) [\#31] (https://github.com/Finschia/finschia/pull/31) Apply VoterSetCounter

## [v0.1.0] - 2021-11-01

### Features
* (app) Revise bech32 prefix cosmos to link and tlink

### Improvements
* (sdk) Use fastcache for inter block cache and iavl cache
* (sdk) Enable signature verification cache
* (ostracon) Apply asynchronous receiving reactor
* (sdk) [\#21](https://github.com/Finschia/finschia/pull/21) Use lbm-sdk v0.43.0

### Bug Fixes

### Breaking Changes
* (sdk) (auth) [\#16](https://github.com/Finschia/lfb/pull/16) Introduce sig block height for the new replay protection
* (ostracon/sdk) [\#26](https://github.com/Finschia/lfb/pull/26) Use vrf-based consensus, address string treatment
* (global) [\#10](https://github.com/Finschia/finschia/pull/10) Re-brand lfb to lbm

### Build, CI
* (build) [\#25](https://github.com/Finschia/finschia/pull/25) Fix localnet-start

<!-- Release links -->
[Unreleased]: https://github.com/Finschia/finschia/compare/v3.0.0...HEAD
[v3.0.0]: https://github.com/Finschia/finschia/releases/tag/v3.0.0
[v2.0.0]: https://github.com/Finschia/finschia/releases/tag/v2.0.0
[v1.0.0]: https://github.com/Finschia/finschia/releases/tag/v1.0.0
[v0.7.0]: https://github.com/Finschia/finschia/releases/tag/v0.7.0
[v0.6.0]: https://github.com/Finschia/finschia/releases/tag/v0.6.0
[v0.5.0]: https://github.com/Finschia/finschia/releases/tag/v0.5.0
[v0.4.0]: https://github.com/Finschia/finschia/releases/tag/v0.4.0
[v0.3.0]: https://github.com/Finschia/finschia/releases/tag/v0.3.0
[v0.2.0]: https://github.com/Finschia/finschia/releases/tag/v0.2.0
[v0.1.0]: https://github.com/Finschia/finschia/releases/tag/v0.1.0
