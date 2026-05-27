import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hwlogin_method_channel.dart';
import 'login_result.dart';

abstract class HwloginPlatform extends PlatformInterface {
  /// Constructs a HwloginPlatform.
  HwloginPlatform() : super(token: _token);

  static final Object _token = Object();

  static HwloginPlatform _instance = MethodChannelHwlogin();

  /// The default instance of [HwloginPlatform] to use.
  ///
  /// Defaults to [MethodChannelHwlogin].
  static HwloginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HwloginPlatform] when
  /// they register themselves.
  static set instance(HwloginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPhone() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<LoginResult> login() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
