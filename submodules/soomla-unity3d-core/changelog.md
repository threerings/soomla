### v1.0.6 [view commit logs](https://github.com/soomla/soomla-unity3d-core/compare/v1.0.5...v1.0.6)

* Changes
  * Added post build script for core

* Fixes
  * Log error in post build runner
  * Fixing issues with RandomReward and SequenceReward

### v1.0.5 [view commit logs](https://github.com/soomla/soomla-unity3d-core/compare/v1.0.4...v1.0.5)

* Fixes
  * Fixing issue with native KVS iOS via submodule
  * Fixing AsyncTask class not found exception (Android) via submodule

### v1.0.4 [view commit logs](https://github.com/soomla/soomla-unity3d-core/compare/v1.0.3...v1.0.4)

* Changes
  * Updated new features from submodules

### v1.0.3 [view commit logs](https://github.com/soomla/soomla-unity3d-core/compare/v1.0.2...v1.0.3)

* New Features
  * Added option to disable Soomla Unity based messages (Thanks @zentuit)
  * Updated new features from submodules

### v1.0.2 [view commit logs](https://github.com/soomla/soomla-unity3d-core/compare/v1.0.1...v1.0.2)

* Changes
  * Updated submodules

### v1.0.1 [view commit logs](https://github.com/soomla/soomla-unity3d-core/compare/v1.0.0...v1.0.1)

* Fixes
  * Fixing SoomlaEntity cloning without new ID
  * Fixing issue in `toJSONObject` function of `Schedule` class
  * Escaping special characters to support special characters in string for JSON
  * Fixed an issue with a duplicated function and bridge project config
  * Fixing typo in java bridge: onRewardGiven -> onRewardTaken

* Changes
  * Updated ios-core with NonConsumableItem changes
  * Reward storage in natives work with ID now

* New Features
  * Adding a default Schedule to returned reward when converted to Dictionary
  * Creating a generic post build process
  * Added function to return rewards list from Reward object

### v1.0.0

Initial version of the SOOMLA Core library for Unity
