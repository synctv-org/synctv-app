import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:video_player/video_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:synctv_app/features/room/application/danmaku_source.dart';
import 'package:synctv_app/features/room/application/subtitle_source.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/presentation/widgets/danmaku_overlay.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:synctv_app/features/room/presentation/danmaku/acfun_danmaku_codec.dart';
import 'package:synctv_app/features/room/domain/playback_resource_localizer.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_context_menu.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_diagnostics.dart';

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
      _parseDanmaku(content);
      _documentLoaded = true;
    } catch (e) {
      debugPrint('Failed to load danmaku: $e');
    } finally {
      if (generation == _documentGeneration) {
        _documentLoading = false;
      }
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
  final String playbackResourceIdentity;
  final PlaybackResourceLocalizer? resolveSubtitleResource;
  final VoidCallback? onSubtitleP2pDeactivated;
  final VoidCallback? onToggleFullScreen;
  final VoidCallback? onSync;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onEnterPictureInPicture;
  final VoidCallback? onOpenFreeModeSettings;
  final ValueChanged<bool>? onUserPlaybackStateChanged;
  final ValueChanged<Duration>? onUserSeek;
  final ValueChanged<double>? onUserPlaybackSpeedChanged;
  final ValueGetter<bool>? isPlaybackExpectedToBePlaying;
  final bool canControlPlayback;
  final bool isFullScreen;
  final bool isLive;
  final int? liveStartedAt;
  final Function(String)? onSendDanmaku;
  final IconData? fullScreenIcon;
  final IconData? exitFullScreenIcon;
  final Widget? extraBottomWidget;
  final Widget? Function(BuildContext context)? diagnosticsBuilder;
  final PlaybackDiagnosticsContext diagnostics;
  final ValueGetter<PlaybackDiagnosticsContext>? diagnosticsProvider;
  final bool loopPlayback;
  final bool shufflePlayback;
  final bool canChangePlayMode;
  final Future<bool> Function(bool enabled)? onLoopPlaybackChanged;
  final Future<bool> Function(bool enabled)? onShufflePlaybackChanged;
  final VoidCallback? onReloadPlayback;
  final VideoPlayerInteractionMode interactionMode;
  final ResourceUrlResolver resourceUrlResolver;
  final PlayerVolumePreferencesController volumePreferences;
  final SubtitleSource subtitleSource;

  const CustomVideoPlayer({
    super.key,
    required this.controller,
    required this.title,
    required this.volumePreferences,
    required this.subtitleSource,
    this.danmakuController,
    this.subtitles,
    this.playbackResourceIdentity = '',
    this.resolveSubtitleResource,
    this.onSubtitleP2pDeactivated,
    this.onToggleFullScreen,
    this.onSync,
    this.onPrevious,
    this.onNext,
    this.onEnterPictureInPicture,
    this.onOpenFreeModeSettings,
    this.onUserPlaybackStateChanged,
    this.onUserSeek,
    this.onUserPlaybackSpeedChanged,
    this.isPlaybackExpectedToBePlaying,
    this.canControlPlayback = true,
    this.isFullScreen = false,
    this.isLive = false,
    this.liveStartedAt,
    this.onSendDanmaku,
    this.fullScreenIcon,
    this.exitFullScreenIcon,
    this.extraBottomWidget,
    this.diagnosticsBuilder,
    this.diagnostics = const PlaybackDiagnosticsContext(),
    this.diagnosticsProvider,
    this.loopPlayback = false,
    this.shufflePlayback = false,
    this.canChangePlayMode = false,
    this.onLoopPlaybackChanged,
    this.onShufflePlaybackChanged,
    this.onReloadPlayback,
    this.interactionMode = VideoPlayerInteractionMode.mobile,
    this.resourceUrlResolver = const IdentityResourceUrlResolver(),
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
    this.center,
    this.iconSize = 20,
    this.gap = 8,
  });

  final String previousTooltip;
  final String nextTooltip;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Widget? center;
  final double iconSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PlayerIconButton(
          key: const Key('playback_previous_button'),
          icon: Icons.skip_previous_rounded,
          tooltip: previousTooltip,
          onPressed: onPrevious,
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          iconSize: iconSize,
        ),
        SizedBox(width: gap),
        if (center != null) ...[center!, SizedBox(width: gap)],
        _PlayerIconButton(
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

class PictureInPictureControl extends StatelessWidget {
  const PictureInPictureControl({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.iconSize = 20,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return _PlayerIconButton(
      key: const Key('picture_in_picture_button'),
      icon: Icons.picture_in_picture_alt_rounded,
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      iconSize: iconSize,
    );
  }
}

class _PlayerIconButton extends StatelessWidget {
  const _PlayerIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconSize = 20,
    this.constraints = const BoxConstraints.tightFor(width: 40, height: 40),
    this.padding = EdgeInsets.zero,
    this.selected = false,
    this.showTooltip = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double iconSize;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry padding;
  final bool selected;
  final bool showTooltip;

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
      onPressed: onPressed,
      padding: padding,
      constraints: const BoxConstraints(),
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white60,
        backgroundColor: selected ? Colors.white24 : Colors.transparent,
        hoverColor: Colors.white12,
        focusColor: Colors.white12,
        highlightColor: Colors.white24,
      ),
      iconSize: iconSize,
    );
    if (constraints != null) {
      button = ConstrainedBox(constraints: constraints!, child: button);
    }
    button = ExcludeSemantics(child: button);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: tooltip,
      onTap: onPressed,
      child: showTooltip ? AppTooltip(message: tooltip, child: button) : button,
    );
  }
}

@immutable
class PictureInPicturePlaybackChoice {
  const PictureInPicturePlaybackChoice({
    required this.value,
    required this.groupLabel,
    required this.label,
    required this.selected,
  });

  final String value;
  final String groupLabel;
  final String label;
  final bool selected;
}

class PictureInPicturePlaybackOptionsControl extends StatelessWidget {
  const PictureInPicturePlaybackOptionsControl({
    super.key,
    required this.tooltip,
    required this.choices,
    required this.onSelected,
  });

  final String tooltip;
  final List<PictureInPicturePlaybackChoice> choices;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (anchorContext) => Semantics(
        button: true,
        label: tooltip,
        onTap: () => unawaited(_openMenu(anchorContext)),
        child: AppTooltip(
          message: tooltip,
          child: ExcludeSemantics(
            child: GestureDetector(
              key: const Key('picture_in_picture_playback_options_toggle'),
              behavior: HitTestBehavior.opaque,
              onTap: () => unawaited(_openMenu(anchorContext)),
              child: const SizedBox.square(
                dimension: 30,
                child: Icon(Icons.route_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openMenu(BuildContext anchorContext) async {
    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    final overlay =
        Navigator.of(
              anchorContext,
              rootNavigator: true,
            ).overlay?.context.findRenderObject()
            as RenderBox?;
    if (renderBox == null || overlay == null || !renderBox.hasSize) return;
    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight = renderBox.localToGlobal(
      renderBox.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );
    final selected = await showMenu<String>(
      context: anchorContext,
      useRootNavigator: true,
      color: const Color(0xF21A1A24),
      position: RelativeRect.fromLTRB(
        topLeft.dx,
        topLeft.dy - 8,
        overlay.size.width - bottomRight.dx,
        overlay.size.height - bottomRight.dy + 8,
      ),
      items: _buildChoices(),
    );
    if (selected != null) onSelected(selected);
  }

  List<PopupMenuEntry<String>> _buildChoices() {
    final children = <PopupMenuEntry<String>>[];
    String? previousGroup;
    for (final choice in choices) {
      if (choice.groupLabel != previousGroup) {
        previousGroup = choice.groupLabel;
        children.add(
          PopupMenuItem<String>(
            enabled: false,
            height: 28,
            child: Text(
              choice.groupLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
      children.add(
        PopupMenuItem<String>(
          key: ValueKey('picture_in_picture_playback_option_${choice.value}'),
          value: choice.value,
          height: 36,
          child: Row(
            children: [
              Icon(
                choice.selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 16,
                color: choice.selected
                    ? const Color(0xFF7CFFB2)
                    : Colors.white70,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  choice.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return children;
  }
}

class PictureInPicturePlaybackSurface extends StatefulWidget {
  const PictureInPicturePlaybackSurface({
    super.key,
    required this.controller,
    required this.danmakuController,
    required this.emptyState,
    this.danmakuEnabled = true,
    this.exitTooltip,
    this.volumeTooltip,
    this.playbackOptionsControl,
    this.diagnostics,
    this.isLive = false,
    this.liveStartedAt,
    this.canControlPlayback = false,
    this.onPlaybackStateChanged,
    this.onSeek,
    this.isPlaybackExpectedToBePlaying,
    this.onSync,
    this.onPrevious,
    this.onNext,
    this.onDragStart,
    this.onExit,
  });

  final VideoPlayerController? controller;
  final DanmakuController danmakuController;
  final Widget emptyState;
  final bool danmakuEnabled;
  final String? exitTooltip;
  final String? volumeTooltip;
  final Widget? playbackOptionsControl;
  final Widget? diagnostics;
  final bool isLive;
  final int? liveStartedAt;
  final bool canControlPlayback;
  final ValueChanged<bool>? onPlaybackStateChanged;
  final ValueChanged<Duration>? onSeek;
  final ValueGetter<bool>? isPlaybackExpectedToBePlaying;
  final VoidCallback? onSync;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onDragStart;
  final VoidCallback? onExit;

  @override
  State<PictureInPicturePlaybackSurface> createState() =>
      _PictureInPicturePlaybackSurfaceState();
}

class _PictureInPicturePlaybackSurfaceState
    extends State<PictureInPicturePlaybackSurface> {
  bool _showControls = false;
  bool _showVolumeSlider = false;
  double _lastAudibleVolume = 1;
  double? _pendingSeekSeconds;

  Future<void> _setVolume(double volume) async {
    final controller = widget.controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (volume > 0.01) _lastAudibleVolume = volume;
    await controller.setVolume(volume);
  }

  void _toggleMute() {
    final volume = widget.controller?.value.volume ?? 0;
    unawaited(_setVolume(volume <= 0.01 ? _lastAudibleVolume : 0));
  }

  @override
  void didUpdateWidget(PictureInPicturePlaybackSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.controller, oldWidget.controller)) {
      _pendingSeekSeconds = null;
    }
  }

  Future<void> _togglePlayback() async {
    final controller = widget.controller;
    if (!widget.canControlPlayback ||
        controller == null ||
        !controller.value.isInitialized) {
      return;
    }
    final nextIsPlaying = !controller.value.isPlaying;
    if (nextIsPlaying) {
      await resumeVideoPlayback(controller, isLive: widget.isLive);
    } else {
      await controller.pause();
    }
    widget.onPlaybackStateChanged?.call(nextIsPlaying);
  }

  Future<void> _commitSeek(double seconds) async {
    final controller = widget.controller;
    if (!widget.canControlPlayback ||
        widget.isLive ||
        controller == null ||
        !controller.value.isInitialized) {
      return;
    }
    final target = Duration(milliseconds: (seconds * 1000).round());
    await seekVideoPlayback(
      controller,
      position: target,
      expectedToBePlaying:
          widget.isPlaybackExpectedToBePlaying?.call() ??
          controller.value.isPlaying,
    );
    if (mounted) setState(() => _pendingSeekSeconds = null);
    widget.onSeek?.call(target);
  }

  Widget _buildTransportButton({
    required Key key,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return _PlayerIconButton(
      key: key,
      onPressed: onPressed,
      tooltip: tooltip,
      icon: icon,
      iconSize: 18,
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
    );
  }

  Widget _buildTransportControls(VideoPlayerValue? value) {
    final duration = value?.duration ?? Duration.zero;
    final position = value?.position ?? Duration.zero;
    final displayPosition = widget.isLive
        ? livePlaybackPosition(
            playerPosition: position,
            liveStartedAt: widget.liveStartedAt,
          )
        : position;
    final maxSeconds = duration.inMilliseconds / 1000.0;
    final positionSeconds = position.inMilliseconds / 1000.0;
    final sliderValue = (_pendingSeekSeconds ?? positionSeconds).clamp(
      0.0,
      maxSeconds > 0 ? maxSeconds : 1.0,
    );
    final canSeek =
        widget.canControlPlayback &&
        !widget.isLive &&
        value != null &&
        maxSeconds > 0;
    final canToggle = widget.canControlPlayback && value != null;

    return Material(
      color: Colors.black.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isLive && value != null)
              SizedBox(
                height: 18,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                      disabledThumbRadius: 4,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                  ),
                  child: Slider(
                    key: const Key('picture_in_picture_progress_slider'),
                    value: sliderValue,
                    max: maxSeconds > 0 ? maxSeconds : 1,
                    onChangeStart: canSeek
                        ? (seconds) =>
                              setState(() => _pendingSeekSeconds = seconds)
                        : null,
                    onChanged: canSeek
                        ? (seconds) =>
                              setState(() => _pendingSeekSeconds = seconds)
                        : null,
                    onChangeEnd: canSeek
                        ? (seconds) => unawaited(_commitSeek(seconds))
                        : null,
                    semanticFormatterCallback: (seconds) =>
                        formatPlayerDuration(
                          Duration(seconds: seconds.round()),
                        ),
                  ),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.onPrevious != null)
                  _buildTransportButton(
                    key: const Key('picture_in_picture_previous_button'),
                    icon: Icons.skip_previous_rounded,
                    tooltip: context.l10n.previousVideo,
                    onPressed: widget.onPrevious,
                  ),
                _buildTransportButton(
                  key: const Key('picture_in_picture_play_pause_button'),
                  icon: value?.isPlaying == true
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  tooltip: value?.isPlaying == true
                      ? context.l10n.pause
                      : context.l10n.play,
                  onPressed: canToggle
                      ? () => unawaited(_togglePlayback())
                      : null,
                ),
                if (widget.onNext != null)
                  _buildTransportButton(
                    key: const Key('picture_in_picture_next_button'),
                    icon: Icons.skip_next_rounded,
                    tooltip: context.l10n.nextVideo,
                    onPressed: widget.onNext,
                  ),
                if (widget.onSync != null)
                  _buildTransportButton(
                    key: const Key('picture_in_picture_sync_button'),
                    icon: widget.isLive
                        ? Icons.refresh_rounded
                        : Icons.sync_rounded,
                    tooltip: widget.isLive
                        ? context.l10n.reload
                        : context.l10n.sync,
                    onPressed: widget.onSync,
                  ),
                if (widget.playbackOptionsControl != null)
                  KeyedSubtree(
                    key: const Key(
                      'picture_in_picture_playback_options_button',
                    ),
                    child: widget.playbackOptionsControl!,
                  ),
                const Spacer(),
                if (value != null)
                  Text(
                    playbackPositionLabel(
                          isLive: widget.isLive,
                          position: displayPosition,
                          liveLabel: context.l10n.live,
                        ) +
                        (widget.isLive
                            ? ''
                            : ' / ${formatPlayerDuration(duration)}'),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoController = widget.controller;
    return ColoredBox(
      key: const Key('picture_in_picture_surface'),
      color: Colors.black,
      child: MouseRegion(
        onEnter: (_) => setState(() => _showControls = true),
        onExit: (_) => setState(() {
          _showControls = false;
          _showVolumeSlider = false;
        }),
        child: Stack(
          fit: StackFit.expand,
          children: [
            videoController == null || !videoController.value.isInitialized
                ? widget.emptyState
                : ListenableBuilder(
                    listenable: widget.danmakuController,
                    builder: (context, _) => Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: videoController.value.aspectRatio > 0
                                ? videoController.value.aspectRatio
                                : 16 / 9,
                            child: VideoPlayer(videoController),
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: ExcludeSemantics(
                              child: DanmakuOverlay(
                                videoController: videoController,
                                danmakuList: widget.danmakuController.items,
                                isEnabled: widget.danmakuEnabled,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onPanStart: widget.onDragStart == null
                    ? null
                    : (_) => widget.onDragStart?.call(),
                onDoubleTap: widget.onExit,
              ),
            ),
            if (_showControls && videoController?.value.isInitialized == true)
              Positioned(
                right: 8,
                bottom: 70,
                child: ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: videoController!,
                  builder: (context, value, _) => MouseRegion(
                    onEnter: (_) => setState(() => _showVolumeSlider = true),
                    onExit: (_) => setState(() => _showVolumeSlider = false),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_showVolumeSlider)
                          Material(
                            color: Colors.black.withValues(alpha: 0.62),
                            borderRadius: BorderRadius.circular(18),
                            child: SizedBox(
                              width: 34,
                              height: 94,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  key: const Key(
                                    'picture_in_picture_volume_slider',
                                  ),
                                  value: value.volume.clamp(0.0, 1.0),
                                  onChanged: (volume) =>
                                      unawaited(_setVolume(volume)),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Material(
                          color: Colors.black.withValues(alpha: 0.62),
                          shape: const CircleBorder(),
                          child: _PlayerIconButton(
                            key: const Key('picture_in_picture_volume_button'),
                            onPressed: _toggleMute,
                            tooltip:
                                widget.volumeTooltip ?? context.l10n.volume,
                            icon: value.volume <= 0.01
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            iconSize: 18,
                            constraints: const BoxConstraints.tightFor(
                              width: 34,
                              height: 34,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_showControls)
              Positioned(
                left: 8,
                right: 8,
                bottom: 6,
                child: videoController?.value.isInitialized == true
                    ? ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: videoController!,
                        builder: (context, value, _) =>
                            _buildTransportControls(value),
                      )
                    : _buildTransportControls(null),
              ),
            if (_showControls)
              if (widget.onExit case final onExit?)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.62),
                    shape: const CircleBorder(),
                    child: _PlayerIconButton(
                      key: const Key('picture_in_picture_exit_button'),
                      onPressed: onExit,
                      tooltip:
                          widget.exitTooltip ??
                          context.l10n.exitPictureInPicture,
                      icon: Icons.fullscreen_exit_rounded,
                      iconSize: 19,
                      constraints: const BoxConstraints.tightFor(
                        width: 34,
                        height: 34,
                      ),
                    ),
                  ),
                ),
            if (_showControls && widget.diagnostics != null)
              Positioned(
                top: 8,
                right: 8,
                child: KeyedSubtree(
                  key: const Key('picture_in_picture_diagnostics'),
                  child: widget.diagnostics!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum VideoPlayerInteractionMode { mobile, desktop }

class _PlayerVisualIgnorePointer extends SingleChildRenderObjectWidget {
  const _PlayerVisualIgnorePointer({
    required this.ignoring,
    required super.child,
  });

  final bool ignoring;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPlayerVisualIgnorePointer(ignoring);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderPlayerVisualIgnorePointer renderObject,
  ) {
    renderObject.ignoring = ignoring;
  }
}

class _RenderPlayerVisualIgnorePointer extends RenderProxyBox {
  _RenderPlayerVisualIgnorePointer(this._ignoring);

  bool _ignoring;

  set ignoring(bool value) {
    if (_ignoring == value) return;
    _ignoring = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_ignoring) super.paint(context, offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return !_ignoring && super.hitTest(result, position: position);
  }
}

const playerPlaybackSpeedOptions = <double>[2.0, 1.5, 1.25, 1.0, 0.75, 0.5];

class PlayerControlVisibility {
  const PlayerControlVisibility({
    required this.showTime,
    required this.showFullscreen,
    required this.showVolume,
    required this.showSync,
    required this.showPlaybackRoute,
    required this.showSpeed,
    required this.showDanmaku,
    required this.showSubtitles,
    required this.showPictureInPicture,
    required this.showSendDanmaku,
    required this.showSettings,
  });

  factory PlayerControlVisibility.forWidth(
    double width, {
    required bool desktop,
  }) {
    return PlayerControlVisibility(
      showTime: width >= 520,
      showFullscreen: width >= 380,
      showVolume: desktop && width >= 460,
      showSync: width >= 520,
      showPlaybackRoute: width >= 600,
      showSpeed: width >= 680,
      showDanmaku: width >= 740,
      showSubtitles: width >= 800,
      showPictureInPicture: width >= 860,
      showSendDanmaku: width >= 920,
      showSettings: width >= 460,
    );
  }

  final bool showTime;
  final bool showFullscreen;
  final bool showVolume;
  final bool showSync;
  final bool showPlaybackRoute;
  final bool showSpeed;
  final bool showDanmaku;
  final bool showSubtitles;
  final bool showPictureInPicture;
  final bool showSendDanmaku;
  final bool showSettings;
}

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

String formatPlayerDuration(Duration duration) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}

const _completedPlaybackTolerance = Duration(milliseconds: 500);

bool shouldRestartCompletedPlayback(
  VideoPlayerValue value, {
  required bool isLive,
}) {
  if (isLive ||
      value.duration <= Duration.zero ||
      value.position <= Duration.zero) {
    return false;
  }
  return value.position >= value.duration - _completedPlaybackTolerance;
}

Future<void> resumeVideoPlayback(
  VideoPlayerController controller, {
  required bool isLive,
}) async {
  if (shouldRestartCompletedPlayback(controller.value, isLive: isLive)) {
    await controller.seekTo(Duration.zero);
  }
  await controller.play();
}

Future<void> seekVideoPlayback(
  VideoPlayerController controller, {
  required Duration position,
  required bool expectedToBePlaying,
}) async {
  await controller.seekTo(position);
  if (controller.value.isPlaying == expectedToBePlaying) return;
  if (expectedToBePlaying) {
    await controller.play();
  } else {
    await controller.pause();
  }
}

String playbackPositionLabel({
  required bool isLive,
  required Duration position,
  required String liveLabel,
}) {
  final formattedPosition = formatPlayerDuration(position);
  return isLive ? '$liveLabel · $formattedPosition' : formattedPosition;
}

Duration livePlaybackPosition({
  required Duration playerPosition,
  required int? liveStartedAt,
  DateTime? now,
}) {
  if (liveStartedAt == null || liveStartedAt <= 0) return playerPosition;
  final currentTime = now ?? SyncedClock.now();
  final elapsedSeconds =
      currentTime.millisecondsSinceEpoch ~/ 1000 - liveStartedAt;
  return Duration(seconds: elapsedSeconds > 0 ? elapsedSeconds : 0);
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with SingleTickerProviderStateMixin {
  bool _showControls = true;
  bool _showOverflowControls = false;
  bool _showDetailedStatistics = false;
  Size _viewportSize = Size.zero;
  bool? _loopPlaybackOverride;
  bool? _shufflePlaybackOverride;
  bool _playModeChangePending = false;
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
  String? _selectedSubtitleKey;
  bool _subtitlesDisabled = false;
  bool _subtitleLoaded = false;
  int _subtitleLoadGeneration = 0;

  bool get _isDesktopMode =>
      widget.interactionMode == VideoPlayerInteractionMode.desktop;

  bool get _loopPlayback => _loopPlaybackOverride ?? widget.loopPlayback;

  bool get _shufflePlayback =>
      _shufflePlaybackOverride ?? widget.shufflePlayback;

  @override
  void initState() {
    super.initState();
    if (widget.isFullScreen) _applyFullScreenSystemUi(fullScreen: true);
    widget.controller.addListener(_videoListener);
    widget.danmakuController?.addListener(_onDanmakuUpdate);
    _restorePersistedVolume();
    _startHideTimer();
    unawaited(_loadDefaultSubtitles());
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
    if (widget.isFullScreen != oldWidget.isFullScreen) {
      _applyFullScreenSystemUi(fullScreen: widget.isFullScreen);
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_videoListener);
      widget.controller.addListener(_videoListener);
      _restorePersistedVolume();
    }

    if (widget.danmakuController != oldWidget.danmakuController) {
      oldWidget.danmakuController?.removeListener(_onDanmakuUpdate);
      widget.danmakuController?.addListener(_onDanmakuUpdate);
    }

    final oldSubtitleDelivery = _subtitleDelivery(
      oldWidget.subtitles,
      _selectedSubtitleKey,
    );
    final nextSubtitleDelivery = _subtitleDelivery(
      widget.subtitles,
      _selectedSubtitleKey,
    );
    final subtitleResourceChanged =
        oldSubtitleDelivery != null &&
        nextSubtitleDelivery != null &&
        oldSubtitleDelivery.swarmId != nextSubtitleDelivery.swarmId;
    if (widget.playbackResourceIdentity != oldWidget.playbackResourceIdentity ||
        subtitleResourceChanged) {
      unawaited(_reloadSubtitleForPlaybackSelection());
    } else if (widget.subtitles != oldWidget.subtitles &&
        !_subtitlesDisabled &&
        !_subtitleLoaded) {
      unawaited(_reloadSubtitleForPlaybackSelection());
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

    if (widget.loopPlayback != oldWidget.loopPlayback ||
        widget.shufflePlayback != oldWidget.shufflePlayback) {
      _loopPlaybackOverride = null;
      _shufflePlaybackOverride = null;
    }
  }

  @override
  void dispose() {
    if (widget.isFullScreen) {
      _applyFullScreenSystemUi(fullScreen: false);
    }
    widget.controller.removeListener(_videoListener);
    widget.danmakuController?.removeListener(_onDanmakuUpdate);
    _hideTimer?.cancel();
    _volumeOverlayHideTimer?.cancel();
    _removeVolumeOverlay();
    _subtitleTimer?.cancel();
    _subtitleLoadGeneration++;
    super.dispose();
  }

  void _applyFullScreenSystemUi({required bool fullScreen}) {
    if (fullScreen) {
      unawaited(
        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]),
      );
      unawaited(
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
      );
      return;
    }
    unawaited(SystemChrome.setPreferredOrientations(const []));
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
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

  Future<void> _reloadSubtitleForPlaybackSelection() async {
    if (_subtitlesDisabled) {
      _clearSubtitles();
      return;
    }
    final selectedKey = _selectedSubtitleKey;
    if (selectedKey != null &&
        widget.subtitles?.containsKey(selectedKey) == true) {
      await _loadSubtitleByKey(selectedKey);
      return;
    }
    await _loadDefaultSubtitles();
  }

  Future<void> _loadDefaultSubtitles() async {
    final subtitles = widget.subtitles;
    if (subtitles == null || subtitles.isEmpty) {
      _selectedSubtitleKey = null;
      _clearSubtitles();
      widget.onSubtitleP2pDeactivated?.call();
      return;
    }

    String? defaultKey;
    for (final key in subtitles.keys) {
      if (key.toLowerCase().contains('zh') ||
          key.toLowerCase().contains('chi') ||
          key.toLowerCase().contains('中')) {
        defaultKey = key;
        break;
      }
    }
    defaultKey ??= subtitles.keys.first;
    await _loadSubtitleByKey(defaultKey);
  }

  Future<void> _loadSubtitleByKey(String key) async {
    final value = widget.subtitles?[key];
    if (value is! Map) return;
    final subtitle = Map<String, dynamic>.from(value);
    final url = subtitle['url'] as String?;
    if (url == null || url.isEmpty) return;

    _selectedSubtitleKey = key;
    _subtitlesDisabled = false;
    _subtitleLoaded = false;
    final generation = ++_subtitleLoadGeneration;
    _subtitleItems.clear();
    _currentSubtitle = '';
    if (mounted) setState(() {});
    debugPrint('Loading subtitle: $key');
    await _fetchAndParseSubtitles(
      url,
      generation: generation,
      headers: _headersFromDynamicMap(subtitle['headers']),
      p2pDelivery: subtitle['p2pDelivery'] is P2pResourceDelivery
          ? subtitle['p2pDelivery'] as P2pResourceDelivery
          : null,
    );
  }

  P2pResourceDelivery? _subtitleDelivery(
    Map<String, dynamic>? subtitles,
    String? key,
  ) {
    if (subtitles == null || subtitles.isEmpty || key == null) return null;
    final value = subtitles[key];
    if (value is! Map) return null;
    final delivery = value['p2pDelivery'];
    return delivery is P2pResourceDelivery ? delivery : null;
  }

  Future<void> _fetchAndParseSubtitles(
    String url, {
    required int generation,
    Map<String, String> headers = const {},
    P2pResourceDelivery? p2pDelivery,
  }) async {
    try {
      final resolvedUrl = widget.resourceUrlResolver.resolve(url);
      final delivery = p2pDelivery;
      final resolver = widget.resolveSubtitleResource;
      if (delivery == null || resolver == null) {
        widget.onSubtitleP2pDeactivated?.call();
      }
      final resource = delivery == null || resolver == null
          ? LocalizedPlaybackResource(
              uri: Uri.parse(resolvedUrl),
              headers: headers,
            )
          : await resolver(resolvedUrl, headers, delivery);
      if (!mounted || generation != _subtitleLoadGeneration) return;

      final bytes = await widget.subtitleSource.load(
        resource.uri,
        headers: resource.headers,
      );
      if (mounted && generation == _subtitleLoadGeneration && bytes != null) {
        // Robust decoding (handles UTF-16 BOM)
        String content = _decodeSubtitleContent(bytes);

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

        _subtitleLoaded = true;
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Failed to load subtitles: $e');
    }
  }

  void _clearSubtitles() {
    _subtitleLoadGeneration++;
    _subtitleLoaded = false;
    _subtitleItems.clear();
    _currentSubtitle = '';
    if (mounted) setState(() {});
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
          _showOverflowControls = false;
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
        setState(() {
          _showControls = false;
          _showOverflowControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (!_showControls) _showOverflowControls = false;
    });
    if (_showControls) _startHideTimer();
  }

  Future<void> _togglePlayPause() async {
    if (!widget.canControlPlayback) return;
    final nextIsPlaying = !widget.controller.value.isPlaying;
    if (widget.controller.value.isPlaying) {
      await widget.controller.pause();
    } else {
      await resumeVideoPlayback(widget.controller, isLive: widget.isLive);
    }
    widget.onUserPlaybackStateChanged?.call(nextIsPlaying);
    if (mounted) {
      setState(() => _showControls = true);
    }
    _startHideTimer();
  }

  Future<void> _seekFromUser(Duration target) async {
    if (!widget.canControlPlayback || widget.isLive) return;
    final duration = widget.controller.value.duration;
    final clamped = target < Duration.zero
        ? Duration.zero
        : duration > Duration.zero && target > duration
        ? duration
        : target;
    await seekVideoPlayback(
      widget.controller,
      position: clamped,
      expectedToBePlaying:
          widget.isPlaybackExpectedToBePlaying?.call() ??
          widget.controller.value.isPlaying,
    );
    widget.onUserSeek?.call(clamped);
    _showDesktopControls();
  }

  Future<void> _setPlaybackSpeedFromUser(double speed) async {
    if (!widget.canControlPlayback) return;
    await widget.controller.setPlaybackSpeed(speed);
    widget.onUserPlaybackSpeedChanged?.call(speed);
    _startHideTimer();
    if (mounted) setState(() {});
  }

  List<_PlaybackSpeedOption> _playbackSpeedOptions() {
    return [
      for (final speed in playerPlaybackSpeedOptions)
        _PlaybackSpeedOption(
          speed: speed,
          label:
              '${speed.toStringAsFixed(speed == speed.roundToDouble() ? 0 : 2)}x',
        ),
    ];
  }

  Widget _buildSubtitleControl(double iconSize) {
    return _PlayerIconButton(
      key: const Key('playback_subtitles_button'),
      icon: Icons.closed_caption_rounded,
      tooltip: context.l10n.subtitles,
      onPressed: _showSubtitleMenu,
      padding: widget.isFullScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
      constraints: widget.isFullScreen ? null : const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  Widget _buildSpeedControl(VideoPlayerValue value, double iconSize) {
    return _PlaybackSpeedMenuButton(
      currentSpeed: value.playbackSpeed,
      options: _playbackSpeedOptions(),
      dimension: widget.isFullScreen ? 40 : max(32.0, iconSize + 12),
      iconSize: widget.isFullScreen ? 24 : iconSize,
      onSelected: _setPlaybackSpeedFromUser,
    );
  }

  Widget _buildDanmakuControl(double iconSize) {
    return _PlayerIconButton(
      key: const Key('playback_danmaku_button'),
      icon: Icons.comment_rounded,
      tooltip: _showDanmaku
          ? context.l10n.disableDanmaku
          : context.l10n.enableDanmaku,
      selected: _showDanmaku,
      onPressed: () => setState(() => _showDanmaku = !_showDanmaku),
      padding: widget.isFullScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
      constraints: widget.isFullScreen ? null : const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  Widget _buildSyncControl(double iconSize) {
    return _PlayerIconButton(
      key: const Key('playback_sync_button'),
      icon: widget.isLive ? Icons.refresh_rounded : Icons.sync_rounded,
      tooltip: widget.isLive ? context.l10n.reload : context.l10n.sync,
      onPressed: widget.onSync,
      padding: widget.isFullScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
      constraints: widget.isFullScreen ? null : const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  Widget _buildFreeModeSettingsControl(double iconSize) {
    return _PlayerIconButton(
      key: const Key('free_mode_settings_button'),
      icon: Icons.settings_rounded,
      tooltip: context.l10n.freeModeSettings,
      onPressed: widget.onOpenFreeModeSettings,
      padding: widget.isFullScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
      constraints: widget.isFullScreen ? null : const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  Widget _buildFullscreenControl(double iconSize) {
    return _PlayerIconButton(
      key: const Key('playback_fullscreen_button'),
      icon: widget.isFullScreen
          ? (widget.exitFullScreenIcon ?? Icons.fullscreen_exit)
          : (widget.fullScreenIcon ?? Icons.fullscreen),
      tooltip: widget.isFullScreen
          ? context.l10n.exitFullscreen
          : context.l10n.fullscreen,
      onPressed: widget.onToggleFullScreen,
      padding: widget.isFullScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
      constraints: widget.isFullScreen ? null : const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  Widget _buildSendDanmakuControl() {
    return _PlayerIconButton(
      icon: Icons.send_rounded,
      onPressed: _showDanmakuInput,
      tooltip: context.l10n.sendDanmaku,
    );
  }

  Future<void> _seekRelative(Duration offset) async {
    if (!widget.canControlPlayback || widget.isLive) return;
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

  void _handleProgressChangeStart(double value) {
    _hideTimer?.cancel();
    setState(() {
      _isSliderDragging = true;
      _sliderDragValue = value;
      _showControls = true;
    });
  }

  void _handleProgressChanged(double value) {
    setState(() => _sliderDragValue = value);
  }

  void _handleProgressChangeEnd(double value) {
    _sliderDragValue = value;
    unawaited(_commitProgressSeek(value));
  }

  Future<void> _commitProgressSeek(double value) async {
    await _seekFromUser(Duration(milliseconds: value.round()));
    if (!mounted) return;
    setState(() => _isSliderDragging = false);
    _startHideTimer();
  }

  KeyEventResult _handleDesktopKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isDesktopMode || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.keyK) {
      if (!widget.canControlPlayback || widget.isLive) {
        return KeyEventResult.ignored;
      }
      _togglePlayPause();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      if (!widget.canControlPlayback || widget.isLive) {
        return KeyEventResult.ignored;
      }
      _seekRelative(const Duration(seconds: -5));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      if (!widget.canControlPlayback || widget.isLive) {
        return KeyEventResult.ignored;
      }
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
    if (key == LogicalKeyboardKey.keyP &&
        widget.onEnterPictureInPicture != null) {
      widget.onEnterPictureInPicture?.call();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_isDesktopMode) return;
    if (!widget.canControlPlayback || widget.isLive) return;
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
    if (!widget.canControlPlayback || widget.isLive) return;
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
    if (!widget.canControlPlayback || widget.isLive) return;
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
      if (!_isDesktopMode) {
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
        _dragStartVolume = await VolumeController.instance.getVolume();
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
      if (!_isDesktopMode) {
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
        await VolumeController.instance.setVolume(newVal);
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
    return formatPlayerDuration(duration);
  }

  void _rememberAudibleVolume() {
    final volume = widget.controller.value.volume;
    if (volume.isFinite && volume > 0.01) {
      _lastAudibleVolume = volume.clamp(0.0, 1.0).toDouble();
    }
  }

  Future<void> _restorePersistedVolume() async {
    try {
      final preferences = widget.volumePreferences.value;
      _lastAudibleVolume = preferences.lastAudibleVolume;
      await widget.controller.setVolume(preferences.volume);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Restore player volume failed: $e');
      _rememberAudibleVolume();
    }
  }

  Future<void> _persistVolume(double volume) async {
    try {
      await widget.volumePreferences.save(
        volume: volume,
        lastAudibleVolume: _lastAudibleVolume,
      );
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
    _volumeOverlayHideTimer = Timer(const Duration(milliseconds: 500), () {
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

  Widget _buildVolumeOverlay(BuildContext overlayContext) => Positioned.fill(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        ExcludeSemantics(
          child: CompositedTransformFollower(
            link: _volumeControlLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.topCenter,
            followerAnchor: Alignment.bottomCenter,
            offset: const Offset(0, -4),
            child: SizedBox(
              width: 44,
              height: 132,
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
                              key: const Key('desktop_volume_slider'),
                              value: widget.controller.value.volume
                                  .clamp(0.0, 1.0)
                                  .toDouble(),
                              min: 0,
                              max: 1,
                              onChangeStart: (_) => _showVolumeOverlay(),
                              onChanged: _setPlayerVolume,
                              onChangeEnd: (_) => _scheduleVolumeOverlayHide(),
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
        ),
      ],
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
        child: _PlayerIconButton(
          key: const Key('desktop_volume_button'),
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
                _subtitlesDisabled = true;
                _selectedSubtitleKey = null;
                _clearSubtitles();
                widget.onSubtitleP2pDeactivated?.call();
                Navigator.pop(context);
              },
            ),
            const AppDivider(color: Colors.white24, height: 1),
            Flexible(
              child: AppSingleChildScrollView(
                child: Column(
                  children: widget.subtitles!.entries.map((e) {
                    final label = subtitleDisplayLabel(e.key, e.value);
                    return AppTile(
                      title: Text(
                        label,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        unawaited(_loadSubtitleByKey(e.key));
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

  PlaybackDiagnosticsSnapshot _playbackDiagnosticsSnapshot() {
    final value = widget.controller.value;
    return PlaybackDiagnosticsSnapshot(
      capturedAt: DateTime.now(),
      title: widget.title,
      isLive: widget.isLive,
      isInitialized: value.isInitialized,
      isPlaying: value.isPlaying,
      isBuffering: value.isBuffering,
      isCompleted: value.isCompleted,
      isLooping: value.isLooping,
      position: value.position,
      duration: value.duration,
      buffered: [
        for (final range in value.buffered)
          PlaybackBufferRange(start: range.start, end: range.end),
      ],
      viewportSize: _viewportSize,
      videoSize: value.size,
      volume: value.volume,
      playbackSpeed: value.playbackSpeed,
      errorDescription: value.errorDescription,
      context: widget.diagnosticsProvider?.call() ?? widget.diagnostics,
    );
  }

  Future<void> _copyPlaybackDebugInfo() async {
    await Clipboard.setData(
      ClipboardData(text: _playbackDiagnosticsSnapshot().toPrettyJson()),
    );
    if (!mounted) return;
    AppNotifications.showInfo(
      context,
      context.l10n.playbackDebugInfoCopied,
      duration: const Duration(seconds: 1),
    );
  }

  Future<void> _changeContextMenuPlayMode({
    required bool loop,
    required bool shuffle,
    required Future<bool> Function(bool enabled)? callback,
  }) async {
    if (_playModeChangePending || callback == null) return;
    setState(() => _playModeChangePending = true);
    var changed = false;
    try {
      changed = await callback(loop || shuffle);
    } finally {
      if (mounted) {
        setState(() {
          _playModeChangePending = false;
          if (changed) {
            _loopPlaybackOverride = loop;
            _shufflePlaybackOverride = shuffle;
          }
        });
      }
    }
  }

  Future<void> _showPlaybackContextMenu(Offset globalPosition) async {
    _hideTimer?.cancel();
    if (mounted && !_showControls) {
      setState(() => _showControls = true);
    }
    final action = await showPlaybackContextMenu(
      context: context,
      globalPosition: globalPosition,
      state: PlaybackContextMenuState(
        isLive: widget.isLive,
        loopEnabled: _loopPlayback,
        shuffleEnabled: _shufflePlayback,
        canChangePlayMode:
            widget.canChangePlayMode &&
            !_playModeChangePending &&
            widget.onLoopPlaybackChanged != null &&
            widget.onShufflePlaybackChanged != null,
        detailedStatisticsVisible: _showDetailedStatistics,
        canSync: widget.onSync != null,
        canReloadSource: widget.onReloadPlayback != null,
        canEnterPictureInPicture: widget.onEnterPictureInPicture != null,
      ),
    );
    if (!mounted || action == null) {
      _startHideTimer();
      return;
    }
    switch (action) {
      case PlaybackContextMenuAction.toggleLoop:
        await _changeContextMenuPlayMode(
          loop: !_loopPlayback,
          shuffle: false,
          callback: widget.onLoopPlaybackChanged,
        );
        break;
      case PlaybackContextMenuAction.toggleShuffle:
        await _changeContextMenuPlayMode(
          loop: false,
          shuffle: !_shufflePlayback,
          callback: widget.onShufflePlaybackChanged,
        );
        break;
      case PlaybackContextMenuAction.sync:
        widget.onSync?.call();
        break;
      case PlaybackContextMenuAction.reloadSource:
        widget.onReloadPlayback?.call();
        break;
      case PlaybackContextMenuAction.pictureInPicture:
        widget.onEnterPictureInPicture?.call();
        break;
      case PlaybackContextMenuAction.copyDebugInfo:
        await _copyPlaybackDebugInfo();
        break;
      case PlaybackContextMenuAction.toggleDetailedStatistics:
        setState(() {
          _showDetailedStatistics = !_showDetailedStatistics;
        });
        break;
    }
    _startHideTimer();
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
        includeSemantics: false,
        onKeyEvent: _handleDesktopKeyEvent,
        child: MouseRegion(
          onHover: (_) => _showDesktopControls(),
          onExit: _handleDesktopPointerExit,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onSecondaryTapDown: (details) =>
                unawaited(_showPlaybackContextMenu(details.globalPosition)),
            onLongPressStart: _isDesktopMode
                ? null
                : (details) => unawaited(
                    _showPlaybackContextMenu(details.globalPosition),
                  ),
            onTap: _isDesktopMode
                ? (!widget.canControlPlayback || widget.isLive
                      ? null
                      : _togglePlayPause)
                : _toggleControls,
            onDoubleTap:
                _isDesktopMode || !widget.canControlPlayback || widget.isLive
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
                    child: ExcludeSemantics(
                      child: DanmakuOverlay(
                        videoController: widget.controller,
                        danmakuList: widget.danmakuController?.items ?? [],
                        isEnabled: _showDanmaku,
                      ),
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
                _PlayerVisualIgnorePointer(
                  ignoring: !_showControls,
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
                                  final diagnostics = widget.diagnosticsBuilder
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
                                final visibility =
                                    PlayerControlVisibility.forWidth(
                                      controlsWidth,
                                      desktop: _isDesktopMode,
                                    );
                                final iconSize = controlsWidth < 360
                                    ? 18.0
                                    : 20.0;
                                final playIconSize = controlsWidth < 360
                                    ? 28.0
                                    : 32.0;
                                final horizontalGap = controlsWidth < 360
                                    ? 4.0
                                    : 8.0;
                                final playPauseControl = _PlayerIconButton(
                                  onPressed: widget.canControlPlayback
                                      ? _togglePlayPause
                                      : null,
                                  tooltip: videoValue.isPlaying
                                      ? context.l10n.pause
                                      : context.l10n.play,
                                  constraints: const BoxConstraints.tightFor(
                                    width: 40,
                                    height: 40,
                                  ),
                                  icon: videoValue.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  iconSize: playIconSize,
                                );
                                final controls =
                                    <({Widget control, bool visible})>[
                                      if (_isDesktopMode)
                                        (
                                          control: _buildHoverVolumeControl(
                                            videoValue,
                                            iconSize: widget.isFullScreen
                                                ? 24
                                                : 20,
                                          ),
                                          visible: visibility.showVolume,
                                        ),
                                      if (widget.subtitles != null &&
                                          widget.subtitles!.isNotEmpty)
                                        (
                                          control: _buildSubtitleControl(
                                            iconSize,
                                          ),
                                          visible: visibility.showSubtitles,
                                        ),
                                      if (widget.canControlPlayback &&
                                          !widget.isLive)
                                        (
                                          control: _buildSpeedControl(
                                            videoValue,
                                            iconSize,
                                          ),
                                          visible: visibility.showSpeed,
                                        ),
                                      (
                                        control: _buildDanmakuControl(iconSize),
                                        visible: visibility.showDanmaku,
                                      ),
                                      if (widget.onSync != null)
                                        (
                                          control: _buildSyncControl(iconSize),
                                          visible: visibility.showSync,
                                        ),
                                      if (widget.extraBottomWidget
                                          case final control?)
                                        (
                                          control: control,
                                          visible: visibility.showPlaybackRoute,
                                        ),
                                      if (widget.isFullScreen &&
                                          widget.onSendDanmaku != null)
                                        (
                                          control: _buildSendDanmakuControl(),
                                          visible: visibility.showSendDanmaku,
                                        ),
                                      if (widget.onEnterPictureInPicture !=
                                          null)
                                        (
                                          control: PictureInPictureControl(
                                            tooltip:
                                                context.l10n.pictureInPicture,
                                            onPressed:
                                                widget.onEnterPictureInPicture!,
                                            iconSize: widget.isFullScreen
                                                ? 24
                                                : iconSize,
                                          ),
                                          visible:
                                              visibility.showPictureInPicture,
                                        ),
                                      if (widget.onOpenFreeModeSettings != null)
                                        (
                                          control:
                                              _buildFreeModeSettingsControl(
                                                iconSize,
                                              ),
                                          visible: visibility.showSettings,
                                        ),
                                      if (widget.onToggleFullScreen != null)
                                        (
                                          control: _buildFullscreenControl(
                                            iconSize,
                                          ),
                                          visible: visibility.showFullscreen,
                                        ),
                                    ];
                                final hiddenControls = [
                                  for (final entry in controls)
                                    if (!entry.visible) entry.control,
                                ];

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        if (widget.onPrevious != null ||
                                            widget.onNext != null)
                                          PlaybackNavigationControls(
                                            previousTooltip:
                                                context.l10n.previousVideo,
                                            nextTooltip: context.l10n.nextVideo,
                                            onPrevious: widget.onPrevious,
                                            onNext: widget.onNext,
                                            center: playPauseControl,
                                            iconSize: iconSize,
                                            gap: horizontalGap,
                                          )
                                        else
                                          playPauseControl,
                                        SizedBox(width: horizontalGap),
                                        if (visibility.showTime) ...[
                                          Text(
                                            playbackPositionLabel(
                                              isLive: widget.isLive,
                                              position: widget.isLive
                                                  ? livePlaybackPosition(
                                                      playerPosition:
                                                          videoValue.position,
                                                      liveStartedAt:
                                                          widget.liveStartedAt,
                                                    )
                                                  : videoValue.position,
                                              liveLabel: context.l10n.live,
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
                                              enabled:
                                                  widget.canControlPlayback,
                                              label:
                                                  context.l10n.playbackProgress,
                                              value:
                                                  '${_formatDuration(videoValue.position)} / ${_formatDuration(videoValue.duration)}',
                                              increasedValue: _formatDuration(
                                                videoValue.position +
                                                    const Duration(seconds: 5),
                                              ),
                                              decreasedValue: _formatDuration(
                                                videoValue.position -
                                                    const Duration(seconds: 5),
                                              ),
                                              onIncrease:
                                                  widget.canControlPlayback
                                                  ? () => unawaited(
                                                      _seekRelative(
                                                        const Duration(
                                                          seconds: 5,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              onDecrease:
                                                  widget.canControlPlayback
                                                  ? () => unawaited(
                                                      _seekRelative(
                                                        const Duration(
                                                          seconds: -5,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              child: ExcludeSemantics(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: Align(
                                                    alignment: Alignment.center,
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
                                                              overlayRadius: 24,
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
                                                            const RectangularSliderTrackShape(),
                                                      ),
                                                      child: AppSlider(
                                                        key: const Key(
                                                          'playback_progress_slider',
                                                        ),
                                                        value:
                                                            (_isSliderDragging
                                                                    ? _sliderDragValue
                                                                    : videoValue
                                                                          .position
                                                                          .inMilliseconds
                                                                          .toDouble())
                                                                .clamp(
                                                                  0,
                                                                  videoValue.duration.inMilliseconds
                                                                              .toDouble() >
                                                                          0
                                                                      ? videoValue
                                                                            .duration
                                                                            .inMilliseconds
                                                                            .toDouble()
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
                                                        onChangeStart:
                                                            widget
                                                                .canControlPlayback
                                                            ? _handleProgressChangeStart
                                                            : null,
                                                        onChanged:
                                                            widget
                                                                .canControlPlayback
                                                            ? _handleProgressChanged
                                                            : null,
                                                        onChangeEnd:
                                                            widget
                                                                .canControlPlayback
                                                            ? _handleProgressChangeEnd
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (visibility.showTime &&
                                            !widget.isLive) ...[
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
                                        for (final entry in controls)
                                          if (entry.visible) ...[
                                            SizedBox(
                                              width: widget.isFullScreen
                                                  ? 0
                                                  : 4,
                                            ),
                                            entry.control,
                                          ],
                                        if (hiddenControls.isNotEmpty) ...[
                                          SizedBox(width: horizontalGap),
                                          _PlayerIconButton(
                                            key: const Key(
                                              'playback_overflow_button',
                                            ),
                                            icon: _showOverflowControls
                                                ? Icons.expand_more_rounded
                                                : Icons.more_horiz_rounded,
                                            tooltip: context.l10n.moreActions,
                                            selected: _showOverflowControls,
                                            onPressed: () => setState(
                                              () => _showOverflowControls =
                                                  !_showOverflowControls,
                                            ),
                                            constraints:
                                                const BoxConstraints.tightFor(
                                                  width: 40,
                                                  height: 40,
                                                ),
                                            padding: EdgeInsets.zero,
                                            iconSize: iconSize,
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (_showOverflowControls &&
                                        hiddenControls.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: AppPanelSurface(
                                          key: const Key(
                                            'playback_overflow_controls',
                                          ),
                                          color: const Color(0xD91A1A24),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: Colors.white24,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: Wrap(
                                            spacing: 4,
                                            runSpacing: 4,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: hiddenControls,
                                          ),
                                        ),
                                      ),
                                    ],
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
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      _viewportSize = constraints.biggest;
                      if (!_showDetailedStatistics) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          12,
                          widget.isFullScreen ? 62 : 8,
                          12,
                          widget.isFullScreen ? 88 : 64,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 460,
                              maxHeight: 410,
                            ),
                            child: PlaybackStatisticsPanel(
                              snapshot: _playbackDiagnosticsSnapshot(),
                              onClose: () => setState(
                                () => _showDetailedStatistics = false,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
      child: AppTooltip(
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
