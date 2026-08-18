import 'dart:async';
import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:protobuf/well_known_types/google/protobuf/field_mask.pb.dart'
    as field_mask;

import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/core/network/server_http_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pb.dart' as common;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pb.dart' as oauth2;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;
import 'package:synctv_app/src/generated/proto/providers/alist.pb.dart'
    as alist;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/cloudreve.pb.dart'
    as cloudreve;
import 'package:synctv_app/src/generated/proto/providers/emby.pb.dart' as emby;
import 'package:synctv_app/src/generated/proto/providers/fnos.pb.dart' as fnos;
import 'package:synctv_app/src/generated/proto/providers/nextcloud.pb.dart'
    as nextcloud;
import 'package:synctv_app/src/generated/proto/providers/qnap.pb.dart' as qnap;
import 'package:synctv_app/src/generated/proto/providers/seafile.pb.dart'
    as seafile;
import 'package:synctv_app/src/generated/proto/providers/synology.pb.dart'
    as synology;
import 'package:synctv_app/src/generated/proto/providers/truenas.pb.dart'
    as truenas;
import 'package:synctv_app/src/generated/proto/providers/twitch.pb.dart'
    as twitch;
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;
import 'package:synctv_app/src/generated/proto/providers/douyu.pb.dart'
    as douyu;
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/src/generated/proto/providers/cctv.pb.dart' as cctv;
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/providers/douyin.pb.dart'
    as douyin;
import 'package:synctv_app/src/generated/proto/providers/tiktok.pb.dart'
    as tiktok;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/contracts/playback_client_profile.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

part 'synctv_api_facades.dart';

typedef AuthErrorSink = void Function(int endpointGeneration);
typedef TokenRefreshSink = Future<void> Function(int endpointGeneration);

class _FileObjectUploadResult {
  const _FileObjectUploadResult({
    required this.complete,
    required this.uploadedSizeBytes,
    required this.uploadedParts,
  });

  final bool complete;
  final Int64 uploadedSizeBytes;
  final List<int> uploadedParts;
}

class _FileObjectDownloadResult {
  const _FileObjectDownloadResult({
    required this.mimeType,
    required this.contentManifestSha256,
    required this.data,
    required this.contentRange,
    required this.totalSizeBytes,
  });

  final String mimeType;
  final String contentManifestSha256;
  final List<int> data;
  final client.FileByteRange? contentRange;
  final Int64 totalSizeBytes;
}

class SyncTvApiException implements Exception {
  final int statusCode;
  final String message;
  final int? code;
  final int? grpcCode;
  final String? requestId;
  final oauth2_enum.OAuth2Operation? oauth2Operation;
  final String? requestMethod;
  final Uri? requestUri;

  SyncTvApiException(
    this.message, {
    required this.statusCode,
    this.code,
    this.grpcCode,
    this.requestId,
    this.oauth2Operation,
    this.requestMethod,
    this.requestUri,
  });

  @override
  String toString() {
    final method = requestMethod;
    final uri = requestUri;
    if (method == null || uri == null) return message;
    return '$method ${uri.path}: $message';
  }
}

class SyncTvStaleEndpointException implements Exception {
  const SyncTvStaleEndpointException();

  @override
  String toString() => 'The request belongs to a previously active server';
}

class SyncTvSession {
  SyncTvSessionIdentity _identity = const AnonymousSessionIdentity();

  SyncTvSessionIdentity get identity => _identity;
  String? get accessToken => switch (_identity) {
    AccountSessionIdentity(:final accessToken) => accessToken,
    GuestSessionIdentity(:final accessToken) => accessToken,
    AnonymousSessionIdentity() => null,
  };
  String? get refreshToken => switch (_identity) {
    AccountSessionIdentity(:final refreshToken) => refreshToken,
    AnonymousSessionIdentity() || GuestSessionIdentity() => null,
  };

  bool get hasAccessToken => accessToken != null;
  bool get hasRefreshToken => refreshToken != null;
  bool get hasRecoverableCredentials => hasAccessToken || hasRefreshToken;

  void updateAccountTokens({String? accessToken, String? refreshToken}) {
    final current = _identity;
    final currentAccess = current is AccountSessionIdentity
        ? current.accessToken
        : null;
    final currentRefresh = current is AccountSessionIdentity
        ? current.refreshToken
        : null;
    final nextAccess = _nonEmpty(accessToken) ?? currentAccess;
    final nextRefresh = _nonEmpty(refreshToken) ?? currentRefresh;
    if (nextAccess == null && nextRefresh == null) {
      throw ArgumentError('Account session requires at least one token');
    }
    _identity = AccountSessionIdentity(
      accessToken: nextAccess,
      refreshToken: nextRefresh,
    );
  }

  void activateGuest({
    required String accessToken,
    required String roomId,
    required String displayName,
  }) {
    final token = _nonEmpty(accessToken);
    final guestRoomId = _nonEmpty(roomId);
    final guestDisplayName = _nonEmpty(displayName);
    if (token == null || guestRoomId == null || guestDisplayName == null) {
      throw ArgumentError('Guest session fields must be non-empty');
    }
    _identity = GuestSessionIdentity(
      accessToken: token,
      roomId: guestRoomId,
      displayName: guestDisplayName,
    );
  }

  void clear() {
    _identity = const AnonymousSessionIdentity();
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}

class SyncTvApiClient {
  SyncTvApiClient({
    required String baseUrl,
    required this.session,
    this.onAuthError,
    this.onTokenRefresh,
    bool allowInsecureTls = false,
    http.Client? httpClient,
  }) : _baseUri = _normalizeBaseUri(baseUrl),
       _allowInsecureTls = allowInsecureTls,
       _usesInjectedHttpClient = httpClient != null {
    _http =
        httpClient ??
        createServerHttpClient(
          _baseUri.toString(),
          allowInsecureTls: allowInsecureTls,
        );
  }

  late http.Client _http;
  final bool _usesInjectedHttpClient;
  final SyncTvSession session;
  final AuthErrorSink? onAuthError;
  final TokenRefreshSink? onTokenRefresh;
  Uri _baseUri;
  bool _allowInsecureTls;
  int _endpointGeneration = 0;
  ({int generation, Future<bool> future})? _refreshInFlight;
  final Expando<int> _responseGenerations = Expando<int>(
    'SyncTv response endpoint generation',
  );

  late final SyncTvAuthApi auth = SyncTvAuthApi._(this);
  late final SyncTvUserApi user = SyncTvUserApi._(this);
  late final SyncTvRoomApi room = SyncTvRoomApi._(this);
  late final SyncTvPublicApi publicService = SyncTvPublicApi._(this);
  late final SyncTvEmailApi emailService = SyncTvEmailApi._(this);
  late final SyncTvNotificationApi notifications = SyncTvNotificationApi._(
    this,
  );
  late final SyncTvOAuth2Api oauth2Service = SyncTvOAuth2Api._(this);
  late final SyncTvAdminApi adminService = SyncTvAdminApi._(this);
  late final SyncTvProviderCommonApi providerCommon = SyncTvProviderCommonApi._(
    this,
  );
  late final SyncTvAlistProviderApi alistProvider = SyncTvAlistProviderApi._(
    this,
  );
  late final SyncTvEmbyProviderApi embyProvider = SyncTvEmbyProviderApi._(this);
  late final SyncTvCloudreveProviderApi cloudreveProvider =
      SyncTvCloudreveProviderApi._(this);
  late final SyncTvBilibiliProviderApi bilibiliProvider =
      SyncTvBilibiliProviderApi._(this);
  late final SyncTvTwitchProviderApi twitchProvider = SyncTvTwitchProviderApi._(
    this,
  );
  late final SyncTvHuyaProviderApi huyaProvider = SyncTvHuyaProviderApi._(this);
  late final SyncTvDouyuProviderApi douyuProvider = SyncTvDouyuProviderApi._(
    this,
  );
  late final SyncTvAcFunProviderApi acFunProvider = SyncTvAcFunProviderApi._(
    this,
  );
  late final SyncTvCctvProviderApi cctvProvider = SyncTvCctvProviderApi._(this);
  late final SyncTvYoutubeProviderApi youtubeProvider =
      SyncTvYoutubeProviderApi._(this);
  late final SyncTvDouyinProviderApi douyinProvider = SyncTvDouyinProviderApi._(
    this,
  );
  late final SyncTvTikTokProviderApi tiktokProvider = SyncTvTikTokProviderApi._(
    this,
  );
  late final SyncTvFnosProviderApi fnosProvider = SyncTvFnosProviderApi._(this);
  late final SyncTvQnapProviderApi qnapProvider = SyncTvQnapProviderApi._(this);
  late final SyncTvSynologyProviderApi synologyProvider =
      SyncTvSynologyProviderApi._(this);
  late final SyncTvNextcloudProviderApi nextcloudProvider =
      SyncTvNextcloudProviderApi._(this);
  late final SyncTvSeafileProviderApi seafileProvider =
      SyncTvSeafileProviderApi._(this);
  late final SyncTvTrueNasProviderApi trueNasProvider =
      SyncTvTrueNasProviderApi._(this);

  String get baseUrl => _baseUri.toString();
  bool get allowInsecureTls => _allowInsecureTls;

  Map<String, String> get authenticatedResourceHeaders {
    final token = session.accessToken;
    return token == null || token.isEmpty
        ? const {}
        : {'authorization': 'Bearer $token'};
  }

  set baseUrl(String value) {
    configureServer(value, allowInsecureTls: _allowInsecureTls);
  }

  void configureServer(String value, {required bool allowInsecureTls}) {
    final normalized = _normalizeBaseUri(value);
    if (normalized == _baseUri && allowInsecureTls == _allowInsecureTls) {
      return;
    }
    final previousClient = _http;
    _baseUri = normalized;
    _allowInsecureTls = allowInsecureTls;
    if (!_usesInjectedHttpClient) {
      _http = createServerHttpClient(
        normalized.toString(),
        allowInsecureTls: allowInsecureTls,
      );
      previousClient.close();
    }
    _endpointGeneration++;
  }

  void close() => _http.close();

  bool isEndpointGenerationCurrent(int generation) =>
      generation == _endpointGeneration;

  int get endpointGeneration => _endpointGeneration;

  Future<http.Response> uploadRawBytes(
    String uploadUrl,
    List<int> data, {
    required String contentType,
    Map<String, String> headers = const {},
  }) async {
    final generation = _endpointGeneration;
    final uri = _resolveUploadUri(uploadUrl);
    final requestHeaders = <String, String>{
      ...headers,
      if (contentType.isNotEmpty) 'content-type': contentType,
    };
    final response = await _http.put(uri, headers: requestHeaders, body: data);
    _ensureCurrentEndpoint(generation);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _apiException(response, method: 'PUT', uri: uri);
    }
    return response;
  }

  Future<_FileObjectUploadResult> _uploadFileObject(
    String path, {
    required String token,
    required List<int> data,
    String contentType = '',
    client.FileUploadRange? contentRange,
  }) async {
    final generation = _endpointGeneration;
    final headers = <String, String>{
      'accept': 'application/json',
      'x-synctv-file-upload-token': token,
      if (contentType.isNotEmpty) 'content-type': contentType,
      if (contentRange != null)
        'content-range': _contentRangeHeader(contentRange),
    };
    final uri = _uri(path);
    final response = await _http.put(uri, headers: headers, body: data);
    _ensureCurrentEndpoint(generation);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _apiException(response, method: 'PUT', uri: uri);
    }
    return _FileObjectUploadResult(
      complete:
          _responseHeader(
            response,
            'x-synctv-upload-complete',
          ).toLowerCase().trim() ==
          'true',
      uploadedSizeBytes: _parseInt64(
        _responseHeader(response, 'x-synctv-uploaded-size-bytes'),
      ),
      uploadedParts: _parseIntListHeader(
        _responseHeader(response, 'x-synctv-uploaded-parts'),
      ),
    );
  }

  Future<_FileObjectDownloadResult> _downloadFileObject(
    String path, {
    required String token,
    client.FileRangeRequest? range,
  }) async {
    final generation = _endpointGeneration;
    final rangeHeader = range == null ? null : _rangeHeader(range);
    final headers = <String, String>{'accept': '*/*', 'range': ?rangeHeader};
    final uri = _uri(path, {'token': token});
    final response = await _http.get(uri, headers: headers);
    _ensureCurrentEndpoint(generation);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _apiException(response, method: 'GET', uri: uri);
    }

    final parsedRange = _parseContentRange(
      _responseHeader(response, 'content-range'),
    );
    return _FileObjectDownloadResult(
      mimeType: _responseHeader(response, 'content-type'),
      contentManifestSha256: _responseHeader(
        response,
        'x-synctv-content-manifest-sha256',
      ),
      data: response.bodyBytes,
      contentRange: parsedRange?.range,
      totalSizeBytes:
          parsedRange?.totalSize ??
          _parseInt64(
            _responseHeader(response, 'content-length'),
            fallback: response.bodyBytes.length,
          ),
    );
  }

  String _contentRangeHeader(client.FileUploadRange range) {
    return 'bytes ${range.start}-${range.endInclusive}/${range.totalSize}';
  }

  String? _rangeHeader(client.FileRangeRequest range) {
    return switch (range.whichRange()) {
      client.FileRangeRequest_Range.exact =>
        'bytes=${range.exact.start}-${range.exact.endInclusive}',
      client.FileRangeRequest_Range.fromStart => 'bytes=${range.fromStart}-',
      client.FileRangeRequest_Range.suffixLength =>
        'bytes=-${range.suffixLength}',
      client.FileRangeRequest_Range.notSet => null,
    };
  }

  ({client.FileByteRange range, Int64 totalSize})? _parseContentRange(
    String value,
  ) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || !trimmed.startsWith('bytes ')) return null;
    final parts = trimmed.substring(6).split('/');
    if (parts.length != 2) return null;
    final rangeParts = parts[0].split('-');
    if (rangeParts.length != 2) return null;
    final start = int.tryParse(rangeParts[0].trim());
    final endInclusive = int.tryParse(rangeParts[1].trim());
    final totalSize = int.tryParse(parts[1].trim());
    if (start == null || endInclusive == null || totalSize == null) {
      return null;
    }
    return (
      range: client.FileByteRange(
        start: Int64(start),
        endInclusive: Int64(endInclusive),
      ),
      totalSize: Int64(totalSize),
    );
  }

  Int64 _parseInt64(String value, {int fallback = 0}) {
    return Int64(int.tryParse(value.trim()) ?? fallback);
  }

  List<int> _parseIntListHeader(String value) {
    if (value.trim().isEmpty) return const [];
    return value
        .split(',')
        .map((part) => int.tryParse(part.trim()))
        .whereType<int>()
        .toList(growable: false);
  }

  String _responseHeader(http.Response response, String name) {
    final lowerName = name.toLowerCase();
    for (final entry in response.headers.entries) {
      if (entry.key.toLowerCase() == lowerName) return entry.value;
    }
    return '';
  }

  Uri _resolveUploadUri(String uploadUrl) {
    final parsed = Uri.parse(uploadUrl);
    if (parsed.hasScheme) return parsed;
    return _baseUri.resolve(uploadUrl);
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
    final requestPath = relative.path.startsWith('/')
        ? relative.path
        : '/${relative.path}';

    return _baseUri
        .replace(
          path: '$basePath$requestPath',
          query: relative.hasQuery ? relative.query : null,
          fragment: relative.hasFragment ? relative.fragment : null,
        )
        .toString();
  }

  static Uri _normalizeBaseUri(String input) =>
      Uri.parse(ServerEndpointIdentity.normalize(input));

  Uri _uri(String path, [Map<String, Object?> query = const {}]) {
    final basePath = _baseUri.path.endsWith('/')
        ? _baseUri.path.substring(0, _baseUri.path.length - 1)
        : _baseUri.path;
    final requestPath = path.startsWith('/') ? path : '/$path';
    final filteredQuery = <String, dynamic>{};
    query.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.isEmpty) return;
      if (value is Iterable && value.isEmpty) return;
      filteredQuery[key] = value;
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
    Map<String, Object?> query = const {},
    bool auth = true,
  }) async {
    final generation = _endpointGeneration;
    final uri = _uri(path, query);
    final encodedBody = _encodeBody(body);
    final response = await _sendHttp(
      method,
      uri,
      headers: _headers(auth: auth),
      body: encodedBody,
    );
    _ensureCurrentEndpoint(generation);

    if (_shouldRefresh(response, auth: auth, path: path)) {
      final refreshed = await _tryRefreshToken(generation);
      _ensureCurrentEndpoint(generation);
      if (refreshed) {
        final retry = await _sendHttp(
          method,
          uri,
          headers: _headers(auth: auth),
          body: encodedBody,
        );
        return _decodeCurrentResponse(
          retry,
          create,
          method: method,
          uri: uri,
          generation: generation,
        );
      }
      _notifyAuthError(generation);
    } else if (response.statusCode == 401 && auth) {
      _notifyAuthError(generation);
    }

    return _decodeCurrentResponse(
      response,
      create,
      method: method,
      uri: uri,
      generation: generation,
    );
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
    final hasAccountRefreshToken = switch (session.identity) {
      AccountSessionIdentity(:final refreshToken) => refreshToken != null,
      AnonymousSessionIdentity() || GuestSessionIdentity() => false,
    };
    return response.statusCode == 401 &&
        auth &&
        hasAccountRefreshToken &&
        path != '/api/auth/refresh';
  }

  Future<bool> _tryRefreshToken([int? expectedGeneration]) async {
    final generation = expectedGeneration ?? _endpointGeneration;
    _ensureCurrentEndpoint(generation);
    final inFlight = _refreshInFlight;
    if (inFlight != null && inFlight.generation == generation) {
      return inFlight.future;
    }

    final refresh = _refreshTokenOnce(generation);
    _refreshInFlight = (generation: generation, future: refresh);
    try {
      return await refresh;
    } finally {
      if (identical(_refreshInFlight?.future, refresh)) {
        _refreshInFlight = null;
      }
    }
  }

  Future<bool> _refreshTokenOnce(int generation) async {
    try {
      _ensureCurrentEndpoint(generation);
      final refreshToken = session.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }
      await auth.refreshToken(
        client.RefreshTokenRequest(refreshToken: refreshToken),
      );
      _ensureCurrentEndpoint(generation);
      await onTokenRefresh?.call(generation);
      _ensureCurrentEndpoint(generation);
      return session.hasAccessToken;
    } on SyncTvStaleEndpointException {
      rethrow;
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
    final generation = _endpointGeneration;
    final uri = _uri(path, query);
    final encodedBody = _encodeBody(body);
    final response = await _sendHttp(
      method,
      uri,
      headers: _headers(auth: auth),
      body: encodedBody,
    );

    return _decodeCurrentResponse(
      response,
      create,
      method: method,
      uri: uri,
      generation: generation,
    );
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
      supportNamesWithUnderscores: false,
      permissiveEnums: true,
      ignoreUnknownFields: true,
    );
    return message;
  }

  Map<String, Object?> _messageQuery(GeneratedMessage message) {
    return _messageJson(
      message,
    ).map((key, value) => MapEntry(key, _queryValue(value)));
  }

  Map<String, dynamic> _protoFieldJson(GeneratedMessage message) {
    final result = <String, dynamic>{};
    for (final field in message.info_.sortedByTag) {
      if (!message.hasField(field.tagNumber)) continue;
      result[field.name] = _protoFieldValue(message.getField(field.tagNumber));
    }
    return result;
  }

  dynamic _protoFieldValue(Object? value) {
    if (value == null) return null;
    if (value is field_mask.FieldMask) {
      return value.toProto3Json();
    }
    if (value is source_config.MediaSourceConfig) {
      return SourceConfigCodec.mediaSourceConfigJson(value);
    }
    if (value is source_config.PlaylistSourceConfig) {
      return SourceConfigCodec.playlistSourceConfigJson(value);
    }
    if (value is client.ProviderTarget && providerTargetIsEmpty(value)) {
      return null;
    }
    if (value is oauth2.OAuth2ProviderType) {
      return oauth2ProviderTypeToString(value);
    }
    if (value is source_enum.SourceProvider) {
      return value.value;
    }
    if (value is GeneratedMessage) return _protoFieldJson(value);
    if (value is pb.ProtobufEnum) return value.value;
    if (value is Int64) return value.toString();
    if (value is List<int>) {
      return base64Encode(value);
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

  Object? _queryValue(Object? value) {
    if (value == null) return null;
    if (value is Iterable) {
      return value.map(_queryScalarValue).toList(growable: false);
    }
    return _queryScalarValue(value);
  }

  String _queryScalarValue(Object? value) {
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
      final key = field.name;
      if (!result.containsKey(key)) continue;
      final fieldPath =
          '${message.info_.qualifiedMessageName}.${field.protoName}';
      result[key] = _normalizeFieldJson(
        result[key],
        fieldPath: fieldPath,
        isBytes: pb.PbFieldType.isBytes(field.type),
        isEnum: field.isEnum,
        subBuilder: field.subBuilder,
        parentJson: result,
      );
    }
    return result;
  }

  dynamic _normalizeFieldJson(
    Object? value, {
    required String fieldPath,
    required bool isBytes,
    required bool isEnum,
    required GeneratedMessage Function()? subBuilder,
    required Map<String, dynamic> parentJson,
  }) {
    if (_isSourceProviderField(fieldPath)) {
      return _normalizeSourceProviderJson(value);
    }
    if (fieldPath.endsWith('.oauth2_provider')) {
      return oauth2ProviderTypeFromString(value?.toString() ?? '').value;
    }
    if (_isSourceConfigField(fieldPath)) {
      return _normalizeSourceConfigJson(value, fieldPath, parentJson);
    }
    if (isBytes && value is List) {
      return base64Encode(value.cast<int>());
    }
    if (isEnum && value is String) return value.toUpperCase();
    if (subBuilder == null) return value;
    if (value is List) {
      return value
          .map(
            (entry) => entry is Map<String, dynamic>
                ? _normalizeMessageJson(entry, subBuilder())
                : entry,
          )
          .toList();
    }
    if (value is Map<String, dynamic>) {
      return _normalizeMessageJson(value, subBuilder());
    }
    return value;
  }

  bool _isSourceProviderField(String fieldPath) {
    return fieldPath.endsWith('.source_provider') ||
        fieldPath.endsWith('.provider_type') ||
        fieldPath.endsWith('.providers');
  }

  bool _isSourceConfigField(String fieldPath) {
    return fieldPath.endsWith('.source_config') &&
        (fieldPath.contains('Media') ||
            fieldPath.contains('Playlist') ||
            fieldPath.contains('AddMediaRequest') ||
            fieldPath.contains('CreatePlaylistRequest'));
  }

  dynamic _normalizeSourceProviderJson(Object? value) {
    if (value is List) {
      return value.map(_normalizeSourceProviderJson).toList();
    }
    if (value is String) {
      return SourceConfigCodec.providerFromString(value).value;
    }
    return value;
  }

  dynamic _normalizeSourceConfigJson(
    Object? value,
    String fieldPath,
    Map<String, dynamic> parentJson,
  ) {
    if (value is! Map<String, dynamic>) return value;
    if (_hasSourceConfigWrapper(value)) return value;
    final providerValue = parentJson['sourceProvider'];
    final provider = providerValue is source_enum.SourceProvider
        ? providerValue
        : providerValue is int
        ? source_enum.SourceProvider.valueOf(providerValue) ??
              source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED
        : SourceConfigCodec.providerFromString(providerValue?.toString() ?? '');
    final config = Map<String, dynamic>.from(value);
    if (fieldPath.contains('Playlist') ||
        fieldPath.contains('CreatePlaylistRequest')) {
      final proto = SourceConfigCodec.playlistSourceConfigForProvider(
        provider,
        config,
      );
      return proto == null
          ? value
          : SourceConfigCodec.playlistSourceConfigJson(proto);
    }
    final proto = SourceConfigCodec.mediaSourceConfigForProvider(
      provider,
      config,
    );
    return proto == null
        ? value
        : SourceConfigCodec.mediaSourceConfigJson(proto);
  }

  static final Set<String> _sourceConfigWrapperFields = {
    ...source_config.MediaSourceConfig.create().info_.sortedByTag.map(
      (field) => field.name,
    ),
    ...source_config.PlaylistSourceConfig.create().info_.sortedByTag.map(
      (field) => field.name,
    ),
  };

  bool _hasSourceConfigWrapper(Map<String, dynamic> value) =>
      value.keys.any(_sourceConfigWrapperFields.contains);

  T _decodeResponse<T extends GeneratedMessage>(
    http.Response response,
    T Function() create, {
    required String method,
    required Uri uri,
  }) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _apiException(response, method: method, uri: uri);
    }
    final message = create();
    if (response.body.trim().isEmpty) {
      return message;
    }
    final decoded = _normalizeResponseJson(jsonDecode(response.body), message);
    message.mergeFromProto3Json(
      decoded,
      supportNamesWithUnderscores: false,
      permissiveEnums: true,
      ignoreUnknownFields: true,
    );
    return message;
  }

  T _decodeCurrentResponse<T extends GeneratedMessage>(
    http.Response response,
    T Function() create, {
    required String method,
    required Uri uri,
    required int generation,
  }) {
    _ensureCurrentEndpoint(generation);
    final message = _decodeResponse(response, create, method: method, uri: uri);
    _ensureCurrentEndpoint(generation);
    _responseGenerations[message] = generation;
    return message;
  }

  void _ensureCurrentEndpoint(int generation) {
    if (generation != _endpointGeneration) {
      throw const SyncTvStaleEndpointException();
    }
  }

  void _notifyAuthError(int generation) {
    if (generation == _endpointGeneration) onAuthError?.call(generation);
  }

  SyncTvApiException _apiException(
    http.Response response, {
    required String method,
    required Uri uri,
  }) {
    final responseBody = response.body.trim();
    var message = responseBody.isEmpty
        ? 'HTTP ${response.statusCode}'
        : response.body;
    int? code;
    int? grpcCode;
    String? requestId;
    oauth2_enum.OAuth2Operation? oauth2Operation;
    try {
      if (responseBody.isEmpty) {
        return SyncTvApiException(
          message,
          statusCode: response.statusCode,
          code: code,
          grpcCode: grpcCode,
          requestId: requestId,
          oauth2Operation: oauth2Operation,
          requestMethod: method,
          requestUri: uri,
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        message = _stringValue(decoded['message']) ?? message;
        grpcCode = _intValue(decoded['code']);

        final details = decoded['details'];
        if (details is List) {
          for (final detail in details) {
            if (detail is! Map<String, dynamic>) continue;
            final metadata = detail['metadata'];
            if (metadata is Map<String, dynamic>) {
              requestId ??= _stringValue(metadata['requestId']);
              code ??= _intValue(metadata['errorCode']);
              oauth2Operation ??= _oauth2OperationValue(
                metadata['oauth2Operation'],
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('API error response parse failed: $e');
    }
    return SyncTvApiException(
      message,
      statusCode: response.statusCode,
      code: code,
      grpcCode: grpcCode,
      requestId: requestId,
      oauth2Operation: oauth2Operation,
      requestMethod: method,
      requestUri: uri,
    );
  }

  String? _stringValue(Object? value) {
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  int? _intValue(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  oauth2_enum.OAuth2Operation? _oauth2OperationValue(Object? value) {
    if (value is int) return oauth2_enum.OAuth2Operation.valueOf(value);
    if (value is String) {
      final numeric = int.tryParse(value);
      if (numeric != null) {
        return oauth2_enum.OAuth2Operation.valueOf(numeric);
      }
      for (final operation in oauth2_enum.OAuth2Operation.values) {
        if (operation.name == value) return operation;
      }
    }
    return null;
  }

  Stream<T> _watchSse<T extends GeneratedMessage>(
    String path,
    T Function() create, {
    Map<String, Object?> query = const {},
  }) async* {
    final generation = _endpointGeneration;
    var request = _sseRequest(path, query, generation);
    var response = await _http.send(request);
    _ensureCurrentEndpoint(generation);
    var refreshedSession = false;
    var authErrorNotified = false;
    if (_shouldRefresh(response, auth: true, path: path)) {
      final refreshed = await _tryRefreshToken(generation);
      _ensureCurrentEndpoint(generation);
      if (refreshed) {
        refreshedSession = true;
        request = _sseRequest(path, query, generation);
        response = await _http.send(request);
        _ensureCurrentEndpoint(generation);
      } else {
        _notifyAuthError(generation);
        authErrorNotified = true;
      }
    }
    if (response.statusCode == 401 && !refreshedSession && !authErrorNotified) {
      _notifyAuthError(generation);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.stream.bytesToString();
      final errorResponse = http.Response(
        body.isEmpty ? '{"message":"SSE watch failed"}' : body,
        response.statusCode,
        headers: response.headers,
      );
      throw _apiException(
        errorResponse,
        method: request.method,
        uri: request.url,
      );
    }

    yield* _decodeSseStream(response.stream, create, generation);
  }

  http.Request _sseRequest(
    String path,
    Map<String, Object?> query,
    int generation,
  ) {
    _ensureCurrentEndpoint(generation);
    final request = http.Request('GET', _uri(path, query));
    request.headers.addAll(_headers());
    request.headers['accept'] = 'text/event-stream';
    return request;
  }

  Stream<T> _decodeSseStream<T extends GeneratedMessage>(
    Stream<List<int>> stream,
    T Function() create,
    int generation,
  ) async* {
    var eventName = '';
    final dataLines = <String>[];
    await for (final line
        in stream.transform(utf8.decoder).transform(const LineSplitter())) {
      _ensureCurrentEndpoint(generation);
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

    _ensureCurrentEndpoint(generation);
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
            supportNamesWithUnderscores: false,
            permissiveEnums: true,
            ignoreUnknownFields: true,
          );
        _setWatchObserved(message, observed);
        return message;
      case 'changed':
        final normalized = _normalizeProtoJson(
          decoded,
          client.ResourceEvent.create(),
        );
        final changed = client.ResourceEvent()
          ..mergeFromProto3Json(
            normalized,
            supportNamesWithUnderscores: false,
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
            supportNamesWithUnderscores: false,
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
      case client.WatchPlaybackEvent event:
        event.observed = observed;
      case client.WatchRoomSettingsEvent event:
        event.observed = observed;
      case client.WatchPlaylistItemsEvent event:
        event.observed = observed;
      case client.WatchRoomMemberEventsEvent event:
        event.observed = observed;
      case client.WatchChatEventsEvent event:
        event.observed = observed;
      case client.WatchChatPinEventsEvent event:
        event.observed = observed;
      default:
        throw ArgumentError.value(message, 'message');
    }
  }

  void _setWatchChanged(
    GeneratedMessage message,
    client.ResourceEvent changed,
  ) {
    switch (message) {
      case client.WatchPlaybackStateEvent event:
        event.resourceEvent = changed;
      case client.WatchPlaybackEvent event:
        event.resourceEvent = changed;
      case client.WatchRoomSettingsEvent event:
        event.resourceEvent = changed;
      case client.WatchPlaylistItemsEvent event:
        event.resourceEvent = changed;
      case client.WatchRoomMemberEventsEvent event:
        event.resourceEvent = changed;
      case client.WatchChatEventsEvent event:
        event.resourceEvent = changed;
      case client.WatchChatPinEventsEvent event:
        event.resourceEvent = changed;
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
      case client.WatchPlaybackEvent event:
        event.error = error;
      case client.WatchRoomSettingsEvent event:
        event.error = error;
      case client.WatchPlaylistItemsEvent event:
        event.error = error;
      case client.WatchRoomMemberEventsEvent event:
        event.error = error;
      case client.WatchChatEventsEvent event:
        event.error = error;
      case client.WatchChatPinEventsEvent event:
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

  Map<String, String> _playbackClientProfileQuery(
    client.PlaybackClientProfile profile,
  ) {
    return {
      if (profile.hasStreamPreference())
        'streamPreference': profile.streamPreference.value.toString(),
      if (profile.hasMaxStreamingBitrate())
        'maxStreamingBitrate': profile.maxStreamingBitrate.toString(),
      if (profile.hasMaxAudioChannels())
        'maxAudioChannels': profile.maxAudioChannels.toString(),
      if (profile.supportedVideoCodecs.isNotEmpty)
        'videoCodecs': profile.supportedVideoCodecs
            .map((codec) => codec.value)
            .join(','),
      if (profile.supportedContainers.isNotEmpty)
        'containers': profile.supportedContainers
            .map((container) => container.value)
            .join(','),
      if (profile.supportedLiveTransports.isNotEmpty)
        'liveTransports': profile.supportedLiveTransports
            .map((transport) => transport.value)
            .join(','),
      if (profile.hasAudioCapability())
        'audioCapability': profile.audioCapability.value.toString(),
      if (profile.hasSubtitlePreference())
        'subtitlePreference': profile.subtitlePreference.value.toString(),
    };
  }

  Map<String, Object?> _watchQuery({
    client_enum.ResourceDeliveryMode deliveryMode =
        client_enum.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
    Int64? afterEventSequence,
  }) {
    return {
      'deliveryMode': deliveryMode.value.toString(),
      if (afterEventSequence != null)
        'afterEventSequence': afterEventSequence.toString(),
    };
  }

  Uri roomWebSocketUri(String roomId, {required String ticket}) {
    final wsScheme = _baseUri.scheme == 'https' ? 'wss' : 'ws';
    final encodedRoomId = Uri.encodeComponent(roomId);
    return _baseUri.replace(
      scheme: wsScheme,
      path: '/ws/rooms/$encodedRoomId',
      queryParameters: {'ticket': ticket, 'format': 'json'},
    );
  }

  void _storeLogin(
    GeneratedMessage response,
    String accessToken,
    String refreshToken,
  ) {
    final generation = _responseGenerations[response];
    if (generation == null) {
      throw StateError(
        'Authentication response was not created by this API client',
      );
    }
    _ensureCurrentEndpoint(generation);
    if (accessToken.isEmpty && refreshToken.isEmpty) return;
    session.updateAccountTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<T> runForCurrentEndpointResponse<T>(
    GeneratedMessage response,
    Future<T> Function() operation,
  ) async {
    final generation = _responseGenerations[response];
    if (generation == null) {
      throw StateError('Response was not created by this API client');
    }
    _ensureCurrentEndpoint(generation);
    final result = await operation();
    _ensureCurrentEndpoint(generation);
    return result;
  }

  int _requestGeneration() => _endpointGeneration;

  void _clearSessionForGeneration(int generation) {
    _ensureCurrentEndpoint(generation);
    session.clear();
  }
}

extension SyncTvModelMapping on SyncTvApiClient {
  SyncTvUser mapUser(client.User user) {
    return SyncTvUser(
      id: user.id,
      username: user.username,
      email: user.email.isEmpty ? null : user.email,
      avatarUrl: resolveResourceUrl(
        user.avatarUrl.isNotEmpty
            ? user.avatarUrl
            : user.hasAvatar()
            ? user.avatar.url
            : '',
      ),
      role: AccountUserRole(user.role),
      status: user.status,
      createdAt: user.createdAt.toInt(),
      isBanned: user.isBanned,
    );
  }

  SyncTvUser mapPublicUser(client.UserPublicView user) {
    return SyncTvUser(
      id: user.id,
      username: user.username,
      avatarUrl: resolveResourceUrl(
        user.avatarUrl.isNotEmpty
            ? user.avatarUrl
            : user.hasAvatar()
            ? user.avatar.url
            : '',
      ),
      role: AccountUserRole(user.role),
      createdAt: user.createdAt.toInt(),
    );
  }

  SyncTvUser mapMember(common.RoomMember member) {
    return SyncTvUser(
      id: member.userId,
      username: member.username,
      role: RoomMembershipRole(member.role),
      createdAt: member.joinedAt.toInt(),
      status: common_enum.UserStatus.USER_STATUS_ACTIVE,
      onlineCount: member.isOnline ? 1 : 0,
      connectionCount: member.connectionCount,
    );
  }

  SyncTvUser mapAdminUser(admin.AdminUser user) {
    return SyncTvUser(
      id: user.id,
      username: user.username,
      email: user.email.isEmpty ? null : user.email,
      role: AccountUserRole(user.role),
      createdAt: user.createdAt.toInt(),
      updatedAt: user.updatedAt.toInt(),
      status: user.isBanned
          ? common_enum.UserStatus.USER_STATUS_BANNED
          : user.status,
      onlineCount: user.hasPresence() && user.presence.connectionCount > 0
          ? 1
          : 0,
      connectionCount: user.hasPresence() ? user.presence.connectionCount : 0,
      isBanned: user.isBanned,
      bannedAt: user.bannedAt.toInt(),
      bannedBy: user.bannedBy,
      bannedReason: user.bannedReason,
    );
  }

  SyncTvRoom mapAdminRoom(admin.Room room) {
    final settings = roomSettingsToJson(room.settings);
    return SyncTvRoom(
      roomId: room.id,
      roomName: room.name,
      description: room.description,
      onlineMemberCount: room.hasPresence()
          ? room.presence.onlineMemberCount
          : 0,
      onlineGuestCount: room.hasPresence() ? room.presence.onlineGuestCount : 0,
      connectionCount: room.hasPresence() ? room.presence.connectionCount : 0,
      memberCount: room.memberCount,
      isPublic: room.hasIsPublic() ? room.isPublic : true,
      creator: room.creatorUsername,
      creatorId: room.creatorId,
      creatorAvatarUrl: resolveResourceUrl(room.creatorAvatarUrl),
      createdAt: room.createdAt.toInt(),
      updatedAt: room.updatedAt.toInt(),
      status: room.status,
      isBanned: room.isBanned,
      version: room.version.toInt(),
      creatorStatus: room.creatorStatus,
      coverUrl: resolveResourceUrl(room.hasCover() ? room.cover.url : ''),
      needPassword: settings['requirePassword'] == true,
      needVerify: settings['requireApproval'] == true,
      guestCanPause: true,
      guestCanAdd: true,
      category: room.hasCategory() ? mapRoomCategory(room.category) : null,
      labels: room.labels.map(mapRoomLabel).toList(growable: false),
    );
  }

  SyncTvRoom mapRoom(client.Room room) {
    final settings = roomSettingsToJson(room.settings);
    return SyncTvRoom(
      roomId: room.id,
      roomName: room.name,
      description: room.description,
      onlineMemberCount: room.hasPresence()
          ? room.presence.onlineMemberCount
          : 0,
      onlineGuestCount: room.hasPresence() ? room.presence.onlineGuestCount : 0,
      connectionCount: room.hasPresence() ? room.presence.connectionCount : 0,
      memberCount: room.memberCount,
      isPublic: room.hasIsPublic() ? room.isPublic : true,
      creator: room.hasCreator() ? room.creator.username : '',
      creatorId: room.hasCreator() ? room.creator.id : room.createdBy,
      creatorAvatarUrl: resolveResourceUrl(
        room.hasCreator() ? room.creator.avatarUrl : '',
      ),
      coverUrl: resolveResourceUrl(room.hasCover() ? room.cover.url : ''),
      createdAt: room.createdAt.toInt(),
      updatedAt: room.updatedAt.toInt(),
      status: room.status,
      isBanned: room.isBanned,
      availability: room.availability,
      version: room.version.toInt(),
      needPassword: settings['requirePassword'] == true,
      needVerify: settings['requireApproval'] == true,
      guestCanPause: true,
      guestCanAdd: true,
      category: room.hasCategory() ? mapRoomCategory(room.category) : null,
      labels: room.labels.map(mapRoomLabel).toList(growable: false),
    );
  }

  SyncTvRoom mapRoomDiscoveryItem(client.RoomDiscoveryItem item) =>
      mapRoom(item.room).copyWith(
        joined: item.joined,
        isFavorite: item.favorited,
        canJoin: item.canJoin,
        discoveryAccess: item.access,
      );

  SyncTvRoom mapMyRoom(client.MyRoom myRoom) => mapRoom(myRoom.room).copyWith(
    myPermissions: myRoom.permissions.toInt(),
    myRole: myRoom.role,
    myRelation: myRoom.relation,
    joined: true,
    canJoin: false,
    isFavorite: myRoom.favorited,
  );

  RoomCategoryInfo mapRoomCategory(client.RoomCategory category) {
    return RoomCategoryInfo(
      id: category.id,
      key: category.key,
      name: category.name,
      description: category.description,
      sortOrder: category.sortOrder,
      isEnabled: category.isEnabled,
    );
  }

  RoomLabelInfo mapRoomLabel(client.RoomLabel label) {
    return RoomLabelInfo(
      id: label.id,
      key: label.key,
      name: label.name,
      description: label.description,
      color: label.color,
      categoryId: label.categoryId,
      sortOrder: label.sortOrder,
      isEnabled: label.isEnabled,
    );
  }

  RoomMediaItem mapMedia(client.Media media) {
    final metadata = media.hasMetadata()
        ? resourceMetadataToJson(media.metadata)
        : <String, dynamic>{};
    final sourceConfig = media.hasSourceConfig()
        ? SourceConfigCodec.mediaSourceConfigToMap(media.sourceConfig)
        : <String, dynamic>{};
    final sourceProvider = media.hasSourceProvider()
        ? media.sourceProvider
        : SourceConfigCodec.providerForMediaSourceConfig(media.sourceConfig);
    final url = resolveResourceUrl(
      RoomMediaEntry.playbackUrlFromResource(
        metadata: metadata,
        sourceConfig: sourceConfig,
      ),
    );
    final liveState = resourceMetadataLiveState(
      media.hasMetadata() ? media.metadata : null,
    );
    final isLive =
        liveState.isLive ||
        (media.hasSourceConfig() &&
            SourceConfigCodec.isLiveMediaSourceConfig(media.sourceConfig));
    return RoomMediaItem(
      id: media.id,
      name: media.name,
      url: url,
      creator: media.creatorId,
      roomId: media.roomId,
      position: media.position,
      addedAt: media.addedAt.toInt(),
      availability: media.availability,
      version: media.version.toInt(),
      type: SourceConfigCodec.providerToString(sourceProvider),
      headers: _stringMap(metadata['headers']),
      proxy: metadata['proxy'] == true,
      live: isLive,
      liveStreamAvailability: liveState.isCurrentlyLive == null
          ? null
          : liveState.isCurrentlyLive!
          ? SyncTvLiveStreamAvailability.live
          : SyncTvLiveStreamAvailability.offline,
      sourceProvider: sourceProvider,
      providerInstanceName: media.providerInstanceName,
      sourceConfig: sourceConfig,
      metadata: metadata,
      description: media.description,
      coverUrl: resolveResourceUrl(media.hasCover() ? media.cover.url : ''),
      thumbnailUrl: resolveResourceUrl(
        media.hasThumbnail() ? media.thumbnail.url : '',
      ),
    );
  }

  RoomPlaylistItem mapPlaylist(client.Playlist playlist) {
    final sourceProvider = playlist.hasSourceProvider()
        ? playlist.sourceProvider
        : SourceConfigCodec.providerForPlaylistSourceConfig(
            playlist.sourceConfig,
          );
    final sourceConfig = playlist.hasSourceConfig()
        ? SourceConfigCodec.playlistSourceConfigToMap(playlist.sourceConfig)
        : <String, dynamic>{};
    final metadata = <String, dynamic>{'isDynamic': playlist.isDynamic}
      ..addAll(
        playlist.hasMetadata()
            ? resourceMetadataToJson(playlist.metadata)
            : const <String, dynamic>{},
      );
    return RoomPlaylistItem(
      id: playlist.id,
      name: playlist.name,
      creator: playlist.creatorId,
      roomId: playlist.roomId,
      parentId: playlist.parentId.isEmpty ? null : playlist.parentId,
      position: playlist.position,
      createdAt: playlist.createdAt.toInt(),
      updatedAt: playlist.updatedAt.toInt(),
      itemCount: playlist.itemCount,
      availability: playlist.availability,
      version: playlist.version.toInt(),
      description: playlist.description,
      coverUrl: resolveResourceUrl(
        playlist.hasCover() ? playlist.cover.url : '',
      ),
      type: playlist.isDynamic
          ? SourceConfigCodec.providerToString(sourceProvider)
          : 'playlist',
      sourceProvider: sourceProvider,
      providerInstanceName: playlist.providerInstanceName,
      sourceConfig: sourceConfig,
      metadata: metadata,
    );
  }

  RoomDynamicMediaEntry mapDynamicItem(
    client.PlaylistItem item, {
    String? playlistId,
  }) {
    final target = item.target;
    final encodedTarget = providerTargetToBase64(target);
    final thumbnailUrl = item.hasThumbnail()
        ? resolveResourceUrl(item.thumbnail)
        : '';
    final metadata =
        <String, dynamic>{
          'target': target,
          'target_json': providerTargetToJson(target),
          'thumbnail': thumbnailUrl,
          'size': item.hasSize() ? item.size.toInt() : null,
        }..addAll(
          item.hasMetadata()
              ? resourceMetadataToJson(item.metadata)
              : const <String, dynamic>{},
        );
    final liveState = resourceMetadataLiveState(
      item.hasMetadata() ? item.metadata : null,
    );
    return RoomDynamicMediaEntry(
      id: encodedTarget,
      name: item.name,
      live: liveState.isLive,
      liveStreamAvailability: liveState.isCurrentlyLive == null
          ? null
          : liveState.isCurrentlyLive!
          ? SyncTvLiveStreamAvailability.live
          : SyncTvLiveStreamAvailability.offline,
      isPlaylist: item.itemType == client_enum.ItemType.ITEM_TYPE_PLAYLIST,
      parentId: playlistId,
      subPath: encodedTarget,
      coverUrl: thumbnailUrl,
      mediaSourceConfig: item.hasMediaSourceConfig()
          ? item.mediaSourceConfig.deepCopy()
          : null,
      playlistSourceConfig: item.hasPlaylistSourceConfig()
          ? item.playlistSourceConfig.deepCopy()
          : null,
      metadata: metadata,
    );
  }

  SyncTvPlaybackStatus mapPlaybackState(
    client.PlaybackState state, {
    RoomMediaEntry? entry,
  }) {
    return SyncTvPlaybackStatus(
      entry: entry,
      isPlaying: state.isPlaying,
      currentTime: state.position,
      playbackRate: state.speed == 0 ? 1.0 : state.speed,
      generatedAtMillis: state.generatedAtMillis.toInt(),
      version: state.version.toInt(),
      playingMediaId: state.playingMediaId,
      playingPlaylistId: state.playingPlaylistId,
      targetHash: state.targetHash,
    );
  }

  Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }
}
