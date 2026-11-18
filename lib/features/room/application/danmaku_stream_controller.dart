import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/features/room/application/danmaku_source.dart';
import 'package:synctv_app/features/room/domain/acfun_danmaku_codec.dart';
import 'package:synctv_app/features/room/domain/danmaku_model.dart';
import 'package:synctv_app/features/room/domain/media_document_parsing.dart';
import 'package:synctv_app/features/room/domain/playback_resource_localizer.dart';
import 'package:video_player/video_player.dart';

class DanmakuController extends ChangeNotifier {
  DanmakuController(
    this._source, {
    ResourceUrlResolver? resourceUrlResolver,
    this.onStreamAccessExpired,
  }) : _resourceUrlResolver =
           resourceUrlResolver ?? const IdentityResourceUrlResolver();

  final DanmakuSource _source;
  final ResourceUrlResolver _resourceUrlResolver;

  List<DanmakuItem> _items = [];
  List<DanmakuItem> get items => _items;

  VoidCallback? onStreamAccessExpired;
  StreamSubscription<String>? _sseSubscription;
  Timer? _reconnectTimer;
  int _documentGeneration = 0;
  int _streamGeneration = 0;
  bool _disposed = false;
  VideoPlayerController? videoController;

  String? _loadedDanmakuUrl;
  Map<String, String> _loadedDanmakuHeaders = const {};
  bool _documentLoaded = false;
  bool _documentLoading = false;
  String? _streamDanmakuUrl;
  Map<String, String> _streamDanmakuHeaders = const {};

  @override
  void dispose() {
    _disposed = true;
    _documentGeneration++;
    _streamGeneration++;
    _reconnectTimer?.cancel();
    unawaited(_sseSubscription?.cancel());
    super.dispose();
  }

  void updateConfig({
    String? danmakuUrl,
    Map<String, String> danmakuHeaders = const {},
    P2pResourceDelivery? danmakuP2pDelivery,
    PlaybackResourceLocalizer? localizeStaticResource,
    String? streamDanmakuUrl,
    Map<String, String> streamDanmakuHeaders = const {},
    VideoPlayerController? controller,
    bool preserveLoadedDocument = false,
  }) {
    if (controller != null) {
      videoController = controller;
    }

    final requestedDocumentMatches =
        danmakuUrl == _loadedDanmakuUrl &&
        _sameHeaders(danmakuHeaders, _loadedDanmakuHeaders);
    final shouldLoadDocument =
        !preserveLoadedDocument ||
        (!_documentLoaded && (!_documentLoading || !requestedDocumentMatches));
    if (shouldLoadDocument) {
      if (!preserveLoadedDocument) {
        _items.clear();
        notifyListeners();
      }
      _loadedDanmakuUrl = danmakuUrl;
      _loadedDanmakuHeaders = Map<String, String>.from(danmakuHeaders);
      _documentLoaded = false;
      _documentLoading = danmakuUrl?.isNotEmpty == true;
      unawaited(
        _loadDanmaku(
          ++_documentGeneration,
          danmakuUrl,
          _loadedDanmakuHeaders,
          danmakuP2pDelivery,
          localizeStaticResource,
        ),
      );
    }

    if (streamDanmakuUrl != _streamDanmakuUrl ||
        !_sameHeaders(streamDanmakuHeaders, _streamDanmakuHeaders)) {
      _streamDanmakuUrl = streamDanmakuUrl;
      _streamDanmakuHeaders = Map<String, String>.from(streamDanmakuHeaders);
      unawaited(_replaceDanmakuStream());
    }
  }

  void add(DanmakuItem item) {
    _items.add(item);
    if (_items.length > 500) {
      _items.removeRange(0, _items.length - 400);
    }
    notifyListeners();
  }

  void addItems(List<DanmakuItem> newItems) {
    _items.addAll(newItems);
    notifyListeners();
  }

  void addUniqueItems(List<DanmakuItem> newItems) {
    if (newItems.isEmpty) return;
    final existingKeys = _items.map(_danmakuKey).toSet();
    var changed = false;
    for (final item in newItems) {
      if (existingKeys.add(_danmakuKey(item))) {
        _items.add(item);
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  String _danmakuKey(DanmakuItem item) {
    return '${item.origin.index}|${item.startTime.inMilliseconds}|'
        '${item.text}|${item.type.index}';
  }

  void replaceVideoItems(List<DanmakuItem> newItems) {
    _items = [
      ..._items.where((item) => item.origin != DanmakuOrigin.video),
      ...newItems,
    ];
    notifyListeners();
  }

  bool _sameHeaders(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void detachVideoController(VideoPlayerController controller) {
    if (identical(videoController, controller)) {
      videoController = null;
    }
  }

  Future<void> _loadDanmaku(
    int generation,
    String? danmakuUrl,
    Map<String, String> headers,
    P2pResourceDelivery? p2pDelivery,
    PlaybackResourceLocalizer? localizeStaticResource,
  ) async {
    _items.clear();
    notifyListeners();

    if (danmakuUrl == null || danmakuUrl.isEmpty) {
      _documentLoading = false;
      return;
    }
    try {
      final url = _resourceUrlResolver.resolve(danmakuUrl);
      final resource = p2pDelivery == null || localizeStaticResource == null
          ? LocalizedPlaybackResource(uri: Uri.parse(url), headers: headers)
          : await localizeStaticResource(url, headers, p2pDelivery);
      if (_disposed || generation != _documentGeneration) return;
      final content = await _source.loadDocument(
        resource.uri,
        headers: resource.headers,
      );
      if (_disposed || generation != _documentGeneration || content == null) {
        return;
      }
      // Documents are untrusted (server, provider host, or P2P peer): parse
      // off the UI isolate with a hard size cap.
      if (content.length > maxDanmakuDocumentChars) {
        debugPrint('Danmaku document exceeds size cap, skipping');
        return;
      }
      final acFunItems = await documentParseRunner(
        decodeAcFunDanmakuDocument,
        content,
      );
      if (_disposed || generation != _documentGeneration) return;
      if (acFunItems != null) {
        replaceVideoItems(acFunItems);
      } else {
        final records = await documentParseRunner(
          parseBilibiliDanmakuXml,
          content,
        );
        if (_disposed || generation != _documentGeneration) return;
        replaceVideoItems(danmakuItemsFromRecords(records));
      }
      _documentLoaded = true;
    } catch (e) {
      debugPrint('Failed to load danmaku: $e');
    } finally {
      if (generation == _documentGeneration) {
        _documentLoading = false;
      }
    }
  }

  Future<void> _replaceDanmakuStream() async {
    final generation = ++_streamGeneration;
    _reconnectTimer?.cancel();
    final previousSubscription = _sseSubscription;
    _sseSubscription = null;
    if (previousSubscription != null) {
      unawaited(previousSubscription.cancel());
    }

    if (_disposed || _streamDanmakuUrl?.isNotEmpty != true) return;
    await _connectDanmakuStream(generation);
  }

  Future<void> _connectDanmakuStream(int generation) async {
    if (_disposed || generation != _streamGeneration) return;

    try {
      _sseSubscription = _source
          .openEventStream(
            Uri.parse(_streamDanmakuUrl!),
            headers: _streamDanmakuHeaders,
          )
          .listen(
            _handleRealtimeDanmaku,
            onError: (Object error) {
              if (generation != _streamGeneration || _disposed) return;
              _sseSubscription = null;
              if (error is DanmakuAccessExpiredException) {
                onStreamAccessExpired?.call();
                return;
              }
              if (error is DanmakuAccessDeniedException) {
                debugPrint('SSE access denied');
                return;
              }
              debugPrint('SSE Error: $error');
              _scheduleReconnect(generation);
            },
            onDone: () {
              if (generation != _streamGeneration || _disposed) return;
              _sseSubscription = null;
              debugPrint('SSE Done');
              _scheduleReconnect(generation);
            },
            cancelOnError: true,
          );
    } catch (e) {
      if (generation != _streamGeneration || _disposed) return;
      debugPrint('SSE Connection failed: $e');
      _scheduleReconnect(generation);
    }
  }

  void _scheduleReconnect(int generation) {
    if (_disposed || generation != _streamGeneration) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      unawaited(_connectDanmakuStream(generation));
    });
  }

  void _handleRealtimeDanmaku(String jsonStr) {
    if (videoController == null) return;
    try {
      final data = jsonDecode(jsonStr);
      String text = '';
      Color color = Colors.white;
      DanmakuType type = DanmakuType.floating;

      if (data is String) {
        text = data;
      } else if (data is Map) {
        // Bilibili live events expose their chat body as `message`, while
        // the other live providers use `text`.
        text = (data['text'] ?? data['message'] ?? '').toString();
        if (data['color'] != null) {
          try {
            String c = data['color'].toString();
            if (c.startsWith('#')) {
              c = c.substring(1);
              if (c.length == 6) {
                color = Color(int.parse('0xFF$c'));
              }
            }
          } catch (e) {
            debugPrint('Danmaku color parse error: $e');
          }
        }
      }

      if (text.isNotEmpty) {
        final now = videoController!.value.position;
        final item = DanmakuItem(
          text: text,
          startTime: now,
          endTime: now + const Duration(seconds: 8),
          color: color,
          type: type,
        );
        add(item);
      }
    } catch (e) {
      debugPrint('Danmaku parse error: $e');
    }
  }
}
