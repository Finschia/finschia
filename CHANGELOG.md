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
* [\#83](https://github.com/line/lbm/pull/83) enable tests on CI

### Improvements
* [\#95](https://github.com/line/lbm/pull/95) apply the changes of lbm-sdk v0.46.0-rc8

### Breaking Changes
* [\#87](https://github.com/line/lbm/pull/87) remove unused modules from app

### Build, CI
* (ci) [\#80](https://github.com/line/lbm/pull/80) remove stale github action
* (build) [\#89](https://github.com/line/lbm/pull/89) upgrade golang to 1.18


<!-- Release links -->
[Unreleased]: https://github.com/line/lbm/compare/v0.5.0...HEAD
