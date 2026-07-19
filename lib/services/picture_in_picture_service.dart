import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PictureInPictureService {
  PictureInPictureService._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static final PictureInPictureService instance = PictureInPictureService._();
  static const MethodChannel _channel = MethodChannel(
    'com.sync.app/picture_in_picture',
  );

  final ValueNotifier<bool> active = ValueNotifier(false);
  bool _available = false;

  bool get available => _available;

  Future<bool> initialize() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      _available = false;
      return false;
    }
    try {
      _available = await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException {
      _available = false;
    } on MissingPluginException {
      _available = false;
    }
    return _available;
  }

  Future<bool> enter({required double aspectRatio}) async {
    if (!_available) return false;
    final ratio = aspectRatio.isFinite && aspectRatio > 0
        ? aspectRatio.clamp(1 / 2.39, 2.39)
        : 16 / 9;
    try {
      return await _channel.invokeMethod<bool>('enter', {
            'width': (ratio * 1000).round(),
            'height': 1000,
          }) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onPictureInPictureChanged') {
      active.value = call.arguments == true;
    }
  }
}
