## 3.2.3

* Merge pull request [35](https://github.com/Wayaer/fl_pip/pull/35)

## 3.2.1

* Update gradle version
* Optimize background music playback on iOS backend

## 3.1.0

* Breaking changes , Please refer to the example
* Fix the error when calling plug-in methods in Pip mode
* Modify some configuration parameters of Android and iOS
* Modified examples and some documents
* When the app enters the background, the picture in picture still cannot work properly on iOS

## 2.0.0

* Add the `PiPStatusInfo` class and add the `isCreateNewEngine` and `isEnabledWhenBackground` for
  the current pip
* Fixed `disable()` not working in android when `createNewEngine=true`
* Change the `isActive()` return parameter to `PiPStatusInfo`

## 1.0.0

* Removed `FlPiP().enableWithEngine`
* Add `createNewEngine`、`enabledWhenBackground` to `FlPiPConfig()`

## 0.1.1

* Fixed ios gesture conflicts
* Added the method for creating an engine
* Added a system-level window for android

## 0.0.1

* TODO: Describe initial release.
