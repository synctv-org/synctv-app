import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

void main() {
  for (final connected in [false, true]) {
    test(
      'old event stream cannot invalidate or update a new session, connected=$connected',
      () async {
        final started = Completer<void>();
        final response = Completer<http.StreamedResponse>();
        final events = StreamController<List<int>>.broadcast();
        final session = SyncTvSession()
          ..updateAccountTokens(accessToken: 'old-access');
        var authErrors = 0;
        final api = SyncTvApiClient(
          baseUrl: 'https://example.test',
          session: session,
          onAuthError: (_) => authErrors++,
          httpClient: MockClient.streaming((_, _) {
            started.complete();
            return response.future;
          }),
        );
        final stream = api.room.watchRoomSettings(
          'room-1',
          client.WatchRoomSettingsRequest(),
        );
        final result = expectLater(
          stream,
          emitsError(isA<SyncTvStaleSessionException>()),
        );
        await started.future;
        if (connected) {
          response.complete(
            http.StreamedResponse(
              events.stream,
              200,
              headers: {'content-type': 'text/event-stream'},
            ),
          );
          await Future<void>.delayed(Duration.zero);
        }
        session.updateAccountTokens(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );
        if (connected) {
          events.add(utf8.encode('data: {}\n\n'));
        } else {
          response.complete(http.StreamedResponse(const Stream.empty(), 401));
        }
        await result;
        await events.close();
        expect(authErrors, 0);
        expect(session.accessToken, 'new-access');
      },
    );
  }

  for (final status in [200, 401, 500, null]) {
    test(
      'old logout preserves a replacement session, response=$status',
      () async {
        final response = Completer<http.Response>();
        final started = Completer<void>();
        final session = SyncTvSession()
          ..updateAccountTokens(
            accessToken: 'old-access',
            refreshToken: 'old-refresh',
          );
        var requests = 0;
        var authErrors = 0;
        final api = SyncTvApiClient(
          baseUrl: 'https://example.test',
          session: session,
          onAuthError: (_) => authErrors++,
          httpClient: MockClient((request) {
            requests++;
            expect(request.headers['authorization'], 'Bearer old-access');
            started.complete();
            return response.future;
          }),
        );
        final logout = api.user.logout(client.LogoutRequest());
        final result = expectLater(
          logout,
          throwsA(isA<SyncTvStaleSessionException>()),
        );
        await started.future;
        session.updateAccountTokens(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );
        if (status == null) {
          response.completeError(http.ClientException('connection lost'));
        } else {
          response.complete(_json({}, status));
        }
        await result;
        expect(session.accessToken, 'new-access');
        expect(session.refreshToken, 'new-refresh');
        expect(requests, 1);
        expect(authErrors, 0);
      },
    );
  }

  test(
    'logout still refreshes its own session and clears it after retry',
    () async {
      final session = SyncTvSession()
        ..updateAccountTokens(
          accessToken: 'old-access',
          refreshToken: 'old-refresh',
        );
      var logouts = 0;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: session,
        httpClient: MockClient((request) async {
          if (request.url.path == '/api/auth/refresh') {
            return _json({
              'accessToken': 'fresh-access',
              'refreshToken': 'fresh-refresh',
            });
          }
          logouts++;
          if (logouts == 1) return _json({}, 401);
          expect(request.headers['authorization'], 'Bearer fresh-access');
          return _json({});
        }),
      );
      await api.user.logout(client.LogoutRequest());
      expect(logouts, 2);
      expect(session.identity, isA<AnonymousSessionIdentity>());
    },
  );

  for (final status in [200, 401]) {
    test(
      'old protected response is rejected without refreshing a new account, status=$status',
      () async {
        final response = Completer<http.Response>();
        final started = Completer<void>();
        final session = SyncTvSession()
          ..updateAccountTokens(accessToken: 'old-access');
        var requests = 0;
        var authErrors = 0;
        final api = SyncTvApiClient(
          baseUrl: 'https://example.test',
          session: session,
          onAuthError: (_) => authErrors++,
          httpClient: MockClient((_) {
            requests++;
            started.complete();
            return response.future;
          }),
        );
        final profile = api.user.getProfile(client.GetProfileRequest());
        final result = expectLater(
          profile,
          throwsA(isA<SyncTvStaleSessionException>()),
        );
        await started.future;
        session.updateAccountTokens(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );
        response.complete(_json({'id': 'old-user'}, status));
        await result;
        expect(requests, 1);
        expect(authErrors, 0);
        expect(session.accessToken, 'new-access');
      },
    );
  }

  test(
    'refresh requests are isolated across sessions on the same server',
    () async {
      final pending = <String, Completer<http.Response>>{};
      final session = SyncTvSession()
        ..updateAccountTokens(refreshToken: 'old-refresh');
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: session,
        httpClient: MockClient((request) {
          final token =
              (jsonDecode(request.body) as Map)['refreshToken'] as String;
          return (pending[token] = Completer<http.Response>()).future;
        }),
      );
      final oldRefresh = api.refreshAccessTokenIfPossible();
      final oldResult = expectLater(
        oldRefresh,
        throwsA(isA<SyncTvStaleSessionException>()),
      );
      await Future<void>.delayed(Duration.zero);
      session.updateAccountTokens(
        accessToken: 'new-access',
        refreshToken: 'new-refresh',
      );
      final newRefresh = api.refreshAccessTokenIfPossible();
      await Future<void>.delayed(Duration.zero);
      expect(pending.keys, containsAll(['old-refresh', 'new-refresh']));
      pending['new-refresh']!.complete(
        _json({'accessToken': 'new-fresh', 'refreshToken': 'new-rotated'}),
      );
      expect(await newRefresh, isTrue);
      pending['old-refresh']!.complete(
        _json({'accessToken': 'old-fresh', 'refreshToken': 'old-rotated'}),
      );
      await oldResult;
      expect(session.accessToken, 'new-fresh');
      expect(session.refreshToken, 'new-rotated');
    },
  );

  test('old account closure does not clear a new session', () async {
    final response = Completer<http.Response>();
    final session = SyncTvSession()
      ..updateAccountTokens(accessToken: 'old-access');
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: session,
      httpClient: MockClient((_) => response.future),
    );
    final close = api.user.closeAccount(client.CloseAccountRequest());
    final result = expectLater(
      close,
      throwsA(isA<SyncTvStaleSessionException>()),
    );
    await Future<void>.delayed(Duration.zero);
    session.activateGuest(
      accessToken: 'guest-access',
      roomId: 'room-1',
      displayName: 'Guest',
    );
    response.complete(_json({}));
    await result;
    expect(session.identity, isA<GuestSessionIdentity>());
    expect(session.accessToken, 'guest-access');
  });
}

http.Response _json(Map<String, Object?> body, [int status = 200]) =>
    http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json'},
    );
