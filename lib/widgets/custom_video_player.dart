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

import 'package:synctv_app/widgets/danmaku_overlay.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/models/danmaku_model.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/services/dlna.dart';
import 'package:synctv_app/services/xml_parser.dart';
import 'package:synctv_app/utils/message_utils.dart';

class DanmakuController extends ChangeNotifier {
  List<DanmakuItem> _items = [];
  List<DanmakuItem> get items => _items;

  http.Client? _sseClient;
  Timer? _reconnectTimer;
  VideoPlayerController? videoController;

  String? _danmakuUrl;
  Map<String, String> _danmakuHeaders = const {};
  String? _streamDanmakuUrl;
  Map<String, String> _streamDanmakuHeaders = const {};

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _sseClient?.close();
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
      _connectDanmakuStream();
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

  void _connectDanmakuStream() async {
    _reconnectTimer?.cancel();
    _sseClient?.close();

    if (_streamDanmakuUrl == null || _streamDanmakuUrl!.isEmpty) return;

    _sseClient = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(_streamDanmakuUrl!));
      request.headers.addAll(_streamDanmakuHeaders);
      request.headers['Accept'] = 'text/event-stream';

      final response = await _sseClient!.send(request);

      if (response.statusCode == 200) {
        response.stream
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
                debugPrint('SSE Error: $e');
                _scheduleReconnect();
              },
              onDone: () {
                debugPrint('SSE Done');
                _scheduleReconnect();
              },
            );
      } else {
        debugPrint('SSE Failed: ${response.statusCode}');
        _scheduleReconnect();
      }
    } catch (e) {
      debugPrint('SSE Connection failed: $e');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      _connectDanmakuStream();
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
  final ValueChanged<bool>? onUserPlaybackStateChanged;
  final ValueChanged<Duration>? onUserSeek;
  final ValueChanged<double>? onUserPlaybackSpeedChanged;
  final bool isFullScreen;
  final bool isLive;
  final Function(String)? onSendDanmaku;
  final IconData? fullScreenIcon;
  final IconData? exitFullScreenIcon;
  final bool showCastButton;
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
    this.onUserPlaybackStateChanged,
    this.onUserSeek,
    this.onUserPlaybackSpeedChanged,
    this.isFullScreen = false,
    this.isLive = false,
    this.onSendDanmaku,
    this.fullScreenIcon,
    this.exitFullScreenIcon,
    this.showCastButton = true,
    this.extraBottomWidget,
    this.diagnosticsBuilder,
    this.interactionMode = VideoPlayerInteractionMode.mobile,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

enum VideoPlayerInteractionMode { mobile, desktop }

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

  // DLNA
  final DLNAManager _dlnaManager = DLNAManager();
  Map<String, DLNADevice> _dlnaDevices = {};
  DLNADevice? _currentDlnaDevice;
  bool _isCasting = false;
  bool _isSearchingDlna = false;
  bool _dlnaIsPlaying = false;
  bool _dlnaMuted = false;
  int _dlnaVolume = 50;
  Duration _dlnaPosition = Duration.zero;
  Duration _dlnaDuration = Duration.zero;
  StreamSubscription? _dlnaDevicesSubscription;
  StreamSubscription? _dlnaPositionSubscription;

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
    _subtitleTimer?.cancel();
    _stopDlna();
    super.dispose();
  }

  void _stopDlna() {
    _dlnaManager.stop();
    _dlnaDevicesSubscription?.cancel();
    _dlnaPositionSubscription?.cancel();
    _currentDlnaDevice?.positionPoller.stop();
    _currentDlnaDevice = null;
    _isCasting = false;
  }

  void _videoListener() {
    if (mounted) {
      _rememberAudibleVolume();
      setState(() {});
      if (_subtitleItems.isNotEmpty) {
        final position = _isCasting
            ? _dlnaPosition
            : widget.controller.value.position;
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

          if (text.isNotEmpty) {
            _subtitleItems.add(_SubtitleItem(start, end, text.trim()));
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
    if (_isCasting) {
      if (_dlnaIsPlaying) {
        await _currentDlnaDevice?.pause();
      } else {
        await _currentDlnaDevice?.play();
      }
      if (mounted) {
        setState(() {
          _dlnaIsPlaying = !_dlnaIsPlaying;
          _showControls = true;
        });
      }
      return;
    }

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
    if (_isCasting) return;
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
    if (_isCasting) return;
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
    if (_isCasting) return;
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
    if (_isCasting) return;
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
    if (_isCasting) return;
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
    if (_isCasting) return;
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
    if (_isCasting) return;
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
            _dragLabel = '亮度';
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
        _dragLabel = '音量';
      });
    }
    _showControls = true;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    if (_isDesktopMode) return;
    if (_isCasting || !_isVerticalDragging) return;
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
            _dragLabel = '亮度 ${(newVal * 100).toInt()}%';
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
        _dragLabel = '音量 ${(newVal * 100).toInt()}%';
      });
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _isVerticalDragging = false;
    if (_isCasting) return;
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
    if (_isCasting) return;
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

  Widget _buildInlineVolumeControl(
    VideoPlayerValue videoValue, {
    required double sliderWidth,
    required double iconSize,
    required bool compact,
  }) {
    final buttonWidth = max(28.0, iconSize + (compact ? 4 : 8));
    final gap = compact ? 4.0 : 8.0;
    return SizedBox(
      width: buttonWidth + gap + sliderWidth,
      height: 40,
      child: Row(
        children: [
          AppIconButton(
            tooltip: videoValue.volume <= 0.01 ? '取消静音' : '静音',
            icon: _volumeIcon(videoValue.volume),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(
              width: buttonWidth,
              height: 40,
            ),
            iconSize: iconSize,
            onPressed: _toggleMute,
          ),
          SizedBox(width: gap),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: compact ? 2.5 : 3,
                activeTrackColor: const Color(0xFF5D5FEF),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: compact ? 5 : 6,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: compact ? 12 : 14,
                ),
              ),
              child: Slider(
                value: videoValue.volume.clamp(0.0, 1.0).toDouble(),
                min: 0,
                max: 1,
                onChanged: _setPlayerVolume,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVolumePanel() {
    _startHideTimer();
    showAppBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF15151F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setPanelState) {
          final volume = widget.controller.value.volume.clamp(0.0, 1.0);
          return AppSafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                children: [
                  AppIconButton(
                    tooltip: volume <= 0.01 ? '取消静音' : '静音',
                    icon: _volumeIcon(volume.toDouble()),
                    onPressed: () async {
                      await _toggleMute();
                      setPanelState(() {});
                    },
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF5D5FEF),
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 18,
                        ),
                      ),
                      child: AppSlider(
                        value: volume.toDouble(),
                        min: 0,
                        max: 1,
                        onChanged: (value) async {
                          await _setPlayerVolume(value);
                          setPanelState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    child: Text(
                      '${(volume * 100).round()}%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDlnaMenu() {
    _dlnaDevices.clear();
    _isSearchingDlna = true;

    StateSetter? sheetSetState;

    _dlnaManager.start().then((manager) {
      _dlnaDevicesSubscription?.cancel();
      _dlnaDevicesSubscription = manager.devices.stream.listen((devices) {
        if (mounted) {
          setState(() {
            _dlnaDevices = devices;
          });
          sheetSetState?.call(() {});
        }
      });
    });

    showAppBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          sheetSetState = setSheetState;
          return AppSafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '投屏设备',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_isSearchingDlna)
                        const AppLoadingIndicator(
                          size: AppLoadingSize.sm,
                          centered: false,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
                const AppDivider(color: Colors.white24, height: 1),
                if (_isCasting && _currentDlnaDevice != null)
                  AppTile(
                    prefix: const Icon(
                      Icons.cast_connected,
                      color: Color(0xFF5D5FEF),
                    ),
                    title: Text(
                      '正在投屏: ${_currentDlnaDevice!.info.friendlyName}',
                      style: const TextStyle(color: Color(0xFF5D5FEF)),
                    ),
                    suffix: AppActionButton(
                      onPressed: () {
                        _stopDlnaCasting();
                        Navigator.pop(context);
                      },
                      label: '退出投屏',
                      style: AppActionButtonStyle.destructive,
                    ),
                  ),
                if (_dlnaDevices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      '正在搜索设备...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                Flexible(
                  child: AppSingleChildScrollView(
                    child: Column(
                      children: _dlnaDevices.values.map((device) {
                        final isSelected = _currentDlnaDevice == device;
                        return AppTile(
                          prefix: Icon(
                            Icons.tv,
                            color: isSelected
                                ? const Color(0xFF5D5FEF)
                                : Colors.white,
                          ),
                          title: Text(
                            device.info.friendlyName,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF5D5FEF)
                                  : Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            _connectToDlnaDevice(device);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).whenComplete(() {
      _isSearchingDlna = false;
      _dlnaManager.stop();
    });
  }

  Future<void> _connectToDlnaDevice(DLNADevice device) async {
    widget.controller.pause();

    setState(() {
      _currentDlnaDevice = device;
      _isCasting = true;
      _dlnaIsPlaying = true;
      _dlnaMuted = false;
      _dlnaVolume = 50;
    });

    try {
      final url = widget.controller.dataSource;
      debugPrint('Casting to ${device.info.friendlyName}: $url');

      PlayType type = VideoMime.any;
      if (url.endsWith('.mp4')) type = VideoMime.mp4;
      if (url.endsWith('.mkv')) type = VideoMime.xMatroska;

      await device.setUrl(url, title: widget.title, type: type);
      await device.play();

      device.positionPoller.start();
      _dlnaPositionSubscription?.cancel();
      _dlnaPositionSubscription = device.currPosition.stream.listen((position) {
        if (mounted) {
          setState(() {
            _dlnaPosition = Duration(seconds: position.relTimeSeconds);
            _dlnaDuration = Duration(seconds: position.trackDurationSeconds);
          });
        }
      });

      final currentPos = widget.controller.value.position;
      if (currentPos > Duration.zero) {
        await device.seek(_formatDurationDlna(currentPos));
      }
      _syncDlnaRenderingState(device);
    } catch (e) {
      debugPrint('DLNA Error: $e');
      if (mounted) {
        MessageUtils.showError(context, '投屏失败: $e');
        setState(() {
          _isCasting = false;
          _currentDlnaDevice = null;
        });
      }
    }
  }

  Future<void> _stopDlnaCasting({bool resumeLocal = true}) async {
    final device = _currentDlnaDevice;
    final position = _dlnaPosition;
    if (device != null) {
      try {
        await device.stop();
      } catch (e) {
        debugPrint('DLNA stop failed: $e');
      }
      device.positionPoller.stop();
    }
    await _dlnaPositionSubscription?.cancel();
    if (!mounted) return;
    setState(() {
      _isCasting = false;
      _currentDlnaDevice = null;
      _dlnaIsPlaying = false;
      _dlnaMuted = false;
    });
    if (resumeLocal) {
      await widget.controller.seekTo(position);
      await widget.controller.play();
    }
  }

  Future<void> _syncDlnaRenderingState([DLNADevice? target]) async {
    final device = target ?? _currentDlnaDevice;
    if (device == null) return;
    try {
      final results = await Future.wait([
        device.getVolume(),
        device.getMute(),
        device.getTransportInfo(),
      ]);
      final volume = VolumeParser(results[0]).current.clamp(0, 100);
      final muted = MuteParser(results[1]).muted;
      final transport = TransportInfoParser(results[2]);
      final playing =
          transport.currentTransportState.toUpperCase() == 'PLAYING';
      if (!mounted || _currentDlnaDevice != device) return;
      setState(() {
        _dlnaVolume = volume;
        _dlnaMuted = muted;
        _dlnaIsPlaying = playing || _dlnaIsPlaying;
      });
    } catch (e) {
      debugPrint('DLNA state sync failed: $e');
    }
  }

  Future<void> _setDlnaVolume(int volume) async {
    final device = _currentDlnaDevice;
    if (device == null) return;
    final nextVolume = volume.clamp(0, 100);
    setState(() {
      _dlnaVolume = nextVolume;
      if (nextVolume > 0) _dlnaMuted = false;
    });
    try {
      await device.volume(nextVolume);
      if (nextVolume > 0) await device.mute(false);
    } catch (e) {
      debugPrint('DLNA volume failed: $e');
      if (mounted) MessageUtils.showError(context, '调节投屏音量失败: $e');
    }
  }

  Future<void> _toggleDlnaMute() async {
    final device = _currentDlnaDevice;
    if (device == null) return;
    final nextMuted = !_dlnaMuted;
    setState(() => _dlnaMuted = nextMuted);
    try {
      await device.mute(nextMuted);
    } catch (e) {
      if (!mounted) return;
      setState(() => _dlnaMuted = !nextMuted);
      MessageUtils.showError(context, '切换投屏静音失败: $e');
    }
  }

  Future<void> _seekDlnaBy(Duration delta) async {
    final device = _currentDlnaDevice;
    if (device == null) return;
    final upperBound = _dlnaDuration > Duration.zero
        ? _dlnaDuration
        : const Duration(hours: 24);
    final target = _dlnaPosition + delta;
    final bounded = target < Duration.zero
        ? Duration.zero
        : target > upperBound
        ? upperBound
        : target;
    setState(() => _dlnaPosition = bounded);
    try {
      await device.seek(_formatDurationDlna(bounded));
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '投屏跳转失败: $e');
    }
  }

  Future<void> _runDlnaCommand(
    Future<String> Function(DLNADevice device) command, {
    required String successMessage,
    required String errorPrefix,
  }) async {
    final device = _currentDlnaDevice;
    if (device == null) return;
    try {
      await command(device);
      if (mounted) {
        MessageUtils.showInfo(
          context,
          successMessage,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '$errorPrefix: $e');
    }
  }

  Future<void> _showDlnaInfoDialog() async {
    final device = _currentDlnaDevice;
    if (device == null) return;
    try {
      final results = await Future.wait([
        device.getTransportInfo(),
        device.getCurrentTransportActions(),
        device.getMediaInfo(),
        device.getDeviceCapabilities(),
      ]);
      if (!mounted) return;
      await showAppDialog<void>(
        context: context,
        builder: (dialogContext) => AppDialog(
          title: const Text('投屏设备信息'),
          icon: const Icon(Icons.info_outline_rounded),
          body: SizedBox(
            width: 560,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DlnaInfoLine(label: '设备', value: device.info.friendlyName),
                  _DlnaInfoLine(
                    label: '传输状态',
                    value: TransportInfoParser(
                      results[0],
                    ).currentTransportState.trim(),
                  ),
                  _DlnaInfoLine(
                    label: '可用动作',
                    value: _extractDlnaTag(results[1], 'Actions'),
                  ),
                  _DlnaInfoLine(
                    label: '媒体时长',
                    value: _extractDlnaTag(results[2], 'MediaDuration'),
                  ),
                  _DlnaInfoLine(
                    label: '能力',
                    value: [
                      _extractDlnaTag(results[3], 'PlayMedia'),
                      _extractDlnaTag(results[3], 'RecMedia'),
                      _extractDlnaTag(results[3], 'RecQualityModes'),
                    ].where((value) => value.isNotEmpty).join(' / '),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            AppActionButton(
              onPressed: () => Navigator.pop(dialogContext),
              label: '关闭',
              style: AppActionButtonStyle.tonal,
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '读取投屏设备信息失败: $e');
    }
  }

  String _extractDlnaTag(String xml, String tagName) {
    final start = xml.indexOf('<$tagName>');
    final end = xml.indexOf('</$tagName>');
    if (start < 0 || end <= start) return '';
    return xml.substring(start + tagName.length + 2, end).trim();
  }

  String _formatDurationDlna(Duration d) {
    // HH:MM:SS
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '选择字幕',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppTile(
              prefix: const Icon(Icons.close, color: Colors.white),
              title: const Text('关闭字幕', style: TextStyle(color: Colors.white)),
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
                    final label = e.key;
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
                    label: '弹幕',
                    showLabel: false,
                    hintText: '发个弹幕见证当下...',
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
                  tooltip: '发送',
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

  void _showDlnaControlPanel() {
    showAppBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setPanelState) {
          // Listen to DLNA updates to refresh this panel
          final subscription = _currentDlnaDevice?.currPosition.stream.listen((
            _,
          ) {
            if (mounted) setPanelState(() {});
          });

          return PopScope(
            onPopInvokedWithResult: (_, __) {
              subscription?.cancel();
            },
            child: AppSafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentDlnaDevice?.info.friendlyName ?? '未知设备',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Progress
                    Row(
                      children: [
                        Text(
                          _formatDuration(_dlnaPosition),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Expanded(
                          child: AppSlider(
                            value: _dlnaPosition.inSeconds.toDouble().clamp(
                              0,
                              _dlnaDuration.inSeconds.toDouble(),
                            ),
                            min: 0,
                            max: _dlnaDuration.inSeconds.toDouble() > 0
                                ? _dlnaDuration.inSeconds.toDouble()
                                : 1.0,
                            activeColor: const Color(0xFF5D5FEF),
                            inactiveColor: Colors.white24,
                            thumbColor: Colors.white,
                            onChanged: (val) {
                              final target = Duration(seconds: val.toInt());
                              _currentDlnaDevice?.seek(
                                _formatDurationDlna(target),
                              );
                              setState(() {
                                _dlnaPosition = target;
                              });
                              setPanelState(() {});
                            },
                          ),
                        ),
                        Text(
                          _formatDuration(_dlnaDuration),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        AppIconButton(
                          icon: _dlnaMuted ? Icons.volume_off : Icons.volume_up,
                          tooltip: _dlnaMuted ? '取消静音' : '静音',
                          onPressed: () async {
                            await _toggleDlnaMute();
                            setPanelState(() {});
                          },
                        ),
                        Expanded(
                          child: AppSlider(
                            value: _dlnaVolume.toDouble(),
                            min: 0,
                            max: 100,
                            activeColor: const Color(0xFF5D5FEF),
                            inactiveColor: Colors.white24,
                            thumbColor: Colors.white,
                            onChanged: (value) {
                              _setDlnaVolume(value.round());
                              setPanelState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          width: 42,
                          child: Text(
                            _dlnaMuted ? '静音' : '$_dlnaVolume',
                            textAlign: TextAlign.end,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIconButton(
                          icon: Icons.skip_previous_rounded,
                          tooltip: '上一首',
                          onPressed: () async {
                            await _runDlnaCommand(
                              (device) => device.previous(),
                              successMessage: '已切换上一首',
                              errorPrefix: '上一首失败',
                            );
                            setPanelState(() {});
                          },
                        ),
                        const SizedBox(width: 16),
                        AppIconButton(
                          icon: Icons.replay_10_rounded,
                          tooltip: '后退 10 秒',
                          onPressed: () async {
                            await _seekDlnaBy(const Duration(seconds: -10));
                            setPanelState(() {});
                          },
                        ),
                        const SizedBox(width: 16),
                        AppIconButton(
                          iconSize: 64,
                          icon: _dlnaIsPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          tooltip: _dlnaIsPlaying ? '暂停' : '播放',
                          onPressed: () {
                            if (_dlnaIsPlaying) {
                              _currentDlnaDevice?.pause();
                            } else {
                              _currentDlnaDevice?.play();
                            }
                            setState(() {
                              _dlnaIsPlaying = !_dlnaIsPlaying;
                            });
                            setPanelState(() {});
                          },
                        ),
                        const SizedBox(width: 16),
                        AppIconButton(
                          icon: Icons.forward_10_rounded,
                          tooltip: '前进 10 秒',
                          onPressed: () async {
                            await _seekDlnaBy(const Duration(seconds: 10));
                            setPanelState(() {});
                          },
                        ),
                        const SizedBox(width: 16),
                        AppIconButton(
                          icon: Icons.skip_next_rounded,
                          tooltip: '下一首',
                          onPressed: () async {
                            await _runDlnaCommand(
                              (device) => device.next(),
                              successMessage: '已切换下一首',
                              errorPrefix: '下一首失败',
                            );
                            setPanelState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        AppActionButton(
                          onPressed: () async {
                            await _runDlnaCommand(
                              (device) => device.setPlayMode('NORMAL'),
                              successMessage: '已设置顺序播放',
                              errorPrefix: '设置播放模式失败',
                            );
                          },
                          icon: Icons.format_list_numbered_rounded,
                          label: '顺序',
                          style: AppActionButtonStyle.outlined,
                        ),
                        AppActionButton(
                          onPressed: () async {
                            await _runDlnaCommand(
                              (device) => device.setPlayMode('REPEAT_ALL'),
                              successMessage: '已设置循环播放',
                              errorPrefix: '设置播放模式失败',
                            );
                          },
                          icon: Icons.repeat_rounded,
                          label: '循环',
                          style: AppActionButtonStyle.outlined,
                        ),
                        AppActionButton(
                          onPressed: _showDlnaInfoDialog,
                          icon: Icons.info_outline_rounded,
                          label: '信息',
                          style: AppActionButtonStyle.outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppActionButton(
                          onPressed: () async {
                            await _syncDlnaRenderingState();
                            setPanelState(() {});
                          },
                          icon: Icons.sync_rounded,
                          label: '同步状态',
                          style: AppActionButtonStyle.tonal,
                        ),
                        const SizedBox(width: 12),
                        AppActionButton(
                          onPressed: () async {
                            await _stopDlnaCasting();
                            if (context.mounted) Navigator.pop(context);
                          },
                          icon: Icons.cast_connected_rounded,
                          label: '退出投屏',
                          style: AppActionButtonStyle.destructive,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
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
            onTap: _isDesktopMode ? _togglePlayPause : _toggleControls,
            onDoubleTap: _isDesktopMode ? null : _togglePlayPause,
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
                if (_isCasting)
                  AppPanelSurface(
                    color: Colors.black,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.zero,
                    clipBehavior: Clip.none,
                    child: Stack(
                      children: [
                        // Top Right Switch Button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AppSafeArea(
                            child: AppOverlayActionButton(
                              icon: Icons.swap_horiz,
                              label: '切换设备',
                              onPressed: _showDlnaMenu,
                              foregroundColor: Colors.white70,
                              backgroundColor: Colors.black26,
                              textStyle: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        Center(
                          child: AppSingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.cast_connected,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  '正在投屏中',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Text(
                                    _currentDlnaDevice?.info.friendlyName ??
                                        '未知设备',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Control Button
                                AppOverlayActionButton(
                                  onPressed: _showDlnaControlPanel,
                                  icon: Icons.tune,
                                  label: '遥控器',
                                  backgroundColor: Colors.white10,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  textStyle: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Center(
                    child: AspectRatio(
                      aspectRatio: videoValue.aspectRatio > 0
                          ? videoValue.aspectRatio
                          : 16 / 9,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),
                Positioned.fill(
                  child: DanmakuOverlay(
                    videoController: widget.controller,
                    danmakuList: widget.danmakuController?.items ?? [],
                    isEnabled: _showDanmaku,
                  ),
                ),
                if (_currentSubtitle.isNotEmpty)
                  Positioned(
                    bottom: widget.isFullScreen ? 40 : 10,
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
                if (!_isCasting)
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
                              color: Colors.transparent,
                              borderRadius: BorderRadius.zero,
                              clipBehavior: Clip.none,
                              gradient: widget.isFullScreen
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black87,
                                        Colors.transparent,
                                      ],
                                    )
                                  : null,
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
                                  if (widget.showCastButton)
                                    AppIconButton(
                                      icon: _isCasting
                                          ? Icons.cast_connected
                                          : Icons.cast,
                                      tooltip: _isCasting ? '正在投屏' : '投屏',
                                      selected: _isCasting,
                                      style: _isCasting
                                          ? AppIconButtonStyle.tonal
                                          : AppIconButtonStyle.ghost,
                                      onPressed: _showDlnaMenu,
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom Bar
                          Positioned(
                            bottom: widget.isFullScreen
                                ? 24
                                : 0, // 全屏模式下抬高 24 像素
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
                                color: Colors.transparent,
                                borderRadius: BorderRadius.zero,
                                clipBehavior: Clip.none,
                                gradient: widget.isFullScreen
                                    ? const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black87,
                                          Colors.transparent,
                                        ],
                                      )
                                    : null,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final controlsWidth = constraints.maxWidth;
                                    final showTime = controlsWidth >= 300;
                                    final showSecondaryButtons =
                                        controlsWidth >= 360;
                                    final showInlineVolume =
                                        controlsWidth >= 520 &&
                                        (widget.isFullScreen ||
                                            Platform.isMacOS ||
                                            Platform.isWindows ||
                                            Platform.isLinux ||
                                            controlsWidth >= 720);
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
                                                  ? '暂停'
                                                  : '播放',
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
                                            SizedBox(width: horizontalGap),
                                            if (showTime) ...[
                                              Text(
                                                widget.isLive
                                                    ? '直播'
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
                                            Expanded(
                                              child: Semantics(
                                                slider: true,
                                                enabled: !widget.isLive,
                                                label: widget.isLive
                                                    ? '直播'
                                                    : '播放进度',
                                                value: widget.isLive
                                                    ? '直播'
                                                    : '${_formatDuration(videoValue.position)} / ${_formatDuration(videoValue.duration)}',
                                                child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onHorizontalDragStart: (details) {
                                                    if (widget.isLive) return;
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
                                                    if (widget.isLive) return;
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
                                                        if (widget.isLive) {
                                                          return;
                                                        }
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
                                                    if (widget.isLive) return;
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
                                                    if (widget.isLive) return;
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
                                                    if (widget.isLive) return;
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
                                                              widget.isLive
                                                              ? Colors.redAccent
                                                              : const Color(
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
                                                            value: widget.isLive
                                                                ? 1.0
                                                                : (_isSliderDragging
                                                                          ? _sliderDragValue
                                                                          : videoValue.position.inMilliseconds.toDouble())
                                                                      .clamp(
                                                                        0,
                                                                        videoValue.duration.inMilliseconds.toDouble() >
                                                                                0
                                                                            ? videoValue.duration.inMilliseconds.toDouble()
                                                                            : 1.0,
                                                                      ),
                                                            min: 0,
                                                            max: widget.isLive
                                                                ? 1.0
                                                                : videoValue
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
                                            if (showInlineVolume)
                                              _buildInlineVolumeControl(
                                                videoValue,
                                                sliderWidth: widget.isFullScreen
                                                    ? 96
                                                    : 76,
                                                iconSize: widget.isFullScreen
                                                    ? 24
                                                    : 20,
                                                compact: !widget.isFullScreen,
                                              )
                                            else
                                              AppIconButton(
                                                tooltip:
                                                    videoValue.volume <= 0.01
                                                    ? '取消静音'
                                                    : '音量',
                                                icon: _volumeIcon(
                                                  videoValue.volume,
                                                ),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                iconSize: iconSize,
                                                onPressed: _showVolumePanel,
                                              ),
                                            if (showSecondaryButtons &&
                                                widget.subtitles != null &&
                                                widget.subtitles!.isNotEmpty)
                                              AppIconButton(
                                                icon: Icons
                                                    .closed_caption_rounded,
                                                tooltip: '字幕',
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
                                                options:
                                                    _playbackSpeedOptions(),
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
                                                    ? '关闭弹幕'
                                                    : '开启弹幕',
                                                selected: _showDanmaku,
                                                style: _showDanmaku
                                                    ? AppIconButtonStyle.tonal
                                                    : AppIconButtonStyle.ghost,
                                                onPressed: () {
                                                  setState(() {
                                                    _showDanmaku =
                                                        !_showDanmaku;
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
                                                    ? '重新加载'
                                                    : '同步',
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
                                                tooltip: '发送弹幕',
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
                                                    ? '退出全屏'
                                                    : '全屏',
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

class _DlnaInfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _DlnaInfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = value.trim().isEmpty ? '未知' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: AppSelectableText(
              displayValue,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
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
      label: '倍速',
      child: Tooltip(
        message: '倍速 ${currentSpeed.toStringAsFixed(2)}x',
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
