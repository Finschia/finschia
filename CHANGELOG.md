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
* (build) [\#202](https://github.com/Finschia/finschia/pull/202) bump up finschia-sdk from v0.47.1-0.20230517010045-e9fe90608161 to v0.47.1-rc1
* (sdk) [\#204](https://github.com/Finschia/finschia/pull/204) apply Finschia/finschia-sdk#1019(backport Finschia/finschia-sdk#1012)
* (ibc) [\#209](https://github.com/Finschia/finschia/pull/209) bump up ibc-go from v3.3.3 to v3.3.4-0.20230531095546-59c47ab8e095

### Improvements
* (x/wasm) [\#191](https://github.com/Finschia/finschia/pull/191) bump up Finschia/wasmd from v0.1.3 to v0.1.4

### Bug Fixes
* (build) [\#205](https://github.com/Finschia/finschia/pull/205) fix wasm error by changing from image to golang:1.18-alpine

### Breaking Changes
* (sdk) [\#187](https://github.com/finschia/finschia/pull/187) Apply Finschia/finschia-sdk#999

### Build, CI
* (ci) [\#185](https://github.com/Finschia/finschia/pull/185) update `tag.yml` github action
* (build) [\#188](https://github.com/Finschia/finschia/pull/188) fix example wrong app name in `--help` description of cli

### Docs

<!-- Release links -->
[Unreleased]: https://github.com/Finschia/finschia/compare/v1.0.0...HEAD
