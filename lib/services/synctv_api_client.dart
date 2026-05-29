import 'dart:async';
import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/protobuf.dart' as pb;

import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pb.dart' as common;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pb.dart' as oauth2;
import 'package:synctv_app/src/generated/proto/providers/alist.pb.dart'
    as alist;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/emby.pb.dart' as emby;
import 'package:synctv_app/src/generated/proto/providers/rtmp.pb.dart' as rtmp;
import 'package:synctv_app/models/playback_client_profile.dart';
import 'package:synctv_app/models/watch_together_models.dart';

part 'synctv_api_facades.dart';

typedef AuthErrorSink = void Function();
typedef TokenRefreshSink = Future<void> Function();

class SyncTvApiException implements Exception {
  final int statusCode;
  final String message;
  final int? code;
  final String? requestId;

  SyncTvApiException(
    this.message, {
    required this.statusCode,
    this.code,
    this.requestId,
  });

  @override
  String toString() => message;
}

class SyncTvSession {
  String? accessToken;
  String? refreshToken;
  bool isGuest = false;

  bool get hasAccessToken => accessToken != null && accessToken!.isNotEmpty;
}

class SyncTvApiClient {
  SyncTvApiClient({
    required String baseUrl,
    required this.session,
    this.onAuthError,
    this.onTokenRefresh,
    http.Client? httpClient,
  })  : _http = httpClient ?? http.Client(),
        _baseUri = _normalizeBaseUri(baseUrl);

  final http.Client _http;
  final SyncTvSession session;
  final AuthErrorSink? onAuthError;
  final TokenRefreshSink? onTokenRefresh;
  Uri _baseUri;
  Future<bool>? _refreshInFlight;

  late final SyncTvAuthApi auth = SyncTvAuthApi._(this);
  late final SyncTvUserApi user = SyncTvUserApi._(this);
  late final SyncTvRoomApi room = SyncTvRoomApi._(this);
  late final SyncTvPublicApi publicService = SyncTvPublicApi._(this);
  late final SyncTvEmailApi emailService = SyncTvEmailApi._(this);
  late final SyncTvNotificationApi notifications =
      SyncTvNotificationApi._(this);
  late final SyncTvOAuth2Api oauth2Service = SyncTvOAuth2Api._(this);
  late final SyncTvAdminApi adminService = SyncTvAdminApi._(this);
  late final SyncTvProviderCommonApi providerCommon =
      SyncTvProviderCommonApi._(this);
  late final SyncTvAlistProviderApi alistProvider =
      SyncTvAlistProviderApi._(this);
  late final SyncTvEmbyProviderApi embyProvider = SyncTvEmbyProviderApi._(this);
  late final SyncTvBilibiliProviderApi bilibiliProvider =
      SyncTvBilibiliProviderApi._(this);
  late final SyncTvRtmpProviderApi rtmpProvider = SyncTvRtmpProviderApi._(this);

  static const Set<String> _jsonBytesFields = {
    'synctv.client.CreateRoomRequest.settings',
    'synctv.client.Room.settings',
    'synctv.client.Media.metadata',
    'synctv.client.Media.source_config',
    'synctv.client.Playlist.source_config',
    'synctv.client.PlaybackState.target',
    'synctv.client.UpdateRoomSettingsRequest.settings',
    'synctv.client.GetRoomSettingsResponse.settings',
    'synctv.client.ResetRoomSettingsResponse.settings',
    'synctv.client.UserPreferences.settings',
    'synctv.client.StartPlaybackRequest.target',
    'synctv.client.StartPasskeyLoginResponse.options',
    'synctv.client.FinishPasskeyLoginRequest.credential',
    'synctv.client.StartPasskeyRegistrationResponse.options',
    'synctv.client.FinishPasskeyRegistrationRequest.credential',
    'synctv.client.StartPasskeyBindResponse.options',
    'synctv.client.FinishPasskeyBindRequest.credential',
    'synctv.client.NotificationProto.data',
    'synctv.client.StartMfaPasskeyResponse.options',
    'synctv.client.FinishMfaPasskeyRequest.credential',
    'synctv.client.StartOpaquePasswordUpdateResponse.passkey_options',
    'synctv.client.FinishOpaquePasswordUpdateRequest.passkey_credential',
    'synctv.client.AddMediaRequest.source_config',
    'synctv.client.ListPlaylistItemsRequest.target',
    'synctv.client.ObservePlaybackSnapshot.target',
    'synctv.client.PlaylistItem.target',
    'synctv.client.PlaylistBrowsePathNode.target',
    'synctv.client.CreatePlaylistRequest.source_config',
    'synctv.client.RoomSettingsChanged.settings',
    'synctv.admin.AdminRoom.settings',
    'synctv.admin.SettingsGroup.settings',
    'synctv.admin.GetRoomSettingsResponse.settings',
    'synctv.admin.UpdateRoomSettingsRequest.settings',
    'synctv.admin.GetSystemStatsResponse.additional_stats',
  };

  String get baseUrl => _baseUri.toString();

  static String normalizeBaseUrl(String input) =>
      _normalizeBaseUri(input).toString();

  set baseUrl(String value) {
    _baseUri = _normalizeBaseUri(value);
  }

  List<int> encodeJsonBytes(Object? value) => _jsonBytes(value);

  String resolveResourceUrl(String url) {
    final value = url.trim();
    if (value.isEmpty) return '';

    final parsed = Uri.tryParse(value);
    if (parsed != null && parsed.hasScheme) return value;
    if (value.startsWith('//')) return '${_baseUri.scheme}:$value';

    final relative = parsed ?? Uri(path: value);
    final basePath = _baseUri.path.endsWith('/')
        ? _baseUri.path.substring(0, _baseUri.path.length - 1)
        : _baseUri.path;
    final requestPath =
        relative.path.startsWith('/') ? relative.path : '/${relative.path}';

    return _baseUri
        .replace(
          path: '$basePath$requestPath',
          query: relative.hasQuery ? relative.query : null,
          fragment: relative.hasFragment ? relative.fragment : null,
        )
        .toString();
  }

  static Uri _normalizeBaseUri(String input) {
    var value = input.trim();
    if (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      value = 'https://$value';
    }
    final parsed = Uri.parse(value);
    final path = parsed.path.endsWith('/api')
        ? parsed.path.substring(0, parsed.path.length - 4)
        : parsed.path;
    return parsed.replace(path: path.isEmpty ? '' : path);
  }

  Uri _uri(String path, [Map<String, String?> query = const {}]) {
    final basePath = _baseUri.path.endsWith('/')
        ? _baseUri.path.substring(0, _baseUri.path.length - 1)
        : _baseUri.path;
    final requestPath = path.startsWith('/') ? path : '/$path';
    final filteredQuery = <String, String>{};
    query.forEach((key, value) {
      if (value != null && value.isNotEmpty) filteredQuery[key] = value;
    });
    return _baseUri.replace(
      path: '$basePath$requestPath',
      queryParameters: filteredQuery.isEmpty ? null : filteredQuery,
    );
  }

  Map<String, String> _headers({bool auth = true}) {
    final headers = <String, String>{
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final token = session.accessToken;
    if (auth && token != null && token.isNotEmpty) {
      headers['authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<T> _send<T extends GeneratedMessage>(
    String method,
    String path,
    T Function() create, {
    Object? body,
    Map<String, String?> query = const {},
    bool auth = true,
  }) async {
    final uri = _uri(path, query);
    final encodedBody = _encodeBody(body);
    final response = await _sendHttp(
      method,
      uri,
      headers: _headers(auth: auth),
      body: encodedBody,
    );

    if (_shouldRefresh(response, auth: auth, path: path)) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        final retry = await _sendHttp(
          method,
          uri,
          headers: _headers(auth: auth),
          body: encodedBody,
        );
        return _decodeResponse(retry, create);
      }
    }

    return _decodeResponse(response, create);
  }

  Future<http.Response> _sendHttp(
    String method,
    Uri uri, {
    required Map<String, String> headers,
    String? body,
  }) {
    return switch (method) {
      'GET' => _http.get(uri, headers: headers),
      'POST' => _http.post(uri, headers: headers, body: body),
      'PATCH' => _http.patch(uri, headers: headers, body: body),
      'PUT' => _http.put(uri, headers: headers, body: body),
      'DELETE' => _http.delete(uri, headers: headers, body: body),
      _ => throw ArgumentError.value(method, 'method'),
    };
  }

  bool _shouldRefresh(
    http.BaseResponse response, {
    required bool auth,
    required String path,
  }) {
    return response.statusCode == 401 &&
        auth &&
        !session.isGuest &&
        session.refreshToken != null &&
        session.refreshToken!.isNotEmpty &&
        path != '/api/auth/refresh';
  }

  Future<bool> _tryRefreshToken() async {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final refresh = _refreshTokenOnce();
    _refreshInFlight = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_refreshInFlight, refresh)) {
        _refreshInFlight = null;
      }
    }
  }

  Future<bool> _refreshTokenOnce() async {
    try {
      final refreshToken = session.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }
      await auth.refreshToken(
        client.RefreshTokenRequest(refreshToken: refreshToken),
      );
      await onTokenRefresh?.call();
      return session.hasAccessToken;
    } catch (_) {
      return false;
    }
  }

  Future<bool> refreshAccessTokenIfPossible() => _tryRefreshToken();

  Future<T> _sendWithoutRefresh<T extends GeneratedMessage>(
    String method,
    String path,
    T Function() create, {
    Object? body,
    Map<String, String?> query = const {},
    bool auth = true,
  }) async {
    final uri = _uri(path, query);
    final encodedBody = _encodeBody(body);
    final response = await _sendHttp(
      method,
      uri,
      headers: _headers(auth: auth),
      body: encodedBody,
    );

    return _decodeResponse(response, create);
  }

  String? _encodeBody(Object? body) {
    if (body == null) return null;
    if (body is GeneratedMessage) {
      return jsonEncode(_messageJson(body));
    }
    if (body is Map<String, dynamic>) {
      return jsonEncode(_stripNulls(body));
    }
    throw ArgumentError.value(body, 'body', 'Unsupported request body');
  }

  Map<String, dynamic> _messageJson(GeneratedMessage message) {
    return _stripNulls(_protoFieldJson(message));
  }

  Object? protoJson(GeneratedMessage message) {
    return _normalizeProtoJson(_messageJson(message), message);
  }

  T decodeProtoJson<T extends GeneratedMessage>(
    Object? decoded,
    T Function() create,
  ) {
    final message = create();
    message.mergeFromProto3Json(
      _normalizeProtoJson(decoded, message),
      supportNamesWithUnderscores: true,
      permissiveEnums: true,
      ignoreUnknownFields: true,
    );
    return message;
  }

  Map<String, String?> _messageQuery(GeneratedMessage message) {
    return _messageJson(message).map(
      (key, value) => MapEntry(key, _queryValue(value)),
    );
  }

  Map<String, dynamic> _protoFieldJson(GeneratedMessage message) {
    final result = <String, dynamic>{};
    for (final field in message.info_.sortedByTag) {
      if (!message.hasField(field.tagNumber)) continue;
      final fieldPath =
          '${message.info_.qualifiedMessageName}.${field.protoName}';
      result[field.protoName] = _protoFieldValue(
        message.getField(field.tagNumber),
        jsonBytes: _jsonBytesFields.contains(fieldPath),
      );
    }
    return result;
  }

  dynamic _protoFieldValue(Object? value, {bool jsonBytes = false}) {
    if (value == null) return null;
    if (value is GeneratedMessage) return _protoFieldJson(value);
    if (value is pb.ProtobufEnum) return value.value;
    if (value is Int64) return value.toString();
    if (value is List<int>) {
      if (!jsonBytes) return base64Encode(value);
      if (value.isEmpty) return null;
      return jsonDecode(utf8.decode(value));
    }
    if (value is Iterable) {
      return value.map((entry) => _protoFieldValue(entry)).toList();
    }
    if (value is Map) {
      return value.map(
        (key, entryValue) =>
            MapEntry(key.toString(), _protoFieldValue(entryValue)),
      );
    }
    return value;
  }

  String? _queryValue(Object? value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return jsonEncode(value);
  }

  dynamic _normalizeResponseJson(Object? value, GeneratedMessage message) {
    if (value is! Map<String, dynamic>) return value;
    return _normalizeMessageJson(value, message);
  }

  Map<String, dynamic> _normalizeMessageJson(
    Map<String, dynamic> json,
    GeneratedMessage message,
  ) {
    final result = Map<String, dynamic>.from(json);
    for (final field in message.info_.sortedByTag) {
      final key = result.containsKey(field.name) ? field.name : field.protoName;
      if (!result.containsKey(key)) continue;
      final fieldPath =
          '${message.info_.qualifiedMessageName}.${field.protoName}';
      result[key] = _normalizeFieldJson(
        result[key],
        fieldPath: fieldPath,
        isBytes: pb.PbFieldType.isBytes(field.type),
        subBuilder: field.subBuilder,
      );
    }
    return result;
  }

  dynamic _normalizeFieldJson(
    Object? value, {
    required String fieldPath,
    required bool isBytes,
    required GeneratedMessage Function()? subBuilder,
  }) {
    if (_jsonBytesFields.contains(fieldPath) && value == null) {
      return '';
    }
    if (_jsonBytesFields.contains(fieldPath) && value is! String) {
      return base64Encode(utf8.encode(jsonEncode(value)));
    }
    if (isBytes && value is List) {
      return base64Encode(value.cast<int>());
    }
    if (subBuilder == null) return value;
    if (value is List) {
      return value
          .map((entry) => entry is Map<String, dynamic>
              ? _normalizeMessageJson(entry, subBuilder())
              : entry)
          .toList();
    }
    if (value is Map<String, dynamic>) {
      return _normalizeMessageJson(value, subBuilder());
    }
    return value;
  }

  T _decodeResponse<T extends GeneratedMessage>(
    http.Response response,
    T Function() create,
  ) {
    if (response.statusCode == 401) {
      onAuthError?.call();
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _apiException(response);
    }
    final message = create();
    if (response.body.trim().isEmpty) {
      return message;
    }
    final decoded = _normalizeResponseJson(jsonDecode(response.body), message);
    message.mergeFromProto3Json(
      decoded,
      supportNamesWithUnderscores: true,
      permissiveEnums: true,
      ignoreUnknownFields: true,
    );
    return message;
  }

  SyncTvApiException _apiException(http.Response response) {
    var message = response.body;
    int? code;
    String? requestId;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        message =
            (decoded['error'] ?? decoded['message'] ?? message).toString();
        final rawCode = decoded['code'];
        if (rawCode is int) code = rawCode;
        requestId = decoded['request_id']?.toString();
      }
    } catch (e) {
      debugPrint('API error response parse failed: $e');
    }
    return SyncTvApiException(
      message,
      statusCode: response.statusCode,
      code: code,
      requestId: requestId,
    );
  }

  Stream<T> _watchSse<T extends GeneratedMessage>(
    String path,
    T Function() create, {
    Map<String, String?> query = const {},
  }) async* {
    var request = _sseRequest(path, query);
    var response = await _http.send(request);
    if (_shouldRefresh(response, auth: true, path: path)) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        request = _sseRequest(path, query);
        response = await _http.send(request);
      }
    }
    if (response.statusCode == 401) {
      onAuthError?.call();
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.stream.bytesToString();
      throw SyncTvApiException(
        body.isEmpty ? 'SSE watch failed' : body,
        statusCode: response.statusCode,
      );
    }

    yield* _decodeSseStream(response.stream, create);
  }

  http.Request _sseRequest(String path, Map<String, String?> query) {
    final request = http.Request('GET', _uri(path, query));
    request.headers.addAll(_headers());
    request.headers['accept'] = 'text/event-stream';
    return request;
  }

  Stream<T> _decodeSseStream<T extends GeneratedMessage>(
    Stream<List<int>> stream,
    T Function() create,
  ) async* {
    var eventName = '';
    final dataLines = <String>[];
    await for (final line
        in stream.transform(utf8.decoder).transform(const LineSplitter())) {
      if (line.isEmpty) {
        final event = _decodeSseEvent(eventName, dataLines, create);
        eventName = '';
        dataLines.clear();
        if (event != null) yield event;
        continue;
      }
      if (line.startsWith(':')) continue;
      if (line.startsWith('event:')) {
        eventName = line.substring(6).trim();
        continue;
      }
      if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).trimLeft());
      }
    }

    final event = _decodeSseEvent(eventName, dataLines, create);
    if (event != null) yield event;
  }

  T? _decodeSseEvent<T extends GeneratedMessage>(
    String eventName,
    List<String> dataLines,
    T Function() create,
  ) {
    if (dataLines.isEmpty) return null;
    final data = dataLines.join('\n');
    final message = create();
    final decoded = jsonDecode(data);
    switch (eventName) {
      case 'observed':
        final normalized = _normalizeProtoJson(
          decoded,
          client.ResourceObserved.create(),
        );
        final observed = client.ResourceObserved()
          ..mergeFromProto3Json(
            normalized,
            supportNamesWithUnderscores: true,
            permissiveEnums: true,
            ignoreUnknownFields: true,
          );
        _setWatchObserved(message, observed);
        return message;
      case 'changed':
        final normalized = _normalizeProtoJson(
          decoded,
          client.ResourceChanged.create(),
        );
        final changed = client.ResourceChanged()
          ..mergeFromProto3Json(
            normalized,
            supportNamesWithUnderscores: true,
            permissiveEnums: true,
            ignoreUnknownFields: true,
          );
        _setWatchChanged(message, changed);
        return message;
      case 'error':
        final normalized = _normalizeProtoJson(
          decoded,
          client.ResourceObserveError.create(),
        );
        final error = client.ResourceObserveError()
          ..mergeFromProto3Json(
            normalized,
            supportNamesWithUnderscores: true,
            permissiveEnums: true,
            ignoreUnknownFields: true,
          );
        _setWatchError(message, error);
        return message;
      default:
        return null;
    }
  }

  Object? _normalizeProtoJson(Object? decoded, GeneratedMessage message) {
    if (decoded is! Map<String, dynamic>) return decoded;
    return _normalizeMessageJson(decoded, message);
  }

  void _setWatchObserved(
    GeneratedMessage message,
    client.ResourceObserved observed,
  ) {
    switch (message) {
      case client.WatchPlaybackStateEvent event:
        event.observed = observed;
      case client.WatchPlaybackSnapshotEvent event:
        event.observed = observed;
      case client.WatchRoomSettingsEvent event:
        event.observed = observed;
      case client.WatchPlaylistItemsEvent event:
        event.observed = observed;
      case client.WatchRoomMembersEvent event:
        event.observed = observed;
      default:
        throw ArgumentError.value(message, 'message');
    }
  }

  void _setWatchChanged(
    GeneratedMessage message,
    client.ResourceChanged changed,
  ) {
    switch (message) {
      case client.WatchPlaybackStateEvent event:
        event.changed = changed;
      case client.WatchPlaybackSnapshotEvent event:
        event.changed = changed;
      case client.WatchRoomSettingsEvent event:
        event.changed = changed;
      case client.WatchPlaylistItemsEvent event:
        event.changed = changed;
      case client.WatchRoomMembersEvent event:
        event.changed = changed;
      default:
        throw ArgumentError.value(message, 'message');
    }
  }

  void _setWatchError(
    GeneratedMessage message,
    client.ResourceObserveError error,
  ) {
    switch (message) {
      case client.WatchPlaybackStateEvent event:
        event.error = error;
      case client.WatchPlaybackSnapshotEvent event:
        event.error = error;
      case client.WatchRoomSettingsEvent event:
        event.error = error;
      case client.WatchPlaylistItemsEvent event:
        event.error = error;
      case client.WatchRoomMembersEvent event:
        event.error = error;
      default:
        throw ArgumentError.value(message, 'message');
    }
  }

  Map<String, dynamic> _stripNulls(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    for (final entry in map.entries) {
      final value = entry.value;
      if (value == null) continue;
      if (value is String && value.isEmpty) {
        result[entry.key] = value;
      } else if (value is Map<String, dynamic>) {
        result[entry.key] = _stripNulls(value);
      } else {
        result[entry.key] = value;
      }
    }
    return result;
  }

  List<int> _jsonBytes(Object? value) {
    if (value == null) return const [];
    if (value is List<int>) return value;
    return utf8.encode(jsonEncode(value));
  }

  String _lowerEnumSuffix(pb.ProtobufEnum value, String prefix) {
    final name = value.name;
    final suffix =
        name.startsWith(prefix) ? name.substring(prefix.length) : name;
    return suffix.toLowerCase();
  }

  Map<String, String> _playbackClientProfileQuery(
    client.PlaybackClientProfile profile,
  ) {
    return {
      if (profile.hasDeliveryPreference())
        'delivery_preference': _lowerEnumSuffix(
          profile.deliveryPreference,
          'PLAYBACK_DELIVERY_PREFERENCE_',
        ),
      if (profile.hasMaxStreamingBitrate())
        'max_streaming_bitrate': profile.maxStreamingBitrate.toString(),
      if (profile.hasMaxAudioChannels())
        'max_audio_channels': profile.maxAudioChannels.toString(),
      if (profile.supportedVideoCodecs.isNotEmpty)
        'video_codecs': profile.supportedVideoCodecs
            .map((codec) => _lowerEnumSuffix(codec, 'PLAYBACK_VIDEO_CODEC_'))
            .join(','),
      if (profile.supportedContainers.isNotEmpty)
        'containers': profile.supportedContainers
            .map((container) =>
                _lowerEnumSuffix(container, 'PLAYBACK_CONTAINER_'))
            .join(','),
      if (profile.hasAudioCapability())
        'audio_capability': _lowerEnumSuffix(
          profile.audioCapability,
          'PLAYBACK_AUDIO_CAPABILITY_',
        ),
      if (profile.hasSubtitlePreference())
        'subtitle_preference': _lowerEnumSuffix(
          profile.subtitlePreference,
          'PLAYBACK_SUBTITLE_PREFERENCE_',
        ),
    };
  }

  Map<String, String?> _watchOptionsQuery(client.WatchOptions options) {
    return {
      ..._messageQuery(options),
      if (options.hasDeliveryMode())
        'delivery_mode': _lowerEnumSuffix(
          options.deliveryMode,
          'RESOURCE_DELIVERY_MODE_',
        ),
    };
  }

  Uri roomWebSocketUri(String roomId, {required String ticket}) {
    final wsScheme = _baseUri.scheme == 'https' ? 'wss' : 'ws';
    final encodedRoomId = Uri.encodeComponent(roomId);
    return _baseUri.replace(
      scheme: wsScheme,
      path: '/ws/rooms/$encodedRoomId',
      queryParameters: {
        'ticket': ticket,
        'format': 'json',
      },
    );
  }

  void _storeLogin(String accessToken, String refreshToken) {
    if (accessToken.isEmpty && refreshToken.isEmpty) return;
    if (accessToken.isNotEmpty) session.accessToken = accessToken;
    if (refreshToken.isNotEmpty) session.refreshToken = refreshToken;
    session.isGuest = false;
  }
}

extension SyncTvModelMapping on SyncTvApiClient {
  WUser mapUser(client.User user) {
    return WUser(
      id: user.id,
      username: user.username,
      email: user.email.isEmpty ? null : user.email,
      role: user.role.value,
      status: user.status.value,
      createdAt: user.createdAt.toInt(),
      isBanned: user.isBanned,
    );
  }

  WUser mapMember(common.RoomMember member) {
    return WUser(
      id: member.userId,
      username: member.username,
      role: member.role.value,
      createdAt: member.joinedAt.toInt(),
      status: common_enum.MemberStatus.MEMBER_STATUS_ACTIVE.value,
      onlineCount: member.isOnline ? 1 : 0,
    );
  }

  WUser mapAdminUser(admin.AdminUser user) {
    return WUser(
      id: user.id,
      username: user.username,
      email: user.email.isEmpty ? null : user.email,
      role: user.role.value,
      createdAt: user.createdAt.toInt(),
      updatedAt: user.updatedAt.toInt(),
      status: user.isBanned
          ? common_enum.UserStatus.USER_STATUS_BANNED.value
          : user.status.value,
      isBanned: user.isBanned,
      bannedAt: user.bannedAt.toInt(),
      bannedBy: user.bannedBy,
      bannedReason: user.bannedReason,
    );
  }

  WRoom mapAdminRoom(admin.AdminRoom room) {
    final settings = _decodeJsonBytes(room.settings);
    return WRoom(
      roomId: room.id,
      roomName: room.name,
      description: room.description,
      viewerCount: room.memberCount,
      memberCount: room.memberCount,
      creator: room.creatorUsername,
      creatorId: room.creatorId,
      createdAt: room.createdAt.toInt(),
      updatedAt: room.updatedAt.toInt(),
      status: room.status.value,
      isBanned: room.isBanned,
      version: room.version.toInt(),
      creatorStatus: room.creatorStatus.value,
      needPassword: settings['require_password'] == true,
      needVerify: settings['require_approval'] == true,
      guestCanPause: true,
      guestCanAdd: true,
    );
  }

  WRoom mapRoom(client.Room room) {
    final settings = _decodeJsonBytes(room.settings);
    return WRoom(
      roomId: room.id,
      roomName: room.name,
      description: room.description,
      viewerCount: room.memberCount,
      memberCount: room.memberCount,
      creatorId: room.createdBy,
      createdAt: room.createdAt.toInt(),
      updatedAt: room.updatedAt.toInt(),
      status: room.status.value,
      isBanned: room.isBanned,
      availability: room.availability.value,
      version: room.version.toInt(),
      needPassword: settings['require_password'] == true,
      needVerify: settings['require_approval'] == true,
      guestCanPause: true,
      guestCanAdd: true,
    );
  }

  WRoom mapMyRoom(client.MyRoom myRoom) => mapRoom(myRoom.room).copyWith(
        myPermissions: myRoom.permissions.toInt(),
        myRole: myRoom.role.value,
        myRelation: myRoom.relation.value,
      );

  WMovie mapMedia(client.Media media) {
    final metadata = _decodeJsonBytes(media.metadata);
    final sourceConfig = _decodeJsonBytes(media.sourceConfig);
    final url = resolveResourceUrl(
      (metadata['url'] ?? sourceConfig['url'] ?? '').toString(),
    );
    return WMovie(
      id: media.id,
      name: media.name,
      url: url,
      creator: media.creatorId,
      roomId: media.roomId,
      position: media.position,
      addedAt: media.addedAt.toInt(),
      availability: media.availability.value,
      version: media.version.toInt(),
      type: media.sourceProvider,
      headers: _stringMap(metadata['headers']),
      proxy: metadata['proxy'] == true,
      live: media.sourceProvider == 'rtmp' ||
          (media.sourceProvider == 'bilibili' &&
              sourceConfig['type'] == 'live') ||
          metadata['is_live'] == true,
      sourceProvider: media.sourceProvider,
      providerInstanceName: media.providerInstanceName,
      sourceConfig: sourceConfig,
      metadata: metadata,
    );
  }

  WMovie mapPlaylist(client.Playlist playlist) {
    return WMovie(
      id: playlist.id,
      name: playlist.name,
      url: '',
      isFolder: true,
      roomId: playlist.roomId,
      parentId: playlist.parentId.isEmpty ? null : playlist.parentId,
      position: playlist.position,
      createdAt: playlist.createdAt.toInt(),
      updatedAt: playlist.updatedAt.toInt(),
      itemCount: playlist.itemCount,
      availability: playlist.availability.value,
      version: playlist.version.toInt(),
      type: playlist.isDynamic ? playlist.sourceProvider : 'playlist',
      sourceProvider: playlist.sourceProvider,
      providerInstanceName: playlist.providerInstanceName,
      sourceConfig: _decodeJsonBytes(playlist.sourceConfig),
      metadata: {'is_dynamic': playlist.isDynamic},
    );
  }

  WMovie mapDynamicItem(client.PlaylistItem item, {String? playlistId}) {
    final target = Uint8List.fromList(item.target);
    final encodedTarget = base64Url.encode(target);
    return WMovie(
      id: encodedTarget,
      name: item.name,
      url: '',
      isFolder: item.itemType == client_enum.ItemType.ITEM_TYPE_PLAYLIST,
      parentId: playlistId,
      subPath: encodedTarget,
      metadata: {
        'target': target,
        'target_json': _decodeJsonBytes(item.target),
        'thumbnail':
            item.hasThumbnail() ? resolveResourceUrl(item.thumbnail) : '',
        'size': item.hasSize() ? item.size.toInt() : null,
      },
    );
  }

  WPlaybackStatus mapPlayback(client.GetPlaybackResponse response) {
    final state = response.playbackState;
    final snapshot = response.playbackSnapshot;
    final encodedTarget =
        state.target.isEmpty ? '' : base64Url.encode(state.target);
    WMovie? movie;
    if (snapshot.mediaId.isNotEmpty || snapshot.playlistId.isNotEmpty) {
      final info = snapshot.playbackInfos[snapshot.defaultMode] ??
          (snapshot.playbackInfos.isNotEmpty
              ? snapshot.playbackInfos.values.first
              : null);
      final playbackUrl = info != null && info.urls.isNotEmpty
          ? info.urls[(info.defaultUrlIndex >= 0 &&
                  info.defaultUrlIndex < info.urls.length)
              ? info.defaultUrlIndex
              : 0]
          : null;
      movie = WMovie(
        id: encodedTarget.isNotEmpty
            ? encodedTarget
            : snapshot.mediaId.isNotEmpty
                ? snapshot.mediaId
                : snapshot.playlistId,
        name: snapshot.name,
        url: resolveResourceUrl(playbackUrl?.url ?? ''),
        headers: playbackUrl == null
            ? const {}
            : Map<String, String>.from(playbackUrl.headers),
        type: info?.format ?? '',
        subPath: encodedTarget.isEmpty ? null : encodedTarget,
        parentId: encodedTarget.isEmpty ? null : state.playingPlaylistId,
        metadata: {
          'snapshot_version': snapshot.version,
          'default_mode': snapshot.defaultMode,
          'playback_metadata': Map<String, String>.from(snapshot.metadata),
        },
      );
    }
    return WPlaybackStatus(
      movie: movie,
      isPlaying: state.isPlaying,
      currentTime: state.position,
      playbackRate: state.speed == 0 ? 1.0 : state.speed,
    );
  }

  Map<String, dynamic> _decodeJsonBytes(List<int> bytes) {
    if (bytes.isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) return const {};
    return value
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }
}
