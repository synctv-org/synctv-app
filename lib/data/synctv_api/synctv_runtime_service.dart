import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

typedef SyncTvServerInfoProbe =
    Future<client.GetServerInfoResponse> Function(SyncTvApiClient api);

class SyncTvRuntimeService {
  static const serverProbeTimeout = Duration(seconds: 8);

  SyncTvRuntimeService({this.serverInfoProbe, String? singleServerEndpoint})
    : _singleServerEndpoint = _resolveSingleServerEndpoint(
        singleServerEndpoint,
      ),
      session = SyncTvSession() {
    sessionStore = SyncTvSessionStore(session);
    _api = _createClient(SyncTvSessionStore.clientBootstrapBaseUrl);
  }

  final SyncTvSession session;
  final SyncTvServerInfoProbe? serverInfoProbe;
  final String? _singleServerEndpoint;
  late final SyncTvSessionStore sessionStore;
  late SyncTvApiClient _api;
  final StreamController<void> _authErrorController =
      StreamController<void>.broadcast();
  final Set<({SyncTvApiClient source, int generation})> _authErrorsInFlight =
      {};
  int _serverSelectionRevision = 0;

  SyncTvApiClient get api => _api;
  Stream<void> get onAuthError => _authErrorController.stream;
  String get baseUrl => sessionStore.baseUrl;
  bool get hasRecoverableSession => session.hasRecoverableCredentials;
  List<SyncTvServerProfile> get servers =>
      List.unmodifiable(sessionStore.servers);
  SyncTvServerProfile? get activeServer => sessionStore.activeServer;
  bool get allowInsecureTls => activeServer?.allowInsecureTls == true;
  String? get guestRoomId => sessionStore.guestSession?.roomId;
  SyncTvSessionIdentity get sessionIdentity => session.identity;
  bool get singleServerMode => _singleServerEndpoint != null;

  Future<void> init() async {
    await sessionStore.load();
    if (_singleServerEndpoint case final endpoint?) {
      await sessionStore.forceSingleServer(endpoint);
    }
    final previousApi = _api;
    _api = _createClient(
      sessionStore.baseUrl.isEmpty
          ? SyncTvSessionStore.clientBootstrapBaseUrl
          : sessionStore.baseUrl,
      allowInsecureTls: allowInsecureTls,
    );
    previousApi.close();
    final revision = ++_serverSelectionRevision;
    unawaited(_promotePendingActiveServer(revision));
  }

  Future<void> setBaseUrl(String url) async {
    _requireAllowedEndpoint(url);
    _serverSelectionRevision++;
    _api.configureServer(url, allowInsecureTls: false);
    await sessionStore.setBaseUrl(_api.baseUrl);
  }

  Future<SyncTvServerProfile> addServer(
    String url, {
    bool allowInsecureTls = false,
  }) async {
    _requireAllowedEndpoint(url, allowInsecureTls: allowInsecureTls);
    if (_singleServerEndpoint != null) {
      return sessionStore.forceSingleServer(_singleServerEndpoint);
    }
    final serverClient = _createClient(url, allowInsecureTls: allowInsecureTls);
    try {
      final info = await _getServerInfo(
        serverClient,
      ).timeout(serverProbeTimeout);
      final declaredServerId = info.serverId.trim();
      _serverSelectionRevision++;
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
    _requireAllowedEndpoint(endpoint);
    final normalized = ServerEndpointIdentity.normalize(endpoint);
    if (!servers.any((server) => server.endpoint == normalized)) {
      throw ArgumentError.value(endpoint, 'endpoint', 'Unknown server');
    }
    final target = servers.firstWhere(
      (server) => server.endpoint == normalized,
    );
    _serverSelectionRevision++;
    _api.configureServer(normalized, allowInsecureTls: target.allowInsecureTls);
    await sessionStore.activateServer(normalized);
  }

  Future<void> removeServer(String endpoint) async {
    if (_singleServerEndpoint != null) {
      throw UnsupportedError(
        'The deployment server cannot be removed in a browser.',
      );
    }
    final normalized = ServerEndpointIdentity.normalize(endpoint);
    if (activeServer?.endpoint == normalized) {
      _serverSelectionRevision++;
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
    return switch (session.identity) {
      GuestSessionIdentity() => true,
      AccountSessionIdentity(:final accessToken) when accessToken != null =>
        true,
      AccountSessionIdentity(:final refreshToken) when refreshToken != null =>
        await _refreshAccountSession(),
      AccountSessionIdentity() ||
      AnonymousSessionIdentity() => _expireCurrentSession(),
    };
  }

  Future<bool> refreshSessionAfterUnauthorized() async {
    return switch (session.identity) {
      AccountSessionIdentity() => await _refreshAccountSession(),
      GuestSessionIdentity() ||
      AnonymousSessionIdentity() => _expireCurrentSession(),
    };
  }

  Future<bool> _refreshAccountSession() async {
    final refreshed = await _api.refreshAccessTokenIfPossible();
    if (refreshed) return true;
    return _expireCurrentSession();
  }

  bool _expireCurrentSession() {
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
    await sessionStore.persistSession();
  }

  Future<void> closeAccount() async {
    final generation = _api.endpointGeneration;
    await _api.user.closeAccount(client.CloseAccountRequest());
    if (!_api.isEndpointGenerationCurrent(generation)) {
      throw const SyncTvStaleEndpointException();
    }
    await sessionStore.persistSession();
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
        await sessionStore.persistSession();
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

  Future<client.GetServerInfoResponse> _getServerInfo(SyncTvApiClient api) =>
      serverInfoProbe?.call(api) ??
      api.publicService.getServerInfo(client.GetServerInfoRequest());

  static String? _resolveSingleServerEndpoint(String? explicitEndpoint) {
    final endpoint = explicitEndpoint?.trim();
    if (endpoint != null && endpoint.isNotEmpty) {
      return ServerEndpointIdentity.normalize(endpoint);
    }
    if (!kIsWeb) return null;
    return ServerEndpointIdentity.normalize(Uri.base.origin);
  }

  void _requireAllowedEndpoint(
    String endpoint, {
    bool allowInsecureTls = false,
  }) {
    final fixed = _singleServerEndpoint;
    if (fixed == null) return;
    final normalized = ServerEndpointIdentity.normalize(endpoint);
    if (normalized != fixed || allowInsecureTls) {
      throw UnsupportedError(
        'Browser deployments can only use their page origin as the server.',
      );
    }
  }

  Future<void> _promotePendingActiveServer(int revision) async {
    final active = sessionStore.activeServer;
    if (active == null || !active.isPending) return;
    final endpoint = active.endpoint;
    final serverClient = _createClient(
      endpoint,
      allowInsecureTls: active.allowInsecureTls,
    );
    try {
      final info = await _getServerInfo(
        serverClient,
      ).timeout(serverProbeTimeout);
      final declaredServerId = info.serverId.trim();
      if (declaredServerId.isEmpty) return;
      if (revision != _serverSelectionRevision ||
          !servers.any((server) => server.endpoint == endpoint)) {
        return;
      }
      await sessionStore.addOrUpdateServer(
        declaredServerId: declaredServerId,
        name: info.serverName,
        endpoint: endpoint,
        allowInsecureTls: active.allowInsecureTls,
        activate: false,
      );
    } catch (_) {
      // Keep the pending profile usable offline; the next successful launch or
      // manual server edit can promote it to the server-provided identity.
    } finally {
      serverClient.close();
    }
  }
}
