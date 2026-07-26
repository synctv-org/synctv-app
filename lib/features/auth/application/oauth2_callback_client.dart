import 'package:synctv_app/contracts/account_models.dart';

abstract interface class OAuth2CallbackClient {
  bool get canCreateSession;

  Future<void> initialize();

  Future<OAuth2CallbackSession> createSession();
}

abstract interface class OAuth2CallbackSession {
  String get redirectUrl;

  Future<OAuth2CallbackPayload> waitForCallback({
    required String expectedState,
    Duration timeout = const Duration(minutes: 5),
  });

  Future<void> close();
}
