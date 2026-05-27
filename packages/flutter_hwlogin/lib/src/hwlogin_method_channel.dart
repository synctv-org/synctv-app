import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'login_result.dart';

import 'hwlogin_platform_interface.dart';

/// An implementation of [HwloginPlatform] that uses method channels.
class MethodChannelHwlogin extends HwloginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.looptry/hwlogin');

  Future<String?> getPhone() async {
    // 已经不需要获取手机号
    return null;
  }

  @override
  Future<LoginResult> login() async {
    try {
      final String? result = await methodChannel.invokeMethod<String>('login');
      if (result == null || result.isEmpty) {
        return LoginResult(
            success: false, errorCode: 'EMPTY_CODE', errorMessage: '未获取到授权码');
      }
      return LoginResult(success: true, authCode: result);
    } on PlatformException catch (error) {
      return LoginResult(
          success: false, errorCode: error.code, errorMessage: error.message);
    } catch (e) {
      return LoginResult(
          success: false, errorCode: 'UNKNOWN_ERROR', errorMessage: e.toString());
    }
  }
}
