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
<<<<<<< HEAD
=======
* (improvements) [\#230](https://github.com/Finschia/finschia/pull/230) fix Makefile for format and execute make format #230
* (chore) [\#299](https://github.com/Finschia/finschia/pull/299) remove x/token and x/collection apis in swagger
>>>>>>> eeb4ff5 (chore: remove x/token and x/collection apis in swagger (#299))

### Bug Fixes
* (finschia-sdk) [\#298](https://github.com/Finschia/finschia/pull/298) bump up finschia-sdk from v0.48.0 to v0.48.1 (backport #297)

### Breaking Changes

### Build, CI
* (ci) [\#290](https://github.com/Finschia/finschia/pull/290) remove autopr ci
* (ci) [\#291](https://github.com/Finschia/finschia/pull/291) fix goreleaser ci error and replace release-build

### Docs

<!-- Release links -->
[Unreleased]: https://github.com/Finschia/finschia/compare/v2.0.0...HEAD
