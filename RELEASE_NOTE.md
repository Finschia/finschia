# Finschia v1.0.0 Release Note

## What's Changes
This version base on [finschia-sdk v0.47.0](https://github.com/Finschia/finschia-sdk/releases/tag/v0.47.0), [Ostracon v1.1.0](https://github.com/Finschia/ostracon/tree/v1.1.0), [finschia/wasmd v0.1.3](https://github.com/Finschia/wasmd/releases/tag/v0.1.3) and [finschia/ibc-go v3.3.3](https://github.com/Finschia/ibc-go/releases/tag/v3.3.3).

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


## Base sub modules
* Ostracon: [v1.1.0](https://github.com/Finschia/ostracon/tree/v1.1.0)
* finschia-sdk: [v0.47.0](https://github.com/Finschia/finschia-sdk/tree/v0.47.0)
* Finschia/wasmd: [v0.1.3](https://github.com/Finschia/wasmd/tree/v0.1.3)
* Finschia/ibc-go: [v3.3.3](https://github.com/Finschia/ibc-go/tree/v3.3.3)

Full Changelog: [v0.7.0...v1.0.0](https://github.com/Finschia/finschia/compare/v0.7.0...v1.0.0)
