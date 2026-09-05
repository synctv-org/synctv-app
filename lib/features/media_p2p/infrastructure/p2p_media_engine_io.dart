import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_cache.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_manifest.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_max_resource_length.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_length_metadata.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';

typedef P2pPieceRequester = Future<P2pPeerPiece?> Function(
  String swarmId,
  String pieceKey,
  P2pPieceRequestCancellation cancellation,
);
typedef P2pIntegrityReporter = Future<void> Function(
  P2pPeerSource source,
  bool valid,
);
typedef P2pPeerAvailability = bool Function(String swarmId);

Future<void> _ignorePeerIntegrity(P2pPeerSource source, bool valid) async {}
bool _alwaysHasPeer(String swarmId) => true;

typedef _P2pManifestKind = P2pManifestKind;

class P2pMediaEngine implements P2pMediaPlaybackEngine {
  P2pMediaEngine({
    required this.requestPeerPiece,
    this.reportPeerIntegrity = _ignorePeerIntegrity,
    this.canRequestPeer = _alwaysHasPeer,
    this.maxCacheBytes = 128 * 1024 * 1024,
    this.persistentCache,
    Duration? cacheTtl,
    P2pMediaCacheClock? clock,
    this.originHeaderPeerRetryDelay = const Duration(seconds: 2),
    this.originHeaderTimeout = const Duration(seconds: 15),
    this.originHeaderPeerRecoveryTimeout = const Duration(seconds: 30),
    this.originBodyStallPeerRetryDelay = const Duration(seconds: 3),
    this.peerMissingRetryDelay = const Duration(seconds: 1),
    this.peerPrefetchJoinDelay = const Duration(milliseconds: 150),
    this.originBodySlowObservation = const Duration(seconds: 2),
    this.originBodyHedgeDelay = const Duration(seconds: 5),
    this.originBodyMinimumRateBytesPerSecond = 256 * 1024,
    this.progressiveOriginPeerRecoveryTimeout = const Duration(seconds: 2),
    this.securityMode = P2pMediaSecurityMode.standard,
    this.originSampleRate = 0.10,
  }) : cacheTtl =
           cacheTtl ?? persistentCache?.ttl ?? const Duration(minutes: 10),
       _clock = clock ?? DateTime.now,
       _memoryCache = _ByteLruCache(
         ttl: cacheTtl ?? persistentCache?.ttl ?? const Duration(minutes: 10),
         clock: clock ?? DateTime.now,
       ) {
    assert(maxCacheBytes > 0);
    assert(this.cacheTtl > Duration.zero);
    assert(originHeaderTimeout > Duration.zero);
    assert(originHeaderPeerRecoveryTimeout > Duration.zero);
    assert(progressiveOriginPeerRecoveryTimeout > Duration.zero);
    assert(originSampleRate >= 0 && originSampleRate <= 1);
    assert(originBodyMinimumRateBytesPerSecond > 0);
    _httpClient.connectionTimeout = const Duration(seconds: 10);
  }

  static const int progressivePieceSize = 1024 * 1024;
  static const int _maxWholeResourceBytes = 16 * 1024 * 1024;
  static const int _maxManifestBytes = 4 * 1024 * 1024;
  static const int _progressivePrefetchWindow = 2;
  static const int _maxPeerPrefetches = 2;
  static const int _progressiveOriginAttempts = 3;
  static const Duration _progressiveOriginRetryDelay = Duration(
    milliseconds: 200,
  );
  static const int _maxResourceMappings = 8192;
  static const Duration _resourceIdleTtl = Duration(minutes: 30);

  final P2pPieceRequester requestPeerPiece;
  final P2pIntegrityReporter reportPeerIntegrity;
  final P2pPeerAvailability canRequestPeer;
  @override
  final int maxCacheBytes;
  final P2pMediaPersistentCache? persistentCache;
  final Duration cacheTtl;
  final Duration originHeaderPeerRetryDelay;
  final Duration originHeaderTimeout;
  final Duration originHeaderPeerRecoveryTimeout;
  final Duration originBodyStallPeerRetryDelay;
  final Duration peerMissingRetryDelay;
  final Duration peerPrefetchJoinDelay;
  final Duration originBodySlowObservation;
  final Duration originBodyHedgeDelay;
  final int originBodyMinimumRateBytesPerSecond;
  final Duration progressiveOriginPeerRecoveryTimeout;
  @override
  final P2pMediaSecurityMode securityMode;
  final double originSampleRate;
  @override
  final ValueNotifier<P2pMediaStats> stats = ValueNotifier(
    const P2pMediaStats(),
  );
  final HttpClient _httpClient = HttpClient();
  final Map<String, _GatewayResource> _resources = {};
  final Map<String, _CachedLength> _progressiveLengths = {};
  final Map<String, Future<Uint8List?>> _pieceLoads = {};
  final Map<String, _CompleteOriginLoad> _completeOriginLoads = {};
  final Map<String, _PeerPrefetch> _peerPrefetches = {};
  final Map<String, Completer<void>> _peerPrefetchReservations = {};
  final Set<P2pPieceRequestCancellation> _activePeerRequests = {};
  final P2pMediaCacheClock _clock;
  final _ByteLruCache _memoryCache;
  final Random _random = Random.secure();
  HttpServer? _server;
  String? _sessionToken;
  bool _disposed = false;

  @override
  Future<Uri> localize({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String format,
  }) async {
    if (_disposed) throw StateError('P2P media engine has been disposed');
    await _ensureServer();
    final manifestKind = p2pManifestKind(format, upstream);
    final resource = _registerResource(
      upstream: upstream,
      headers: headers,
      swarmId: swarmId,
      logicalKey: 'root',
      shareable: manifestKind == P2pManifestKind.progressive,
      manifestKind: manifestKind,
      isDirectory: false,
    );
    return _localUri(resource);
  }

  @override
  Future<Uri> localizeStatic({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String logicalKey,
  }) async {
    if (_disposed) throw StateError('P2P media engine has been disposed');
    await _ensureServer();
    final resource = _registerResource(
      upstream: upstream,
      headers: headers,
      swarmId: swarmId,
      logicalKey: logicalKey,
      shareable: true,
      manifestKind: _P2pManifestKind.progressive,
      isDirectory: false,
    );
    return _localUri(resource);
  }

  @override
  Future<Uint8List?> cachedPiece(String swarmId, String pieceKey) async {
    final key = _cacheKey(swarmId, pieceKey);
    return _readCachedPiece(key, recordStats: true);
  }

  Future<Uint8List?> _readCachedPiece(
    String key, {
    required bool recordStats,
  }) async {
    var value = _memoryCache.get(key);
    if (value != null) {
      final cache = persistentCache;
      if (cache != null) {
        unawaited(
          cache.touch(key).then((_) => _updateCacheByteStats()).catchError((
            Object error,
          ) {
            debugPrint('P2P media cache touch failed: $error');
          }),
        );
      }
    } else {
      final cache = persistentCache;
      if (cache != null) {
        try {
          value = await cache.get(key);
          value ??= _memoryCache.get(key);
          if (value != null) {
            _memoryCache.put(key, value);
            _memoryCache.evictTo(_memoryCacheLimit);
          }
        } catch (error) {
          debugPrint('P2P media cache read failed: $error');
          value = _memoryCache.get(key);
        }
      }
    }
    value ??= _memoryCache.get(key);
    if (recordStats) {
      stats.value = value == null
          ? stats.value.copyWith(cacheMisses: stats.value.cacheMisses + 1)
          : stats.value.copyWith(cacheHits: stats.value.cacheHits + 1);
    }
    _updateCacheByteStats();
    return value;
  }

  Future<void> _ensureServer() async {
    if (_server != null) return;
    try {
      await persistentCache?.initialize();
      _updateCacheByteStats();
    } catch (error) {
      debugPrint('P2P media cache initialization failed: $error');
    }
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _sessionToken = _randomToken(24);
    _server = server;
    unawaited(
      server.forEach((request) async {
        try {
          await _handleRequest(request);
        } catch (error, stackTrace) {
          debugPrint('P2P media gateway error: $error\n$stackTrace');
          try {
            request.response.statusCode = HttpStatus.badGateway;
          } on StateError {
            // The response already started; closing terminates the failed stream.
          }
          try {
            await _closeResponseIgnoringContentLengthShortfall(
              request.response,
            );
          } catch (closeError, closeStackTrace) {
            debugPrint(
              'P2P media gateway response close failed: '
              '$closeError\n$closeStackTrace',
            );
          }
        }
      }),
    );
  }

  Future<void> _handleRequest(HttpRequest request) async {
    if (request.method != 'GET' && request.method != 'HEAD') {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      await request.response.close();
      return;
    }
    final segments = request.uri.pathSegments;
    if (segments.length < 2 || segments[0] != _sessionToken) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }
    final resource = _resources[segments[1]];
    if (resource == null) {
      request.response.statusCode = HttpStatus.gone;
      await request.response.close();
      return;
    }
    resource.lastAccessed = DateTime.now();
    if (resource.isDirectory) {
      await _serveDirectoryResource(request, resource, segments.skip(2));
      return;
    }
    if (resource.manifestKind == _P2pManifestKind.hls ||
        resource.manifestKind == _P2pManifestKind.dash) {
      await _serveManifest(request, resource);
      return;
    }
    final rangeHeader = request.headers.value(HttpHeaders.rangeHeader);
    if (rangeHeader != null) {
      final requested = _parseRange(rangeHeader);
      final totalLength = await _resolveResourceLength(resource);
      final range = requested?.resolve(totalLength);
      if (range == null) {
        await _writeRangeNotSatisfiable(request, totalLength);
        return;
      }
      if (requested!.isOpenEnded) {
        await _serveProgressiveBody(
          request,
          resource,
          totalLength,
          range: range,
        );
      } else if (resource.logicalKey == 'root') {
        await _serveProgressiveRange(
          request,
          resource,
          range,
          totalLength: totalLength,
        );
      } else {
        await _serveWholePiece(
          request,
          resource,
          range: range,
          totalLength: totalLength,
        );
      }
      return;
    }
    if (resource.logicalKey == 'root') {
      final length = await _resolveResourceLength(resource);
      if (length > 0 && length <= _maxWholeResourceBytes) {
        await _serveWholePiece(request, resource, totalLength: length);
      } else if (length > _maxWholeResourceBytes) {
        await _serveProgressiveBody(request, resource, length);
      } else if (_canRequestPeer(resource)) {
        request.response.statusCode = HttpStatus.badGateway;
        await request.response.close();
      } else {
        await _streamOrigin(request, resource);
      }
      return;
    }
    await _serveWholePiece(request, resource);
  }

  Future<void> _serveManifest(
    HttpRequest request,
    _GatewayResource resource,
  ) async {
    final origin = await _openOrigin(resource);
    final bytes = await _readAll(origin, maxBytes: _maxManifestBytes);
    if (bytes == null) {
      request.response.statusCode = HttpStatus.badGateway;
      await request.response.close();
      return;
    }
    if (origin.statusCode < 200 || origin.statusCode >= 300) {
      await _writeOriginResponse(request, origin, bytes);
      return;
    }
    final manifest = utf8.decode(bytes, allowMalformed: false);
    final rewritten = resource.manifestKind == _P2pManifestKind.dash
        ? _rewriteDashManifest(manifest, resource)
        : _rewriteHlsManifest(manifest, resource);
    final output = utf8.encode(rewritten);
    request.response.statusCode = HttpStatus.ok;
    request.response.headers.contentType = ContentType(
      'application',
      resource.manifestKind == _P2pManifestKind.dash
          ? 'dash+xml'
          : 'vnd.apple.mpegurl',
      charset: 'utf-8',
    );
    request.response.headers.contentLength = output.length;
    request.response.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
    if (request.method != 'HEAD') request.response.add(output);
    await request.response.close();
  }

  Future<void> _serveWholePiece(
    HttpRequest request,
    _GatewayResource resource, {
    _ByteRange? range,
    int? totalLength,
  }) async {
    if (request.method == 'HEAD' && range == null) {
      final resolvedLength =
          totalLength ?? await _resolveResourceLength(resource);
      if (resolvedLength > 0) {
        request.response.statusCode = HttpStatus.ok;
        request.response.headers.contentLength = resolvedLength;
        request.response.headers.contentType = _contentTypeFor(
          resource.upstream,
        );
        request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
        await request.response.close();
        return;
      }
      if (_canRequestPeer(resource)) {
        request.response.statusCode = HttpStatus.badGateway;
        await request.response.close();
      } else {
        await _streamOrigin(request, resource);
      }
      return;
    }
    final pieceKey = range == null
        ? resource.logicalKey
        : '${resource.logicalKey}:range:${range.start}-${range.end}';
    final bytes = await _loadPiece(
      resource,
      pieceKey,
      rangeHeader: range?.header,
      requestedRange: range,
      expectedLength: range?.length,
    );
    if (bytes == null) {
      if (range == null) {
        await _streamOrigin(request, resource);
        return;
      }
      request.response.statusCode = HttpStatus.badGateway;
      await request.response.close();
      return;
    }
    request.response.statusCode = range == null
        ? HttpStatus.ok
        : HttpStatus.partialContent;
    request.response.headers.contentLength = bytes.length;
    request.response.headers.contentType = _contentTypeFor(resource.upstream);
    if (range != null) {
      request.response.headers.set(
        HttpHeaders.contentRangeHeader,
        'bytes ${range.start}-${range.end}/$totalLength',
      );
      request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
    }
    if (request.method != 'HEAD') request.response.add(bytes);
    await request.response.close();
  }

  Future<void> _serveProgressiveRange(
    HttpRequest request,
    _GatewayResource resource,
    _ByteRange requested, {
    required int totalLength,
  }) async {
    var resolvedTotalLength = totalLength;
    if (resource.originAcceptsRanges == false &&
        resolvedTotalLength <= _maxWholeResourceBytes) {
      await _serveSmallProgressiveRange(
        request,
        resource,
        requested,
        totalLength: resolvedTotalLength,
      );
      return;
    }
    final alignedStart =
        (requested.start ~/ progressivePieceSize) * progressivePieceSize;
    final alignedEnd = alignedStart + progressivePieceSize - 1;
    final pieceKey =
        '${resource.logicalKey}:piece:${alignedStart ~/ progressivePieceSize}';
    final loadKey = _cacheKey(resource.swarmId, pieceKey);
    final originRange = 'bytes=$alignedStart-$alignedEnd';
    await _rememberResourceLength(resource, resolvedTotalLength);
    Uint8List? bytes = await cachedPiece(resource.swarmId, pieceKey);
    var pendingPrefetch = _peerPrefetches[loadKey];
    final reservation = _peerPrefetchReservations[loadKey];
    if (bytes == null && pendingPrefetch == null && reservation != null) {
      await reservation.future;
      bytes = await cachedPiece(resource.swarmId, pieceKey);
      pendingPrefetch = _peerPrefetches[loadKey];
    }
    pendingPrefetch ??= _peerPrefetches[loadKey];
    if (bytes == null && pendingPrefetch != null) {
      bytes = await Future.any<Uint8List?>([
        pendingPrefetch.future,
        Future<Uint8List?>.delayed(peerPrefetchJoinDelay, () => null),
      ]);
    }
    if (bytes == null && pendingPrefetch == null && _canRequestPeer(resource)) {
      bytes = await _requestValidatedPeerPiece(
        resource,
        pieceKey,
        rangeHeader: originRange,
        expectedLength: min(
          progressivePieceSize,
          resolvedTotalLength - alignedStart,
        ),
      );
    }
    if (bytes == null) {
      final opened = await _openOriginWithPeerRetry(
        resource,
        pieceKey,
        rangeHeader: originRange,
        expectedPeerLength: min(
          progressivePieceSize,
          resolvedTotalLength - alignedStart,
        ),
        pendingPeerPrefetch: pendingPrefetch,
      );
      if (opened?.peerBytes case final peerBytes?) {
        bytes = peerBytes;
      } else if (opened?.origin case final origin?) {
        if (origin.statusCode != HttpStatus.partialContent &&
            origin.statusCode != HttpStatus.ok) {
          final errorBytes =
              await _readAll(origin, maxBytes: _maxManifestBytes) ??
              Uint8List(0);
          await _writeOriginResponse(request, origin, errorBytes);
          return;
        }
        final originIgnoredRange = origin.statusCode == HttpStatus.ok;
        resolvedTotalLength = originIgnoredRange
            ? origin.contentLength
            : _totalLength(
                origin.headers.value(HttpHeaders.contentRangeHeader),
              );
        if (originIgnoredRange) {
          bytes = await _readTargetPieceFromCompleteOrigin(
            resource,
            origin,
            targetPieceIndex: alignedStart ~/ progressivePieceSize,
          );
        } else {
          bytes = await _readOriginWithPeerRetry(
            resource,
            pieceKey,
            origin,
            rangeHeader: originRange,
            expectedPeerLength: min(
              progressivePieceSize,
              resolvedTotalLength - alignedStart,
            ),
            requestedRange: _ByteRange(
              alignedStart,
              min(alignedEnd, resolvedTotalLength - 1),
            ),
          );
          if (bytes != null && resource.shareable) {
            _putCache(resource.swarmId, pieceKey, bytes);
          }
        }
        await _rememberResourceLength(resource, resolvedTotalLength);
      } else {
        request.response.statusCode = HttpStatus.badGateway;
        await request.response.close();
        return;
      }
    }
    if (bytes == null) {
      request.response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
      if (resolvedTotalLength > 0) {
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes */$resolvedTotalLength',
        );
      }
      await request.response.close();
      return;
    }
    final offset = requested.start - alignedStart;
    if (offset >= bytes.length) {
      request.response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
      await request.response.close();
      return;
    }
    final requestedEnd = requested.end;
    final availableEnd = alignedStart + bytes.length - 1;
    final outputEnd = min(requestedEnd, availableEnd);
    final output = Uint8List.sublistView(
      bytes,
      offset,
      outputEnd - alignedStart + 1,
    );
    request.response.statusCode = HttpStatus.partialContent;
    request.response.headers.contentLength = output.length;
    request.response.headers.contentType = _contentTypeFor(resource.upstream);
    request.response.headers.set(
      HttpHeaders.contentRangeHeader,
      'bytes ${requested.start}-$outputEnd/$resolvedTotalLength',
    );
    request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
    if (request.method != 'HEAD') request.response.add(output);
    if (resolvedTotalLength > 0) {
      _scheduleProgressivePeerPrefetch(
        resource,
        start: alignedStart + progressivePieceSize,
        totalLength: resolvedTotalLength,
      );
    }
    await request.response.close();
  }

  Future<void> _serveSmallProgressiveRange(
    HttpRequest request,
    _GatewayResource resource,
    _ByteRange range, {
    required int totalLength,
  }) async {
    final bytes = await _loadPiece(
      resource,
      resource.logicalKey,
      expectedLength: totalLength,
    );
    if (bytes == null || bytes.length != totalLength) {
      request.response.statusCode = HttpStatus.badGateway;
      await request.response.close();
      return;
    }
    final output = Uint8List.sublistView(bytes, range.start, range.end + 1);
    request.response.statusCode = HttpStatus.partialContent;
    request.response.headers.contentLength = output.length;
    request.response.headers.contentType = _contentTypeFor(resource.upstream);
    request.response.headers.set(
      HttpHeaders.contentRangeHeader,
      'bytes ${range.start}-${range.end}/$totalLength',
    );
    request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
    if (request.method != 'HEAD') request.response.add(output);
    await request.response.close();
  }

  Future<Uint8List?> _readTargetPieceFromCompleteOrigin(
    _GatewayResource resource,
    HttpClientResponse origin, {
    required int targetPieceIndex,
  }) async {
    final loadKey = _cacheKey(resource.swarmId, resource.logicalKey);
    final existing = _completeOriginLoads[loadKey];
    if (existing != null) {
      await origin.listen((_) {}).cancel();
      final cached = await cachedPiece(
        resource.swarmId,
        '${resource.logicalKey}:piece:$targetPieceIndex',
      );
      return cached ?? existing.waitForPiece(targetPieceIndex);
    }

    final load = _CompleteOriginLoad();
    _completeOriginLoads[loadKey] = load;
    final target = load.waitForPiece(targetPieceIndex);
    unawaited(
      _consumeCompleteOrigin(resource, origin, load).whenComplete(() {
        load.finish();
        if (identical(_completeOriginLoads[loadKey], load)) {
          _completeOriginLoads.remove(loadKey);
        }
      }),
    );
    return target;
  }

  Future<void> _consumeCompleteOrigin(
    _GatewayResource resource,
    HttpClientResponse origin,
    _CompleteOriginLoad load,
  ) async {
    var pieceIndex = 0;
    var builder = BytesBuilder(copy: false);
    await for (final chunk in origin) {
      _recordHttp(chunk.length);
      var offset = 0;
      while (offset < chunk.length) {
        final take = min(
          progressivePieceSize - builder.length,
          chunk.length - offset,
        );
        builder.add(chunk.sublist(offset, offset + take));
        offset += take;
        if (builder.length == progressivePieceSize) {
          final bytes = builder.takeBytes();
          _putCache(
            resource.swarmId,
            '${resource.logicalKey}:piece:$pieceIndex',
            bytes,
          );
          load.completePiece(pieceIndex, bytes);
          pieceIndex++;
          builder = BytesBuilder(copy: false);
        }
      }
    }
    if (builder.isNotEmpty) {
      final bytes = builder.takeBytes();
      _putCache(
        resource.swarmId,
        '${resource.logicalKey}:piece:$pieceIndex',
        bytes,
      );
      load.completePiece(pieceIndex, bytes);
    }
  }

  Future<void> _serveProgressiveBody(
    HttpRequest request,
    _GatewayResource resource,
    int totalLength, {
    _ByteRange? range,
  }) async {
    final outputRange = range ?? _ByteRange(0, totalLength - 1);
    if (range != null &&
        resource.originAcceptsRanges == false &&
        totalLength <= _maxWholeResourceBytes) {
      await _serveSmallProgressiveRange(
        request,
        resource,
        outputRange,
        totalLength: totalLength,
      );
      return;
    }
    var successResponseConfigured = false;
    void configureSuccessResponse() {
      if (successResponseConfigured) return;
      successResponseConfigured = true;
      request.response.statusCode = range == null
          ? HttpStatus.ok
          : HttpStatus.partialContent;
      request.response.headers.contentLength = outputRange.length;
      request.response.headers.contentType = _contentTypeFor(resource.upstream);
      request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
      if (range != null) {
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes ${outputRange.start}-${outputRange.end}/$totalLength',
        );
      }
    }

    Future<void> closeFailedResponse() async {
      if (successResponseConfigured) {
        await _closeResponseIgnoringContentLengthShortfall(request.response);
        return;
      }
      request.response.statusCode = HttpStatus.badGateway;
      request.response.headers.contentLength = 0;
      await request.response.close();
    }

    if (request.method == 'HEAD') {
      configureSuccessResponse();
      await request.response.close();
      return;
    }

    final firstPieceStart =
        (outputRange.start ~/ progressivePieceSize) * progressivePieceSize;
    for (
      var start = firstPieceStart;
      start <= outputRange.end;
      start += progressivePieceSize
    ) {
      final pieceIndex = start ~/ progressivePieceSize;
      final pieceKey = '${resource.logicalKey}:piece:$pieceIndex';
      final loadKey = _cacheKey(resource.swarmId, pieceKey);
      var pendingPrefetch = _peerPrefetches[loadKey];
      var bytes = await cachedPiece(resource.swarmId, pieceKey);
      final reservation = _peerPrefetchReservations[loadKey];
      if (bytes == null && pendingPrefetch == null && reservation != null) {
        await reservation.future;
        bytes = await cachedPiece(resource.swarmId, pieceKey);
        pendingPrefetch = _peerPrefetches[loadKey];
      }
      pendingPrefetch ??= _peerPrefetches[loadKey];
      if (bytes == null && pendingPrefetch != null) {
        bytes = await Future.any<Uint8List?>([
          pendingPrefetch.future,
          Future<Uint8List?>.delayed(peerPrefetchJoinDelay, () => null),
        ]);
      }
      if (bytes == null &&
          pendingPrefetch == null &&
          _canRequestPeer(resource)) {
        final expectedLength = min(progressivePieceSize, totalLength - start);
        bytes = await _requestValidatedPeerPiece(
          resource,
          pieceKey,
          rangeHeader: 'bytes=$start-${start + expectedLength - 1}',
          expectedLength: expectedLength,
        );
      }
      if (bytes == null) {
        final end = min(start + progressivePieceSize, totalLength) - 1;
        final rangeHeader = 'bytes=$start-$end';
        for (
          var attempt = 0;
          attempt < _progressiveOriginAttempts && bytes == null;
          attempt++
        ) {
          final opened = await _openOriginWithPeerRetry(
            resource,
            pieceKey,
            rangeHeader: rangeHeader,
            expectedPeerLength: end - start + 1,
            pendingPeerPrefetch: attempt == 0 ? pendingPrefetch : null,
          );
          if (opened?.peerBytes case final peerBytes?) {
            bytes = peerBytes;
          } else if (opened?.origin case final origin?) {
            if (origin.statusCode == HttpStatus.ok) {
              final wroteOutput = await _streamCompleteOriginFromOffset(
                request,
                resource,
                origin,
                outputOffset: max(start, outputRange.start),
                beforeFirstOutput: configureSuccessResponse,
              );
              if (wroteOutput) {
                await _closeResponseIgnoringContentLengthShortfall(
                  request.response,
                );
              } else {
                await closeFailedResponse();
              }
              return;
            }
            if (origin.statusCode == HttpStatus.partialContent) {
              bytes = await _readOriginWithPeerRetry(
                resource,
                pieceKey,
                origin,
                rangeHeader: rangeHeader,
                expectedPeerLength: end - start + 1,
                requestedRange: _ByteRange(start, end),
                peerRecoveryTimeout: progressiveOriginPeerRecoveryTimeout,
              );
              if (bytes != null && resource.shareable) {
                _putCache(resource.swarmId, pieceKey, bytes);
              }
            } else {
              debugPrint(
                'P2P media origin returned ${origin.statusCode} for '
                '$pieceKey (attempt ${attempt + 1}/'
                '$_progressiveOriginAttempts)',
              );
              await origin.drain<void>();
            }
          }
          if (bytes == null && attempt + 1 < _progressiveOriginAttempts) {
            await Future<void>.delayed(_progressiveOriginRetryDelay);
          }
        }
        if (bytes == null) {
          await closeFailedResponse();
          return;
        }
      }
      final outputStart = max(0, outputRange.start - start);
      final outputEnd = min(bytes.length, outputRange.end - start + 1);
      if (outputStart < outputEnd) {
        configureSuccessResponse();
        request.response.add(
          Uint8List.sublistView(bytes, outputStart, outputEnd),
        );
        await request.response.flush();
      }
      _scheduleProgressivePeerPrefetch(
        resource,
        start: start + progressivePieceSize,
        totalLength: totalLength,
      );
    }
    if (!successResponseConfigured) {
      await closeFailedResponse();
      return;
    }
    await request.response.close();
  }

  static Future<void> _closeResponseIgnoringContentLengthShortfall(
    HttpResponse response,
  ) async {
    try {
      await response.close();
    } on HttpException catch (error) {
      if (!error.message.startsWith(
        'Content size below specified contentLength.',
      )) {
        rethrow;
      }
    }
  }

  void _scheduleProgressivePeerPrefetch(
    _GatewayResource resource, {
    required int start,
    required int totalLength,
  }) {
    if (_disposed || !_canRequestPeer(resource)) return;
    for (
      var offset = start;
      offset < totalLength &&
          offset < start + progressivePieceSize * _progressivePrefetchWindow;
      offset += progressivePieceSize
    ) {
      if (_peerPrefetches.length + _peerPrefetchReservations.length >=
          _maxPeerPrefetches) {
        return;
      }
      final pieceIndex = offset ~/ progressivePieceSize;
      final pieceKey = '${resource.logicalKey}:piece:$pieceIndex';
      final loadKey = _cacheKey(resource.swarmId, pieceKey);
      if (_peerPrefetches.containsKey(loadKey) ||
          _peerPrefetchReservations.containsKey(loadKey)) {
        continue;
      }
      final reservation = Completer<void>();
      _peerPrefetchReservations[loadKey] = reservation;
      final expectedLength = min(progressivePieceSize, totalLength - offset);
      unawaited(
        _startProgressivePeerPrefetch(
          resource,
          pieceKey: pieceKey,
          loadKey: loadKey,
          offset: offset,
          expectedLength: expectedLength,
          reservation: reservation,
        ),
      );
    }
  }

  Future<void> _startProgressivePeerPrefetch(
    _GatewayResource resource, {
    required String pieceKey,
    required String loadKey,
    required int offset,
    required int expectedLength,
    required Completer<void> reservation,
  }) async {
    try {
      if (await _readCachedPiece(loadKey, recordStats: false) != null ||
          _disposed ||
          _peerPrefetches.containsKey(loadKey)) {
        return;
      }
      final cancellation = P2pPieceRequestCancellation();
      _activePeerRequests.add(cancellation);
      late final _PeerPrefetch prefetch;
      final future =
          _requestValidatedPeerPiece(
            resource,
            pieceKey,
            rangeHeader: 'bytes=$offset-${offset + expectedLength - 1}',
            expectedLength: expectedLength,
            cancellation: cancellation,
          ).catchError((Object error) {
            debugPrint('P2P media prefetch failed: $error');
            return null;
          });
      prefetch = _PeerPrefetch(cancellation, future);
      _peerPrefetches[loadKey] = prefetch;
      unawaited(
        future.whenComplete(() {
          _activePeerRequests.remove(cancellation);
          if (identical(_peerPrefetches[loadKey], prefetch)) {
            _peerPrefetches.remove(loadKey);
          }
        }),
      );
    } finally {
      if (identical(_peerPrefetchReservations[loadKey], reservation)) {
        _peerPrefetchReservations.remove(loadKey);
      }
      if (!reservation.isCompleted) reservation.complete();
    }
  }

  Future<bool> _streamCompleteOriginFromOffset(
    HttpRequest request,
    _GatewayResource resource,
    HttpClientResponse origin, {
    required int outputOffset,
    required void Function() beforeFirstOutput,
  }) async {
    request.response.bufferOutput = false;
    var absoluteOffset = 0;
    var pieceIndex = 0;
    var wroteOutput = false;
    var pieceBuilder = BytesBuilder(copy: false);
    await for (final chunk in origin) {
      _recordHttp(chunk.length);
      var chunkOffset = 0;
      while (chunkOffset < chunk.length) {
        final remaining = progressivePieceSize - pieceBuilder.length;
        final take = min(remaining, chunk.length - chunkOffset);
        pieceBuilder.add(chunk.sublist(chunkOffset, chunkOffset + take));
        chunkOffset += take;
        if (pieceBuilder.length == progressivePieceSize) {
          _putCache(
            resource.swarmId,
            '${resource.logicalKey}:piece:$pieceIndex',
            pieceBuilder.takeBytes(),
          );
          pieceBuilder = BytesBuilder(copy: false);
          pieceIndex++;
        }
      }
      final chunkEnd = absoluteOffset + chunk.length;
      if (chunkEnd > outputOffset) {
        final startInChunk = max(0, outputOffset - absoluteOffset);
        if (!wroteOutput) beforeFirstOutput();
        request.response.add(chunk.sublist(startInChunk));
        await request.response.flush();
        wroteOutput = true;
      }
      absoluteOffset = chunkEnd;
    }
    if (pieceBuilder.isNotEmpty) {
      _putCache(
        resource.swarmId,
        '${resource.logicalKey}:piece:$pieceIndex',
        pieceBuilder.takeBytes(),
      );
    }
    return wroteOutput;
  }

  Future<Uint8List?> _loadPiece(
    _GatewayResource resource,
    String pieceKey, {
    String? rangeHeader,
    _ByteRange? requestedRange,
    int? expectedLength,
  }) {
    final loadKey = _cacheKey(resource.swarmId, pieceKey);
    final existing = _pieceLoads[loadKey];
    if (existing != null) return existing;
    final future = _loadPieceOnce(
      resource,
      pieceKey,
      rangeHeader: rangeHeader,
      requestedRange: requestedRange,
      expectedLength: expectedLength,
    );
    _pieceLoads[loadKey] = future;
    return future.whenComplete(() => _pieceLoads.remove(loadKey));
  }

  Future<Uint8List?> _loadPieceOnce(
    _GatewayResource resource,
    String pieceKey, {
    String? rangeHeader,
    _ByteRange? requestedRange,
    int? expectedLength,
  }) async {
    final cached = await cachedPiece(resource.swarmId, pieceKey);
    if (cached != null) return cached;
    if (_canRequestPeer(resource)) {
      final peer = await _requestValidatedPeerPiece(
        resource,
        pieceKey,
        rangeHeader: rangeHeader,
        expectedLength: expectedLength,
      );
      if (peer != null) return peer;
    }
    final opened = await _openOriginWithPeerRetry(
      resource,
      pieceKey,
      rangeHeader: rangeHeader,
      expectedPeerLength: expectedLength,
    );
    if (opened?.peerBytes case final peerBytes?) return peerBytes;
    final origin = opened?.origin;
    if (origin == null) return null;
    if (origin.statusCode < 200 || origin.statusCode >= 300) return null;
    if (expectedLength == null &&
        origin.contentLength > _maxWholeResourceBytes) {
      await origin.listen((_) {}).cancel();
      return null;
    }
    final bytes = await _readOriginWithPeerRetry(
      resource,
      pieceKey,
      origin,
      rangeHeader: rangeHeader,
      expectedPeerLength: expectedLength,
      requestedRange: requestedRange,
    );
    if (bytes != null && resource.shareable) {
      _putCache(resource.swarmId, pieceKey, bytes);
    }
    return bytes;
  }

  Future<_OpenedOriginOrPeer?> _openOriginWithPeerRetry(
    _GatewayResource resource,
    String pieceKey, {
    String? rangeHeader,
    int? expectedPeerLength,
    _PeerPrefetch? pendingPeerPrefetch,
  }) async {
    final originOperation = _CancellableOriginOpen(
      _httpClient,
      resource,
      rangeHeader: rangeHeader,
    );
    if (!_canRequestPeer(resource)) {
      final origin = await Future.any<HttpClientResponse?>([
        originOperation.future,
        Future<HttpClientResponse?>.delayed(originHeaderTimeout, () => null),
      ]);
      if (origin == null) await originOperation.cancel();
      return origin == null ? null : _OpenedOriginOrPeer(origin: origin);
    }
    final cancellation = P2pPieceRequestCancellation();
    _activePeerRequests.add(cancellation);
    final Future<Uint8List?> peerFuture;
    if (pendingPeerPrefetch == null) {
      peerFuture = _retryPeerPiece(
        resource,
        pieceKey,
        cancellation,
        initialDelay: originHeaderPeerRetryDelay,
        rangeHeader: rangeHeader,
        expectedLength: expectedPeerLength,
      );
    } else {
      peerFuture = pendingPeerPrefetch.future.then((bytes) async {
        if (bytes != null) return bytes;
        return _retryPeerPiece(
          resource,
          pieceKey,
          cancellation,
          initialDelay: peerMissingRetryDelay,
          rangeHeader: rangeHeader,
          expectedLength: expectedPeerLength,
        );
      });
    }
    final result = Completer<_OpenedOriginOrPeer?>();
    var originDeadlineExpired = false;

    Future<void> observeOrigin() async {
      final origin = await originOperation.future;
      if (origin != null && !originDeadlineExpired && !result.isCompleted) {
        result.complete(_OpenedOriginOrPeer(origin: origin));
      }
    }

    Future<void> observePeer() async {
      final bytes = await peerFuture;
      if (bytes != null && !result.isCompleted) {
        result.complete(_OpenedOriginOrPeer(peerBytes: bytes));
      }
    }

    unawaited(observeOrigin());
    unawaited(observePeer());
    Timer? peerRecoveryTimer;
    final originHeaderTimer = Timer(originHeaderTimeout, () {
      if (result.isCompleted) return;
      originDeadlineExpired = true;
      unawaited(originOperation.cancel());
      peerRecoveryTimer = Timer(originHeaderPeerRecoveryTimeout, () {
        if (!result.isCompleted) result.complete(null);
      });
    });
    final winner = await result.future;
    originHeaderTimer.cancel();
    peerRecoveryTimer?.cancel();
    cancellation.cancel();
    pendingPeerPrefetch?.cancellation.cancel();
    _activePeerRequests.remove(cancellation);
    if (winner?.peerBytes != null) {
      await originOperation.cancel();
    } else if (winner == null) {
      await originOperation.cancel();
    }
    return winner;
  }

  Future<Uint8List?> _readOriginWithPeerRetry(
    _GatewayResource resource,
    String pieceKey,
    HttpClientResponse origin, {
    String? rangeHeader,
    int? expectedPeerLength,
    _ByteRange? requestedRange,
    Duration? peerRecoveryTimeout,
  }) async {
    final maxOriginBytes =
        origin.statusCode == HttpStatus.ok && requestedRange != null
        ? min(_maxWholeResourceBytes, requestedRange.end + 1)
        : expectedPeerLength ?? _maxWholeResourceBytes;
    final originRead = _CancellableByteRead(
      origin,
      stallTimeout: originBodyStallPeerRetryDelay,
      slowObservation: originBodySlowObservation,
      hedgeDelay: originBodyHedgeDelay,
      minimumRateBytesPerSecond: originBodyMinimumRateBytesPerSecond,
      onBytes: _recordHttp,
      maxBytes: maxOriginBytes,
    );

    Future<Uint8List?> absorbFailure(Future<Uint8List?> future) async {
      try {
        return await future;
      } catch (error) {
        debugPrint('P2P media origin read failed: $error');
        return null;
      }
    }

    final originFuture = absorbFailure(originRead.future).then((bytes) {
      if (bytes == null || requestedRange == null) return bytes;
      if (origin.statusCode != HttpStatus.ok) {
        return bytes.length == requestedRange.length ? bytes : null;
      }
      if (requestedRange.end >= bytes.length) return null;
      return Uint8List.sublistView(
        bytes,
        requestedRange.start,
        requestedRange.end + 1,
      );
    });
    if (!_canRequestPeer(resource)) {
      final stalled = await Future.any<bool>([
        originFuture.then((_) => false),
        originRead.stalled,
      ]);
      if (stalled) {
        await originRead.cancel();
        return null;
      }
      return originFuture;
    }
    final cancellation = P2pPieceRequestCancellation();
    _activePeerRequests.add(cancellation);
    final startPeer = Completer<bool>();
    unawaited(
      originRead.hedgeRecommended.then((recommended) {
        if (!startPeer.isCompleted) startPeer.complete(recommended);
      }),
    );
    unawaited(
      originFuture.then((bytes) {
        if (!startPeer.isCompleted) startPeer.complete(bytes == null);
      }),
    );
    final peerFuture = startPeer.future.then((start) async {
      if (!start) return null;
      final retry = _retryPeerPiece(
        resource,
        pieceKey,
        cancellation,
        rangeHeader: rangeHeader,
        expectedLength: expectedPeerLength,
      );
      if (peerRecoveryTimeout == null) return retry;
      return Future.any<Uint8List?>([
        retry,
        Future<Uint8List?>.delayed(peerRecoveryTimeout, () => null),
      ]);
    });
    final winner = Completer<_PieceReadWinner?>();
    var finished = 0;

    Future<void> observe(
      Future<Uint8List?> future, {
      required bool fromPeer,
    }) async {
      final bytes = await future;
      finished++;
      if (bytes != null && !winner.isCompleted) {
        winner.complete(_PieceReadWinner(bytes, fromPeer: fromPeer));
      } else if (finished == 2 && !winner.isCompleted) {
        winner.complete(null);
      }
    }

    unawaited(observe(originFuture, fromPeer: false));
    unawaited(observe(peerFuture, fromPeer: true));
    final result = await winner.future;
    cancellation.cancel();
    _activePeerRequests.remove(cancellation);
    if (result == null) {
      await originRead.cancel();
      return null;
    }
    if (result.fromPeer) {
      await originRead.cancel();
    }
    return result.bytes;
  }

  Future<Uint8List?> _retryPeerPiece(
    _GatewayResource resource,
    String pieceKey,
    P2pPieceRequestCancellation cancellation, {
    Duration initialDelay = Duration.zero,
    String? rangeHeader,
    int? expectedLength,
  }) async {
    if (!await _waitUnlessCancelled(initialDelay, cancellation)) return null;
    while (!cancellation.isCancelled && !_disposed) {
      final cached = await cachedPiece(resource.swarmId, pieceKey);
      if (cached != null) return cached;
      try {
        final bytes = await _requestValidatedPeerPiece(
          resource,
          pieceKey,
          rangeHeader: rangeHeader,
          expectedLength: expectedLength,
          cancellation: cancellation,
        );
        if (bytes != null) return bytes;
      } catch (error) {
        debugPrint('P2P media peer retry failed: $error');
      }
      if (!await _waitUnlessCancelled(peerMissingRetryDelay, cancellation)) {
        return null;
      }
    }
    return null;
  }

  Future<bool> _waitUnlessCancelled(
    Duration delay,
    P2pPieceRequestCancellation cancellation,
  ) async {
    if (cancellation.isCancelled || _disposed) return false;
    if (delay <= Duration.zero) return true;
    return Future.any<bool>([
      Future<void>.delayed(delay).then((_) => true),
      cancellation.whenCancelled.then((_) => false),
    ]);
  }

  Future<Uint8List?> _requestValidatedPeerPiece(
    _GatewayResource resource,
    String pieceKey, {
    String? rangeHeader,
    int? expectedLength,
    P2pPieceRequestCancellation? cancellation,
  }) async {
    final requestCancellation = cancellation ?? P2pPieceRequestCancellation();
    final ownsCancellation = cancellation == null;
    if (ownsCancellation) _activePeerRequests.add(requestCancellation);
    try {
      final peer = await requestPeerPiece(
        resource.swarmId,
        pieceKey,
        requestCancellation,
      );
      if (peer == null || requestCancellation.isCancelled) return null;

      final verifyWithOrigin =
          securityMode == P2pMediaSecurityMode.sampledOrigin &&
          _random.nextDouble() < originSampleRate;
      final peerBytes = peer.bytes;
      _recordP2p(peerBytes.length);
      if (expectedLength != null && peerBytes.length != expectedLength) {
        await _reportPeerIntegrity(peer.source, false);
        _recordIntegrityMismatch();
        return null;
      }

      if (verifyWithOrigin) {
        final originBytes = await _readOriginForIntegrity(
          resource,
          rangeHeader: rangeHeader,
          expectedLength: expectedLength,
          cancellation: requestCancellation,
        );
        if (requestCancellation.isCancelled) return null;
        if (originBytes == null) {
          stats.value = stats.value.copyWith(
            integrityUnavailable: stats.value.integrityUnavailable + 1,
          );
        } else if (_sameSha256(peerBytes, originBytes)) {
          await _reportPeerIntegrity(peer.source, true);
          stats.value = stats.value.copyWith(
            integrityChecks: stats.value.integrityChecks + 1,
          );
        } else {
          await _reportPeerIntegrity(peer.source, false);
          _recordIntegrityMismatch();
          if (resource.shareable) {
            _putCache(resource.swarmId, pieceKey, originBytes);
          }
          return originBytes;
        }
      }

      if (requestCancellation.isCancelled) return null;
      if (resource.shareable) {
        _putCache(resource.swarmId, pieceKey, peerBytes);
      }
      return peerBytes;
    } finally {
      if (ownsCancellation) _activePeerRequests.remove(requestCancellation);
    }
  }

  Future<Uint8List?> _readOriginForIntegrity(
    _GatewayResource resource, {
    String? rangeHeader,
    int? expectedLength,
    required P2pPieceRequestCancellation cancellation,
  }) async {
    if (cancellation.isCancelled) return null;
    final operation = _CancellableOriginOpen(
      _httpClient,
      resource,
      rangeHeader: rangeHeader,
    );
    final response = await Future.any<HttpClientResponse?>([
      operation.future.timeout(
        originHeaderPeerRetryDelay,
        onTimeout: () => null,
      ),
      cancellation.whenCancelled.then((_) => null),
    ]);
    if (response == null ||
        response.statusCode < HttpStatus.ok ||
        response.statusCode >= HttpStatus.multipleChoices) {
      await operation.cancel();
      return null;
    }
    final read = _CancellableByteRead(
      response,
      stallTimeout: originBodyStallPeerRetryDelay,
      maxBytes: expectedLength ?? _maxWholeResourceBytes,
      onBytes: _recordHttp,
    );
    final stalled = await Future.any([
      read.future.then((_) => false),
      read.stalled,
      cancellation.whenCancelled.then((_) => true),
    ]);
    if (stalled) {
      await read.cancel();
      return null;
    }
    final bytes = await read.future;
    if (bytes == null ||
        (expectedLength != null && bytes.length != expectedLength)) {
      return null;
    }
    return bytes;
  }

  Future<void> _reportPeerIntegrity(P2pPeerSource source, bool valid) async {
    try {
      await reportPeerIntegrity(source, valid);
    } catch (error) {
      debugPrint('P2P media integrity report failed: $error');
    }
  }

  void _recordIntegrityMismatch() {
    stats.value = stats.value.copyWith(
      integrityChecks: stats.value.integrityChecks + 1,
      integrityMismatches: stats.value.integrityMismatches + 1,
    );
  }

  static bool _sameSha256(Uint8List left, Uint8List right) {
    if (left.length != right.length) return false;
    final leftDigest = sha256.convert(left).bytes;
    final rightDigest = sha256.convert(right).bytes;
    var difference = 0;
    for (var index = 0; index < leftDigest.length; index++) {
      difference |= leftDigest[index] ^ rightDigest[index];
    }
    return difference == 0;
  }

  Future<void> _streamOrigin(
    HttpRequest request,
    _GatewayResource resource,
  ) async {
    final operation = _CancellableOriginOpen(_httpClient, resource);
    final origin = await operation.future.timeout(
      originHeaderTimeout,
      onTimeout: () {
        unawaited(operation.cancel());
        return null;
      },
    );
    if (origin == null) {
      request.response.statusCode = HttpStatus.badGateway;
      await request.response.close();
      return;
    }
    request.response.statusCode = origin.statusCode;
    _copyResponseHeaders(origin.headers, request.response.headers);
    if (request.method != 'HEAD') {
      await for (final chunk in origin) {
        _recordHttp(chunk.length);
        request.response.add(chunk);
      }
    }
    await request.response.close();
  }

  Future<HttpClientResponse> _openOrigin(
    _GatewayResource resource, {
    String? rangeHeader,
  }) async {
    final origin = await _httpClient.getUrl(resource.upstream);
    resource.headers.forEach(origin.headers.set);
    if (rangeHeader != null) {
      origin.headers.set(HttpHeaders.rangeHeader, rangeHeader);
    }
    return origin.close();
  }

  Future<int> _probeLength(_GatewayResource resource) async {
    try {
      final request = await _httpClient
          .headUrl(resource.upstream)
          .timeout(originHeaderTimeout);
      resource.headers.forEach(request.headers.set);
      final response = await request.close().timeout(
        originHeaderTimeout,
        onTimeout: () {
          request.abort();
          throw TimeoutException('Origin HEAD response timed out');
        },
      );
      final length = response.contentLength;
      final successful =
          response.statusCode >= HttpStatus.ok &&
          response.statusCode < HttpStatus.multipleChoices;
      if (successful) {
        resource.originAcceptsRanges =
            response.headers
                .value(HttpHeaders.acceptRangesHeader)
                ?.toLowerCase() ==
            'bytes';
      }
      await response.drain<void>();
      if (successful && length > 0) return length;
    } on Object {
      // A one-byte range below handles origins without HEAD support.
    }
    try {
      final operation = _CancellableOriginOpen(
        _httpClient,
        resource,
        rangeHeader: 'bytes=0-0',
      );
      final response = await operation.future.timeout(
        originHeaderTimeout,
        onTimeout: () {
          unawaited(operation.cancel());
          return null;
        },
      );
      if (response == null) return -1;
      resource.originAcceptsRanges =
          response.statusCode == HttpStatus.partialContent;
      final length = response.statusCode == HttpStatus.ok
          ? response.contentLength
          : _totalLength(
              response.headers.value(HttpHeaders.contentRangeHeader),
            );
      await response.listen((_) {}).cancel();
      return length;
    } on Object {
      return -1;
    }
  }

  Future<int> _resolveResourceLength(_GatewayResource resource) async {
    final lengthKey = _cacheKey(resource.swarmId, resource.logicalKey);
    final now = _clock();
    _evictExpiredProgressiveLengths(now);
    final memoryLength = _progressiveLengths[lengthKey];
    if (memoryLength != null) {
      memoryLength.lastAccessed = now;
      final metadataKey = '$lengthKey:length';
      _memoryCache.get(metadataKey);
      final cache = persistentCache;
      if (cache != null) {
        unawaited(
          cache.touch(metadataKey).catchError((Object error) {
            debugPrint('P2P media length cache touch failed: $error');
          }),
        );
      }
      return memoryLength.value;
    }

    final metadata = await _readCachedPiece(
      '$lengthKey:length',
      recordStats: false,
    );
    if (metadata != null) {
      final length = decodeP2pResourceLength(metadata);
      if (length != null && length > 0) {
        resource.originAcceptsRanges = decodeP2pRangeCapability(metadata);
        _progressiveLengths[lengthKey] = _CachedLength(length, _clock());
        return length;
      }
    }

    if (!_canRequestPeer(resource)) {
      final length = await _probeLength(resource);
      await _rememberResourceLength(resource, length);
      return length;
    }

    final cancellation = P2pPieceRequestCancellation();
    _activePeerRequests.add(cancellation);
    final result = Completer<int>();
    unawaited(
      _probeLength(resource).then((length) {
        if (length > 0 && !result.isCompleted) result.complete(length);
      }),
    );
    unawaited(
      _retryPeerResourceLength(resource, cancellation).then((length) {
        if (length > 0 && !result.isCompleted) result.complete(length);
      }),
    );
    final timeout = Timer(
      originHeaderTimeout + originHeaderPeerRecoveryTimeout,
      () {
        if (!result.isCompleted) result.complete(-1);
      },
    );
    final length = await result.future;
    timeout.cancel();
    cancellation.cancel();
    _activePeerRequests.remove(cancellation);
    await _rememberResourceLength(resource, length);
    return length;
  }

  Future<int> _retryPeerResourceLength(
    _GatewayResource resource,
    P2pPieceRequestCancellation cancellation,
  ) async {
    if (!await _waitUnlessCancelled(originHeaderPeerRetryDelay, cancellation)) {
      return -1;
    }
    final pieceKey = '${resource.logicalKey}:length';
    while (!cancellation.isCancelled && !_disposed) {
      try {
        final peer = await requestPeerPiece(
          resource.swarmId,
          pieceKey,
          cancellation,
        );
        final bytes = peer?.bytes;
        if (bytes != null) {
          final length = decodeP2pResourceLength(bytes);
          if (length != null && length > 0 && length <= maxP2pResourceLength) {
            resource.originAcceptsRanges = decodeP2pRangeCapability(bytes);
            _recordP2p(bytes.length);
            return length;
          }
          if (peer != null) await _reportPeerIntegrity(peer.source, false);
        }
      } catch (error) {
        debugPrint('P2P media length lookup failed: $error');
      }
      if (!await _waitUnlessCancelled(peerMissingRetryDelay, cancellation)) {
        break;
      }
    }
    return -1;
  }

  Future<void> _rememberResourceLength(
    _GatewayResource resource,
    int length,
  ) async {
    if (length <= 0) return;
    final now = _clock();
    _evictExpiredProgressiveLengths(now);
    final lengthKey = _cacheKey(resource.swarmId, resource.logicalKey);
    _progressiveLengths[lengthKey] = _CachedLength(length, now);
    final metadataKey = '$lengthKey:length';
    final cached = await _readCachedPiece(metadataKey, recordStats: false);
    if (cached != null &&
        decodeP2pResourceLength(cached) == length &&
        decodeP2pRangeCapability(cached) == resource.originAcceptsRanges) {
      return;
    }
    final metadata = encodeP2pResourceLength(
      length,
      acceptsRanges: resource.originAcceptsRanges,
    );
    _memoryCache.put(metadataKey, metadata);
    _memoryCache.evictTo(_memoryCacheLimit);
    final cache = persistentCache;
    if (cache == null) return;
    await cache.put(metadataKey, metadata);
    _updateCacheByteStats();
  }

  void _evictExpiredProgressiveLengths(DateTime now) {
    _progressiveLengths.removeWhere(
      (_, entry) => now.difference(entry.lastAccessed) >= cacheTtl,
    );
  }

  Future<Uint8List?> _readAll(
    HttpClientResponse response, {
    required int maxBytes,
  }) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in response) {
      if (builder.length + chunk.length > maxBytes) return null;
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  Future<void> _writeRangeNotSatisfiable(
    HttpRequest request,
    int totalLength,
  ) async {
    request.response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
    if (totalLength > 0) {
      request.response.headers.set(
        HttpHeaders.contentRangeHeader,
        'bytes */$totalLength',
      );
    }
    await request.response.close();
  }

  Future<void> _writeOriginResponse(
    HttpRequest request,
    HttpClientResponse origin,
    Uint8List bytes,
  ) async {
    request.response.statusCode = origin.statusCode;
    _copyResponseHeaders(origin.headers, request.response.headers);
    request.response.headers.contentLength = bytes.length;
    if (request.method != 'HEAD') request.response.add(bytes);
    await request.response.close();
  }

  String _rewriteHlsManifest(String manifest, _GatewayResource parent) {
    return rewriteP2pHlsManifest(
      manifest: manifest,
      upstream: parent.upstream,
      logicalKey: parent.logicalKey,
      register: (registration) =>
          _registerPlannedResource(parent, registration),
    );
  }

  String _rewriteDashManifest(String manifest, _GatewayResource parent) {
    return rewriteP2pDashManifest(
      manifest: manifest,
      upstream: parent.upstream,
      logicalKey: parent.logicalKey,
      register: (registration) =>
          _registerPlannedResource(parent, registration),
    );
  }

  Uri _registerPlannedResource(
    _GatewayResource parent,
    P2pMediaResourceRegistration registration,
  ) {
    final resource = _registerResource(
      upstream: registration.upstream,
      headers: parent.headers,
      swarmId: parent.swarmId,
      logicalKey: registration.logicalKey,
      shareable: registration.shareable,
      manifestKind: registration.manifestKind,
      isDirectory: registration.isDirectory,
    );
    return registration.isDirectory
        ? _localDirectoryUri(resource)
        : _localUri(resource);
  }

  Future<void> _serveDirectoryResource(
    HttpRequest request,
    _GatewayResource directory,
    Iterable<String> pathSegments,
  ) async {
    final relativeSegments = pathSegments.toList(growable: false);
    if (relativeSegments.isEmpty) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }
    final relative = Uri(
      pathSegments: relativeSegments,
      query: request.uri.hasQuery ? request.uri.query : null,
    );
    final child = _GatewayResource(
      id: directory.id,
      upstream: directory.upstream.resolve(relative.toString()),
      headers: directory.headers,
      swarmId: directory.swarmId,
      logicalKey: p2pDirectoryChildLogicalKey(directory.logicalKey, relative),
      shareable: true,
      manifestKind: _P2pManifestKind.progressive,
      isDirectory: false,
    );
    final rangeHeader = request.headers.value(HttpHeaders.rangeHeader);
    if (rangeHeader == null) {
      await _serveWholePiece(request, child);
      return;
    }
    final requested = _parseRange(rangeHeader);
    final totalLength = await _resolveResourceLength(child);
    final range = requested?.resolve(totalLength);
    if (range == null) {
      await _writeRangeNotSatisfiable(request, totalLength);
      return;
    }
    if (requested!.isOpenEnded) {
      await _serveProgressiveBody(request, child, totalLength, range: range);
      return;
    }
    await _serveWholePiece(
      request,
      child,
      range: range,
      totalLength: totalLength,
    );
  }

  _GatewayResource _registerResource({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String logicalKey,
    required bool shareable,
    required _P2pManifestKind manifestKind,
    required bool isDirectory,
  }) {
    if (_resources.length >= _maxResourceMappings ||
        _resources.length % 128 == 0) {
      _pruneResources();
    }
    final id = _randomToken(18);
    final resource = _GatewayResource(
      id: id,
      upstream: upstream,
      headers: Map.unmodifiable(headers),
      swarmId: swarmId,
      logicalKey: logicalKey,
      shareable: shareable,
      manifestKind: manifestKind,
      isDirectory: isDirectory,
    );
    _resources[id] = resource;
    return resource;
  }

  void _pruneResources() {
    final cutoff = DateTime.now().subtract(_resourceIdleTtl);
    _resources.removeWhere(
      (_, resource) => resource.lastAccessed.isBefore(cutoff),
    );
    final targetCount = _resources.length >= _maxResourceMappings
        ? _maxResourceMappings - 1
        : _maxResourceMappings;
    if (_resources.length <= targetCount) return;
    final oldest = _resources.values.toList()
      ..sort((left, right) => left.lastAccessed.compareTo(right.lastAccessed));
    final removeCount = _resources.length - targetCount;
    for (final resource in oldest.take(removeCount)) {
      _resources.remove(resource.id);
    }
  }

  bool _canRequestPeer(_GatewayResource resource) =>
      resource.shareable && canRequestPeer(resource.swarmId);

  Uri _localUri(_GatewayResource resource) {
    final server = _server!;
    final filename = resource.upstream.pathSegments.isEmpty
        ? 'media'
        : resource.upstream.pathSegments.last;
    return Uri(
      scheme: 'http',
      host: InternetAddress.loopbackIPv4.address,
      port: server.port,
      pathSegments: [
        _sessionToken!,
        resource.id,
        filename.isEmpty ? 'media' : filename,
      ],
    );
  }

  Uri _localDirectoryUri(_GatewayResource resource) {
    final server = _server!;
    return Uri.parse(
      'http://${InternetAddress.loopbackIPv4.address}:${server.port}/'
      '${Uri.encodeComponent(_sessionToken!)}/${Uri.encodeComponent(resource.id)}/',
    );
  }

  void _putCache(String swarmId, String pieceKey, Uint8List bytes) {
    final key = _cacheKey(swarmId, pieceKey);
    _memoryCache.put(key, bytes);
    _memoryCache.evictTo(_memoryCacheLimit);
    _updateCacheByteStats();
    final cache = persistentCache;
    if (cache != null) {
      unawaited(
        cache.put(key, bytes).then((_) => _updateCacheByteStats()).catchError((
          Object error,
        ) {
          debugPrint('P2P media cache write failed: $error');
        }),
      );
    }
  }

  int get _memoryCacheLimit => min(maxCacheBytes, 32 * 1024 * 1024);

  void _updateCacheByteStats() {
    if (_disposed) return;
    _memoryCache.evictExpired();
    final persistentBytes = persistentCache?.totalBytes ?? 0;
    stats.value = stats.value.copyWith(
      cacheBytes: max(_memoryCache.totalBytes, persistentBytes),
    );
  }

  void _recordHttp(int bytes) {
    stats.value = stats.value.copyWith(
      httpBytes: stats.value.httpBytes + bytes,
    );
  }

  void _recordP2p(int bytes) {
    stats.value = stats.value.copyWith(p2pBytes: stats.value.p2pBytes + bytes);
  }

  static String _cacheKey(String swarmId, String pieceKey) =>
      '$swarmId|$pieceKey';

  String _randomToken(int bytes) {
    return base64Url
        .encode(List<int>.generate(bytes, (_) => _random.nextInt(256)))
        .replaceAll('=', '');
  }

  static _RequestedByteRange? _parseRange(String? value) {
    final match = RegExp(r'^bytes=(?:(\d+)-(\d*)|-(\d+))$')
        .firstMatch(value ?? '');
    if (match == null) return null;
    final suffixValue = match.group(3);
    if (suffixValue != null) {
      final suffixLength = int.tryParse(suffixValue);
      if (suffixLength == null || suffixLength <= 0) return null;
      return _RequestedByteRange.suffix(suffixLength);
    }
    final start = int.tryParse(match.group(1)!);
    final endValue = match.group(2)!;
    final end = endValue.isEmpty ? null : int.tryParse(endValue);
    if (start == null || (end != null && end < start)) return null;
    return _RequestedByteRange(start: start, end: end);
  }

  static int _totalLength(String? contentRange) {
    final match = RegExp(r'^bytes \d+-\d+/(\d+)$')
        .firstMatch(contentRange ?? '');
    return match == null ? -1 : int.tryParse(match.group(1)!) ?? -1;
  }

  static ContentType _contentTypeFor(Uri uri) {
    final path = p2pMediaPath(uri);
    if (path.endsWith('.ts')) return ContentType('video', 'mp2t');
    if (path.endsWith('.m4s')) return ContentType('video', 'iso.segment');
    if (path.endsWith('.mp4')) return ContentType('video', 'mp4');
    if (path.endsWith('.flv')) return ContentType('video', 'x-flv');
    if (path.endsWith('.webm')) return ContentType('video', 'webm');
    if (path.endsWith('.mpd')) return ContentType('application', 'dash+xml');
    if (path.endsWith('.m3u8')) {
      return ContentType('application', 'vnd.apple.mpegurl');
    }
    if (path.endsWith('.vtt')) return ContentType('text', 'vtt');
    if (path.endsWith('.srt')) return ContentType('application', 'x-subrip');
    if (path.endsWith('.ass') || path.endsWith('.ssa')) {
      return ContentType('text', 'x-ssa');
    }
    if (path.endsWith('.aac')) return ContentType('audio', 'aac');
    if (path.endsWith('.mp3')) return ContentType('audio', 'mpeg');
    return ContentType.binary;
  }

  static void _copyResponseHeaders(
    HttpHeaders source,
    HttpHeaders destination,
  ) {
    const forwarded = {
      HttpHeaders.contentTypeHeader,
      HttpHeaders.contentLengthHeader,
      HttpHeaders.contentRangeHeader,
      HttpHeaders.acceptRangesHeader,
      HttpHeaders.etagHeader,
      HttpHeaders.lastModifiedHeader,
    };
    source.forEach((name, values) {
      if (forwarded.contains(name.toLowerCase())) {
        destination.set(name, values);
      }
    });
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    for (final cancellation in _activePeerRequests) {
      cancellation.cancel();
    }
    _activePeerRequests.clear();
    await _server?.close(force: true);
    _server = null;
    _httpClient.close(force: true);
    _resources.clear();
    _progressiveLengths.clear();
    _pieceLoads.clear();
    for (final load in _completeOriginLoads.values) {
      load.finish();
    }
    _completeOriginLoads.clear();
    _peerPrefetches.clear();
    for (final reservation in _peerPrefetchReservations.values) {
      if (!reservation.isCompleted) reservation.complete();
    }
    _peerPrefetchReservations.clear();
    _memoryCache.clear();
    await persistentCache?.close();
    stats.dispose();
  }
}

class _GatewayResource {
  _GatewayResource({
    required this.id,
    required this.upstream,
    required this.headers,
    required this.swarmId,
    required this.logicalKey,
    required this.shareable,
    required this.manifestKind,
    required this.isDirectory,
  });

  final String id;
  final Uri upstream;
  final Map<String, String> headers;
  final String swarmId;
  final String logicalKey;
  final bool shareable;
  final _P2pManifestKind manifestKind;
  final bool isDirectory;
  bool? originAcceptsRanges;
  DateTime lastAccessed = DateTime.now();
}

class _CompleteOriginLoad {
  final Map<int, Completer<Uint8List?>> _pieceWaiters = {};
  bool _finished = false;

  Future<Uint8List?> waitForPiece(int pieceIndex) {
    if (_finished) return Future.value();
    return _pieceWaiters
        .putIfAbsent(pieceIndex, Completer<Uint8List?>.new)
        .future;
  }

  void completePiece(int pieceIndex, Uint8List bytes) {
    final waiter = _pieceWaiters.remove(pieceIndex);
    if (waiter != null && !waiter.isCompleted) waiter.complete(bytes);
  }

  void finish() {
    if (_finished) return;
    _finished = true;
    for (final waiter in _pieceWaiters.values) {
      if (!waiter.isCompleted) waiter.complete();
    }
    _pieceWaiters.clear();
  }
}

class _PieceReadWinner {
  const _PieceReadWinner(this.bytes, {required this.fromPeer});

  final Uint8List bytes;
  final bool fromPeer;
}

class _OpenedOriginOrPeer {
  const _OpenedOriginOrPeer({this.origin, this.peerBytes});

  final HttpClientResponse? origin;
  final Uint8List? peerBytes;
}

class _PeerPrefetch {
  const _PeerPrefetch(this.cancellation, this.future);

  final P2pPieceRequestCancellation cancellation;
  final Future<Uint8List?> future;
}

class _CancellableOriginOpen {
  _CancellableOriginOpen(this._client, this._resource, {this.rangeHeader}) {
    future = _open();
  }

  final HttpClient _client;
  final _GatewayResource _resource;
  final String? rangeHeader;
  late final Future<HttpClientResponse?> future;
  HttpClientRequest? _request;
  bool _cancelled = false;

  Future<HttpClientResponse?> _open() async {
    try {
      final request = await _client.getUrl(_resource.upstream);
      _request = request;
      if (_cancelled) {
        request.abort();
        return null;
      }
      _resource.headers.forEach(request.headers.set);
      if (rangeHeader != null) {
        request.headers.set(HttpHeaders.rangeHeader, rangeHeader!);
      }
      return await request.close();
    } catch (error) {
      if (!_cancelled) {
        debugPrint('P2P media origin connection failed: $error');
      }
      return null;
    }
  }

  Future<void> cancel() async {
    _cancelled = true;
    _request?.abort();
  }
}

class _CancellableByteRead {
  _CancellableByteRead(
    Stream<List<int>> source, {
    required Duration stallTimeout,
    required void Function(int bytes) onBytes,
    int? maxBytes,
    Duration? slowObservation,
    Duration? hedgeDelay,
    int? minimumRateBytesPerSecond,
  }) {
    void armStallTimer() {
      _stallTimer?.cancel();
      if (_stallCompleter.isCompleted) return;
      _stallTimer = Timer(stallTimeout, () {
        if (!_stallCompleter.isCompleted) _stallCompleter.complete(true);
        if (!_hedgeCompleter.isCompleted) _hedgeCompleter.complete(true);
      });
    }

    armStallTimer();
    if (slowObservation != null &&
        hedgeDelay != null &&
        minimumRateBytesPerSecond != null) {
      _slowStopwatch.start();
      final checkInterval = Duration(
        microseconds: min(
          const Duration(milliseconds: 250).inMicroseconds,
          max(
            const Duration(milliseconds: 10).inMicroseconds,
            slowObservation.inMicroseconds ~/ 2,
          ),
        ),
      );
      _slowTimer = Timer.periodic(checkInterval, (_) {
        final elapsed = _slowStopwatch.elapsed;
        final observedRate = elapsed.inMicroseconds == 0
            ? double.infinity
            : _builder.length *
                  Duration.microsecondsPerSecond /
                  elapsed.inMicroseconds;
        final belowUsefulRate =
            elapsed >= slowObservation &&
            _builder.isNotEmpty &&
            observedRate < minimumRateBytesPerSecond;
        if ((elapsed >= hedgeDelay || belowUsefulRate) &&
            !_hedgeCompleter.isCompleted) {
          _hedgeCompleter.complete(true);
          _slowTimer?.cancel();
        }
      });
    }
    _subscription = source.listen(
      (chunk) {
        onBytes(chunk.length);
        if (maxBytes != null && _builder.length + chunk.length > maxBytes) {
          _stallTimer?.cancel();
          _slowTimer?.cancel();
          if (!_stallCompleter.isCompleted) _stallCompleter.complete(false);
          if (!_hedgeCompleter.isCompleted) _hedgeCompleter.complete(true);
          if (!_completer.isCompleted) _completer.complete(null);
          unawaited(_subscription.cancel());
          return;
        }
        _builder.add(chunk);
        armStallTimer();
      },
      onDone: () {
        _stallTimer?.cancel();
        _slowTimer?.cancel();
        if (!_stallCompleter.isCompleted) _stallCompleter.complete(false);
        if (!_hedgeCompleter.isCompleted) _hedgeCompleter.complete(false);
        if (!_completer.isCompleted) {
          _completer.complete(_builder.takeBytes());
        }
      },
      onError: (Object _, StackTrace _) {
        _stallTimer?.cancel();
        _slowTimer?.cancel();
        if (!_stallCompleter.isCompleted) _stallCompleter.complete(false);
        if (!_hedgeCompleter.isCompleted) _hedgeCompleter.complete(true);
        if (!_completer.isCompleted) _completer.complete(null);
      },
      cancelOnError: true,
    );
  }

  final BytesBuilder _builder = BytesBuilder(copy: false);
  final Completer<Uint8List?> _completer = Completer<Uint8List?>();
  final Completer<bool> _stallCompleter = Completer<bool>();
  final Completer<bool> _hedgeCompleter = Completer<bool>();
  final Stopwatch _slowStopwatch = Stopwatch();
  late final StreamSubscription<List<int>> _subscription;
  Timer? _stallTimer;
  Timer? _slowTimer;

  Future<Uint8List?> get future => _completer.future;
  Future<bool> get stalled => _stallCompleter.future;
  Future<bool> get hedgeRecommended => _hedgeCompleter.future;

  Future<void> cancel() async {
    _stallTimer?.cancel();
    _slowTimer?.cancel();
    await _subscription.cancel();
    if (!_stallCompleter.isCompleted) _stallCompleter.complete(false);
    if (!_hedgeCompleter.isCompleted) _hedgeCompleter.complete(false);
    if (!_completer.isCompleted) _completer.complete(null);
  }
}

@immutable
class _ByteRange {
  const _ByteRange(this.start, this.end);

  final int start;
  final int end;
  int get length => end - start + 1;
  String get header => 'bytes=$start-$end';
}

class _RequestedByteRange {
  const _RequestedByteRange({required this.start, this.end})
    : suffixLength = null;
  const _RequestedByteRange.suffix(this.suffixLength)
    : start = null,
      end = null;

  final int? start;
  final int? end;
  final int? suffixLength;

  bool get isOpenEnded => start != null && end == null;

  _ByteRange? resolve(int totalLength) {
    if (totalLength <= 0) return null;
    final suffix = suffixLength;
    if (suffix != null) {
      final length = min(suffix, totalLength);
      return _ByteRange(totalLength - length, totalLength - 1);
    }
    final resolvedStart = start;
    if (resolvedStart == null || resolvedStart >= totalLength) return null;
    return _ByteRange(
      resolvedStart,
      min(end ?? totalLength - 1, totalLength - 1),
    );
  }
}

class _ByteLruCache {
  _ByteLruCache({required this.ttl, required this._clock});

  final Duration ttl;
  final P2pMediaCacheClock _clock;
  final Map<String, _MemoryCacheEntry> _entries = {};
  int totalBytes = 0;

  Uint8List? get(String key) {
    final entry = _entries.remove(key);
    if (entry == null) return null;
    final now = _clock();
    if (_isExpired(entry, now)) {
      totalBytes -= entry.value.length;
      return null;
    }
    entry.lastAccessed = now;
    _entries[key] = entry;
    return entry.value;
  }

  void put(String key, Uint8List value) {
    final previous = _entries.remove(key);
    if (previous != null) totalBytes -= previous.value.length;
    _entries[key] = _MemoryCacheEntry(value, _clock());
    totalBytes += value.length;
  }

  void evictTo(int maxBytes) {
    evictExpired();
    while (totalBytes > maxBytes && _entries.isNotEmpty) {
      final key = _entries.keys.first;
      totalBytes -= _entries.remove(key)!.value.length;
    }
  }

  void evictExpired() {
    final now = _clock();
    for (final key in _entries.keys.toList(growable: false)) {
      final entry = _entries[key]!;
      if (_isExpired(entry, now)) {
        totalBytes -= _entries.remove(key)!.value.length;
      }
    }
  }

  bool _isExpired(_MemoryCacheEntry entry, DateTime now) =>
      now.difference(entry.lastAccessed) >= ttl;

  void clear() {
    _entries.clear();
    totalBytes = 0;
  }
}

class _MemoryCacheEntry {
  _MemoryCacheEntry(this.value, this.lastAccessed);

  final Uint8List value;
  DateTime lastAccessed;
}

class _CachedLength {
  _CachedLength(this.value, this.lastAccessed);

  final int value;
  DateTime lastAccessed;
}
