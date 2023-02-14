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
* (build) [\#126](https://github.com/line/lbm/pull/126) Automatically generates release note and binaries
* (x/wasmd) [\#355](https://github.com/line/lbm/pull/355) chore: apply detached x/wasmd
* (build) [\#130](https://github.com/line/lbm/pull/130) Add a release build for the linux/arm64, darwin/amd64, and darwin/arm64 platform
* (lbm-sdk) [\#137](https://github.com/line/lbm/pull/137) Bump line/lbm-sdk to 6c84a4cffa
* (x/collection,token) [\#138](https://github.com/line/lbm/pull/138) Add x/token and x/collection
* (ibc-go) [\#140](https://github.com/line/lbm/pull/140) apply ibc-go
* (build) [\#143](https://github.com/line/lbm/pull/143) Modify the Makefile to build release bundles

### Improvements

### Bug Fixes

### Breaking Changes
(api) [\#123](https://github.com/line/lbm/pull/123) remove legacy REST API routes

### Build, CI


<!-- Release links -->
[Unreleased]: https://github.com/line/lbm/compare/v0.7.0...HEAD
