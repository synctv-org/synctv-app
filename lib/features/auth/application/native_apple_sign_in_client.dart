import 'package:synctv_app/contracts/account_models.dart';

abstract interface class NativeAppleSignInClient {
  bool get isSupported;

  Future<OAuth2CallbackPayload> authorize({
    required String expectedState,
    required String nonce,
  });
}
