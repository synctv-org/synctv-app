import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 鸿蒙智感握持状态
enum SmartGripStatus {
  /// 未握持
  notHeld,

  /// 左手握持
  leftHand,

  /// 右手握持
  rightHand,

  /// 双手握持
  bothHands,

  /// 未知状态
  unknown,
}

/// 鸿蒙智感握持服务封装
class SmartGripService {
  static final SmartGripService _instance = SmartGripService._internal();

  factory SmartGripService() {
    return _instance;
  }

  SmartGripService._internal();

  static const EventChannel _smartGripChannel =
      EventChannel('com.synctv/smart_grip');
  StreamSubscription? _subscription;

  final _statusController = StreamController<SmartGripStatus>.broadcast();

  /// 当前的握持状态（默认为右手）
  SmartGripStatus _currentStatus = SmartGripStatus.rightHand;

  /// 获取当前状态
  SmartGripStatus get currentStatus => _currentStatus;

  /// 监听状态变化流
  Stream<SmartGripStatus> get onStatusChanged => _statusController.stream;

  /// 初始化服务
  void init() {
    if (Platform.operatingSystem.toLowerCase() == 'ohos') {
      try {
        _subscription = _smartGripChannel.receiveBroadcastStream().listen(
          (dynamic event) {
            if (event is int) {
              _currentStatus = _mapIntToStatus(event);
              _statusController.add(_currentStatus);
            }
          },
          onError: (dynamic error) {
            debugPrint('SmartGrip error: $error');
          },
        );
      } catch (e) {
        debugPrint('SmartGrip setup error: $e');
      }
    }
  }

  /// 将原生传来的 int 映射为枚举
  SmartGripStatus _mapIntToStatus(int value) {
    switch (value) {
      case 0:
        return SmartGripStatus.notHeld;
      case 1:
        return SmartGripStatus.leftHand;
      case 2:
        return SmartGripStatus.rightHand;
      case 3:
        return SmartGripStatus.bothHands;
      default:
        return SmartGripStatus.unknown;
    }
  }

  /// 释放资源
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
