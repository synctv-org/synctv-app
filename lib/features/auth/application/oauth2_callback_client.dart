import 'package:synctv_app/contracts/account_models.dart';

abstract interface class OAuth2CallbackDispatcher {
  void dispatch();
}

const oauth2WebCallbackMessageKey = 'flutter-web-auth-2';
const _oauth2WebCallbackStoragePrefix = 'synctv-oauth2-callback:';

String oauth2WebCallbackStorageKey(String state) =>
    '$_oauth2WebCallbackStoragePrefix$state';

abstract interface class OAuth2CallbackClient {
  bool get canCreateSession;

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
  Future<T> Function(OAuth2CallbackSession session) operation, {
  int maxBindAttempts = oauth2CallbackBindMaxAttempts,
}) async {
  if (maxBindAttempts < 1) {
    throw ArgumentError.value(maxBindAttempts, 'maxBindAttempts');
  }

  var attempt = 0;
  while (true) {
    attempt++;
    OAuth2CallbackSession? session;
    try {
      session = await client.createSession();
      return await operation(session);
    } on OAuth2CallbackBindFailed {
      if (attempt >= maxBindAttempts) rethrow;
    } finally {
      await session?.close();
    }
  }
}

const int oauth2CallbackBindMaxAttempts = 3;
const Duration oauth2AuthorizationTimeout = Duration(minutes: 3);

final class OAuth2AuthorizationCanceled implements Exception {
  const OAuth2AuthorizationCanceled();
}

final class OAuth2AuthorizationTimedOut implements Exception {
  const OAuth2AuthorizationTimedOut();
}

final class OAuth2AuthorizationWindowBlocked implements Exception {
  const OAuth2AuthorizationWindowBlocked();

  @override
  String toString() =>
      'The browser blocked the OAuth2 authorization window. Allow pop-ups and try again.';
}

final class OAuth2CallbackBindFailed implements Exception {
  const OAuth2CallbackBindFailed([this.cause]);

  final Object? cause;

  @override
  String toString() => 'Failed to bind the OAuth2 callback listener: $cause';
}
