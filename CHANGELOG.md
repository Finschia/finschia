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

### Improvements

### Bug Fixes
* (lbm-sdk) [\#162](https://github.com/line/finschia/pull/162) Bump github.com/line/lbm-sdk from v0.47.0-rc2 to v0.47.0-rc3

### Breaking Changes

### Build, CI

### Docs

## [v1.0.0-rc2](https://github.com/line/lbm/releases/tag/v1.0.0-rc2) - 2023-03-29

### Improvements
* (x/wasmd) [\#158](https://github.com/line/finschia/pull/158) bump up wasmd version to v0.1.0
* (lbm-sdk) [\#159](https://github.com/line/finschia/pull/159) Bump github.com/line/lbm-sdk from v0.47.0-rc1 to v0.47.0-rc2

### Build, CI
* (build) [\#157](https://github.com/line/finschia/pull/157) add build args

### Docs
* (doc) [\#156](https://github.com/line/finschia/pull/156) modify broken link or typo doc file and add issue and pr template


## [v1.0.0-rc1](https://github.com/line/lbm/releases/tag/v1.0.0-rc1) - 2023-03-24

### Features
* (build) [\#150](https://github.com/line/lbm/pull/150) Modify the Makefile to build release bundles
* (build) [\#153](https://github.com/line/finschia/pull/153) rename cli name to `fnsad`
* (lbm-sdk) [\#154](https://github.com/line/finschia/pull/154) Bump github.com/line/lbm-sdk from v0.47.0-alpha1.0.20230214070148-11966d123415 to v0.47.0-rc1

### Improvements
* (x/wasmd) [\#147](https://github.com/line/lbm/pull/147) update wasmd version


## [v1.0.0-rc0](https://github.com/line/lbm/releases/tag/v1.0.0-rc0) - 2023-02-16

### Features
* (build) [\#126](https://github.com/line/lbm/pull/126) Automatically generates release note and binaries
* (x/wasmd) [\#129](https://github.com/line/lbm/pull/129) chore: apply detached x/wasmd
* (build) [\#130](https://github.com/line/lbm/pull/130) Add a release build for the linux/arm64, darwin/amd64, and darwin/arm64 platform
* (lbm-sdk) [\#137](https://github.com/line/lbm/pull/137) Bump line/lbm-sdk to 6c84a4cffa
* (x/collection,token) [\#138](https://github.com/line/lbm/pull/138) Add x/token and x/collection
* (ibc-go) [\#140](https://github.com/line/lbm/pull/140) apply ibc-go
* (x/wasmplus) [\#141](https://github.com/line/lbm/pull/141) change wasm module to wrapped `x/wasmplus`
* (lbm-sdk) [\#144](https://github.com/line/lbm/pull/144) bump line/lbm-sdk v0.47.0-alpha1 (11966d1234155ebef20b64f2ae7a905beffdb33f) 

### Breaking Changes
* (api) [\#123](https://github.com/line/lbm/pull/123) remove legacy REST API routes

### Build, CI
* (ci) [\#145](https://github.com/line/lbm/pull/145) add github action to push docker image to docker.io


<!-- Release links -->
[Unreleased]: https://github.com/line/lbm/compare/v0.7.0...HEAD
