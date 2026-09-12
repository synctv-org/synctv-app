import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_runtime_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'failed expiry persistence still notifies and releases the operation guard',
    () async {
      final runtime = SyncTvRuntimeService(
        sessionStoreFactory: (session) => SyncTvSessionStore(
          session,
          preferencesLoader: () =>
              Future.error(StateError('storage unavailable')),
        ),
      );
      addTearDown(runtime.api.close);
      var notifications = 0;
      final subscription = runtime.onAuthError.listen((_) => notifications++);
      addTearDown(subscription.cancel);
      for (var attempt = 1; attempt <= 2; attempt++) {
        runtime.session.updateAccountTokens(accessToken: 'access-$attempt');
        runtime.api.onAuthError!(runtime.api.endpointGeneration);
        await Future<void>.delayed(Duration.zero);
        expect(runtime.session.identity, isA<AnonymousSessionIdentity>());
        expect(notifications, attempt);
      }
    },
  );

  test(
    'late persistence failure cannot invalidate replacement credentials',
    () async {
      final pending = Completer<SharedPreferences>();
      final runtime = SyncTvRuntimeService(
        sessionStoreFactory: (session) => SyncTvSessionStore(
          session,
          preferencesLoader: () => pending.future,
        ),
      );
      addTearDown(runtime.api.close);
      var notifications = 0;
      final subscription = runtime.onAuthError.listen((_) => notifications++);
      addTearDown(subscription.cancel);
      runtime.session.updateAccountTokens(accessToken: 'old-access');
      runtime.api.onAuthError!(runtime.api.endpointGeneration);
      runtime.session.updateAccountTokens(accessToken: 'new-access');
      pending.completeError(StateError('storage unavailable'));
      await Future<void>.delayed(Duration.zero);
      expect(runtime.session.accessToken, 'new-access');
      expect(notifications, 0);
    },
  );

  test('queued notifications recheck the session when delivered', () async {
    final runtime = SyncTvRuntimeService();
    addTearDown(runtime.api.close);
    final first = runtime.onAuthError.listen((_) {
      runtime.session.updateAccountTokens(accessToken: 'new-access');
    });
    addTearDown(first.cancel);
    var staleNotifications = 0;
    final second = runtime.onAuthError.listen((_) => staleNotifications++);
    addTearDown(second.cancel);
    runtime.session.updateAccountTokens(accessToken: 'old-access');
    runtime.api.onAuthError!(runtime.api.endpointGeneration);
    await Future<void>.delayed(Duration.zero);
    expect(runtime.session.accessToken, 'new-access');
    expect(staleNotifications, 0);
  });

  test(
    'delayed expiry notification does not target a replacement session',
    () async {
      final runtime = SyncTvRuntimeService();
      addTearDown(runtime.api.close);
      var notifications = 0;
      final subscription = runtime.onAuthError.listen((_) => notifications++);
      addTearDown(subscription.cancel);
      runtime.session.updateAccountTokens(accessToken: 'old-access');
      runtime.api.onAuthError!(runtime.api.endpointGeneration);
      expect(runtime.session.identity, isA<AnonymousSessionIdentity>());
      runtime.session.updateAccountTokens(accessToken: 'new-access');
      await Future<void>.delayed(Duration.zero);
      expect(runtime.session.accessToken, 'new-access');
      expect(notifications, 0);
    },
  );

  test(
    'expiry of a replacement session is not suppressed by old persistence',
    () async {
      final runtime = SyncTvRuntimeService();
      addTearDown(runtime.api.close);
      var notifications = 0;
      final subscription = runtime.onAuthError.listen((_) => notifications++);
      addTearDown(subscription.cancel);
      runtime.session.updateAccountTokens(accessToken: 'old-access');
      runtime.api.onAuthError!(runtime.api.endpointGeneration);
      runtime.session.updateAccountTokens(accessToken: 'new-access');
      runtime.api.onAuthError!(runtime.api.endpointGeneration);
      expect(runtime.session.identity, isA<AnonymousSessionIdentity>());
      await Future<void>.delayed(Duration.zero);
      expect(notifications, 1);
    },
  );

  test(
    'repeated expiry while clearing a session emits only one notification',
    () async {
      final runtime = SyncTvRuntimeService();
      addTearDown(runtime.api.close);
      var notifications = 0;
      final subscription = runtime.onAuthError.listen((_) => notifications++);
      addTearDown(subscription.cancel);
      runtime.session.updateAccountTokens(accessToken: 'access');
      runtime.api.onAuthError!(runtime.api.endpointGeneration);
      final clearedGeneration = runtime.session.generation;
      runtime.api.onAuthError!(runtime.api.endpointGeneration);
      expect(runtime.session.generation, clearedGeneration);
      await Future<void>.delayed(Duration.zero);
      expect(notifications, 1);
    },
  );
}
