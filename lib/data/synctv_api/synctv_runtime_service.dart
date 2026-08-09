import 'dart:async';

import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class SyncTvRuntimeService {
  SyncTvRuntimeService() : session = SyncTvSession() {
    sessionStore = SyncTvSessionStore(session);
    _api = _createClient(SyncTvSessionStore.clientBootstrapBaseUrl);
  }

  final SyncTvSession session;
  late final SyncTvSessionStore sessionStore;
  late SyncTvApiClient _api;
  final StreamController<void> _authErrorController =
      StreamController<void>.broadcast();
  final Set<({SyncTvApiClient source, int generation})> _authErrorsInFlight =
      {};

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
  bool get allowInsecureTls => activeServer?.allowInsecureTls == true;
  String? get guestRoomId => sessionStore.guestRoomId;
  bool get isGuestSession => sessionStore.isGuestSession;

  Future<void> init() async {
    await sessionStore.load();
    _api = _createClient(
      sessionStore.baseUrl.isEmpty
          ? SyncTvSessionStore.clientBootstrapBaseUrl
          : sessionStore.baseUrl,
      allowInsecureTls: allowInsecureTls,
    );
    await _promotePendingActiveServer();
  }

  Future<void> setBaseUrl(String url) async {
    _api.configureServer(url, allowInsecureTls: false);
    await sessionStore.setBaseUrl(_api.baseUrl);
  }

  Future<SyncTvServerProfile> addServer(
    String url, {
    bool allowInsecureTls = false,
  }) async {
    final serverClient = _createClient(url, allowInsecureTls: allowInsecureTls);
    try {
      final info = await serverClient.publicService.getServerInfo(
        client.GetServerInfoRequest(),
      );
      final declaredServerId = info.serverId.trim();
      _api.configureServer(
        serverClient.baseUrl,
        allowInsecureTls: allowInsecureTls,
      );
      return sessionStore.addOrUpdateServer(
        declaredServerId: declaredServerId,
        name: info.serverName,
        endpoint: serverClient.baseUrl,
        allowInsecureTls: allowInsecureTls,
      );
    } finally {
      serverClient.close();
    }
  }

  Future<void> activateServer(String endpoint) async {
    final normalized = ServerEndpointIdentity.normalize(endpoint);
    if (!servers.any((server) => server.endpoint == normalized)) {
      throw ArgumentError.value(endpoint, 'endpoint', 'Unknown server');
    }
    final target = servers.firstWhere(
      (server) => server.endpoint == normalized,
    );
    _api.configureServer(normalized, allowInsecureTls: target.allowInsecureTls);
    await sessionStore.activateServer(normalized);
  }

  Future<void> removeServer(String endpoint) async {
    final normalized = ServerEndpointIdentity.normalize(endpoint);
    if (activeServer?.endpoint == normalized) {
      final next = servers
          .where((server) => server.endpoint != normalized)
          .firstOrNull;
      _api.configureServer(
        next?.endpoint ?? SyncTvSessionStore.clientBootstrapBaseUrl,
        allowInsecureTls: next?.allowInsecureTls == true,
      );
    }
    await sessionStore.removeServer(normalized);
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
        _handleCurrentAuthError();
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
        return true;
      }
      _handleCurrentAuthError();
      return false;
    }
    _handleCurrentAuthError();
    return false;
  }

  String resolveResourceUrl(String url) => _api.resolveResourceUrl(url);

  Future<void> logout() async {
    final generation = _api.endpointGeneration;
    await _api.user.logout(client.LogoutRequest());
    if (!_api.isEndpointGenerationCurrent(generation)) {
      throw const SyncTvStaleEndpointException();
    }
    await sessionStore.clearGuestContextAndPersist();
  }

  Future<void> closeAccount() async {
    final generation = _api.endpointGeneration;
    await _api.user.closeAccount(client.CloseAccountRequest());
    if (!_api.isEndpointGenerationCurrent(generation)) {
      throw const SyncTvStaleEndpointException();
    }
    await sessionStore.clearGuestContextAndPersist();
  }

  SyncTvApiClient _createClient(
    String baseUrl, {
    bool allowInsecureTls = false,
  }) {
    late final SyncTvApiClient api;
    api = SyncTvApiClient(
      baseUrl: baseUrl,
      allowInsecureTls: allowInsecureTls,
      session: session,
      onAuthError: (generation) => _handleAuthError(api, generation),
      onTokenRefresh: (generation) async {
        if (!identical(api, _api) ||
            !api.isEndpointGenerationCurrent(generation)) {
          throw const SyncTvStaleEndpointException();
        }
        await sessionStore.persistTokens();
      },
    );
    return api;
  }

  void _handleAuthError(SyncTvApiClient source, int generation) {
    if (!identical(source, _api) ||
        !source.isEndpointGenerationCurrent(generation)) {
      return;
    }
    final operation = (source: source, generation: generation);
    if (!_authErrorsInFlight.add(operation)) return;
    unawaited(() async {
      try {
        if (!identical(source, _api) ||
            !source.isEndpointGenerationCurrent(generation)) {
          return;
        }
        await sessionStore.clearSessionAndPersist();
        if (identical(source, _api) &&
            source.isEndpointGenerationCurrent(generation)) {
          _authErrorController.add(null);
        }
      } finally {
        _authErrorsInFlight.remove(operation);
      }
    }());
  }

  void _handleCurrentAuthError() {
    _handleAuthError(_api, _api.endpointGeneration);
  }

  Future<void> _promotePendingActiveServer() async {
    final active = sessionStore.activeServer;
    if (active == null || !active.isPending) return;
    try {
      final info = await _api.publicService.getServerInfo(
        client.GetServerInfoRequest(),
      );
      final declaredServerId = info.serverId.trim();
      if (declaredServerId.isEmpty) return;
      await sessionStore.addOrUpdateServer(
        declaredServerId: declaredServerId,
        name: info.serverName,
        endpoint: _api.baseUrl,
        allowInsecureTls: active.allowInsecureTls,
      );
      _api.configureServer(
        sessionStore.baseUrl,
        allowInsecureTls: active.allowInsecureTls,
      );
    } catch (_) {
      // Keep the pending profile usable offline; the next successful launch or
      // manual server edit can promote it to the server-provided identity.
    }
  }
}
