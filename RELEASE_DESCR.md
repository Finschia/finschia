<!--
Usage:

Include additional details about the release in this file, separate from the RELEASE_CHANGELOG. 
Feel free to add any highlights or other information you'd like to share with the community.
-->

# DESCRIPTION OF RELEASE

## [vX.Y.Z] - YYYY-MM-DD
<!-- <Desription of This Release> -->
<!-- <Add Highlights or any sections if you need> -->

## [v4.0.0] - 2024-05-27
## Highlights
* Introduced fswap and fbridge modules for converting `cony` to kaia coin and managing cross-chain transfers.
* Addressed several crucial bug fixes to enhance stability and performance, including improvements in configuration, error handling, and system integrity checks.
  * [finschia-sdk #1302](https://github.com/Finschia/finschia-sdk/pull/1302) remove map iteration non-determinism with keys + sorting (backport cosmos/cosmos-sdk#13377)
  * [finschia-sdk #1274](https://github.com/Finschia/finschia-sdk/pull/1274) ModuleAccount.Validate now reports a nil .BaseAccount instead of panicking. (backport cosmos/cosmos-sdk#16554)
  * [finschia-sdk #1301](https://github.com/Finschia/finschia-sdk/pull/1301) Use bytes instead of string comparison in delete validator queue (backport cosmos/cosmos-sdk#12303)
  * [finschia-sdk #1310](https://github.com/Finschia/finschia-sdk/pull/1310) fix app-hash mismatch if upgrade migration commit is interrupted (backport cosmos/cosmos-sdk#13530)
  * More detailed changes can be found [here](https://github.com/Finschia/finschia-sdk/releases/tag/v0.49.0).

## [v3.0.0] - 2024-03-04
## Highlights
* patch [CWA-2023-004 issue](https://forum.cosmos.network/t/high-severity-security-patch-upcoming-on-wed-10th-cwa-2023-004-brought-to-you-by-certik-and-confio/12840)
* Ensure smart contracts compiled with Rust v1.70 run without errors.
* disable custom querier in wasm

## [v2.0.0] - 2023-10-19

## [v1.0.0] - 2023-04-24
This version base on [finschia-sdk v0.47.0](https://github.com/Finschia/finschia-sdk/releases/tag/v0.47.0), [Ostracon v1.1.0](https://github.com/Finschia/ostracon/tree/v1.1.0), [finschia/wasmd v0.1.3](https://github.com/Finschia/wasmd/releases/tag/v0.1.3) and [finschia/ibc-go v3.3.3](https://github.com/Finschia/ibc-go/releases/tag/v3.3.3).

## [v0.7.0] - 2022-11-29
This version base on [finschia-sdk v0.46.0](https://github.com/Finschia/finschia-sdk/releases/tag/v0.46.0).

## [v0.6.0] - 2022-10-05
This version based on [finschia-sdk v0.46.0-rc8](https://github.com/Finschia/finschia-sdk/releases/tag/v0.46.0-rc8)

## [v0.5.0] - 2022-09-08
This version based on [finschia-sdk v0.46.0-rc6](https://github.com/Finschia/finschia-sdk/releases/tag/v0.46.0-rc6)

## [v0.4.0] - 2022-06-13
This version based on finschia-sdk v0.46.0-rc2

## [v0.3.0] - 2022-03-31

## [v0.2.0] - 2022-02-04

## [v0.1.0] - 2021-11-01
This is the first release of the Finschia blockchain. It is based on [gaia v4.0.4](https://github.com/cosmos/gaia/releases/tag/v4.0.4).
