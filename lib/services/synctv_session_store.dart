import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:synctv_app/services/synctv_api_client.dart';

class SyncTvServerProfile {
  SyncTvServerProfile({
    required this.serverId,
    required this.name,
    required List<String> endpoints,
    required this.activeEndpoint,
    this.lastSeenAt,
    this.sessionData = const SyncTvServerSessionData(),
  }) : endpoints = _uniqueNormalized(endpoints);

  final String serverId;
  final String name;
  final List<String> endpoints;
  final String activeEndpoint;
  final DateTime? lastSeenAt;
  final SyncTvServerSessionData sessionData;

  bool get isPending => serverId.startsWith('pending_');

  SyncTvServerProfile copyWith({
    String? name,
    List<String>? endpoints,
    String? activeEndpoint,
    DateTime? lastSeenAt,
    SyncTvServerSessionData? sessionData,
  }) {
    final nextEndpoints = endpoints == null
        ? List<String>.from(this.endpoints)
        : _uniqueNormalized(endpoints);
    final nextActiveEndpoint = SyncTvApiClient.normalizeBaseUrl(
      activeEndpoint ?? this.activeEndpoint,
    );
    if (!nextEndpoints.contains(nextActiveEndpoint)) {
      nextEndpoints.add(nextActiveEndpoint);
    }
    return SyncTvServerProfile(
      serverId: serverId,
      name: name ?? this.name,
      endpoints: nextEndpoints,
      activeEndpoint: nextActiveEndpoint,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      sessionData: sessionData ?? this.sessionData,
    );
  }

  Map<String, dynamic> toJson() => {
        'server_id': serverId,
        'name': name,
        'endpoints': endpoints,
        'active_endpoint': activeEndpoint,
        'session': sessionData.toJson(),
        if (lastSeenAt != null) 'last_seen_at': lastSeenAt!.toIso8601String(),
      };

  static SyncTvServerProfile fromJson(Map<String, dynamic> json) {
    final endpoints = (json['endpoints'] as List? ?? const [])
        .map((entry) => entry.toString())
        .where((entry) => entry.trim().isNotEmpty)
        .toList();
    final activeEndpoint = (json['active_endpoint'] as String?) ??
        (endpoints.isNotEmpty
            ? endpoints.first
            : SyncTvSessionStore.defaultBaseUrl);
    return SyncTvServerProfile(
      serverId: json['server_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      endpoints: endpoints.isEmpty ? [activeEndpoint] : endpoints,
      activeEndpoint: activeEndpoint,
      lastSeenAt: DateTime.tryParse(json['last_seen_at']?.toString() ?? ''),
      sessionData: SyncTvServerSessionData.fromJson(
        (json['session'] as Map?) ?? const {},
      ),
    );
  }

  static List<String> _uniqueNormalized(List<String> values) {
    final result = <String>[];
    for (final value in values) {
      if (value.trim().isEmpty) continue;
      final normalized = SyncTvApiClient.normalizeBaseUrl(value);
      if (!result.contains(normalized)) result.add(normalized);
    }
    return result;
  }
}

class SyncTvSessionStore {
  SyncTvSessionStore(this.session);

  static const String tokenKey = 'synctv_token';
  static const String refreshTokenKey = 'synctv_refresh_token';
  static const String guestTokenKey = 'synctv_guest_token';
  static const String guestRoomKey = 'synctv_guest_room_id';
  static const String guestDisplayNameKey = 'synctv_guest_display_name';
  static const String baseUrlKey = 'synctv_base_url';
  static const String defaultBaseUrl = String.fromEnvironment(
    'SYNCTV_DEFAULT_SERVER_URL',
    defaultValue: 'http://127.0.0.1:8080',
  );
  static const String serversKey = 'synctv_servers_v1';
  static const String activeServerKey = 'synctv_active_server_id_v1';

  final SyncTvSession session;

  String baseUrl = defaultBaseUrl;
  String? guestRoomId;
  String? guestDisplayName;
  List<SyncTvServerProfile> servers = [];
  String? activeServerId;

  bool get isGuestSession => session.isGuest;
  SyncTvServerProfile? get activeServer => _serverById(activeServerId);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    servers = _decodeServers(prefs.getString(serversKey));
    activeServerId = prefs.getString(activeServerKey);

    final legacyBaseUrl = prefs.getString(baseUrlKey);
    if (servers.isEmpty) {
      final endpoint = legacyBaseUrl ?? defaultBaseUrl;
      final fallback = _fallbackProfile(endpoint);
      servers = [fallback];
      activeServerId = fallback.serverId;
      await _persistServers(prefs);
    } else if (_serverById(activeServerId) == null) {
      activeServerId = servers.first.serverId;
      await prefs.setString(activeServerKey, activeServerId!);
    }

    baseUrl = activeServer?.activeEndpoint ?? defaultBaseUrl;
    _loadSessionFromPrefs(prefs);
  }

  Future<SyncTvServerProfile> addOrUpdateServer({
    required String serverId,
    required String name,
    required String endpoint,
    bool activate = true,
  }) async {
    final normalizedEndpoint = SyncTvApiClient.normalizeBaseUrl(endpoint);
    final resolvedName = name.trim().isEmpty ? normalizedEndpoint : name.trim();
    final current = activeServer;
    final shouldCarryCurrentSession = activate &&
        current != null &&
        _isFallbackServerId(current.serverId) &&
        current.activeEndpoint == normalizedEndpoint;
    final existingIndex =
        servers.indexWhere((server) => server.serverId == serverId);
    final now = DateTime.now().toUtc();
    late final SyncTvServerProfile profile;
    if (existingIndex >= 0) {
      final existing = servers[existingIndex];
      profile = existing.copyWith(
        name: resolvedName,
        endpoints: [...existing.endpoints, normalizedEndpoint],
        activeEndpoint: normalizedEndpoint,
        lastSeenAt: now,
        sessionData: shouldCarryCurrentSession
            ? _currentSessionData()
            : existing.sessionData,
      );
      servers[existingIndex] = profile;
    } else {
      profile = SyncTvServerProfile(
        serverId: serverId,
        name: resolvedName,
        endpoints: [normalizedEndpoint],
        activeEndpoint: normalizedEndpoint,
        lastSeenAt: now,
        sessionData: shouldCarryCurrentSession
            ? _currentSessionData()
            : const SyncTvServerSessionData(),
      );
      servers.add(profile);
    }

    if (activate) {
      if (!shouldCarryCurrentSession) {
        _captureSessionToActiveServer();
      }
      activeServerId = profile.serverId;
      baseUrl = profile.activeEndpoint;
      _loadProfileSession(profile);
      _removeEmptyPendingServers(exceptServerId: profile.serverId);
    }

    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
    await persistTokens();
    return profile;
  }

  Future<void> setBaseUrl(String normalizedBaseUrl) async {
    final endpoint = SyncTvApiClient.normalizeBaseUrl(normalizedBaseUrl);
    baseUrl = endpoint;
    final current = activeServer;
    if (current == null) {
      final fallback = _fallbackProfile(endpoint);
      servers = [fallback];
      activeServerId = fallback.serverId;
    } else {
      final index =
          servers.indexWhere((server) => server.serverId == current.serverId);
      servers[index] = current.copyWith(activeEndpoint: endpoint);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(baseUrlKey, baseUrl);
    await _persistServers(prefs);
  }

  Future<void> activateServer(String serverId) async {
    final target = _serverById(serverId);
    if (target == null) {
      throw ArgumentError.value(serverId, 'serverId', 'Unknown server');
    }
    _captureSessionToActiveServer();
    activeServerId = target.serverId;
    baseUrl = target.activeEndpoint;
    _loadProfileSession(target);
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
    await persistTokens();
  }

  Future<void> activateServerEndpoint(String serverId, String endpoint) async {
    final normalizedEndpoint = SyncTvApiClient.normalizeBaseUrl(endpoint);
    final target = _serverById(serverId);
    if (target == null) {
      throw ArgumentError.value(serverId, 'serverId', 'Unknown server');
    }
    if (!target.endpoints.contains(normalizedEndpoint)) {
      throw ArgumentError.value(
        normalizedEndpoint,
        'endpoint',
        'Unknown endpoint',
      );
    }
    _captureSessionToActiveServer();
    final index = servers.indexWhere((server) => server.serverId == serverId);
    final updated = target.copyWith(activeEndpoint: normalizedEndpoint);
    servers[index] = updated;
    activeServerId = updated.serverId;
    baseUrl = updated.activeEndpoint;
    _loadProfileSession(updated);
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
    await persistTokens();
  }

  Future<void> removeServer(String serverId) async {
    final index = servers.indexWhere((server) => server.serverId == serverId);
    if (index < 0 || servers.length == 1) return;
    servers.removeAt(index);
    if (activeServerId == serverId) {
      activeServerId = servers.first.serverId;
      baseUrl = servers.first.activeEndpoint;
      _loadProfileSession(servers.first);
    }
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
    await persistTokens();
  }

  Future<void> persistTokens() async {
    _captureSessionToActiveServer();
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
    await prefs.setString(baseUrlKey, baseUrl);

    await prefs.remove(tokenKey);
    await prefs.remove(refreshTokenKey);
    await prefs.remove(guestTokenKey);
    await prefs.remove(guestRoomKey);
    await prefs.remove(guestDisplayNameKey);
  }

  Future<void> clearGuestContextAndPersist() async {
    guestRoomId = null;
    guestDisplayName = null;
    await persistTokens();
  }

  Future<void> activateGuest({
    required String accessToken,
    required String roomId,
    required String displayName,
  }) async {
    session.accessToken = accessToken;
    session.refreshToken = null;
    session.isGuest = true;
    guestRoomId = roomId;
    guestDisplayName = displayName;
    await persistTokens();
  }

  SyncTvServerProfile? _serverById(String? serverId) {
    if (serverId == null || serverId.isEmpty) return null;
    for (final server in servers) {
      if (server.serverId == serverId) return server;
    }
    return null;
  }

  SyncTvServerProfile _fallbackProfile(String endpoint) {
    final normalized = SyncTvApiClient.normalizeBaseUrl(endpoint);
    return SyncTvServerProfile(
      serverId: _fallbackServerId(normalized),
      name: '自定义服务器',
      endpoints: [normalized],
      activeEndpoint: normalized,
    );
  }

  String _fallbackServerId(String endpoint) =>
      'pending_${base64Url.encode(utf8.encode(endpoint)).replaceAll('=', '')}';

  List<SyncTvServerProfile> _decodeServers(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((entry) => SyncTvServerProfile.fromJson(
              entry.map((key, value) => MapEntry(key.toString(), value)),
            ))
        .where((server) => server.serverId.isNotEmpty)
        .toList();
  }

  Future<void> _persistServers(SharedPreferences prefs) async {
    await prefs.setString(
      serversKey,
      jsonEncode(servers.map((server) => server.toJson()).toList()),
    );
    if (activeServerId != null) {
      await prefs.setString(activeServerKey, activeServerId!);
    }
  }

  void _loadSessionFromPrefs(SharedPreferences prefs) {
    final current = activeServer;
    if (current != null && !_isFallbackServerId(current.serverId)) {
      _loadProfileSession(current);
      return;
    }

    final guestToken = prefs.getString(guestTokenKey);
    if (guestToken != null && guestToken.isNotEmpty) {
      session.accessToken = guestToken;
      session.refreshToken = null;
      session.isGuest = true;
      guestRoomId = prefs.getString(guestRoomKey);
      guestDisplayName = prefs.getString(guestDisplayNameKey);
      return;
    }

    session.accessToken =
        prefs.getString(tokenKey) ?? prefs.getString('synctv_access_token');
    session.refreshToken = prefs.getString(refreshTokenKey);
    session.isGuest = false;
    guestRoomId = null;
    guestDisplayName = null;
  }

  void _loadProfileSession(SyncTvServerProfile profile) {
    final data = _serverSessionData(profile);
    session.accessToken = data.accessToken;
    session.refreshToken = data.refreshToken;
    session.isGuest = data.isGuest;
    guestRoomId = data.guestRoomId;
    guestDisplayName = data.guestDisplayName;
  }

  void _captureSessionToActiveServer() {
    final current = activeServer;
    if (current == null) return;
    final index =
        servers.indexWhere((server) => server.serverId == current.serverId);
    if (index < 0) return;
    final data = _currentSessionData();
    servers[index] = current.copyWith(sessionData: data);
    _serverSessions[current.serverId] = data;
  }

  SyncTvServerSessionData _currentSessionData() {
    return SyncTvServerSessionData(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      isGuest: session.isGuest,
      guestRoomId: guestRoomId,
      guestDisplayName: guestDisplayName,
    );
  }

  bool _isFallbackServerId(String serverId) => serverId.startsWith('pending_');

  void _removeEmptyPendingServers({required String exceptServerId}) {
    servers = servers.where((server) {
      if (server.serverId == exceptServerId || !server.isPending) return true;
      return server.sessionData.hasCredentials;
    }).toList();
  }

  final Map<String, SyncTvServerSessionData> _serverSessions = {};

  SyncTvServerSessionData _serverSessionData(SyncTvServerProfile profile) {
    final cached = _serverSessions[profile.serverId];
    if (cached != null) return cached;
    return profile.sessionData;
  }
}

class SyncTvServerSessionData {
  const SyncTvServerSessionData({
    this.accessToken,
    this.refreshToken,
    this.isGuest = false,
    this.guestRoomId,
    this.guestDisplayName,
  });

  final String? accessToken;
  final String? refreshToken;
  final bool isGuest;
  final String? guestRoomId;
  final String? guestDisplayName;

  bool get hasCredentials =>
      (accessToken?.isNotEmpty ?? false) ||
      (refreshToken?.isNotEmpty ?? false) ||
      (guestRoomId?.isNotEmpty ?? false) ||
      (guestDisplayName?.isNotEmpty ?? false);

  Map<String, dynamic> toJson() => {
        if (accessToken != null) 'access_token': accessToken,
        if (refreshToken != null) 'refresh_token': refreshToken,
        'is_guest': isGuest,
        if (guestRoomId != null) 'guest_room_id': guestRoomId,
        if (guestDisplayName != null) 'guest_display_name': guestDisplayName,
      };

  static SyncTvServerSessionData fromJson(Map<dynamic, dynamic> json) {
    return SyncTvServerSessionData(
      accessToken: json['access_token']?.toString(),
      refreshToken: json['refresh_token']?.toString(),
      isGuest: json['is_guest'] == true,
      guestRoomId: json['guest_room_id']?.toString(),
      guestDisplayName: json['guest_display_name']?.toString(),
    );
  }
}
