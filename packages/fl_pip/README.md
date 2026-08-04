# fl_pip

## 基于原生ios和android的画中画模式，实现显示flutter的view,可以通过修改flutter 栈顶的view来显示任意UI

## The picture-in-picture mode is implemented in native ios and android to display flutter's view

### 目前在ios上遇到了一个问题，当app在后台的时候，FlutterUi停止运行或者画中画直接黑屏，猜测可能是由于ios冻结app导致，本人目前没有好的解决办法，如果你有想法，请提交pr

### At present, there is a problem in ios, when the app is in the background, FlutterUi will stop running or black screen directly, which may be caused by ios freezing the app, I have no good solution at present, if you have ideas, please submit PR

## Use configuration

- ios 配置 : `Signing & Capabilities` -> `Capability` 添加 `BackgroundModes`
  勾选 `Audio,AirPlay,And Picture in Picture`
- ios configuration : `Signing & Capabilities` -> `Capability` Add `BackgroundModes`
  check `Audio,AirPlay,And Picture in Picture`
- 修改`/ios/Runner/AppDelegate.swift` 的内容
- Modify the content of `/ios/Runner/AppDelegate.swift`

### swift

```swift
import fl_pip
import Flutter
import UIKit

@main
@objc class AppDelegate: FlFlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func registerPlugin(_ registry: FlutterPluginRegistry) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}


```

- android 配置 : `android/app/src/main/${your package name}/MainActivity` 修改 MainActivity 继承,
- android configuration : `android/app/src/main/${your package name}/MainActivity`,

### kotlin

```kotlin

class MainActivity : FlPiPActivity()

```

### java

```java

class MainActivity extends FlPiPActivity {

}

```

android AndroidManifest file `android/app/src/main/AndroidManifest.xml`,
add ` android:supportsPictureInPicture="true"`

```xml

<application android:label="FlPiP">
    <activity android:name=".MainActivity" android:launchMode="singleTop" android:supportsPictureInPicture="true" />
</application>
```

## Methods available

```dart
/// 开启画中画
/// Open picture-in-picture
void enable() {
  FlPiP().enable(
      iosConfig: FlPiPiOSConfig(),
      androidConfig: FlPiPAndroidConfig(
          aspectRatio: const Rational.maxLandscape()));
}

/// 是否支持画中画
/// Whether to support picture in picture
void isAvailable() {
  FlPiP().isAvailable;
}

/// 画中画状态
/// Picture-in-picture window state
void isActive() {
  FlPiP().isActive;
}

/// 切换前后台
/// Toggle front and back
/// ios仅支持切换后台
/// ios supports background switching only
void toggle() {
  FlPiP().toggle();
}

/// 退出画中画
/// Quit painting in picture
void disable() {
  FlPiP().disable();
}
```

- 如果使用enableWithEngine方法必须在main文件中添加这个main方法
- The main method must be added to the main file if the enableWithEngine method is used

```dart
/// mainName must be the same as the method name
@pragma('vm:entry-point')
void pipMain() {
  runApp(YourApp());
}

```

- Android

https://github.com/user-attachments/assets/1ba2238e-e556-4f87-8ccb-1b25440a6649

- IOS

