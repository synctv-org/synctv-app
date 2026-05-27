import 'hwlogin_platform_interface.dart';
import 'login_result.dart';

class HwLogin {
  Future<String?> getPhone() {
    return HwloginPlatform.instance.getPhone();
  }

  Future<LoginResult> login() {
    return HwloginPlatform.instance.login();
  }
}
