import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_manifest.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_max_resource_length.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_length_metadata.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';

const _pieceSize = 1024 * 1024;
const _maxWholeResourceBytes = 16 * 1024 * 1024;
const _maxManifestBytes = 4 * 1024 * 1024;
const _cacheTtl = Duration(minutes: 10);
const _originHeaderTimeout = Duration(seconds: 15);
const _originSampleRate = 0.10;
const _maxResourceMappings = 8192;
const _resourceIdleTtl = Duration(minutes: 30);

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

class P2pMediaEngine implements P2pMediaPlaybackEngine {
  P2pMediaEngine({
    required this.requestPeerPiece,
    this.reportPeerIntegrity = _ignoreIntegrity,
    this.canRequestPeer = _alwaysHasPeer,
    required this.maxCacheBytes,
    required this.securityMode,
    required String serverBaseUrl,
  }) : _namespace =
           'synctv-p2p-${ServerEndpointIdentity.storageNamespace(serverBaseUrl)}';

  final P2pPieceRequester requestPeerPiece;
  final P2pIntegrityReporter reportPeerIntegrity;
  final P2pPeerAvailability canRequestPeer;
  @override
  final int maxCacheBytes;
  @override
  final P2pMediaSecurityMode securityMode;
  @override
  final ValueNotifier<P2pMediaStats> stats = ValueNotifier(
    const P2pMediaStats(),
  );

  final Map<String, _WebResource> _resources = {};
  final Map<JSObject, _WorkerRequestControl> _workerControls = {};
  final Set<P2pPieceRequestCancellation> _activePeerRequests = {};
  final Random _random = Random.secure();
  late final String _token = _randomToken(18);
  final String _namespace;
  http.Client? _client;
  JSObject? _bridge;
  bool _disposed = false;

  Future<void> initialize() async {
    if (_disposed) throw StateError('P2P media engine has been disposed');
    _client = http.Client();
    final bridge = globalContext.getProperty<JSObject?>('SyncTvP2pBridge'.toJS);
    if (bridge == null) {
      throw StateError('SyncTV P2P Service Worker bridge is unavailable');
    }
    _bridge = bridge;
    final handler = ((JSAny? requestJson, JSObject port) {
      unawaited(_handleWorkerRequest(requestJson, port));
    }).toJS;
    bridge.callMethod<JSAny?>('setRequestHandler'.toJS, handler);
    final ready = bridge.callMethod<JSAny?>('ready'.toJS);
    final readyValue = await (ready as JSPromise<JSAny?>).toDart;
    if (readyValue?.dartify() != true) {
      bridge.callMethod<JSAny?>('setRequestHandler'.toJS, null);
      _bridge = null;
      _client?.close();
      throw StateError(
        'SyncTV P2P requires an active same-origin Service Worker',
      );
    }
  }

  @override
  Future<Uri> localize({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String format,
  }) async {
    _ensureReady();
    final manifestKind = p2pManifestKind(format, upstream);
    final resource = _register(
      upstream: upstream,
      headers: headers,
      swarmId: swarmId,
      logicalKey: 'root',
      format: format,
      shareable: manifestKind == P2pManifestKind.progressive,
    );
    return _uri(resource);
  }

  @override
  Future<Uri> localizeStatic({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String logicalKey,
  }) async {
    _ensureReady();
    return _uri(
      _registerResource(
        registration: P2pMediaResourceRegistration(
          upstream: upstream,
          logicalKey: logicalKey,
          shareable: true,
          manifestKind: P2pManifestKind.progressive,
          isDirectory: false,
        ),
        headers: headers,
        swarmId: swarmId,
      ),
    );
  }

  @override
  Future<Uint8List?> cachedPiece(String swarmId, String pieceKey) async {
    return _cachedPiece(swarmId, pieceKey, recordStats: true);
  }

  Future<Uint8List?> _cachedPiece(
    String swarmId,
    String pieceKey, {
    required bool recordStats,
  }) async {
    final bridge = _bridge;
    if (bridge == null) return null;
    final value = bridge.callMethod<JSAny?>(
      'cacheGet'.toJS,
      _namespace.toJS,
      '$swarmId|$pieceKey'.toJS,
      _cacheTtl.inMilliseconds.toJS,
    );
    final result = await (value as JSPromise<JSAny?>).toDart;
    if (result != null && result.isA<JSUint8Array>()) {
      if (recordStats) {
        stats.value = stats.value.copyWith(
          cacheHits: stats.value.cacheHits + 1,
        );
      }
      return (result as JSUint8Array).toDart;
    }
    if (recordStats) {
      stats.value = stats.value.copyWith(
        cacheMisses: stats.value.cacheMisses + 1,
      );
    }
    return null;
  }

  Future<void> _handleWorkerRequest(JSAny? raw, JSObject port) async {
    final control = _WorkerRequestControl(port);
    final cancellation = control.cancellation;
    _workerControls[port] = control;
    _activePeerRequests.add(cancellation);
    try {
      final request = raw?.dartify();
      if (request is! Map<Object?, Object?>) {
        _postError(port, 400, 'Invalid P2P worker request.');
        return;
      }
      final url = Uri.parse(request['url'].toString());
      final segments = url.pathSegments;
      if (segments.length < 4 ||
          segments[0] != '__synctv_p2p__' ||
          segments[1] != _token) {
        _postError(port, 404, 'P2P resource not found.');
        return;
      }
      var resource = _resources[segments[2]];
      if (resource == null) {
        _postError(port, 410, 'P2P resource has expired.');
        return;
      }
      final method = request['method']?.toString() ?? 'GET';
      final headers = <String, String>{
        for (final value in (request['headers'] as List? ?? const []))
          value[0].toString().toLowerCase(): value[1].toString(),
      };
      if (resource.isDirectory && segments.length > 3) {
        final relative = Uri(
          pathSegments: segments.skip(3),
          query: url.hasQuery ? url.query : null,
        );
        resource = resource.copyWith(
          upstream: resource.upstream.resolve(relative.toString()),
          logicalKey: p2pDirectoryChildLogicalKey(
            resource.logicalKey,
            relative,
          ),
          isDirectory: false,
        );
      }
      resource.lastAccessed = DateTime.now();
      final rangeHeader = headers['range'];
      final range = _parseRange(rangeHeader);
      if (_isManifest(resource)) {
        await _serveManifest(port, resource, method, cancellation);
      } else if (range != null) {
        await _serveRange(port, resource, range, method, cancellation);
      } else if (rangeHeader != null) {
        final length = await _resolveLength(resource, cancellation);
        _sendRangeError(port, length > 0 ? length : null);
      } else {
        await _serveResource(port, resource, method, cancellation);
      }
    } catch (error) {
      if (!cancellation.isCancelled) {
        _postError(port, 502, error.toString());
      }
    } finally {
      _workerControls.remove(port);
      control.close();
      _activePeerRequests.remove(cancellation);
    }
  }

  Future<void> _serveManifest(
    JSObject port,
    _WebResource resource,
    String method,
    P2pPieceRequestCancellation cancellation,
  ) async {
    final response = await _originBytes(
      resource,
      cancellation: cancellation,
      maxBytes: _maxManifestBytes,
    );
    if (response == null) {
      _postError(port, 502, 'Unable to load the media manifest.');
      return;
    }
    _recordHttp(response.transferredBytes);
    final bytes = response.bytes;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      await _sendBytes(
        port,
        response.statusCode,
        response.headers,
        bytes,
        method,
      );
      return;
    }
    final text = utf8.decode(bytes, allowMalformed: false);
    final rewritten = _isHls(resource)
        ? rewriteP2pHlsManifest(
            manifest: text,
            upstream: resource.upstream,
            logicalKey: resource.logicalKey,
            register: (registration) =>
                _registerPlanned(resource, registration),
          )
        : rewriteP2pDashManifest(
            manifest: text,
            upstream: resource.upstream,
            logicalKey: resource.logicalKey,
            register: (registration) =>
                _registerPlanned(resource, registration),
          );
    final output = Uint8List.fromList(utf8.encode(rewritten));
    await _sendBytes(
      port,
      200,
      {
        'content-type': _isHls(resource)
            ? 'application/vnd.apple.mpegurl'
            : 'application/dash+xml',
      },
      output,
      method,
    );
  }

  Future<void> _serveResource(
    JSObject port,
    _WebResource resource,
    String method,
    P2pPieceRequestCancellation cancellation,
  ) async {
    if (method == 'HEAD') {
      final length = await _resolveLength(resource, cancellation);
      if (length > 0) {
        _postMeta(port, 200, {
          ..._headersFor(resource),
          'content-length': '$length',
        });
        _postEnd(port);
        return;
      }
      final response = await _originBytes(
        resource,
        method: 'HEAD',
        maxBytes: 0,
        cancellation: cancellation,
      );
      if (response == null) {
        _postError(port, 502, 'Unable to read media metadata.');
      } else {
        _postMeta(
          port,
          response.statusCode,
          _safeResponseHeaders(response.headers),
        );
        _postEnd(port);
      }
      return;
    }
    final key = resource.logicalKey;
    if (resource.shareable) {
      final cached = await cachedPiece(resource.swarmId, key);
      if (cached != null) {
        await _sendBytes(port, 200, _headersFor(resource), cached, method);
        return;
      }
      final peer = await _loadPeerPiece(
        resource,
        key,
        cancellation: cancellation,
      );
      if (peer != null) {
        await _sendBytes(port, 200, _headersFor(resource), peer, method);
        return;
      }
    }
    final streamed = await _originStream(resource, cancellation);
    await _sendStream(port, streamed, method, resource, cacheKey: key);
  }

  Future<void> _serveRange(
    JSObject port,
    _WebResource resource,
    _RequestedRange range,
    String method,
    P2pPieceRequestCancellation cancellation,
  ) async {
    final length = await _resolveLength(resource, cancellation);
    final resolved = range.resolve(length);
    if (resolved == null) {
      _sendRangeError(port, length > 0 ? length : null);
      return;
    }
    final firstPiece = resolved.start ~/ _pieceSize;
    final lastPiece = resolved.end ~/ _pieceSize;
    Uint8List? firstPieceBytes;
    if (method != 'HEAD') {
      firstPieceBytes = await _loadRangePiece(
        resource,
        firstPiece,
        length,
        cancellation,
      );
      if (firstPieceBytes == null) {
        _postError(port, 502, 'Unable to load P2P media piece.');
        return;
      }
    }
    _postMeta(port, 206, {
      'content-type': _contentType(resource.upstream),
      'content-range': 'bytes ${resolved.start}-${resolved.end}/$length',
      'content-length': '${resolved.length}',
      'accept-ranges': 'bytes',
    });
    if (method == 'HEAD') {
      _postEnd(port);
      return;
    }
    for (var index = firstPiece; index <= lastPiece; index++) {
      final start = index * _pieceSize;
      final bytes = index == firstPiece
          ? firstPieceBytes
          : await _loadRangePiece(resource, index, length, cancellation);
      if (bytes == null) {
        _postError(port, 502, 'Unable to load P2P media piece.');
        return;
      }
      final from = max(0, resolved.start - start);
      final to = min(bytes.length, resolved.end - start + 1);
      if (to > from) {
        await _postChunk(port, Uint8List.sublistView(bytes, from, to));
      }
    }
    _postEnd(port);
  }

  Future<Uint8List?> _loadRangePiece(
    _WebResource resource,
    int index,
    int length,
    P2pPieceRequestCancellation cancellation,
  ) {
    final start = index * _pieceSize;
    final end = min(length - 1, start + _pieceSize - 1);
    return _loadPiece(
      resource,
      '${resource.logicalKey}:piece:$index',
      'bytes=$start-$end',
      expectedLength: end - start + 1,
      cancellation: cancellation,
    );
  }

  Future<Uint8List?> _loadPiece(
    _WebResource resource,
    String key,
    String range, {
    required int expectedLength,
    required P2pPieceRequestCancellation cancellation,
  }) async {
    final cached = await cachedPiece(resource.swarmId, key);
    if (cached != null && cached.length == expectedLength) return cached;
    final peer = await _loadPeerPiece(
      resource,
      key,
      expectedLength: expectedLength,
      range: range,
      cancellation: cancellation,
    );
    if (peer != null) return peer;
    final rangeStart = int.tryParse(
      RegExp(r'^bytes=(\d+)-').firstMatch(range)?.group(1) ?? '',
    );
    if (rangeStart == null) return null;
    final response = await _originRangeBytes(
      resource,
      start: rangeStart,
      expectedLength: expectedLength,
      range: range,
      cancellation: cancellation,
    );
    if (response == null ||
        response.statusCode < 200 ||
        response.statusCode >= 300 ||
        response.bytes.length != expectedLength) {
      return null;
    }
    _recordHttp(response.transferredBytes);
    if (resource.shareable) await _putCache(resource, key, response.bytes);
    return response.bytes;
  }

  Future<int> _resolveLength(
    _WebResource resource,
    P2pPieceRequestCancellation cancellation,
  ) async {
    if (resource.length case final value? when value > 0) return value;

    final pieceKey = '${resource.logicalKey}:length';
    final cached = await _cachedPiece(
      resource.swarmId,
      pieceKey,
      recordStats: false,
    );
    final cachedLength = _decodeLengthMetadata(resource, cached);
    if (cachedLength > 0) {
      resource.length = cachedLength;
      return cachedLength;
    }

    final result = Completer<int>();
    final resolutionCancellation = P2pPieceRequestCancellation();
    unawaited(
      cancellation.whenCancelled.then((_) => resolutionCancellation.cancel()),
    );
    final requestPeer = canRequestPeer(resource.swarmId) && resource.shareable;
    var pending = requestPeer ? 2 : 1;
    void completeCandidate(int length) {
      if (length > 0 && length <= maxP2pResourceLength) {
        if (!result.isCompleted) result.complete(length);
        return;
      }
      pending--;
      if (pending == 0 && !result.isCompleted) result.complete(-1);
    }

    unawaited(
      _resolveOriginLength(resource, resolutionCancellation).then(
        completeCandidate,
        onError: (Object error, StackTrace stackTrace) {
          if (!resolutionCancellation.isCancelled) {
            debugPrint('P2P media origin length lookup failed: $error');
          }
          completeCandidate(-1);
        },
      ),
    );
    if (requestPeer) {
      unawaited(
        _resolvePeerLength(resource, pieceKey, resolutionCancellation).then(
          completeCandidate,
          onError: (Object error, StackTrace stackTrace) {
            if (!resolutionCancellation.isCancelled) {
              debugPrint('P2P media peer length lookup failed: $error');
            }
            completeCandidate(-1);
          },
        ),
      );
    }
    final length = await result.future;
    resolutionCancellation.cancel();
    if (length > 0) {
      resource.length = length;
      await _rememberLength(resource, pieceKey, length);
    }
    return length;
  }

  Future<int> _resolveOriginLength(
    _WebResource resource,
    P2pPieceRequestCancellation cancellation,
  ) async {
    final response = await _originBytes(
      resource,
      method: 'HEAD',
      maxBytes: 0,
      cancellation: cancellation,
    );
    final successful =
        response != null &&
        response.statusCode >= 200 &&
        response.statusCode < 300;
    if (successful) {
      resource.originAcceptsRanges =
          response.headers['accept-ranges']?.toLowerCase() == 'bytes';
    }
    final value = successful
        ? int.tryParse(response.headers['content-length'] ?? '') ?? -1
        : -1;
    if (value > 0 && value <= maxP2pResourceLength) {
      return value;
    }
    final probed = await _probeLength(resource, cancellation);
    return probed <= maxP2pResourceLength ? probed : -1;
  }

  Future<int> _resolvePeerLength(
    _WebResource resource,
    String pieceKey,
    P2pPieceRequestCancellation cancellation,
  ) async {
    final peer = await requestPeerPiece(
      resource.swarmId,
      pieceKey,
      cancellation,
    );
    if (peer == null || cancellation.isCancelled) return -1;
    final length = _decodeLengthMetadata(resource, peer.bytes);
    if (length <= 0 || length > maxP2pResourceLength) {
      await _reportPeerIntegrity(peer.source, false);
      return -1;
    }
    _recordP2p(peer.bytes.length);
    return length;
  }

  int _decodeLengthMetadata(_WebResource resource, Uint8List? metadata) {
    final length = decodeP2pResourceLength(metadata);
    if (length == null || metadata == null) return -1;
    if (length <= 0 || length > maxP2pResourceLength) return -1;
    resource.originAcceptsRanges = decodeP2pRangeCapability(metadata);
    return length;
  }

  Future<void> _rememberLength(
    _WebResource resource,
    String pieceKey,
    int length,
  ) async {
    final metadata = encodeP2pResourceLength(
      length,
      acceptsRanges: resource.originAcceptsRanges,
    );
    await _putCache(resource, pieceKey, metadata);
  }

  Future<int> _probeLength(
    _WebResource resource,
    P2pPieceRequestCancellation cancellation,
  ) async {
    final abort = _OriginAbort(cancellation);
    final request = http.AbortableRequest(
      'GET',
      resource.upstream,
      abortTrigger: abort.whenAborted,
    );
    request.headers
      ..addAll(resource.headers)
      ..['range'] = 'bytes=0-0';
    try {
      final response = await (_client ??= http.Client()).send(request);
      abort.headersReceived();
      resource.originAcceptsRanges = response.statusCode == 206;
      if (response.statusCode == 206) {
        final match = RegExp(r'^bytes \d+-\d+/(\d+)$')
            .firstMatch(response.headers['content-range'] ?? '');
        return int.tryParse(match?.group(1) ?? '') ?? -1;
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.contentLength ?? -1;
      }
      return -1;
    } finally {
      abort.abort();
      abort.close();
    }
  }

  Future<_OriginBytes?> _originBytes(
    _WebResource resource, {
    String? range,
    String method = 'GET',
    required int maxBytes,
    required P2pPieceRequestCancellation cancellation,
  }) async {
    final abort = _OriginAbort(cancellation);
    final request = http.AbortableRequest(
      method,
      resource.upstream,
      abortTrigger: abort.whenAborted,
    );
    request.headers.addAll(resource.headers);
    if (range != null) {
      request.headers['range'] = range;
    }
    try {
      final response = await (_client ??= http.Client()).send(request);
      abort.headersReceived();
      final builder = BytesBuilder(copy: false);
      await for (final chunk in response.stream) {
        if (builder.length + chunk.length > maxBytes) return null;
        builder.add(chunk);
      }
      final bytes = builder.takeBytes();
      return _OriginBytes(
        response.statusCode,
        response.headers,
        bytes,
        transferredBytes: bytes.length,
      );
    } finally {
      abort.close();
    }
  }

  Future<_OriginBytes?> _originRangeBytes(
    _WebResource resource, {
    required String range,
    required int start,
    required int expectedLength,
    required P2pPieceRequestCancellation cancellation,
  }) async {
    final abort = _OriginAbort(cancellation);
    final request = http.AbortableRequest(
      'GET',
      resource.upstream,
      abortTrigger: abort.whenAborted,
    );
    request.headers
      ..addAll(resource.headers)
      ..['range'] = range;
    try {
      final response = await (_client ??= http.Client()).send(request);
      abort.headersReceived();
      if (response.statusCode != 200 && response.statusCode != 206) {
        return _OriginBytes(
          response.statusCode,
          response.headers,
          Uint8List(0),
          transferredBytes: 0,
        );
      }
      final skip = response.statusCode == 200 ? start : 0;
      final builder = BytesBuilder(copy: false);
      var transferred = 0;
      var position = 0;
      await for (final chunk in response.stream) {
        transferred += chunk.length;
        final chunkStart = position;
        final chunkEnd = position + chunk.length;
        position = chunkEnd;
        if (chunkEnd <= skip) continue;
        final from = max(0, skip - chunkStart);
        final remaining = expectedLength - builder.length;
        final to = min(chunk.length, from + remaining);
        if (to > from) builder.add(chunk.sublist(from, to));
        if (builder.length == expectedLength) break;
      }
      return _OriginBytes(
        response.statusCode,
        response.headers,
        builder.takeBytes(),
        transferredBytes: transferred,
      );
    } finally {
      abort.abort();
      abort.close();
    }
  }

  Future<_OriginStream> _originStream(
    _WebResource resource,
    P2pPieceRequestCancellation cancellation,
  ) async {
    final abort = _OriginAbort(cancellation);
    final request = http.AbortableRequest(
      'GET',
      resource.upstream,
      abortTrigger: abort.whenAborted,
    );
    request.headers.addAll(resource.headers);
    try {
      final response = await (_client ??= http.Client()).send(request);
      abort.headersReceived();
      return _OriginStream(response, abort);
    } catch (_) {
      abort.close();
      rethrow;
    }
  }

  Future<void> _putCache(
    _WebResource resource,
    String key,
    Uint8List bytes,
  ) async {
    final bridge = _bridge;
    if (bridge == null) return;
    final promise = bridge.callMethodVarArgs<JSAny?>('cachePut'.toJS, [
      _namespace.toJS,
      '${resource.swarmId}|$key'.toJS,
      bytes.toJS,
      maxCacheBytes.toJS,
      _cacheTtl.inMilliseconds.toJS,
    ]);
    final result = await (promise as JSPromise<JSAny?>).toDart;
    final total = result.dartify();
    stats.value = stats.value.copyWith(
      cacheBytes: total is num ? total.toInt() : stats.value.cacheBytes,
    );
  }

  Future<Uint8List?> _loadPeerPiece(
    _WebResource resource,
    String key, {
    int? expectedLength,
    String? range,
    P2pPieceRequestCancellation? cancellation,
  }) async {
    if (!resource.shareable || !canRequestPeer(resource.swarmId)) return null;
    final requestCancellation = cancellation ?? P2pPieceRequestCancellation();
    final ownsCancellation = cancellation == null;
    if (ownsCancellation) _activePeerRequests.add(requestCancellation);
    try {
      final peer = await requestPeerPiece(
        resource.swarmId,
        key,
        requestCancellation,
      );
      if (peer == null || requestCancellation.isCancelled) return null;
      final bytes = peer.bytes;
      _recordP2p(bytes.length);
      if (expectedLength != null && bytes.length != expectedLength) {
        await _reportPeerIntegrity(peer.source, false);
        stats.value = stats.value.copyWith(
          integrityChecks: stats.value.integrityChecks + 1,
          integrityMismatches: stats.value.integrityMismatches + 1,
        );
        return null;
      }
      if (securityMode == P2pMediaSecurityMode.sampledOrigin &&
          _random.nextDouble() < _originSampleRate) {
        final rangeStart = int.tryParse(
          RegExp(r'^bytes=(\d+)-').firstMatch(range ?? '')?.group(1) ?? '',
        );
        final origin = rangeStart != null && expectedLength != null
            ? await _originRangeBytes(
                resource,
                range: range!,
                start: rangeStart,
                expectedLength: expectedLength,
                cancellation: requestCancellation,
              )
            : await _originBytes(
                resource,
                range: range,
                maxBytes: expectedLength ?? bytes.length,
                cancellation: requestCancellation,
              );
        final originIsValid =
            origin != null &&
            origin.statusCode >= 200 &&
            origin.statusCode < 300 &&
            (expectedLength == null || origin.bytes.length == expectedLength);
        if (origin != null) _recordHttp(origin.transferredBytes);
        if (!originIsValid) {
          stats.value = stats.value.copyWith(
            integrityUnavailable: stats.value.integrityUnavailable + 1,
          );
        } else if (!_sameSha256(bytes, origin.bytes)) {
          await _reportPeerIntegrity(peer.source, false);
          stats.value = stats.value.copyWith(
            integrityChecks: stats.value.integrityChecks + 1,
            integrityMismatches: stats.value.integrityMismatches + 1,
          );
          if (resource.shareable) {
            await _putCache(resource, key, origin.bytes);
          }
          return origin.bytes;
        } else {
          await _reportPeerIntegrity(peer.source, true);
          stats.value = stats.value.copyWith(
            integrityChecks: stats.value.integrityChecks + 1,
          );
        }
      }
      if (resource.shareable) await _putCache(resource, key, bytes);
      return bytes;
    } finally {
      if (ownsCancellation) _activePeerRequests.remove(requestCancellation);
    }
  }

  Future<void> _reportPeerIntegrity(P2pPeerSource source, bool valid) async {
    try {
      await reportPeerIntegrity(source, valid);
    } catch (_) {
      // A reporting failure must not interrupt playback.
    }
  }

  static bool _sameSha256(Uint8List left, Uint8List right) {
    if (left.length != right.length) return false;
    final a = sha256.convert(left).bytes;
    final b = sha256.convert(right).bytes;
    var difference = 0;
    for (var index = 0; index < a.length; index++) {
      difference |= a[index] ^ b[index];
    }
    return difference == 0;
  }

  Future<void> _sendBytes(
    JSObject port,
    int status,
    Map<String, String> headers,
    Uint8List bytes,
    String method,
  ) async {
    _postMeta(port, status, {...headers, 'content-length': '${bytes.length}'});
    if (method != 'HEAD') {
      await _postChunk(port, bytes);
    }
    _postEnd(port);
  }

  void _postMeta(JSObject port, int status, Map<String, String> headers) {
    port.callMethod<JSAny?>(
      'postMessage'.toJS,
      {'type': 'meta', 'status': status, 'headers': headers}.jsify(),
    );
  }

  Future<void> _postChunk(JSObject port, Uint8List bytes) async {
    for (var offset = 0; offset < bytes.length; offset += 256 * 1024) {
      final control = _workerControls[port];
      if (control != null && !await control.takeCredit()) return;
      final end = min(bytes.length, offset + 256 * 1024);
      port.callMethod<JSAny?>(
        'postMessage'.toJS,
        {
          'type': 'chunk',
          'bytes': Uint8List.sublistView(bytes, offset, end).toJS,
        }.jsify(),
      );
    }
  }

  void _postEnd(JSObject port) {
    port.callMethod<JSAny?>('postMessage'.toJS, {'type': 'end'}.jsify());
  }

  void _sendRangeError(JSObject port, int? length) {
    _postMeta(port, 416, {
      if (length != null) 'content-range': 'bytes */$length',
      'content-length': '0',
    });
    _postEnd(port);
  }

  Future<void> _sendStream(
    JSObject port,
    _OriginStream origin,
    String method,
    _WebResource resource, {
    required String cacheKey,
  }) async {
    try {
      _postMeta(port, origin.response.statusCode, {
        ..._safeResponseHeaders(origin.response.headers),
        'content-type':
            origin.response.headers['content-type'] ??
            _contentType(resource.upstream),
      });
      if (method == 'HEAD') {
        await origin.response.stream.drain<void>();
        _postEnd(port);
        return;
      }
      final builder = resource.shareable ? BytesBuilder(copy: false) : null;
      var tooLargeToCache = false;
      await for (final chunk in origin.response.stream) {
        _recordHttp(chunk.length);
        if (builder != null && !tooLargeToCache) {
          if (builder.length + chunk.length <= _maxWholeResourceBytes) {
            builder.add(chunk);
          } else {
            tooLargeToCache = true;
          }
        }
        await _postChunk(port, Uint8List.fromList(chunk));
      }
      if (origin.response.statusCode >= 200 &&
          origin.response.statusCode < 300 &&
          builder != null &&
          !tooLargeToCache) {
        await _putCache(resource, cacheKey, builder.takeBytes());
      }
      _postEnd(port);
    } finally {
      origin.close();
    }
  }

  void _postError(JSObject port, int status, String message) {
    port.callMethod<JSAny?>(
      'postMessage'.toJS,
      {'type': 'error', 'status': status, 'message': message}.jsify(),
    );
  }

  _WebResource _register({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String logicalKey,
    required String format,
    required bool shareable,
  }) {
    return _registerResource(
      registration: P2pMediaResourceRegistration(
        upstream: upstream,
        logicalKey: logicalKey,
        shareable: shareable,
        manifestKind: p2pManifestKind(format, upstream),
        isDirectory: false,
      ),
      headers: headers,
      swarmId: swarmId,
    );
  }

  Uri _registerPlanned(
    _WebResource parent,
    P2pMediaResourceRegistration registration,
  ) => _uri(
    _registerResource(
      registration: registration,
      headers: parent.headers,
      swarmId: parent.swarmId,
    ),
  );

  _WebResource _registerResource({
    required P2pMediaResourceRegistration registration,
    required Map<String, String> headers,
    required String swarmId,
  }) {
    _pruneResources();
    final resource = _WebResource(
      id: _randomToken(12),
      upstream: registration.upstream,
      headers: Map.unmodifiable(headers),
      swarmId: swarmId,
      logicalKey: registration.logicalKey,
      manifestKind: registration.manifestKind,
      shareable: registration.shareable,
      isDirectory: registration.isDirectory,
    );
    _resources[resource.id] = resource;
    return resource;
  }

  void _pruneResources() {
    if (_resources.length < _maxResourceMappings) return;
    final cutoff = DateTime.now().subtract(_resourceIdleTtl);
    _resources.removeWhere((_, value) => value.lastAccessed.isBefore(cutoff));
    if (_resources.length < _maxResourceMappings) return;
    final oldest = _resources.values.toList()
      ..sort((left, right) => left.lastAccessed.compareTo(right.lastAccessed));
    for (final resource in oldest.take(
      _resources.length - _maxResourceMappings + 1,
    )) {
      _resources.remove(resource.id);
    }
  }

  Map<String, String> _headersFor(_WebResource resource) => {
    'content-type': _contentType(resource.upstream),
    'accept-ranges': 'bytes',
  };

  Map<String, String> _safeResponseHeaders(Map<String, String> headers) => {
    for (final name in const [
      'content-type',
      'content-length',
      'content-range',
      'accept-ranges',
      'etag',
      'last-modified',
      'cache-control',
    ])
      name: ?headers[name],
  };

  Uri _uri(_WebResource resource) => Uri.base.resolve(
    '/__synctv_p2p__/${Uri.encodeComponent(_token)}/'
    '${Uri.encodeComponent(resource.id)}/${resource.isDirectory ? '' : 'media'}',
  );
  bool _isManifest(_WebResource resource) =>
      resource.manifestKind != P2pManifestKind.progressive;
  bool _isHls(_WebResource resource) =>
      resource.manifestKind == P2pManifestKind.hls;
  String _contentType(Uri uri) =>
      switch (uri.path.toLowerCase().split('.').last) {
        'm3u8' => 'application/vnd.apple.mpegurl',
        'mpd' => 'application/dash+xml',
        'ts' => 'video/mp2t',
        'flv' => 'video/x-flv',
        'mp4' => 'video/mp4',
        'webm' => 'video/webm',
        _ => 'application/octet-stream',
      };
  void _recordHttp(int bytes) {
    stats.value = stats.value.copyWith(
      httpBytes: stats.value.httpBytes + bytes,
    );
  }

  void _recordP2p(int bytes) {
    stats.value = stats.value.copyWith(p2pBytes: stats.value.p2pBytes + bytes);
  }

  _RequestedRange? _parseRange(String? raw) {
    final match = RegExp(r'^bytes=(?:(\d+)-(\d*)|-(\d+))$')
        .firstMatch(raw ?? '');
    if (match == null) return null;
    if (match.group(3) case final suffix?) {
      final length = int.tryParse(suffix);
      return length == null || length <= 0
          ? null
          : _RequestedRange.suffix(length);
    }
    final start = int.tryParse(match.group(1)!);
    final end = match.group(2)!.isEmpty ? null : int.tryParse(match.group(2)!);
    if (start == null || end != null && end < start) return null;
    return _RequestedRange(start: start, end: end);
  }

  void _ensureReady() {
    if (_disposed || _bridge == null) {
      throw StateError('P2P media engine is not initialized');
    }
  }

  String _randomToken(int bytes) => base64Url
      .encode(List<int>.generate(bytes, (_) => _random.nextInt(256)))
      .replaceAll('=', '');

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    for (final cancellation in _activePeerRequests) {
      cancellation.cancel();
    }
    _activePeerRequests.clear();
    _bridge?.callMethod<JSAny?>('setRequestHandler'.toJS, null);
    _bridge = null;
    _client?.close();
    _resources.clear();
    for (final control in _workerControls.values) {
      control.close();
    }
    _workerControls.clear();
    stats.dispose();
  }
}

final class _WebResource {
  _WebResource({
    required this.id,
    required this.upstream,
    required this.headers,
    required this.swarmId,
    required this.logicalKey,
    required this.manifestKind,
    required this.shareable,
    required this.isDirectory,
  });
  final String id;
  final Uri upstream;
  final Map<String, String> headers;
  final String swarmId;
  final String logicalKey;
  final P2pManifestKind manifestKind;
  final bool shareable;
  final bool isDirectory;
  int? length;
  bool? originAcceptsRanges;
  DateTime lastAccessed = DateTime.now();

  _WebResource copyWith({
    Uri? upstream,
    String? logicalKey,
    bool? isDirectory,
  }) => _WebResource(
    id: id,
    upstream: upstream ?? this.upstream,
    headers: headers,
    swarmId: swarmId,
    logicalKey: logicalKey ?? this.logicalKey,
    manifestKind: manifestKind,
    shareable: shareable,
    isDirectory: isDirectory ?? this.isDirectory,
  );
}

final class _RequestedRange {
  const _RequestedRange({required this.start, this.end}) : suffixLength = null;
  const _RequestedRange.suffix(this.suffixLength) : start = null, end = null;

  final int? start;
  final int? end;
  final int? suffixLength;

  _ResolvedRange? resolve(int totalLength) {
    if (totalLength <= 0) return null;
    if (suffixLength case final suffix?) {
      final length = min(suffix, totalLength);
      return _ResolvedRange(totalLength - length, totalLength - 1);
    }
    final resolvedStart = start;
    if (resolvedStart == null || resolvedStart >= totalLength) return null;
    return _ResolvedRange(
      resolvedStart,
      min(end ?? totalLength - 1, totalLength - 1),
    );
  }
}

final class _ResolvedRange {
  const _ResolvedRange(this.start, this.end);

  final int start;
  final int end;
  int get length => end - start + 1;
}

final class _OriginBytes {
  const _OriginBytes(
    this.statusCode,
    this.headers,
    this.bytes, {
    required this.transferredBytes,
  });

  final int statusCode;
  final Map<String, String> headers;
  final Uint8List bytes;
  final int transferredBytes;
}

final class _OriginStream {
  const _OriginStream(this.response, this._abort);

  final http.StreamedResponse response;
  final _OriginAbort _abort;

  void close() => _abort.close();
}

final class _OriginAbort {
  _OriginAbort(P2pPieceRequestCancellation cancellation) {
    _timeout = Timer(_originHeaderTimeout, abort);
    unawaited(cancellation.whenCancelled.then((_) => abort()));
  }

  final Completer<void> _aborted = Completer<void>();
  Timer? _timeout;

  Future<void> get whenAborted => _aborted.future;

  void headersReceived() {
    _timeout?.cancel();
    _timeout = null;
  }

  void abort() {
    _timeout?.cancel();
    _timeout = null;
    if (!_aborted.isCompleted) _aborted.complete();
  }

  void close() {
    _timeout?.cancel();
    _timeout = null;
  }
}

final class _WorkerRequestControl {
  _WorkerRequestControl(this._port) {
    _handler = ((JSObject event) {
      final data = event.getProperty<JSAny?>('data'.toJS)?.dartify();
      if (data is! Map) return;
      switch (data['type']) {
        case 'pull':
          if (_waiters.isNotEmpty) {
            _waiters.removeFirst().complete(true);
          } else if (_credits < 2) {
            _credits++;
          }
        case 'cancel':
          close();
      }
    }).toJS;
    _port.setProperty('onmessage'.toJS, _handler);
    _port.callMethod<JSAny?>('start'.toJS);
  }

  final JSObject _port;
  late final JSFunction _handler;
  final P2pPieceRequestCancellation cancellation =
      P2pPieceRequestCancellation();
  final Queue<Completer<bool>> _waiters = Queue<Completer<bool>>();
  int _credits = 0;
  bool _closed = false;

  Future<bool> takeCredit() {
    if (_closed) return Future.value(false);
    if (_credits > 0) {
      _credits--;
      return Future.value(true);
    }
    final waiter = Completer<bool>();
    _waiters.add(waiter);
    return waiter.future;
  }

  void close() {
    if (_closed) return;
    _closed = true;
    cancellation.cancel();
    while (_waiters.isNotEmpty) {
      _waiters.removeFirst().complete(false);
    }
  }
}

Future<void> _ignoreIntegrity(P2pPeerSource source, bool valid) async {}
bool _alwaysHasPeer(String swarmId) => true;
