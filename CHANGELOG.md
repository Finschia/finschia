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

This version based on [lbm-sdk v0.46.0-rc6](https://github.com/line/lbm-sdk/releases/tag/v0.46.0-rc6)

### Features
* (x/collection) [\#72](https://github.com/line/lbm/pull/72) add x/collection
* (x/wasm) [\#79](https://github.com/line/lbm/pull/79) chore: add iterator feature for wasm module

### Improvements
[\#76](https://github.com/line/lbm/pull/76) fix Dockerfile.static to build lbm instead of building wasmvm in the Dockerfile

### Bug Fixes
* [\#83](https://github.com/line/lbm/pull/83) enable tests on CI

### Breaking Changes

### Build, CI
* (ci) [\#80](https://github.com/line/lbm/pull/80) remove stale github action


<!-- Release links -->
[Unreleased]: https://github.com/line/lbm/compare/v0.4.0...HEAD
