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
* (x/upgrade) [\#33](https://github.com/line/lbm/pull/33) To smoothen the update to the latest stable release, the SDK includes version map for managing migrations between SDK versions.
* (x/consortium) [\#34](https://github.com/line/lbm/pull/34) add feegrant, consortium and stakingplus module
* (x/bank) [\#36](https://github.com/line/lbm/pull/36) apply a feature that preventing sending coins to inactive contract (related to [lbm-sdk #400](https://github.com/line/lbm-sdk/pull/400))

### Improvements
* (slashing) [\#31] (https://github.com/line/lbm/pull/31) Apply VoterSetCounter

### Bug Fixes

### Breaking Changes
