import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/widgets/danmaku_overlay.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/models/danmaku_model.dart';
import 'package:synctv_app/models/acfun_danmaku_codec.dart';
import 'package:synctv_app/services/synctv_service.dart';

class DanmakuController extends ChangeNotifier {
  DanmakuController({this.onStreamAccessExpired});

  List<DanmakuItem> _items = [];
  List<DanmakuItem> get items => _items;

  VoidCallback? onStreamAccessExpired;
  http.Client? _sseClient;
  StreamSubscription<String>? _sseSubscription;
  Timer? _reconnectTimer;
  int _streamGeneration = 0;
  bool _disposed = false;
  VideoPlayerController? videoController;

  String? _danmakuUrl;
  Map<String, String> _danmakuHeaders = const {};
  String? _streamDanmakuUrl;
  Map<String, String> _streamDanmakuHeaders = const {};

  @override
  void dispose() {
    _disposed = true;
    _streamGeneration++;
    _reconnectTimer?.cancel();
    _sseClient?.close();
    unawaited(_sseSubscription?.cancel());
    super.dispose();
  }

  void updateConfig({
    String? danmakuUrl,
    Map<String, String> danmakuHeaders = const {},
    String? streamDanmakuUrl,
    Map<String, String> streamDanmakuHeaders = const {},
    VideoPlayerController? controller,
  }) {
    if (controller != null) {
      videoController = controller;
    }

    if (danmakuUrl != _danmakuUrl ||
        !_sameHeaders(danmakuHeaders, _danmakuHeaders)) {
      _danmakuUrl = danmakuUrl;
      _danmakuHeaders = Map<String, String>.from(danmakuHeaders);
      _loadDanmaku();
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
    return '${item.startTime.inMilliseconds}|${item.text}|${item.type.index}';
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

  void _loadDanmaku() async {
    _items.clear();
    notifyListeners();

    if (_danmakuUrl == null || _danmakuUrl!.isEmpty) return;
    try {
      final url = SyncTvService.resolveResourceUrl(_danmakuUrl!);
      final response = await http.get(Uri.parse(url), headers: _danmakuHeaders);
      if (response.statusCode == 200) {
        String content;
        try {
          content = utf8.decode(response.bodyBytes);
        } catch (e) {
          content = response.body;
        }
        _parseDanmaku(content);
      }
    } catch (e) {
      debugPrint('Failed to load danmaku: $e');
    }
  }

  void _parseDanmaku(String content) {
    final acFunItems = decodeAcFunDanmakuDocument(content);
    if (acFunItems != null) {
      _items = acFunItems;
      notifyListeners();
      return;
    }
    String normalized = content
        .replaceAll('\u00A0', ' ')
        .replaceAll('\u3000', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');

    final regex = RegExp(r'<d\s+p="([^"]*)"\s*>((?:.|\n)*?)<\/d>');
    final matches = regex.allMatches(normalized);

    final List<DanmakuItem> newItems = [];

    for (final match in matches) {
      final p = match.group(1) ?? '';
      String text = (match.group(2) ?? '').trim();
      final parts = p.split(',');
      if (parts.isNotEmpty) {
        final timeSec = double.tryParse(parts[0]) ?? 0.0;
        final mode = int.tryParse(parts.length > 1 ? parts[1] : '1') ?? 1;
        final colorInt =
            int.tryParse(parts.length > 3 ? parts[3] : '16777215') ?? 16777215;

        DanmakuType type = DanmakuType.floating;
        if (mode == 4) type = DanmakuType.bottom;
        if (mode == 5) type = DanmakuType.top;

        // Color is decimal RGB
        final color = Color(0xFF000000 | (colorInt & 0x00FFFFFF));
        final startTime = Duration(milliseconds: (timeSec * 1000).toInt());
        final duration = type == DanmakuType.floating
            ? const Duration(seconds: 8)
            : const Duration(seconds: 4);

        // Remove HTML entities if present
        text = text
            .replaceAll('&amp;', '&')
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>');

        newItems.add(
          DanmakuItem(
            text: text,
            startTime: startTime,
            endTime: startTime + duration,
            color: color,
            type: type,
          ),
        );
      }
    }

    _items = newItems;
    notifyListeners();
  }

  Future<void> _replaceDanmakuStream() async {
    final generation = ++_streamGeneration;
    _reconnectTimer?.cancel();
    _sseClient?.close();
    await _sseSubscription?.cancel();
    _sseSubscription = null;
    _sseClient = null;

    if (_disposed || _streamDanmakuUrl?.isNotEmpty != true) return;
    await _connectDanmakuStream(generation);
  }

  Future<void> _connectDanmakuStream(int generation) async {
    if (_disposed || generation != _streamGeneration) return;

    final client = http.Client();
    _sseClient = client;
    try {
      final request = http.Request('GET', Uri.parse(_streamDanmakuUrl!));
      request.headers.addAll(_streamDanmakuHeaders);
      request.headers['Accept'] = 'text/event-stream';

      final response = await client.send(request);
      if (_disposed || generation != _streamGeneration) {
        client.close();
        return;
      }

      if (response.statusCode == 200) {
        _sseSubscription = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              (line) {
                if (line.startsWith('data: ')) {
                  final data = line.substring(6);
                  _handleRealtimeDanmaku(data);
                }
              },
              onError: (e) {
                if (generation != _streamGeneration || _disposed) return;
                debugPrint('SSE Error: $e');
                _scheduleReconnect(generation);
              },
              onDone: () {
                if (generation != _streamGeneration || _disposed) return;
                debugPrint('SSE Done');
                _scheduleReconnect(generation);
              },
            );
      } else {
        debugPrint('SSE Failed: ${response.statusCode}');
        client.close();
        if (response.statusCode == 401 || response.statusCode == 403) {
          onStreamAccessExpired?.call();
          return;
        }
        _scheduleReconnect(generation);
      }
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
        text = data['text'] ?? '';
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

class CustomVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;
  final DanmakuController? danmakuController;
  final Map<String, dynamic>? subtitles;
  final VoidCallback? onToggleFullScreen;
  final VoidCallback? onSync;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<bool>? onUserPlaybackStateChanged;
  final ValueChanged<Duration>? onUserSeek;
  final ValueChanged<double>? onUserPlaybackSpeedChanged;
  final bool isFullScreen;
  final bool isLive;
  final Function(String)? onSendDanmaku;
  final IconData? fullScreenIcon;
  final IconData? exitFullScreenIcon;
  final Widget? extraBottomWidget;
  final Widget? Function(BuildContext context)? diagnosticsBuilder;
  final VideoPlayerInteractionMode interactionMode;

  const CustomVideoPlayer({
    super.key,
    required this.controller,
    required this.title,
    this.danmakuController,
    this.subtitles,
    this.onToggleFullScreen,
    this.onSync,
    this.onPrevious,
    this.onNext,
    this.onUserPlaybackStateChanged,
    this.onUserSeek,
    this.onUserPlaybackSpeedChanged,
    this.isFullScreen = false,
    this.isLive = false,
    this.onSendDanmaku,
    this.fullScreenIcon,
    this.exitFullScreenIcon,
    this.extraBottomWidget,
    this.diagnosticsBuilder,
    this.interactionMode = VideoPlayerInteractionMode.mobile,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class PlaybackNavigationControls extends StatelessWidget {
  const PlaybackNavigationControls({
    super.key,
    required this.previousTooltip,
    required this.nextTooltip,
    this.onPrevious,
    this.onNext,
    this.iconSize = 20,
    this.gap = 8,
  });

  final String previousTooltip;
  final String nextTooltip;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final double iconSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          key: const Key('playback_previous_button'),
          icon: Icons.skip_previous_rounded,
          tooltip: previousTooltip,
          onPressed: onPrevious,
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          iconSize: iconSize,
        ),
        SizedBox(width: gap),
        AppIconButton(
          key: const Key('playback_next_button'),
          icon: Icons.skip_next_rounded,
          tooltip: nextTooltip,
          onPressed: onNext,
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          iconSize: iconSize,
        ),
      ],
    );
  }
}

enum VideoPlayerInteractionMode { mobile, desktop }

VideoPlayerInteractionMode videoPlayerInteractionModeForPlatform(
  TargetPlatform platform,
) => switch (platform) {
  TargetPlatform.android ||
  TargetPlatform.iOS => VideoPlayerInteractionMode.mobile,
  _ => VideoPlayerInteractionMode.desktop,
};

String sanitizeSubtitleText(String text) {
  return text
      .replaceAll(RegExp(r'<(?:\d{2}:)?\d{2}:\d{2}[.,]\d{3}>'), '')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join('\n');
}

String subtitleDisplayLabel(String key, dynamic value) {
  if (value is Map) {
    final name = value['name']?.toString().trim() ?? '';
    if (name.isNotEmpty) return name;
    final language = value['language']?.toString().trim() ?? '';
    if (language.isNotEmpty) return language;
  }
  return key;
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with SingleTickerProviderStateMixin {
  static const String _volumePrefKey = 'synctv.player.volume';
  static const String _lastAudibleVolumePrefKey =
      'synctv.player.last_audible_volume';

  bool _showControls = true;
  Timer? _hideTimer;
  bool _isDragging = false;
  bool _isVerticalDragging = false;
  bool _showDanmaku = true;
  double _lastAudibleVolume = 1.0;
  final LayerLink _volumeControlLink = LayerLink();
  OverlayEntry? _volumeOverlayEntry;
  Timer? _volumeOverlayHideTimer;
  bool _showVolumeSlider = false;

  // Gesture State
  double? _dragStartVolume;
  double? _dragStartBrightness;
  Duration? _dragStartPosition;
  String _dragLabel = '';
  IconData _dragIcon = Icons.info;

  // Slider Drag State
  bool _isSliderDragging = false;
  double _sliderDragValue = 0.0;

  // Subtitles
  final List<_SubtitleItem> _subtitleItems = [];
  String _currentSubtitle = '';
  Timer? _subtitleTimer;

  bool get _isDesktopMode =>
      widget.interactionMode == VideoPlayerInteractionMode.desktop;

  @override
  void initState() {
    super.initState();
    if (widget.isFullScreen) {
      // Lock to landscape mode only for fullscreen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Delay setting immersive mode slightly to allow orientation to settle
      Future.delayed(const Duration(milliseconds: 100), () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      });
    }
    widget.controller.addListener(_videoListener);
    widget.danmakuController?.addListener(_onDanmakuUpdate);
    _restorePersistedVolume();
    _startHideTimer();
    _loadSubtitles();
    if (_isDesktopMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _insertVolumeOverlay();
      });
    }
  }

  void _onDanmakuUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_videoListener);
      widget.controller.addListener(_videoListener);
      _restorePersistedVolume();
    }

    if (widget.danmakuController != oldWidget.danmakuController) {
      oldWidget.danmakuController?.removeListener(_onDanmakuUpdate);
      widget.danmakuController?.addListener(_onDanmakuUpdate);
    }

    if (widget.subtitles != oldWidget.subtitles) {
      _loadSubtitles();
    }

    if (widget.interactionMode != oldWidget.interactionMode) {
      if (_isDesktopMode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _insertVolumeOverlay();
        });
      } else {
        _removeVolumeOverlay();
      }
    }
  }

  @override
  void dispose() {
    if (widget.isFullScreen) {
      // Restore orientation and UI mode when exiting fullscreen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      // Delay resetting UI mode slightly to allow orientation to settle
      Future.delayed(const Duration(milliseconds: 100), () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      });
    }
    widget.controller.removeListener(_videoListener);
    widget.danmakuController?.removeListener(_onDanmakuUpdate);
    _hideTimer?.cancel();
    _volumeOverlayHideTimer?.cancel();
    _removeVolumeOverlay();
    _subtitleTimer?.cancel();
    super.dispose();
  }

  void _videoListener() {
    if (mounted) {
      _rememberAudibleVolume();
      setState(() {});
      if (_subtitleItems.isNotEmpty) {
        final position = widget.controller.value.position;
        try {
          final current = _subtitleItems.firstWhere(
            (item) => item.start <= position && item.end >= position,
            orElse: () => _SubtitleItem(Duration.zero, Duration.zero, ''),
          );
          if (_currentSubtitle != current.text) {
            _currentSubtitle = current.text;
          }
        } catch (_) {
          // ignore any lookup errors
        }
      }
    }
  }

  void _loadSubtitles([String? specificUrl]) async {
    _subtitleItems.clear();
    _currentSubtitle = '';

    // If specific URL provided (or null to clear), use it
    if (specificUrl != null) {
      await _fetchAndParseSubtitles(
        specificUrl,
        headers: _subtitleHeadersForUrl(specificUrl),
      );
      return;
    }

    // Otherwise load default
    if (widget.subtitles == null || widget.subtitles!.isEmpty) return;

    // Prefer 'zh' or 'chi' or 'Chinese', otherwise first
    Map<String, dynamic>? selected;
    String? url;
    String? defaultKey;

    // First pass: look for Chinese
    for (var key in widget.subtitles!.keys) {
      if (key.toLowerCase().contains('zh') ||
          key.toLowerCase().contains('chi') ||
          key.toLowerCase().contains('中')) {
        if (widget.subtitles![key] is Map) {
          selected = Map<String, dynamic>.from(widget.subtitles![key]);
          url = selected['url'] as String?;
          defaultKey = key;
          break;
        }
      }
    }

    // Second pass: take first available if no Chinese found
    if (url == null) {
      for (var key in widget.subtitles!.keys) {
        if (widget.subtitles![key] is Map) {
          selected = Map<String, dynamic>.from(widget.subtitles![key]);
          url = selected['url'] as String?;
          defaultKey = key;
          break;
        }
      }
    }

    if (url != null) {
      debugPrint('Loading default subtitle: $defaultKey');
      await _fetchAndParseSubtitles(
        url,
        headers: _headersFromDynamicMap(selected?['headers']),
      );
    }
  }

  Future<void> _fetchAndParseSubtitles(
    String url, {
    Map<String, String> headers = const {},
  }) async {
    try {
      final uri = Uri.parse(SyncTvService.resolveResourceUrl(url));

      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        // Robust decoding (handles UTF-16 BOM)
        String content = _decodeSubtitleContent(response.bodyBytes);

        // Debug content header
        debugPrint(
          'Subtitle Content Start: ${content.substring(0, min(200, content.length)).replaceAll('\n', '\\n')}',
        );

        // Determine format
        if (content.contains('[Script Info]') || content.contains('[Events]')) {
          _parseAssSubtitles(content);
        } else {
          _parseSubtitles(content);
        }

        if (mounted) setState(() {});
      } else {
        debugPrint('Failed to load subtitles: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Failed to load subtitles: $e');
    }
  }

  Map<String, String> _subtitleHeadersForUrl(String url) {
    final subtitles = widget.subtitles;
    if (subtitles == null || subtitles.isEmpty) return const {};
    for (final value in subtitles.values) {
      if (value is! Map) continue;
      if (value['url'] != url) continue;
      return _headersFromDynamicMap(value['headers']);
    }
    return const {};
  }

  Map<String, String> _headersFromDynamicMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map((key, value) => MapEntry('$key', '$value'));
  }

  String _decodeSubtitleContent(Uint8List bytes) {
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      debugPrint('Detected UTF-16 LE BOM');
      final List<int> codes = [];
      for (int i = 2; i < bytes.length - 1; i += 2) {
        codes.add(bytes[i] | (bytes[i + 1] << 8));
      }
      return String.fromCharCodes(codes);
    }

    if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
      debugPrint('Detected UTF-16 BE BOM');
      final List<int> codes = [];
      for (int i = 2; i < bytes.length - 1; i += 2) {
        codes.add((bytes[i] << 8) | bytes[i + 1]);
      }
      return String.fromCharCodes(codes);
    }

    int start = 0;
    if (bytes.length >= 3 &&
        bytes[0] == 0xEF &&
        bytes[1] == 0xBB &&
        bytes[2] == 0xBF) {
      debugPrint('Detected UTF-8 BOM');
      start = 3;
    }

    try {
      return utf8.decode(bytes.sublist(start), allowMalformed: false);
    } catch (e) {
      debugPrint('UTF-8 decode failed, trying lenient decode: $e');
      return utf8.decode(bytes, allowMalformed: true);
    }
  }

  void _parseAssSubtitles(String content) {
    if (content.contains('Script generated by danmu2ass')) {
      debugPrint('Detected danmu2ass script, parsing as Danmaku...');
      _parseAssToDanmaku(content);
      return;
    }

    debugPrint('Parsing ASS subtitles...');
    _subtitleItems.clear();
    final lines = LineSplitter.split(content).toList();

    List<String> formatFields = [];

    bool inEvents = false;

    for (String line in lines) {
      line = line.trim();
      if (line == '[Events]') {
        inEvents = true;
        continue;
      }

      if (!inEvents) continue;

      if (line.startsWith('Format:')) {
        final formatStr = line.substring(7).trim();
        formatFields = formatStr
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .toList();
        debugPrint('ASS Format: $formatFields');
        continue;
      }

      if (line.startsWith('Dialogue:')) {
        if (formatFields.isEmpty) {
          formatFields = [
            'layer',
            'start',
            'end',
            'style',
            'name',
            'marginl',
            'marginr',
            'marginv',
            'effect',
            'text',
          ];
        }

        final contentStr = line.substring(9).trim();

        List<String> parts = [];
        int currentStart = 0;
        for (int i = 0; i < formatFields.length - 1; i++) {
          int commaIndex = contentStr.indexOf(',', currentStart);
          if (commaIndex == -1) break;
          parts.add(contentStr.substring(currentStart, commaIndex));
          currentStart = commaIndex + 1;
        }
        // The rest is the text
        if (currentStart < contentStr.length) {
          parts.add(contentStr.substring(currentStart));
        } else {
          parts.add('');
        }

        if (parts.length == formatFields.length) {
          try {
            int startIndex = formatFields.indexOf('start');
            int endIndex = formatFields.indexOf('end');
            int textIndex = formatFields.indexOf('text');

            if (startIndex != -1 && endIndex != -1 && textIndex != -1) {
              final start = _parseAssDuration(parts[startIndex]);
              final end = _parseAssDuration(parts[endIndex]);
              String text = parts[textIndex];

              text = text.replaceAll(RegExp(r'\{.*?\}'), '');
              // Replace \N with newline
              text = text.replaceAll(r'\N', '\n');
              text = text.trim();

              if (text.isNotEmpty) {
                _subtitleItems.add(_SubtitleItem(start, end, text));
              }
            }
          } catch (e) {
            debugPrint('ASS subtitle parse error: $e');
          }
        }
      }
    }
    debugPrint('Parsed ${_subtitleItems.length} ASS subtitles');
  }

  void _parseAssToDanmaku(String content) {
    if (widget.danmakuController == null) return;

    final lines = LineSplitter.split(content).toList();
    List<DanmakuItem> danmakuItems = [];

    List<String> formatFields = [];
    bool inEvents = false;

    for (String line in lines) {
      line = line.trim();
      if (line == '[Events]') {
        inEvents = true;
        continue;
      }
      if (!inEvents) continue;

      if (line.startsWith('Format:')) {
        final formatStr = line.substring(7).trim();
        formatFields = formatStr
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .toList();
        continue;
      }

      if (line.startsWith('Dialogue:')) {
        if (formatFields.isEmpty) {
          formatFields = [
            'layer',
            'start',
            'end',
            'style',
            'name',
            'marginl',
            'marginr',
            'marginv',
            'effect',
            'text',
          ];
        }

        final contentStr = line.substring(9).trim();
        List<String> parts = [];
        int currentStart = 0;
        for (int i = 0; i < formatFields.length - 1; i++) {
          int commaIndex = contentStr.indexOf(',', currentStart);
          if (commaIndex == -1) break;
          parts.add(contentStr.substring(currentStart, commaIndex));
          currentStart = commaIndex + 1;
        }
        if (currentStart < contentStr.length) {
          parts.add(contentStr.substring(currentStart));
        } else {
          parts.add('');
        }

        if (parts.length == formatFields.length) {
          try {
            int startIndex = formatFields.indexOf('start');
            int endIndex = formatFields.indexOf('end');
            int textIndex = formatFields.indexOf('text');
            int styleIndex = formatFields.indexOf('style');

            if (startIndex != -1 && endIndex != -1 && textIndex != -1) {
              final start = _parseAssDuration(parts[startIndex]);
              final end = _parseAssDuration(parts[endIndex]);
              String rawText = parts[textIndex];
              String style = styleIndex != -1 ? parts[styleIndex] : '';

              // Extract color from tags if present {\c&HBBGGRR&}
              Color color = Colors.white;
              final colorMatch = RegExp(
                r'\\c&H([0-9a-fA-F]{6})&',
              ).firstMatch(rawText);
              if (colorMatch != null) {
                final hex = colorMatch.group(1)!; // BBGGRR
                final b = int.parse(hex.substring(0, 2), radix: 16);
                final g = int.parse(hex.substring(2, 4), radix: 16);
                final r = int.parse(hex.substring(4, 6), radix: 16);
                color = Color.fromARGB(255, r, g, b);
              }

              // Remove tags
              String text = rawText
                  .replaceAll(RegExp(r'\{.*?\}'), '')
                  .replaceAll(r'\N', '\n')
                  .trim();

              if (text.isNotEmpty) {
                DanmakuType type = DanmakuType.floating;
                if (style.toLowerCase().contains('top')) {
                  type = DanmakuType.top;
                }
                if (style.toLowerCase().contains('bottom')) {
                  type = DanmakuType.bottom;
                }

                danmakuItems.add(
                  DanmakuItem(
                    text: text,
                    startTime: start,
                    endTime:
                        end, // DanmakuOverlay uses internal duration usually, but we can pass it
                    color: color,
                    type: type,
                  ),
                );
              }
            }
          } catch (e) {
            // ignore
          }
        }
      }
    }

    _subtitleItems.clear();

    // Add to danmaku controller
    widget.danmakuController!.clear();
    widget.danmakuController!.addItems(danmakuItems);
    debugPrint(
      'Parsed and added ${danmakuItems.length} danmaku items from ASS',
    );

    // Enable danmaku if not already
    if (!_showDanmaku) {
      setState(() {
        _showDanmaku = true;
      });
    }
  }

  Duration _parseAssDuration(String s) {
    // h:mm:ss.cc
    final parts = s.split(':');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    final secParts = parts[2].split('.');
    int seconds = int.parse(secParts[0]);
    int centiseconds = int.parse(secParts[1]);

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: centiseconds * 10,
    );
  }

  void _parseSubtitles(String content) {
    _subtitleItems.clear();
    final lines = LineSplitter.split(content).toList();
    final regex = RegExp(
      r'((?:\d{2}:)?\d{2}:\d{2}[.,]\d{3}) --> ((?:\d{2}:)?\d{2}:\d{2}[.,]\d{3})',
    );

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final match = regex.firstMatch(line);
      if (match != null) {
        try {
          final start = _parseDuration(match.group(1)!);
          final end = _parseDuration(match.group(2)!);

          String text = '';
          int j = i + 1;
          while (j < lines.length && lines[j].trim().isNotEmpty) {
            text += '${lines[j].trim()}\n';
            j++;
          }

          final sanitizedText = sanitizeSubtitleText(text);
          if (sanitizedText.isNotEmpty) {
            _subtitleItems.add(_SubtitleItem(start, end, sanitizedText));
          }
          i = j;
        } catch (e) {
          debugPrint('Error parsing subtitle line: $line, error: $e');
        }
      }
    }
    debugPrint('Parsed ${_subtitleItems.length} subtitles');
  }

  Duration _parseDuration(String s) {
    final parts = s.split(':');
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    int milliseconds = 0;

    if (parts.length == 3) {
      hours = int.parse(parts[0]);
      minutes = int.parse(parts[1]);
      final secondsParts = parts[2].split(RegExp(r'[.,]'));
      seconds = int.parse(secondsParts[0]);
      milliseconds = int.parse(secondsParts[1]);
    } else if (parts.length == 2) {
      minutes = int.parse(parts[0]);
      final secondsParts = parts[1].split(RegExp(r'[.,]'));
      seconds = int.parse(secondsParts[0]);
      milliseconds = int.parse(secondsParts[1]);
    }

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted &&
          widget.controller.value.isPlaying &&
          !_isDragging &&
          !_isDesktopMode) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showDesktopControls() {
    if (!_isDesktopMode) return;
    _hideTimer?.cancel();
    if (mounted && !_showControls) {
      setState(() => _showControls = true);
    }
  }

  void _handleDesktopPointerExit(PointerExitEvent event) {
    if (!_isDesktopMode) return;
    if (!widget.controller.value.isPlaying) return;
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted && widget.controller.value.isPlaying && !_isSliderDragging) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) _startHideTimer();
  }

  Future<void> _togglePlayPause() async {
    final nextIsPlaying = !widget.controller.value.isPlaying;
    if (widget.controller.value.isPlaying) {
      await widget.controller.pause();
    } else {
      await widget.controller.play();
    }
    widget.onUserPlaybackStateChanged?.call(nextIsPlaying);
    if (mounted) {
      setState(() => _showControls = true);
    }
    _startHideTimer();
  }

  Future<void> _seekFromUser(Duration target) async {
    if (widget.isLive) return;
    final duration = widget.controller.value.duration;
    final clamped = target < Duration.zero
        ? Duration.zero
        : duration > Duration.zero && target > duration
        ? duration
        : target;
    await widget.controller.seekTo(clamped);
    widget.onUserSeek?.call(clamped);
    _showDesktopControls();
  }

  Future<void> _setPlaybackSpeedFromUser(double speed) async {
    await widget.controller.setPlaybackSpeed(speed);
    widget.onUserPlaybackSpeedChanged?.call(speed);
    _startHideTimer();
    if (mounted) setState(() {});
  }

  List<_PlaybackSpeedOption> _playbackSpeedOptions() {
    const speeds = <double>[0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    return [
      for (final speed in speeds)
        _PlaybackSpeedOption(
          speed: speed,
          label:
              '${speed.toStringAsFixed(speed == speed.roundToDouble() ? 0 : 2)}x',
        ),
    ];
  }

  Future<void> _seekRelative(Duration offset) async {
    if (widget.isLive) return;
    final value = widget.controller.value;
    final duration = value.duration;
    if (duration <= Duration.zero) return;
    final target = value.position + offset;
    final clamped = target < Duration.zero
        ? Duration.zero
        : target > duration
        ? duration
        : target;
    await _seekFromUser(clamped);
  }

  KeyEventResult _handleDesktopKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isDesktopMode || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.keyK) {
      if (widget.isLive) return KeyEventResult.handled;
      _togglePlayPause();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      if (widget.isLive) return KeyEventResult.handled;
      _seekRelative(const Duration(seconds: -5));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      if (widget.isLive) return KeyEventResult.handled;
      _seekRelative(const Duration(seconds: 5));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      _setPlayerVolume(widget.controller.value.volume + 0.05);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      _setPlayerVolume(widget.controller.value.volume - 0.05);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.keyM) {
      _toggleMute();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.keyF && widget.onToggleFullScreen != null) {
      widget.onToggleFullScreen?.call();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_isDesktopMode) return;
    if (widget.isLive) return;
    _isDragging = true;
    _dragStartPosition = widget.controller.value.position;
    _hideTimer?.cancel();
    setState(() {
      _showControls = true;
      _dragLabel = _formatDuration(_dragStartPosition!);
      _dragIcon = Icons.fast_forward;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isDesktopMode) return;
    if (widget.isLive) return;
    if (_dragStartPosition == null) return;

    final duration = widget.controller.value.duration.inMilliseconds.toDouble();
    final deltaMs = details.primaryDelta! * 200;

    final currentMs = _dragStartPosition!.inMilliseconds.toDouble();
    final newPosMs = (currentMs + deltaMs).clamp(0.0, duration);
    _dragStartPosition = Duration(milliseconds: newPosMs.toInt());

    setState(() {
      _dragLabel =
          '${_formatDuration(_dragStartPosition!)} / ${_formatDuration(widget.controller.value.duration)}';
      _dragIcon = details.primaryDelta! > 0
          ? Icons.fast_forward
          : Icons.fast_rewind;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isDesktopMode) return;
    if (widget.isLive) return;
    _isDragging = false;
    if (_dragStartPosition != null) {
      unawaited(_seekFromUser(_dragStartPosition!));
    }
    _startHideTimer();
    setState(() {
      _dragLabel = '';
    });
  }

  void _onVerticalDragStart(DragStartDetails details) async {
    if (_isDesktopMode) return;
    _isVerticalDragging = true;
    final width = MediaQuery.of(context).size.width;
    final isLeft = details.globalPosition.dx < width / 2;

    if (isLeft) {
      if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
        try {
          _dragStartBrightness = await ScreenBrightness().application;
          if (!_isVerticalDragging) return;
          setState(() {
            _dragIcon = Icons.brightness_6;
            _dragLabel = context.l10n.brightness;
          });
        } catch (e) {
          debugPrint('Brightness get error: $e');
        }
      }
    } else {
      try {
        _dragStartVolume = await FlutterVolumeController.getVolume();
      } catch (e) {
        _dragStartVolume = widget.controller.value.volume;
      }
      if (!_isVerticalDragging) return;
      await widget.controller.setVolume(_dragStartVolume!.clamp(0.0, 1.0));
      setState(() {
        _dragIcon = Icons.volume_up;
        _dragLabel = context.l10n.volume;
      });
    }
    _showControls = true;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    if (_isDesktopMode) return;
    if (!_isVerticalDragging) return;
    final delta = details.primaryDelta! / -200; // Up is negative, so invert

    if (_dragStartBrightness != null) {
      // Platform check before setting brightness
      if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
        final newVal = (_dragStartBrightness! + delta).clamp(0.0, 1.0);
        try {
          await ScreenBrightness().setApplicationScreenBrightness(newVal);
          if (!_isVerticalDragging) return;
          _dragStartBrightness = newVal; // accumulate
          setState(() {
            _dragLabel = context.l10n.brightnessPercent((newVal * 100).toInt());
          });
        } catch (e) {
          debugPrint('Brightness set error: $e');
        }
      }
    } else if (_dragStartVolume != null) {
      final newVal = (_dragStartVolume! + delta).clamp(0.0, 1.0);

      try {
        await FlutterVolumeController.setVolume(newVal);
      } catch (e) {
        // System volume is unavailable on some desktop targets.
      }
      await widget.controller.setVolume(newVal);
      unawaited(_persistVolume(newVal));

      if (!_isVerticalDragging) return;
      _dragStartVolume = newVal;
      setState(() {
        _dragLabel = context.l10n.volumePercent((newVal * 100).toInt());
      });
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _isVerticalDragging = false;
    _dragStartBrightness = null;
    _dragStartVolume = null;

    _startHideTimer();

    // Force immediate hide first to clear icon
    if (mounted) {
      setState(() {
        _dragLabel = '';
      });
    }
  }

  void _onVerticalDragCancel() {
    _isVerticalDragging = false;
    _dragStartBrightness = null;
    _dragStartVolume = null;

    _startHideTimer();

    if (mounted) {
      setState(() {
        _dragLabel = '';
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _rememberAudibleVolume() {
    final volume = widget.controller.value.volume;
    if (volume.isFinite && volume > 0.01) {
      _lastAudibleVolume = volume.clamp(0.0, 1.0).toDouble();
    }
  }

  Future<void> _restorePersistedVolume() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final volume = prefs.getDouble(_volumePrefKey);
      final audible = prefs.getDouble(_lastAudibleVolumePrefKey);
      if (audible != null && audible.isFinite && audible > 0.01) {
        _lastAudibleVolume = audible.clamp(0.0, 1.0).toDouble();
      }
      if (volume != null && volume.isFinite) {
        await widget.controller.setVolume(volume.clamp(0.0, 1.0).toDouble());
      } else {
        _rememberAudibleVolume();
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Restore player volume failed: $e');
      _rememberAudibleVolume();
    }
  }

  Future<void> _persistVolume(double volume) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_volumePrefKey, volume.clamp(0.0, 1.0).toDouble());
      if (_lastAudibleVolume > 0.01) {
        await prefs.setDouble(
          _lastAudibleVolumePrefKey,
          _lastAudibleVolume.clamp(0.0, 1.0).toDouble(),
        );
      }
    } catch (e) {
      debugPrint('Persist player volume failed: $e');
    }
  }

  IconData _volumeIcon(double volume) {
    if (volume <= 0.01) return Icons.volume_off_rounded;
    if (volume < 0.5) return Icons.volume_down_rounded;
    return Icons.volume_up_rounded;
  }

  Future<void> _setPlayerVolume(double volume) async {
    final nextVolume = volume.clamp(0.0, 1.0);
    if (nextVolume > 0.01) _lastAudibleVolume = nextVolume;
    await widget.controller.setVolume(nextVolume);
    unawaited(_persistVolume(nextVolume));
    _volumeOverlayEntry?.markNeedsBuild();
    _startHideTimer();
    if (mounted) setState(() {});
  }

  Future<void> _toggleMute() async {
    final currentVolume = widget.controller.value.volume;
    if (currentVolume > 0.01) {
      _lastAudibleVolume = currentVolume.clamp(0.0, 1.0).toDouble();
      await _setPlayerVolume(0);
    } else {
      await _setPlayerVolume(
        _lastAudibleVolume <= 0.01
            ? 1.0
            : _lastAudibleVolume.clamp(0.0, 1.0).toDouble(),
      );
    }
  }

  void _showVolumeOverlay() {
    _volumeOverlayHideTimer?.cancel();
    _hideTimer?.cancel();
    if (mounted && !_showVolumeSlider) {
      _showVolumeSlider = true;
      _volumeOverlayEntry?.markNeedsBuild();
    }
  }

  void _scheduleVolumeOverlayHide() {
    _volumeOverlayHideTimer?.cancel();
    _volumeOverlayHideTimer = Timer(const Duration(milliseconds: 180), () {
      if (mounted && _showVolumeSlider) {
        _showVolumeSlider = false;
        _volumeOverlayEntry?.markNeedsBuild();
      }
      _startHideTimer();
    });
  }

  void _insertVolumeOverlay() {
    if (_volumeOverlayEntry != null) return;
    final entry = OverlayEntry(builder: _buildVolumeOverlay);
    _volumeOverlayEntry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  void _removeVolumeOverlay() {
    final entry = _volumeOverlayEntry;
    _volumeOverlayEntry = null;
    entry?.remove();
    entry?.dispose();
  }

  Widget _buildVolumeOverlay(BuildContext overlayContext) => Positioned(
    width: 44,
    height: 132,
    child: ExcludeSemantics(
      child: CompositedTransformFollower(
        link: _volumeControlLink,
        showWhenUnlinked: false,
        targetAnchor: Alignment.topCenter,
        followerAnchor: Alignment.bottomCenter,
        offset: const Offset(0, -4),
        child: IgnorePointer(
          ignoring: !_showVolumeSlider,
          child: Opacity(
            opacity: _showVolumeSlider ? 1 : 0,
            child: MouseRegion(
              onEnter: (_) => _showVolumeOverlay(),
              onExit: (_) => _scheduleVolumeOverlayHide(),
              child: Material(
                color: const Color(0xF21A1A24),
                elevation: 8,
                shadowColor: Colors.black54,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SliderTheme(
                    data: SliderTheme.of(overlayContext).copyWith(
                      trackHeight: 3,
                      activeTrackColor: const Color(0xFF5D5FEF),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: widget.controller.value.volume
                            .clamp(0.0, 1.0)
                            .toDouble(),
                        min: 0,
                        max: 1,
                        onChanged: _setPlayerVolume,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildHoverVolumeControl(
    VideoPlayerValue videoValue, {
    required double iconSize,
  }) {
    final buttonSize = max(32.0, iconSize + 12);
    return CompositedTransformTarget(
      link: _volumeControlLink,
      child: MouseRegion(
        onEnter: (_) => _showVolumeOverlay(),
        onExit: (_) => _scheduleVolumeOverlayHide(),
        child: AppIconButton(
          tooltip: videoValue.volume <= 0.01
              ? context.l10n.unmute
              : context.l10n.mute,
          icon: _volumeIcon(videoValue.volume),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(width: buttonSize, height: 40),
          iconSize: iconSize,
          showTooltip: false,
          onPressed: _toggleMute,
        ),
      ),
    );
  }

  void _showSubtitleMenu() {
    if (widget.subtitles == null || widget.subtitles!.isEmpty) {
      return;
    }

    showAppBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AppSafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.chooseSubtitles,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppTile(
              prefix: const Icon(Icons.close, color: Colors.white),
              title: Text(
                context.l10n.disableSubtitles,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _subtitleItems.clear();
                  _currentSubtitle = '';
                });
                Navigator.pop(context);
              },
            ),
            const AppDivider(color: Colors.white24, height: 1),
            Flexible(
              child: AppSingleChildScrollView(
                child: Column(
                  children: widget.subtitles!.entries.map((e) {
                    final label = subtitleDisplayLabel(e.key, e.value);
                    final url = e.value is Map ? e.value['url'] : null;
                    return AppTile(
                      title: Text(
                        label,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (url != null) _loadSubtitles(url);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDanmakuInput() {
    final textController = TextEditingController();
    showAppBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      useSafeArea: false,
      showDragHandle: false,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AppPanelSurface(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
          color: const Color(0xFF1E1E2C),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AppSafeArea(
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: textController,
                    label: context.l10n.danmaku,
                    showLabel: false,
                    hintText: context.l10n.danmakuHint,
                    prefixIcon: Icons.subtitles_rounded,
                    style: const TextStyle(color: Colors.white),
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    enabledBorderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                    focusedBorderSide: const BorderSide(
                      color: Color(0xFF5D5FEF),
                      width: 1.4,
                    ),
                    showClearButton: true,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        widget.onSendDanmaku?.call(value.trim());
                        Navigator.pop(context);
                      }
                    },
                    autofocus: true,
                    smartDashesType: SmartDashesType.disabled,
                    smartQuotesType: SmartQuotesType.disabled,
                  ),
                ),
                AppIconButton(
                  icon: Icons.send,
                  tooltip: context.l10n.send,
                  style: AppIconButtonStyle.tonal,
                  onPressed: () {
                    if (textController.text.trim().isNotEmpty) {
                      widget.onSendDanmaku?.call(textController.text.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoValue = widget.controller.value;

    return AppScaffold(
      backgroundColor: Colors.black,
      body: Focus(
        autofocus: _isDesktopMode,
        onKeyEvent: _handleDesktopKeyEvent,
        child: MouseRegion(
          onHover: (_) => _showDesktopControls(),
          onExit: _handleDesktopPointerExit,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isDesktopMode
                ? (widget.isLive ? null : _togglePlayPause)
                : _toggleControls,
            onDoubleTap: _isDesktopMode || widget.isLive
                ? null
                : _togglePlayPause,
            onHorizontalDragStart: _isDesktopMode
                ? null
                : _onHorizontalDragStart,
            onHorizontalDragUpdate: _isDesktopMode
                ? null
                : _onHorizontalDragUpdate,
            onHorizontalDragEnd: _isDesktopMode ? null : _onHorizontalDragEnd,
            onVerticalDragStart: _isDesktopMode ? null : _onVerticalDragStart,
            onVerticalDragUpdate: _isDesktopMode ? null : _onVerticalDragUpdate,
            onVerticalDragEnd: _isDesktopMode ? null : _onVerticalDragEnd,
            onVerticalDragCancel: _isDesktopMode ? null : _onVerticalDragCancel,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: videoValue.aspectRatio > 0
                        ? videoValue.aspectRatio
                        : 16 / 9,
                    child: VideoPlayer(widget.controller),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DanmakuOverlay(
                      videoController: widget.controller,
                      danmakuList: widget.danmakuController?.items ?? [],
                      isEnabled: _showDanmaku,
                    ),
                  ),
                ),
                if (_currentSubtitle.isNotEmpty)
                  Positioned(
                    bottom: _showControls
                        ? (widget.isFullScreen ? 112 : 76)
                        : (widget.isFullScreen ? 40 : 10),
                    left: 16,
                    right: 16,
                    child: AppPanelSurface(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.zero,
                      clipBehavior: Clip.none,
                      child: Text(
                        _currentSubtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.isFullScreen ? 24 : 14,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(0, -1),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(1, 0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(-1, 0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: widget.isFullScreen ? 4 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (_dragLabel.isNotEmpty)
                  AppPanelSurface(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black54,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_dragIcon, color: Colors.white, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          _dragLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                IgnorePointer(
                  ignoring: !_showControls,
                  child: AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Stack(
                      children: [
                        // Top Bar
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AppPanelSurface(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 8,
                              bottom: 8,
                              left: 16,
                              right: 16,
                            ),
                            color: const Color(0x66000000),
                            borderRadius: BorderRadius.zero,
                            clipBehavior: Clip.none,
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black87, Colors.transparent],
                            ),
                            child: Row(
                              children: [
                                if (widget.isFullScreen)
                                  BackButton(
                                    color: Colors.white,
                                    onPressed: widget.onToggleFullScreen,
                                  ),
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    final diagnostics = widget
                                        .diagnosticsBuilder
                                        ?.call(context);
                                    if (diagnostics == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: diagnostics,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom Bar
                        Positioned(
                          bottom: widget.isFullScreen ? 24 : 0, // 全屏模式下抬高 24 像素
                          left: 0,
                          right: 0,
                          child: AppSafeArea(
                            top: false,
                            bottom:
                                false, // 无论是全屏还是非全屏，都禁用 SafeArea 的底部填充，完全由 Positioned 控制
                            child: AppPanelSurface(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              color: const Color(0x99000000),
                              borderRadius: BorderRadius.zero,
                              clipBehavior: Clip.none,
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black87, Colors.transparent],
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final controlsWidth = constraints.maxWidth;
                                  final showTime = controlsWidth >= 300;
                                  final showSecondaryButtons =
                                      controlsWidth >= 360;
                                  final showHoverVolume = _isDesktopMode;
                                  final iconSize = controlsWidth < 360
                                      ? 18.0
                                      : 20.0;
                                  final playIconSize = controlsWidth < 360
                                      ? 28.0
                                      : 32.0;
                                  final horizontalGap = controlsWidth < 360
                                      ? 4.0
                                      : 8.0;

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Semantics(
                                            button: true,
                                            label: videoValue.isPlaying
                                                ? context.l10n.pause
                                                : context.l10n.play,
                                            onTap: _togglePlayPause,
                                            child: GestureDetector(
                                              onTap: _togglePlayPause,
                                              child: SizedBox.square(
                                                dimension: 40,
                                                child: Icon(
                                                  videoValue.isPlaying
                                                      ? Icons.pause_rounded
                                                      : Icons
                                                            .play_arrow_rounded,
                                                  color: Colors.white,
                                                  size: playIconSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (widget.onPrevious != null ||
                                              widget.onNext != null) ...[
                                            SizedBox(width: horizontalGap),
                                            PlaybackNavigationControls(
                                              previousTooltip:
                                                  context.l10n.previousVideo,
                                              nextTooltip:
                                                  context.l10n.nextVideo,
                                              onPrevious: widget.onPrevious,
                                              onNext: widget.onNext,
                                              iconSize: iconSize,
                                              gap: horizontalGap,
                                            ),
                                          ],
                                          SizedBox(width: horizontalGap),
                                          if (showTime) ...[
                                            Text(
                                              widget.isLive
                                                  ? context.l10n.live
                                                  : _formatDuration(
                                                      videoValue.position,
                                                    ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(width: horizontalGap),
                                          ],
                                          if (widget.isLive)
                                            const Spacer()
                                          else
                                            Expanded(
                                              child: Semantics(
                                                slider: true,
                                                label: context
                                                    .l10n
                                                    .playbackProgress,
                                                value:
                                                    '${_formatDuration(videoValue.position)} / ${_formatDuration(videoValue.duration)}',
                                                child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onHorizontalDragStart: (details) {
                                                    _startHideTimer();
                                                    final RenderBox box =
                                                        context.findRenderObject()
                                                            as RenderBox;
                                                    final double
                                                    relativePosition =
                                                        details
                                                            .localPosition
                                                            .dx /
                                                        box.size.width;
                                                    final double value =
                                                        (relativePosition *
                                                                videoValue
                                                                    .duration
                                                                    .inMilliseconds
                                                                    .toDouble())
                                                            .clamp(
                                                              0,
                                                              videoValue
                                                                  .duration
                                                                  .inMilliseconds
                                                                  .toDouble(),
                                                            );
                                                    setState(() {
                                                      _isSliderDragging = true;
                                                      _sliderDragValue = value;
                                                    });
                                                  },
                                                  onHorizontalDragUpdate: (details) {
                                                    _startHideTimer();
                                                    final RenderBox box =
                                                        context.findRenderObject()
                                                            as RenderBox;
                                                    final double
                                                    relativePosition =
                                                        details
                                                            .localPosition
                                                            .dx /
                                                        box.size.width;
                                                    final double value =
                                                        (relativePosition *
                                                                videoValue
                                                                    .duration
                                                                    .inMilliseconds
                                                                    .toDouble())
                                                            .clamp(
                                                              0,
                                                              videoValue
                                                                  .duration
                                                                  .inMilliseconds
                                                                  .toDouble(),
                                                            );
                                                    setState(() {
                                                      _sliderDragValue = value;
                                                    });
                                                  },
                                                  onHorizontalDragEnd:
                                                      (details) {
                                                        _startHideTimer();
                                                        final target = Duration(
                                                          milliseconds:
                                                              _sliderDragValue
                                                                  .toInt(),
                                                        );
                                                        _seekFromUser(
                                                          target,
                                                        ).then((_) {
                                                          setState(() {
                                                            _isSliderDragging =
                                                                false;
                                                          });
                                                        });
                                                      },
                                                  onTapDown: (details) {
                                                    _startHideTimer();
                                                    final RenderBox box =
                                                        context.findRenderObject()
                                                            as RenderBox;
                                                    final double
                                                    relativePosition =
                                                        details
                                                            .localPosition
                                                            .dx /
                                                        box.size.width;
                                                    final double value =
                                                        (relativePosition *
                                                                videoValue
                                                                    .duration
                                                                    .inMilliseconds
                                                                    .toDouble())
                                                            .clamp(
                                                              0,
                                                              videoValue
                                                                  .duration
                                                                  .inMilliseconds
                                                                  .toDouble(),
                                                            );
                                                    setState(() {
                                                      _isSliderDragging = true;
                                                      _sliderDragValue = value;
                                                    });
                                                  },
                                                  onTapUp: (details) {
                                                    _startHideTimer();
                                                    final target = Duration(
                                                      milliseconds:
                                                          _sliderDragValue
                                                              .toInt(),
                                                    );
                                                    _seekFromUser(target).then((
                                                      _,
                                                    ) {
                                                      setState(() {
                                                        _isSliderDragging =
                                                            false;
                                                      });
                                                    });
                                                  },
                                                  onTapCancel: () {
                                                    if (_isSliderDragging) {
                                                      final target = Duration(
                                                        milliseconds:
                                                            _sliderDragValue
                                                                .toInt(),
                                                      );
                                                      _seekFromUser(
                                                        target,
                                                      ).then((_) {
                                                        setState(() {
                                                          _isSliderDragging =
                                                              false;
                                                        });
                                                      });
                                                    }
                                                  },
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SliderTheme(
                                                        data: SliderTheme.of(context).copyWith(
                                                          thumbShape: RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                _isSliderDragging
                                                                ? (widget.isFullScreen
                                                                      ? 8
                                                                      : 10)
                                                                : (widget.isFullScreen
                                                                      ? 6
                                                                      : 8),
                                                          ),
                                                          trackHeight:
                                                              _isSliderDragging
                                                              ? (widget.isFullScreen
                                                                    ? 4
                                                                    : 6)
                                                              : (widget.isFullScreen
                                                                    ? 2
                                                                    : 4),
                                                          overlayShape:
                                                              const RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    24,
                                                              ),
                                                          activeTrackColor:
                                                              const Color(
                                                                0xFF5D5FEF,
                                                              ),
                                                          inactiveTrackColor:
                                                              Colors.white24,
                                                          thumbColor:
                                                              Colors.white,
                                                          trackShape:
                                                              const RectangularSliderTrackShape(), // 确保轨道充满可用宽度
                                                        ),
                                                        child: IgnorePointer(
                                                          // 禁用原生 Slider 的手势，完全由外层 GestureDetector 接管
                                                          child: AppSlider(
                                                            value:
                                                                (_isSliderDragging
                                                                        ? _sliderDragValue
                                                                        : videoValue
                                                                              .position
                                                                              .inMilliseconds
                                                                              .toDouble())
                                                                    .clamp(
                                                                      0,
                                                                      videoValue.duration.inMilliseconds.toDouble() >
                                                                              0
                                                                          ? videoValue.duration.inMilliseconds.toDouble()
                                                                          : 1.0,
                                                                    ),
                                                            min: 0,
                                                            max:
                                                                videoValue
                                                                        .duration
                                                                        .inMilliseconds
                                                                        .toDouble() >
                                                                    0
                                                                ? videoValue
                                                                      .duration
                                                                      .inMilliseconds
                                                                      .toDouble()
                                                                : 1.0,
                                                            onChanged:
                                                                (
                                                                  value,
                                                                ) {}, // 忽略，由外层接管
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (showTime && !widget.isLive) ...[
                                            SizedBox(width: horizontalGap),
                                            Text(
                                              _formatDuration(
                                                videoValue.duration,
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                          SizedBox(width: horizontalGap),
                                          if (showHoverVolume)
                                            _buildHoverVolumeControl(
                                              videoValue,
                                              iconSize: widget.isFullScreen
                                                  ? 24
                                                  : 20,
                                            ),
                                          if (showSecondaryButtons &&
                                              widget.subtitles != null &&
                                              widget.subtitles!.isNotEmpty)
                                            AppIconButton(
                                              icon:
                                                  Icons.closed_caption_rounded,
                                              tooltip: context.l10n.subtitles,
                                              onPressed: _showSubtitleMenu,
                                              padding: widget.isFullScreen
                                                  ? const EdgeInsets.all(8)
                                                  : EdgeInsets.zero,
                                              constraints: widget.isFullScreen
                                                  ? null
                                                  : const BoxConstraints(),
                                              iconSize: widget.isFullScreen
                                                  ? 24
                                                  : iconSize,
                                            ),
                                          if (showSecondaryButtons) ...[
                                            SizedBox(
                                              width: widget.isFullScreen
                                                  ? 0
                                                  : 4,
                                            ),
                                            _PlaybackSpeedMenuButton(
                                              currentSpeed:
                                                  videoValue.playbackSpeed,
                                              options: _playbackSpeedOptions(),
                                              dimension: widget.isFullScreen
                                                  ? 40
                                                  : max(32.0, iconSize + 12),
                                              iconSize: widget.isFullScreen
                                                  ? 24
                                                  : iconSize,
                                              onSelected:
                                                  _setPlaybackSpeedFromUser,
                                            ),
                                          ],
                                          if (showSecondaryButtons) ...[
                                            SizedBox(
                                              width: widget.isFullScreen
                                                  ? 0
                                                  : 4,
                                            ),
                                            AppIconButton(
                                              icon: Icons.comment_rounded,
                                              tooltip: _showDanmaku
                                                  ? context.l10n.disableDanmaku
                                                  : context.l10n.enableDanmaku,
                                              selected: _showDanmaku,
                                              style: _showDanmaku
                                                  ? AppIconButtonStyle.tonal
                                                  : AppIconButtonStyle.ghost,
                                              onPressed: () {
                                                setState(() {
                                                  _showDanmaku = !_showDanmaku;
                                                });
                                              },
                                              padding: widget.isFullScreen
                                                  ? const EdgeInsets.all(8)
                                                  : EdgeInsets.zero,
                                              constraints: widget.isFullScreen
                                                  ? null
                                                  : const BoxConstraints(),
                                              iconSize: widget.isFullScreen
                                                  ? 24
                                                  : iconSize,
                                            ),
                                          ],
                                          if (widget.onSync != null) ...[
                                            SizedBox(
                                              width: widget.isFullScreen
                                                  ? 0
                                                  : 4,
                                            ),
                                            AppIconButton(
                                              icon: widget.isLive
                                                  ? Icons.refresh_rounded
                                                  : Icons.sync_rounded,
                                              tooltip: widget.isLive
                                                  ? context.l10n.reload
                                                  : context.l10n.sync,
                                              onPressed: widget.onSync,
                                              padding: widget.isFullScreen
                                                  ? const EdgeInsets.all(8)
                                                  : EdgeInsets.zero,
                                              constraints: widget.isFullScreen
                                                  ? null
                                                  : const BoxConstraints(),
                                              iconSize: widget.isFullScreen
                                                  ? 24
                                                  : iconSize,
                                            ),
                                          ],
                                          if (showSecondaryButtons &&
                                              widget.extraBottomWidget !=
                                                  null) ...[
                                            SizedBox(
                                              width: widget.isFullScreen
                                                  ? 0
                                                  : 4,
                                            ),
                                            widget.extraBottomWidget!,
                                          ],
                                          if (widget.isFullScreen &&
                                              widget.onSendDanmaku != null)
                                            AppIconButton(
                                              icon: Icons.send_rounded,
                                              onPressed: _showDanmakuInput,
                                              tooltip: context.l10n.sendDanmaku,
                                            ),
                                          if (widget.onToggleFullScreen !=
                                              null) ...[
                                            SizedBox(
                                              width: widget.isFullScreen
                                                  ? 0
                                                  : 4,
                                            ),
                                            AppIconButton(
                                              icon: widget.isFullScreen
                                                  ? (widget.exitFullScreenIcon ??
                                                        Icons.fullscreen_exit)
                                                  : (widget.fullScreenIcon ??
                                                        Icons.fullscreen),
                                              tooltip: widget.isFullScreen
                                                  ? context.l10n.exitFullscreen
                                                  : context.l10n.fullscreen,
                                              onPressed:
                                                  widget.onToggleFullScreen,
                                              padding: widget.isFullScreen
                                                  ? const EdgeInsets.all(8)
                                                  : EdgeInsets.zero,
                                              constraints: widget.isFullScreen
                                                  ? null
                                                  : const BoxConstraints(),
                                              iconSize: widget.isFullScreen
                                                  ? 24
                                                  : iconSize,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaybackSpeedOption {
  final double speed;
  final String label;

  const _PlaybackSpeedOption({required this.speed, required this.label});
}

class _PlaybackSpeedMenuButton extends StatelessWidget {
  final double currentSpeed;
  final List<_PlaybackSpeedOption> options;
  final double dimension;
  final double iconSize;
  final ValueChanged<double> onSelected;

  const _PlaybackSpeedMenuButton({
    required this.currentSpeed,
    required this.options,
    required this.dimension,
    required this.iconSize,
    required this.onSelected,
  });

  Future<void> _openMenu(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (overlay == null || !overlay.hasSize) return;
    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight = renderBox.localToGlobal(
      renderBox.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );
    final selected = await showMenu<double>(
      context: context,
      color: Colors.black87,
      position: RelativeRect.fromLTRB(
        topLeft.dx,
        topLeft.dy,
        overlay.size.width - bottomRight.dx,
        overlay.size.height - bottomRight.dy,
      ),
      items: [
        for (final option in options)
          PopupMenuItem<double>(
            value: option.speed,
            height: 36,
            child: Row(
              children: [
                Icon(
                  (currentSpeed - option.speed).abs() < 0.001
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: (currentSpeed - option.speed).abs() < 0.001
                      ? const Color(0xFF7CFFB2)
                      : Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(option.label, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
      ],
    );
    if (selected != null) onSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.playbackSpeed,
      child: Tooltip(
        message: context.l10n.playbackSpeedValue(
          currentSpeed.toStringAsFixed(2),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openMenu(context),
          child: AppInkSurface(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(dimension / 2),
            child: SizedBox.square(
              dimension: dimension,
              child: Center(
                child: Icon(
                  Icons.speed_rounded,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubtitleItem {
  final Duration start;
  final Duration end;
  final String text;

  _SubtitleItem(this.start, this.end, this.text);
}
