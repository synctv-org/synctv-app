import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef PiPBuilderCallback = Widget Function(PiPStatusInfo? status);

class PiPBuilder extends StatefulWidget {
  const PiPBuilder({
    super.key,
    required this.builder,
  });

  final PiPBuilderCallback builder;

  @override
  State<PiPBuilder> createState() => _PiPBuilderState();
}

class _PiPBuilderState extends State<PiPBuilder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final value = await FlPiP().isAvailable;
      if (value) {
        FlPiP().status.addListener(listener);
        await FlPiP().isActive;
      } else {
        FlPiP().status.value = PiPStatusInfo(status: PiPStatus.unavailable);
      }
    });
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(FlPiP().status.value);

  @override
  void dispose() {
    FlPiP().status.removeListener(listener);
    super.dispose();
  }
}

enum PiPStatus {
  /// Show picture in picture
  enabled,

  /// Does not display picture-in-picture
  disabled,

  /// Picture-in-picture is not supported
  unavailable
}

class PiPStatusInfo {
  PiPStatusInfo({required this.status, this.isCreateNewEngine = false, this.isEnabledWhenBackground = false});

  PiPStatusInfo.fromMap(Map<dynamic, dynamic> map)
      : status = PiPStatus.values[map['status'] as int],
        isCreateNewEngine = map['createNewEngine'] as bool,
        isEnabledWhenBackground = map['enabledWhenBackground'] as bool;

  ///  pip status
  final PiPStatus status;

  /// is create new engine
  final bool isCreateNewEngine;

  /// is enabled when background
  final bool isEnabledWhenBackground;
}

const _channel = MethodChannel('fl_pip');

class FlPiP {
  factory FlPiP() => _instance;

  static final FlPiP _instance = FlPiP._();

  static FlPiP get instance => _instance;

  FlPiP._() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onPiPStatus':
          status.value = PiPStatusInfo.fromMap(call.arguments);
          break;
      }
    });
  }

  final ValueNotifier<PiPStatusInfo?> status = ValueNotifier(null);

  /// 开启画中画
  /// enable picture-in-picture
  Future<bool> enable({
    FlPiPAndroidConfig android = const FlPiPAndroidConfig(),
    FlPiPiOSConfig ios = const FlPiPiOSConfig(),
  }) async {
    if (!(_isAndroid || _isIOS)) {
      return false;
    }

    if (_isAndroid && !(android.aspectRatio.fitsInAndroidRequirements) && !android.createNewEngine) {
      throw RationalNotMatchingAndroidRequirementsException(android.aspectRatio);
    }
    final state = await _channel.invokeMethod<bool>('enable', _isAndroid ? android.toMap() : ios.toMap());
    return state ?? false;
  }

  /// 关闭画中画
  /// disable picture-in-picture
  Future<bool> disable() async {
    final state = await _channel.invokeMethod<bool>('disable');
    return state ?? false;
  }

  /// 画中画状态
  /// Picture-in-picture window state
  Future<PiPStatusInfo?> get isActive async {
    final map = await _channel.invokeMethod<Map<dynamic, dynamic>>('isActive');
    if (map != null) {
      status.value = PiPStatusInfo.fromMap(map);
    }
    return status.value;
  }

  /// 是否支持画中画
  /// Whether to support picture in picture
  Future<bool> get isAvailable async {
    final bool? state = await _channel.invokeMethod('available');
    return state ?? false;
  }

  /// 切换前后台
  /// Toggle front and back
  /// ios仅支持切换后台
  /// ios supports background switching only
  Future<void> toggle(AppState state) => _channel.invokeMethod('toggle', state == AppState.foreground);
}

enum AppState {
  /// 前台
  foreground,

  /// 后台
  background,
}

class FlPiPConfig {
  const FlPiPConfig({this.enabledWhenBackground = false, this.createNewEngine = false, this.packageName, this.rect});

  ///  ios 画中画弹出前视频的初始大小和位置,默认 [left:width/2,top:height/2,width:0.1,height:0.1]
  ///  ios The initial size and position of the video before the picture-in-picture pops up,default [left:width/2,top:height/2,width:0.1,height:0.1]
  ///  android 系统弹窗的大小和位置 ,默认 [left:width/2,top:height/2,width:300,height:300]
  ///  android The size and position of the system popup,default [left:width/2,top:height/2,width:300,height:300]
  final Rect? rect;

  /// Enabled when the app is in the background
  /// 当app处于后台时启用
  final bool enabledWhenBackground;

  /// 创建新的 engine
  /// create new engine
  final bool createNewEngine;

  /// 资源地址的 packageName
  /// Set packageName to the asset address
  /// 如果使用你自己项目的资源文件 请设置[packageName]为null
  /// If using your own project's resource files, set [packageName] to null
  final String? packageName;

  Map<String, dynamic> toMap() => {
        'left': rect?.left,
        'top': rect?.top,
        'width': rect?.width,
        'height': rect?.height,
        'packageName': packageName,
        'enabledWhenBackground': enabledWhenBackground,
        'createNewEngine': createNewEngine,
      };
}

/// android 画中画配置
/// android picture-in-picture configuration
class FlPiPAndroidConfig extends FlPiPConfig {
  const FlPiPAndroidConfig(
      {
      /// Android 悬浮框右上角的关闭按钮的图片地址
      /// Android The image address of the Close button in the upper right corner of the floating
      this.closeIconPath,
      this.aspectRatio = const Rational.square(),
      super.packageName,
      super.enabledWhenBackground = false,
      super.createNewEngine = false,
      super.rect});

  /// android 画中画窗口宽高比例
  /// android picture in picture window width-height ratio
  final Rational aspectRatio;

  /// 当createNewEngine 等于true时，在android上实际上是创建了一个windowManager，而不是PIP,这个是右上角关闭按钮的图片路径
  /// When [createNewEngine]= true, a windowManager is actually created on Android, not PIP. This is the image path of the close button in the upper right corner
  final String? closeIconPath;

  @override
  Map<String, dynamic> toMap() => {
        ...aspectRatio.toMap(),
        ...super.toMap(),
        'closeIconPath': closeIconPath,
      };
}

/// ios 画中画配置
/// ios picture-in-picture configuration
class FlPiPiOSConfig extends FlPiPConfig {
  const FlPiPiOSConfig(
      {
      /// 视频路径 用于修修改画中画尺寸
      /// The video [path] is used to modify the size of the picture in picture
      this.videoPath = 'assets/landscape.mp4',
      this.audioPath = 'assets/audio.mp3',
      super.packageName = 'fl_pip',
      this.enableControls = false,
      this.enablePlayback = false,
      super.enabledWhenBackground = false,
      super.createNewEngine = false,
      super.rect});

  /// 显示播放控制
  /// Display play control
  final bool enableControls;

  /// 开启播放速度
  /// Turn on playback speed
  final bool enablePlayback;

  /// 视频路径 用于修修改画中画尺寸
  /// The video [path] is used to modify the size of the picture in picture
  /// Video address used to control pip width and height
  final String videoPath;

  /// Audio address
  final String audioPath;

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'videoPath': videoPath,
        'audioPath': audioPath,
        'packageName': packageName,
        'enableControls': enableControls,
        'enablePlayback': enablePlayback,
      };
}

/// android 画中画宽高比
/// android picture in picture aspect ratio
class Rational {
  final int numerator;
  final int denominator;

  double get aspectRatio => numerator / denominator;

  const Rational(this.numerator, this.denominator);

  const Rational.square()
      : numerator = 1,
        denominator = 1;

  const Rational.landscape()
      : numerator = 16,
        denominator = 9;

  const Rational.maxLandscape()
      : numerator = 239,
        denominator = 100;

  const Rational.maxVertical()
      : numerator = 100,
        denominator = 239;

  const Rational.vertical()
      : numerator = 9,
        denominator = 16;

  @override
  String toString() => 'Rational(numerator: $numerator, denominator: $denominator)';

  Map<String, dynamic> toMap() => {'numerator': numerator, 'denominator': denominator};
}

extension on Rational {
  bool get fitsInAndroidRequirements {
    final aspectRatio = numerator / denominator;
    const min = 1 / 2.39;
    const max = 2.39;
    return (min <= aspectRatio) && (aspectRatio <= max);
  }
}

class RationalNotMatchingAndroidRequirementsException implements Exception {
  final Rational rational;

  RationalNotMatchingAndroidRequirementsException(this.rational);

  @override
  String toString() => 'RationalNotMatchingAndroidRequirementsException('
      '${rational.numerator}/${rational.denominator} does not fit into '
      'Android-supported aspect ratios. Boundaries: '
      'min: 1/2.39, max: 2.39/1. '
      ')';
}

bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
