import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';

void main() {
  group('withOAuth2CallbackSession', () {
    test('closes the session after a successful operation', () async {
      final session = _FakeOAuth2CallbackSession();
      final result = await withOAuth2CallbackSession(
        _FakeOAuth2CallbackClient(session),
        (_) async => 'complete',
      );

      expect(result, 'complete');
      expect(session.closed, isTrue);
    });

    test('closes the session after an operation failure', () async {
      final session = _FakeOAuth2CallbackSession();

      await expectLater(
        withOAuth2CallbackSession(
          _FakeOAuth2CallbackClient(session),
          (_) async => throw StateError('authorization failed'),
        ),
        throwsStateError,
      );
      expect(session.closed, isTrue);
    });
  });
}

final class _FakeOAuth2CallbackClient implements OAuth2CallbackClient {
  const _FakeOAuth2CallbackClient(this.session);

  final OAuth2CallbackSession session;

  @override
  bool get canCreateSession => true;

  @override
  Future<OAuth2CallbackSession> createSession() async => session;

  @override
  Future<void> initialize() async {}
}

final class _FakeOAuth2CallbackSession implements OAuth2CallbackSession {
  bool closed = false;

  @override
  String get redirectUrl => 'https://syncs.tv/oauth2/callback';

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async => OAuth2CallbackPayload(code: 'code', state: expectedState);

  @override
  Future<void> close() async {
    closed = true;
  }
}
