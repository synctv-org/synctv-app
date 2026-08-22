import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';

class SyncTvServerProfile {
  SyncTvServerProfile({
    required this.endpoint,
    required this.declaredServerId,
    required this.name,
    this.isBuiltIn = false,
    this.allowInsecureTls = false,
    this.lastSeenAt,
    this.sessionData = const AnonymousServerSessionData(),
  });

  final String endpoint;
  final String declaredServerId;
  final String name;
  final bool isBuiltIn;
  final bool allowInsecureTls;
  final DateTime? lastSeenAt;
  final SyncTvServerSessionData sessionData;

  bool get isPending => declaredServerId.isEmpty;

  SyncTvServerProfile copyWith({
    String? declaredServerId,
    String? name,
    bool? isBuiltIn,
    bool? allowInsecureTls,
    DateTime? lastSeenAt,
    SyncTvServerSessionData? sessionData,
  }) {
    return SyncTvServerProfile(
      endpoint: endpoint,
      declaredServerId: declaredServerId ?? this.declaredServerId,
      name: name ?? this.name,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      allowInsecureTls: allowInsecureTls ?? this.allowInsecureTls,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      sessionData: sessionData ?? this.sessionData,
    );
  }

  Map<String, dynamic> toJson() => {
    'endpoint': endpoint,
    'declared_server_id': declaredServerId,
    'name': name,
    'is_built_in': isBuiltIn,
    'allow_insecure_tls': allowInsecureTls,
    'session': sessionData.toJson(),
    if (lastSeenAt != null) 'last_seen_at': lastSeenAt!.toIso8601String(),
  };

  static SyncTvServerProfile? fromJson(Map<String, dynamic> json) {
    final rawEndpoint = json['endpoint']?.toString().trim() ?? '';
    if (rawEndpoint.isEmpty) return null;
    try {
      final endpoint = ServerEndpointIdentity.normalize(rawEndpoint);
      return SyncTvServerProfile(
        endpoint: endpoint,
        declaredServerId: json['declared_server_id']?.toString().trim() ?? '',
        name: json['name']?.toString().trim() ?? endpoint,
        isBuiltIn: json['is_built_in'] == true,
        allowInsecureTls: json['allow_insecure_tls'] == true,
        lastSeenAt: DateTime.tryParse(json['last_seen_at']?.toString() ?? ''),
        sessionData: SyncTvServerSessionData.fromJson(
          (json['session'] as Map?) ?? const {},
        ),
      );
    } on FormatException {
      return null;
    }
  }
}

class SyncTvSessionStore {
  SyncTvSessionStore(this.session, {String? builtInServerUrl})
    : _builtInServerUrl = _normalizeOptionalBaseUrl(
        builtInServerUrl ?? SyncTvSessionStore.builtInServerUrl,
      ) {
    baseUrl = _builtInServerUrl;
  }

  static const String configuredBuiltInServerUrl = String.fromEnvironment(
    'SYNCTV_BUILT_IN_SERVER_URL',
    defaultValue: '',
  );
  static const String fallbackClientBaseUrl = 'http://127.0.0.1:8080';
  static const String serversKey = 'synctv.servers';
  static const String activeServerKey = 'synctv.active_server_endpoint';

  static String get builtInServerUrl => resolveBuiltInServerUrl(
    configuredUrl: configuredBuiltInServerUrl,
    debugMode: kDebugMode,
  );

  static String resolveBuiltInServerUrl({
    required String configuredUrl,
    required bool debugMode,
  }) {
    final value = configuredUrl.trim();
    if (value.isNotEmpty) return ServerEndpointIdentity.normalize(value);
    return debugMode ? fallbackClientBaseUrl : '';
  }

  static bool get hasBuiltInServer => builtInServerUrl.isNotEmpty;
  static String get initialClientBaseUrl =>
      hasBuiltInServer ? builtInServerUrl : '';
  static String get clientBootstrapBaseUrl =>
      hasBuiltInServer ? builtInServerUrl : fallbackClientBaseUrl;

  final SyncTvSession session;
  final String _builtInServerUrl;

  late String baseUrl;
  List<SyncTvServerProfile> servers = [];
  String? activeServerEndpoint;

  GuestSessionIdentity? get guestSession => switch (session.identity) {
    final GuestSessionIdentity identity => identity,
    AnonymousSessionIdentity() || AccountSessionIdentity() => null,
  };
  SyncTvServerProfile? get activeServer =>
      _serverByEndpoint(activeServerEndpoint);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    servers = _decodeServers(prefs.getString(serversKey));
    activeServerEndpoint = _normalizeStoredEndpoint(
      prefs.getString(activeServerKey),
    );
    var changed = _reconcileBuiltInServer();

    if (servers.isEmpty) {
      activeServerEndpoint = null;
      changed = true;
    } else if (_serverByEndpoint(activeServerEndpoint) == null) {
      activeServerEndpoint = servers.first.endpoint;
      changed = true;
    }

    baseUrl = activeServer?.endpoint ?? _builtInServerUrl;
    _loadSessionFromActiveServer();
    if (changed) await _persistServers(prefs);
  }

  Future<SyncTvServerProfile> forceSingleServer(String endpoint) async {
    final normalizedEndpoint = ServerEndpointIdentity.normalize(endpoint);
    _captureSessionToActiveServer();
    final existing = _serverByEndpoint(normalizedEndpoint);
    final profile =
        existing?.copyWith(isBuiltIn: true, allowInsecureTls: false) ??
        SyncTvServerProfile(
          endpoint: normalizedEndpoint,
          declaredServerId: '',
          name: normalizedEndpoint,
          isBuiltIn: true,
        );
    servers = [profile];
    activeServerEndpoint = normalizedEndpoint;
    baseUrl = normalizedEndpoint;
    _loadProfileSession(profile);
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
    return profile;
  }

  Future<SyncTvServerProfile> addOrUpdateServer({
    required String declaredServerId,
    required String name,
    required String endpoint,
    bool allowInsecureTls = false,
    bool activate = true,
  }) async {
    final normalizedEndpoint = ServerEndpointIdentity.normalize(endpoint);
    final existingIndex = servers.indexWhere(
      (server) => server.endpoint == normalizedEndpoint,
    );
    final current = activeServer;
    final carryCurrentSession =
        activate &&
        current?.endpoint == normalizedEndpoint &&
        current!.isPending;
    final existing = existingIndex < 0 ? null : servers[existingIndex];
    final profile = SyncTvServerProfile(
      endpoint: normalizedEndpoint,
      declaredServerId: declaredServerId.trim(),
      name: name.trim().isEmpty ? normalizedEndpoint : name.trim(),
      isBuiltIn:
          existing?.isBuiltIn == true || _isBuiltInEndpoint(normalizedEndpoint),
      allowInsecureTls: allowInsecureTls,
      lastSeenAt: DateTime.now().toUtc(),
      sessionData: carryCurrentSession
          ? _currentSessionData()
          : existing?.sessionData ?? const AnonymousServerSessionData(),
    );

    if (activate && current?.endpoint != normalizedEndpoint) {
      _captureSessionToActiveServer();
    }
    if (existingIndex < 0) {
      servers.add(profile);
    } else {
      servers[existingIndex] = profile;
    }
    if (activate) {
      activeServerEndpoint = normalizedEndpoint;
      baseUrl = normalizedEndpoint;
      _loadProfileSession(profile);
    }

    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
    return profile;
  }

  Future<void> setBaseUrl(String value) async {
    final rawEndpoint = value.trim();
    if (rawEndpoint.isEmpty) {
      _captureSessionToActiveServer();
      activeServerEndpoint = null;
      baseUrl = _builtInServerUrl;
      _clearInMemorySession();
      final prefs = await SharedPreferences.getInstance();
      await _persistServers(prefs);
      return;
    }

    final endpoint = ServerEndpointIdentity.normalize(rawEndpoint);
    _captureSessionToActiveServer();
    var target = _serverByEndpoint(endpoint);
    if (target == null) {
      target = _pendingProfile(endpoint);
      servers.add(target);
    }
    activeServerEndpoint = endpoint;
    baseUrl = endpoint;
    _loadProfileSession(target);
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
  }

  Future<void> activateServer(String endpoint) async {
    final normalizedEndpoint = ServerEndpointIdentity.normalize(endpoint);
    final target = _serverByEndpoint(normalizedEndpoint);
    if (target == null) {
      throw ArgumentError.value(endpoint, 'endpoint', 'Unknown server');
    }
    if (target.endpoint == activeServerEndpoint) return;
    _captureSessionToActiveServer();
    activeServerEndpoint = target.endpoint;
    baseUrl = target.endpoint;
    _loadProfileSession(target);
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
  }

  Future<void> removeServer(String endpoint) async {
    final normalizedEndpoint = ServerEndpointIdentity.normalize(endpoint);
    final index = servers.indexWhere(
      (server) => server.endpoint == normalizedEndpoint,
    );
    if (index < 0 || servers[index].isBuiltIn) return;
    servers.removeAt(index);
    if (activeServerEndpoint == normalizedEndpoint) {
      final next = servers.firstOrNull;
      activeServerEndpoint = next?.endpoint;
      baseUrl = next?.endpoint ?? _builtInServerUrl;
      next == null ? _clearInMemorySession() : _loadProfileSession(next);
    }
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
  }

  Future<void> persistSession() async {
    _captureSessionToActiveServer();
    final prefs = await SharedPreferences.getInstance();
    await _persistServers(prefs);
  }

  Future<void> clearSessionAndPersist() async {
    session.clear();
    await persistSession();
  }

  Future<void> activateGuest({
    required String accessToken,
    required String roomId,
    required String displayName,
  }) async {
    session.activateGuest(
      accessToken: accessToken,
      roomId: roomId,
      displayName: displayName,
    );
    await persistSession();
  }

  SyncTvServerProfile? _serverByEndpoint(String? endpoint) {
    if (endpoint == null || endpoint.isEmpty) return null;
    for (final server in servers) {
      if (server.endpoint == endpoint) return server;
    }
    return null;
  }

  SyncTvServerProfile _pendingProfile(String endpoint) => SyncTvServerProfile(
    endpoint: endpoint,
    declaredServerId: '',
    name: endpoint,
    isBuiltIn: _isBuiltInEndpoint(endpoint),
  );

  bool _isBuiltInEndpoint(String endpoint) =>
      _builtInServerUrl.isNotEmpty && endpoint == _builtInServerUrl;

  bool _reconcileBuiltInServer() {
    final configured = _builtInServerUrl;
    var changed = false;
    if (configured.isNotEmpty && _serverByEndpoint(configured) == null) {
      servers.insert(0, _pendingProfile(configured));
      changed = true;
    }
    for (var index = 0; index < servers.length; index++) {
      final shouldBeBuiltIn = servers[index].endpoint == configured;
      if (servers[index].isBuiltIn != shouldBeBuiltIn) {
        servers[index] = servers[index].copyWith(isBuiltIn: shouldBeBuiltIn);
        changed = true;
      }
    }
    return changed;
  }

  static String _normalizeOptionalBaseUrl(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? '' : ServerEndpointIdentity.normalize(trimmed);
  }

  static String? _normalizeStoredEndpoint(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    try {
      return ServerEndpointIdentity.normalize(trimmed);
    } on FormatException {
      return null;
    }
  }

  List<SyncTvServerProfile> _decodeServers(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      final byEndpoint = <String, SyncTvServerProfile>{};
      for (final entry in decoded.whereType<Map>()) {
        final profile = SyncTvServerProfile.fromJson(
          entry.map((key, value) => MapEntry(key.toString(), value)),
        );
        if (profile != null) byEndpoint[profile.endpoint] = profile;
      }
      return byEndpoint.values.toList(growable: true);
    } on FormatException {
      return [];
    }
  }

  Future<void> _persistServers(SharedPreferences prefs) async {
    await prefs.setString(
      serversKey,
      jsonEncode(servers.map((server) => server.toJson()).toList()),
    );
    final active = activeServerEndpoint;
    if (active == null) {
      await prefs.remove(activeServerKey);
    } else {
      await prefs.setString(activeServerKey, active);
    }
  }

  void _loadSessionFromActiveServer() {
    final current = activeServer;
    current == null ? _clearInMemorySession() : _loadProfileSession(current);
  }

  void _clearInMemorySession() {
    session.clear();
  }

  void _loadProfileSession(SyncTvServerProfile profile) {
    final data = profile.sessionData;
    switch (data) {
      case AnonymousServerSessionData():
        session.clear();
      case AccountServerSessionData(:final accessToken, :final refreshToken):
        session.clear();
        session.updateAccountTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      case GuestServerSessionData(
        :final accessToken,
        :final roomId,
        :final displayName,
      ):
        session.activateGuest(
          accessToken: accessToken,
          roomId: roomId,
          displayName: displayName,
        );
    }
  }

  void _captureSessionToActiveServer() {
    final endpoint = activeServerEndpoint;
    if (endpoint == null) return;
    final index = servers.indexWhere((server) => server.endpoint == endpoint);
    if (index < 0) return;
    servers[index] = servers[index].copyWith(
      sessionData: _currentSessionData(),
    );
  }

  SyncTvServerSessionData _currentSessionData() => switch (session.identity) {
    AnonymousSessionIdentity() => const AnonymousServerSessionData(),
    AccountSessionIdentity(:final accessToken, :final refreshToken) =>
      SyncTvServerSessionData.account(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    GuestSessionIdentity(
      :final accessToken,
      :final roomId,
      :final displayName,
    ) =>
      SyncTvServerSessionData.guest(
        accessToken: accessToken,
        roomId: roomId,
        displayName: displayName,
      ),
  };
}

sealed class SyncTvServerSessionData {
  const SyncTvServerSessionData();

  factory SyncTvServerSessionData.account({
    String? accessToken,
    String? refreshToken,
  }) {
    final access = _nonEmptySessionValue(accessToken);
    final refresh = _nonEmptySessionValue(refreshToken);
    if (access == null && refresh == null) {
      return const AnonymousServerSessionData();
    }
    return AccountServerSessionData._(
      accessToken: access,
      refreshToken: refresh,
    );
  }

  factory SyncTvServerSessionData.guest({
    required String accessToken,
    required String roomId,
    required String displayName,
  }) {
    final token = _nonEmptySessionValue(accessToken);
    final guestRoomId = _nonEmptySessionValue(roomId);
    final guestDisplayName = _nonEmptySessionValue(displayName);
    if (token == null || guestRoomId == null || guestDisplayName == null) {
      return const AnonymousServerSessionData();
    }
    return GuestServerSessionData._(
      accessToken: token,
      roomId: guestRoomId,
      displayName: guestDisplayName,
    );
  }

  factory SyncTvServerSessionData.fromJson(Map<dynamic, dynamic> json) {
    return switch (json['kind']?.toString()) {
      'account' => SyncTvServerSessionData.account(
        accessToken: json['access_token']?.toString(),
        refreshToken: json['refresh_token']?.toString(),
      ),
      'guest' => SyncTvServerSessionData.guest(
        accessToken: json['access_token']?.toString() ?? '',
        roomId: json['room_id']?.toString() ?? '',
        displayName: json['display_name']?.toString() ?? '',
      ),
      _ => const AnonymousServerSessionData(),
    };
  }

  Map<String, dynamic> toJson();
}

final class AnonymousServerSessionData extends SyncTvServerSessionData {
  const AnonymousServerSessionData();

  @override
  Map<String, dynamic> toJson() => const {'kind': 'anonymous'};
}

final class AccountServerSessionData extends SyncTvServerSessionData {
  const AccountServerSessionData._({this.accessToken, this.refreshToken});

  final String? accessToken;
  final String? refreshToken;

  @override
  Map<String, dynamic> toJson() => {
    'kind': 'account',
    if (accessToken != null) 'access_token': accessToken,
    if (refreshToken != null) 'refresh_token': refreshToken,
  };
}

final class GuestServerSessionData extends SyncTvServerSessionData {
  const GuestServerSessionData._({
    required this.accessToken,
    required this.roomId,
    required this.displayName,
  });

  final String accessToken;
  final String roomId;
  final String displayName;

  @override
  Map<String, dynamic> toJson() => {
    'kind': 'guest',
    'access_token': accessToken,
    'room_id': roomId,
    'display_name': displayName,
  };
}

String? _nonEmptySessionValue(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}
