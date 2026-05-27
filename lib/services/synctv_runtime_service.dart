import 'dart:async';

import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class SyncTvRuntimeService {
  SyncTvRuntimeService() : session = SyncTvSession() {
    sessionStore = SyncTvSessionStore(session);
    _api = _createClient(SyncTvSessionStore.defaultBaseUrl);
  }

  final SyncTvSession session;
  late final SyncTvSessionStore sessionStore;
  late SyncTvApiClient _api;
  final StreamController<void> _authErrorController =
      StreamController<void>.broadcast();

  SyncTvApiClient get api => _api;
  Stream<void> get onAuthError => _authErrorController.stream;
  String get baseUrl => sessionStore.baseUrl;
  String? get guestRoomId => sessionStore.guestRoomId;
  bool get isGuestSession => sessionStore.isGuestSession;

  Future<void> init() async {
    await sessionStore.load();
    _api = _createClient(sessionStore.baseUrl);
  }

  Future<void> setBaseUrl(String url) async {
    _api.baseUrl = url;
    await sessionStore.setBaseUrl(_api.baseUrl);
  }

  Future<String?> getToken() async => session.accessToken;

  String resolveResourceUrl(String url) => _api.resolveResourceUrl(url);

  Future<void> logout() async {
    await _api.user.logout(client.LogoutRequest());
    await sessionStore.clearGuestContextAndPersist();
  }

  Future<void> closeAccount() async {
    await _api.user.closeAccount(client.CloseAccountRequest());
    await sessionStore.clearGuestContextAndPersist();
  }

  Stream<client.ServerMessage> connectRoomMessageStream(
    String roomId,
    Stream<client.ClientMessage> messages, {
    Duration? timeout,
  }) {
    return _api.messageStream(roomId, messages, timeout: timeout);
  }

  SyncTvApiClient _createClient(String baseUrl) {
    return SyncTvApiClient(
      baseUrl: baseUrl,
      session: session,
      onAuthError: () => _authErrorController.add(null),
      onTokenRefresh: sessionStore.persistTokens,
    );
  }
}
