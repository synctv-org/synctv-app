import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';

void main() {
  group('withOAuth2CallbackSession', () {
    test('returns the result from a successful operation', () async {
      final session = _FakeOAuth2CallbackSession('first');
      final client = _FakeOAuth2CallbackClient([session]);

      final result = await withOAuth2CallbackSession(
        client,
        (_) async => 'complete',
      );

      expect(result, 'complete');
      expect(client.createCount, 1);
      expect(session.closeCount, 1);
    });

    test('preserves ordinary operation failures without retrying', () async {
      final session = _FakeOAuth2CallbackSession('first');
      final client = _FakeOAuth2CallbackClient([session]);

      await expectLater(
        withOAuth2CallbackSession(
          client,
          (_) async => throw StateError('authorization failed'),
        ),
        throwsStateError,
      );
      expect(client.createCount, 1);
      expect(session.closeCount, 1);
    });

    test('creates a fresh session after a callback bind failure', () async {
      final first = _FakeOAuth2CallbackSession('first');
      final second = _FakeOAuth2CallbackSession('second');
      final client = _FakeOAuth2CallbackClient([first, second]);
      var operationCount = 0;

      final result = await withOAuth2CallbackSession(client, (session) async {
        operationCount++;
        if (operationCount == 1) {
          throw const OAuth2CallbackBindFailed();
        }
        return session.redirectUrl;
      });

      expect(result, contains('second'));
      expect(client.createCount, 2);
      expect(first.closeCount, 1);
      expect(second.closeCount, 1);
    });

    test('stops retrying after the configured bind attempt limit', () async {
      final sessions = [
        _FakeOAuth2CallbackSession('first'),
        _FakeOAuth2CallbackSession('second'),
      ];
      final client = _FakeOAuth2CallbackClient(sessions);

      await expectLater(
        withOAuth2CallbackSession(
          client,
          (_) async => throw const OAuth2CallbackBindFailed(),
          maxBindAttempts: 2,
        ),
        throwsA(isA<OAuth2CallbackBindFailed>()),
      );
      expect(client.createCount, 2);
      for (final session in sessions) {
        expect(session.closeCount, 1);
      }
    });

    test('rejects an empty bind attempt budget', () async {
      final client = _FakeOAuth2CallbackClient([
        _FakeOAuth2CallbackSession('first'),
      ]);

      await expectLater(
        withOAuth2CallbackSession(
          client,
          (_) async => 'unused',
          maxBindAttempts: 0,
        ),
        throwsArgumentError,
      );
      expect(client.createCount, 0);
    });
  });
}

final class _FakeOAuth2CallbackClient implements OAuth2CallbackClient {
  _FakeOAuth2CallbackClient(this.sessions);

  final List<OAuth2CallbackSession> sessions;
  int createCount = 0;

  @override
  bool get canCreateSession => true;

  @override
  Future<OAuth2CallbackSession> createSession() async {
    return sessions[createCount++];
  }
}

final class _FakeOAuth2CallbackSession implements OAuth2CallbackSession {
  _FakeOAuth2CallbackSession(this.name);

  final String name;
  int closeCount = 0;

  @override
  String get redirectUrl => 'https://syncs.tv/oauth2/callback?session=$name';

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async => OAuth2CallbackPayload(code: 'code', state: expectedState);

  @override
  Future<void> close() async {
    closeCount++;
  }
}
