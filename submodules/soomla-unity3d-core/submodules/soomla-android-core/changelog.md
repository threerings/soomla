### v1.0.3 [view commit logs](https://github.com/soomla/soomla-android-core/compare/v1.0.2...v1.0.3)

* Fixes
  * Fixing AsyncTask class not found for lower Android versions as proposed [here](http://stackoverflow.com/questions/6968744/getting-noclassdeffounderror-android-os-asynctask)

### v1.0.2 [view commit logs](https://github.com/soomla/soomla-android-core/compare/v1.0.1...v1.0.2)

* Fixes
  * Foreground is disabled on android versions < ICS
  * Foreground will be available on versions < ICS but events are only available on versions >= ICS

### v1.0.1 [view commit logs](https://github.com/soomla/soomla-android-core/compare/v1.0.0...v1.0.1)

* New Features
  * Added Foreground service that fires events when the app goes to background/foreground
  * Added functions to fetch or reset rewards state

* Fixes
  * Fixed an issue when reward last-given-time wasn't saved correctly

### v1.0.0

Initial version of the SOOMLA Core library for Android
