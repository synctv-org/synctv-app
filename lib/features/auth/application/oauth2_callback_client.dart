import 'package:synctv_app/contracts/account_models.dart';

abstract interface class OAuth2CallbackClient {
  bool get canCreateSession;

  Future<void> initialize();

  Future<OAuth2CallbackSession> createSession();
}

abstract interface class OAuth2CallbackSession {
  String get redirectUrl;

  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  });

  Future<void> close();
}

Future<T> withOAuth2CallbackSession<T>(
  OAuth2CallbackClient client,
  Future<T> Function(OAuth2CallbackSession session) operation,
) async {
  final session = await client.createSession();
  try {
    return await operation(session);
  } finally {
    await session.close();
  }
}

final class OAuth2AuthorizationCanceled implements Exception {
  const OAuth2AuthorizationCanceled();
}
