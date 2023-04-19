# Finschia v1.0.0-rc6 Release Note

## What's Changes
* Rename and bump up dependencies by @0Tech in https://github.com/Finschia/finschia/pull/176
  * rename the following dependencies (and update scripts when necessary)
    * github.com/line/lbm-sdk => github.com/Finschia/finschia-sdk
    * github.com/line/ostracon => github.com/Finschia/ostracon
    * github.com/line/ibc-go => github.com/FInschia/ibc-go
    * github.com/line/wasmd => github.com/Finschia/wasmd
  * bump up Finschia/finschia-sdk
    * chore: change import path to github.com/Finschia/finschia-sdk
      fix: not to throw error when no txs in block
      refactor: refactor x/token,collection query errors
  * change the ci runners from self-hosted to ubuntu-latest

## Base sub modules
* Ostracon: [v1.0.10-0.20230417090415-bc3f5693b6a1](https://github.com/Finschia/ostracon/tree/bc3f5693b6a15644dd313d23760280efe7a385a8)
* finschia-sdk: [v0.47.0-rc6](https://github.com/Finschia/finschia-sdk/tree/v0.47.0-rc6)
* Finschia/wasmd: [v0.1.3](https://github.com/Finschia/wasmd/tree/v0.1.3)
* Finschia/ibc-go: [v3.3.3](https://github.com/Finschia/ibc-go/tree/v3.3.3)

Full Changelog: [v1.0.0-rc5...v1.0.0-rc6](https://github.com/Finschia/finschia/compare/v1.0.0-rc5...v1.0.0-rc6)
