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
* (improvements) [\#230](https://github.com/Finschia/finschia/pull/230) fix Makefile for format and execute make format #230

### Bug Fixes

### Breaking Changes

### Build, CI
* (ci) [\#290](https://github.com/Finschia/finschia/pull/290) remove autopr ci
* (ci) [\#291](https://github.com/Finschia/finschia/pull/291) fix goreleaser ci error and replace release-build
* (ci) [\#296](https://github.com/Finschia/finschia/pull/296) bump actions/checkout from 3 to 4

### Docs

<!-- Release links -->
[Unreleased]: https://github.com/Finschia/finschia/compare/v2.0.0...HEAD
