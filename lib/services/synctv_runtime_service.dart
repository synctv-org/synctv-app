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
  bool _isHandlingAuthError = false;

  SyncTvApiClient get api => _api;
  Stream<void> get onAuthError => _authErrorController.stream;
  String get baseUrl => sessionStore.baseUrl;
  bool get hasRecoverableSession =>
      session.hasAccessToken ||
      (!session.isGuest &&
          session.refreshToken != null &&
          session.refreshToken!.isNotEmpty);
  List<SyncTvServerProfile> get servers =>
      List.unmodifiable(sessionStore.servers);
  SyncTvServerProfile? get activeServer => sessionStore.activeServer;
  String? get guestRoomId => sessionStore.guestRoomId;
  bool get isGuestSession => sessionStore.isGuestSession;

  Future<void> init() async {
    await sessionStore.load();
    _api = _createClient(sessionStore.baseUrl);
    await _promotePendingActiveServer();
  }

  Future<void> setBaseUrl(String url) async {
    _api.baseUrl = url;
    await sessionStore.setBaseUrl(_api.baseUrl);
  }

  Future<SyncTvServerProfile> addServer(String url) async {
    final probe = _createClient(url);
    final info =
        await probe.publicService.getServerInfo(client.GetServerInfoRequest());
    final serverId = info.serverId.trim();
    if (serverId.isEmpty) {
      throw SyncTvApiException(
        '服务器未返回 server_id',
        statusCode: 500,
      );
    }
    final profile = await sessionStore.addOrUpdateServer(
      serverId: serverId,
      name: info.serverName,
      endpoint: probe.baseUrl,
    );
    _api.baseUrl = sessionStore.baseUrl;
    return profile;
  }

  Future<void> activateServer(String serverId) async {
    await sessionStore.activateServer(serverId);
    _api.baseUrl = sessionStore.baseUrl;
  }

  Future<void> activateServerEndpoint(String serverId, String endpoint) async {
    await sessionStore.activateServerEndpoint(serverId, endpoint);
    _api.baseUrl = sessionStore.baseUrl;
  }

  Future<void> removeServer(String serverId) async {
    await sessionStore.removeServer(serverId);
    _api.baseUrl = sessionStore.baseUrl;
  }

  Future<String?> getToken() async => session.accessToken;

  Object? encodeRealtimeJson(client.ClientMessage message) {
    return _api.protoJson(message);
  }

  client.ServerMessage decodeRealtimeJson(Object? decoded) {
    return _api.decodeProtoJson(decoded, client.ServerMessage.create);
  }

  Future<Uri> createRoomWebSocketUri(String roomId) async {
    if (!hasRecoverableSession) {
      throw SyncTvApiException('登录状态已失效', statusCode: 401);
    }
    try {
      final ticket = await _api.room.createWebSocketTicket(
        client.CreateWebSocketTicketRequest(roomId: roomId),
      );
      return _api.roomWebSocketUri(roomId, ticket: ticket.ticket);
    } on SyncTvApiException catch (e) {
      if (e.statusCode == 401) {
        _handleAuthError();
      }
      rethrow;
    }
  }

  Future<bool> ensureAuthenticated() async {
    if (session.isGuest) return session.hasAccessToken;
    if (session.hasAccessToken) return true;
    if (session.refreshToken != null && session.refreshToken!.isNotEmpty) {
      final refreshed = await _api.refreshAccessTokenIfPossible();
      if (refreshed) {
        await sessionStore.persistTokens();
        return true;
      }
      _handleAuthError();
      return false;
    }
    _handleAuthError();
    return false;
  }

  String resolveResourceUrl(String url) => _api.resolveResourceUrl(url);

  Future<void> logout() async {
    await _api.user.logout(client.LogoutRequest());
    await sessionStore.clearGuestContextAndPersist();
  }

  Future<void> closeAccount() async {
    await _api.user.closeAccount(client.CloseAccountRequest());
    await sessionStore.clearGuestContextAndPersist();
  }

  SyncTvApiClient _createClient(String baseUrl) {
    return SyncTvApiClient(
      baseUrl: baseUrl,
      session: session,
      onAuthError: _handleAuthError,
      onTokenRefresh: sessionStore.persistTokens,
    );
  }

  void _handleAuthError() {
    if (_isHandlingAuthError) return;
    _isHandlingAuthError = true;
    unawaited(() async {
      try {
        await sessionStore.clearSessionAndPersist();
        _authErrorController.add(null);
      } finally {
        _isHandlingAuthError = false;
      }
    }());
  }

  Future<void> _promotePendingActiveServer() async {
    final active = sessionStore.activeServer;
    if (active == null || !active.isPending) return;
    try {
      final info =
          await _api.publicService.getServerInfo(client.GetServerInfoRequest());
      final serverId = info.serverId.trim();
      if (serverId.isEmpty) return;
      await sessionStore.addOrUpdateServer(
        serverId: serverId,
        name: info.serverName,
        endpoint: _api.baseUrl,
      );
      _api.baseUrl = sessionStore.baseUrl;
    } catch (_) {
      // Keep the pending profile usable offline; the next successful launch or
      // manual server edit can promote it to the server-provided identity.
    }
  }
}
