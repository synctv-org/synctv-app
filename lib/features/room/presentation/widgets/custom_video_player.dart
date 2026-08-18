import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:canvas_danmaku/models/danmaku_option.dart';
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
import 'package:synctv_app/features/room/application/playback_overlay_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_context_menu.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_diagnostics.dart';
import 'package:synctv_app/features/room/presentation/widgets/player_control_popup_style.dart';

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
      replaceVideoItems(acFunItems);
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

    replaceVideoItems(newItems);
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
  final bool freeModeEnabled;
  final ValueChanged<bool>? onFreeModeChanged;
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
  final PlaybackOverlayPreferencesController? overlayPreferences;
  final P2pMediaPreferencesController? p2pMediaPreferences;
  final SubtitleSource subtitleSource;

  const CustomVideoPlayer({
    super.key,
    required this.controller,
    required this.title,
    required this.volumePreferences,
    this.overlayPreferences,
    this.p2pMediaPreferences,
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
    this.freeModeEnabled = false,
    this.onFreeModeChanged,
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

class _PlayerControlsPopupEntry extends PopupMenuEntry<bool> {
  const _PlayerControlsPopupEntry({
    super.key,
    required this.entryHeight,
    required this.child,
  });

  final double entryHeight;
  final Widget child;

  @override
  double get height => entryHeight;

  @override
  bool represents(bool? value) => false;

  @override
  State<_PlayerControlsPopupEntry> createState() =>
      _PlayerControlsPopupEntryState();
}

class _PlayerControlsPopupEntryState extends State<_PlayerControlsPopupEntry> {
  @override
  Widget build(BuildContext context) => widget.child;
}

class _PlayerOverflowSwitchRow extends StatelessWidget {
  const _PlayerOverflowSwitchRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final switchTheme = SwitchTheme.of(context).copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      thumbColor: WidgetStatePropertyAll(
        value ? const Color(0xFF11131B) : Colors.white70,
      ),
      trackColor: WidgetStatePropertyAll(
        value ? const Color(0xFF9BA8FF) : Colors.white24,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
    return MergeSemantics(
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(switchTheme: switchTheme),
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerOverflowActionRow extends StatelessWidget {
  const _PlayerOverflowActionRow({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerSubtitleSelectionRow extends StatelessWidget {
  const _PlayerSubtitleSelectionRow({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? Colors.white
        : Colors.white.withValues(alpha: 0.9);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Semantics(
        button: true,
        label: label,
        onTap: onPressed,
        child: ExcludeSemantics(
          child: Material(
            color: selected ? const Color(0xFF30304A) : const Color(0xFF25252F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selected
                    ? const Color(0xFF9BA8FF)
                    : Colors.white.withValues(alpha: 0.08),
                width: selected ? 1.2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(icon, color: foreground, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      child: selected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              key: ValueKey('selected'),
                              color: Color(0xFF9BA8FF),
                              size: 20,
                            )
                          : const SizedBox(
                              key: ValueKey('unselected'),
                              width: 20,
                              height: 20,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
    final items = _buildChoices();
    final menuHeight =
        16.0 + items.fold<double>(0, (height, item) => height + item.height);
    final menuTop = (topLeft.dy - menuHeight - 8)
        .clamp(8.0, max(8.0, overlay.size.height - menuHeight - 8))
        .toDouble();
    final selected = await showMenu<String>(
      context: anchorContext,
      useRootNavigator: true,
      popUpAnimationStyle: playerControlPopupAnimationStyle,
      color: const Color(0xF21A1A24),
      position: RelativeRect.fromLTRB(
        topLeft.dx,
        menuTop,
        overlay.size.width - bottomRight.dx,
        overlay.size.height - bottomRight.dy + 8,
      ),
      items: items,
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
    this.overlayPreferences,
    required this.emptyState,
    this.exitTooltip,
    this.volumeTooltip,
    this.playbackOptionsControl,
    this.diagnostics,
    this.isLive = false,
    this.liveStartedAt,
    this.canControlPlayback = false,
    this.onPlaybackStateChanged,
    this.onPlaybackSpeedChanged,
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
  final PlaybackOverlayPreferencesController? overlayPreferences;
  final Widget emptyState;
  final String? exitTooltip;
  final String? volumeTooltip;
  final Widget? playbackOptionsControl;
  final Widget? diagnostics;
  final bool isLive;
  final int? liveStartedAt;
  final bool canControlPlayback;
  final ValueChanged<bool>? onPlaybackStateChanged;
  final ValueChanged<double>? onPlaybackSpeedChanged;
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
  double? _pendingSeekSeconds;
  late PlaybackOverlayPreferenceValues _overlayStyle;

  @override
  void initState() {
    super.initState();
    _overlayStyle =
        widget.overlayPreferences?.value ??
        const PlaybackOverlayPreferenceValues();
    widget.overlayPreferences?.addListener(_onOverlayPreferencesChanged);
  }

  void _onOverlayPreferencesChanged() {
    if (!mounted || widget.overlayPreferences == null) return;
    setState(() => _overlayStyle = widget.overlayPreferences!.value);
  }

  Future<void> _setVolume(double volume) async {
    final controller = widget.controller;
    if (controller == null || !controller.value.isInitialized) return;
    await controller.setVolume(volume);
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    final controller = widget.controller;
    if (!widget.canControlPlayback ||
        controller == null ||
        !controller.value.isInitialized) {
      return;
    }
    await controller.setPlaybackSpeed(speed);
    widget.onPlaybackSpeedChanged?.call(speed);
  }

  @override
  void didUpdateWidget(PictureInPicturePlaybackSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.controller, oldWidget.controller)) {
      _pendingSeekSeconds = null;
    }
    if (widget.overlayPreferences != oldWidget.overlayPreferences) {
      oldWidget.overlayPreferences?.removeListener(
        _onOverlayPreferencesChanged,
      );
      widget.overlayPreferences?.addListener(_onOverlayPreferencesChanged);
      _overlayStyle =
          widget.overlayPreferences?.value ??
          const PlaybackOverlayPreferenceValues();
    }
  }

  @override
  void dispose() {
    widget.overlayPreferences?.removeListener(_onOverlayPreferencesChanged);
    super.dispose();
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

  RelativeRect? _controlMenuPosition(
    BuildContext anchorContext, {
    required double menuWidth,
    required double menuHeight,
  }) {
    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    final overlayBox =
        Navigator.of(
              context,
              rootNavigator: true,
            ).overlay?.context.findRenderObject()
            as RenderBox?;
    if (renderBox == null || overlayBox == null || !renderBox.hasSize) {
      return null;
    }
    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final left = (topLeft.dx + (renderBox.size.width - menuWidth) / 2)
        .clamp(8.0, max(8.0, overlayBox.size.width - menuWidth - 8))
        .toDouble();
    final top = (topLeft.dy - menuHeight - 4)
        .clamp(8.0, max(8.0, overlayBox.size.height - menuHeight - 8))
        .toDouble();
    return RelativeRect.fromLTRB(
      left,
      top,
      overlayBox.size.width - left - menuWidth,
      overlayBox.size.height - topLeft.dy + 4,
    );
  }

  Future<void> _openVolumeMenu(BuildContext anchorContext) async {
    const menuWidth = 54.0;
    const menuHeight = 112.0;
    final position = _controlMenuPosition(
      anchorContext,
      menuWidth: menuWidth,
      menuHeight: menuHeight,
    );
    final controller = widget.controller;
    if (position == null || controller == null) return;
    await showMenu<bool>(
      context: context,
      useRootNavigator: true,
      popUpAnimationStyle: playerControlPopupAnimationStyle,
      color: const Color(0xF21A1A24),
      constraints: const BoxConstraints.tightFor(width: menuWidth),
      position: position,
      items: [
        _PlayerControlsPopupEntry(
          entryHeight: menuHeight,
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: controller,
            builder: (context, value, _) => SizedBox(
              width: menuWidth,
              height: menuHeight,
              child: RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  key: const Key('picture_in_picture_volume_slider'),
                  value: value.volume.clamp(0.0, 1.0),
                  onChanged: (volume) => unawaited(_setVolume(volume)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openPlaybackSpeedMenu(
    BuildContext anchorContext,
    double currentSpeed,
  ) async {
    const menuWidth = 132.0;
    const menuHeight = 148.0;
    final position = _controlMenuPosition(
      anchorContext,
      menuWidth: menuWidth,
      menuHeight: menuHeight,
    );
    if (position == null) return;
    await showMenu<bool>(
      context: context,
      useRootNavigator: true,
      popUpAnimationStyle: playerControlPopupAnimationStyle,
      color: const Color(0xF21A1A24),
      constraints: const BoxConstraints.tightFor(width: menuWidth),
      position: position,
      items: [
        _PlayerControlsPopupEntry(
          entryHeight: menuHeight,
          child: SizedBox(
            width: menuWidth,
            height: menuHeight,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: ListView.builder(
                key: const Key('picture_in_picture_speed_options_list'),
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemExtent: 36,
                itemCount: playerPlaybackSpeedOptions.length,
                itemBuilder: (context, index) {
                  final speed = playerPlaybackSpeedOptions[index];
                  final selected = (currentSpeed - speed).abs() < 0.001;
                  return InkWell(
                    key: ValueKey('picture_in_picture_speed_option_$speed'),
                    onTap: () {
                      Navigator.of(context).pop();
                      unawaited(_setPlaybackSpeed(speed));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 16,
                            color: selected
                                ? const Color(0xFF7CFFB2)
                                : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${speed.toStringAsFixed(speed == speed.roundToDouble() ? 0 : 2)}x',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
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
                if (value != null)
                  Builder(
                    builder: (anchorContext) => _buildTransportButton(
                      key: const Key('picture_in_picture_volume_button'),
                      icon: value.volume <= 0.01
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      tooltip: widget.volumeTooltip ?? context.l10n.volume,
                      onPressed: () =>
                          unawaited(_openVolumeMenu(anchorContext)),
                    ),
                  ),
                if (value != null && !widget.isLive)
                  Builder(
                    builder: (anchorContext) => _buildTransportButton(
                      key: const Key(
                        'picture_in_picture_playback_speed_button',
                      ),
                      icon: Icons.speed_rounded,
                      tooltip: context.l10n.playbackSpeedValue(
                        value.playbackSpeed.toStringAsFixed(2),
                      ),
                      onPressed: canToggle
                          ? () => unawaited(
                              _openPlaybackSpeedMenu(
                                anchorContext,
                                value.playbackSpeed,
                              ),
                            )
                          : null,
                    ),
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
        onExit: (_) => setState(() => _showControls = false),
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
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                VideoPlayer(videoController),
                                IgnorePointer(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      if (_overlayStyle.videoDanmakuEnabled)
                                        DanmakuOverlay(
                                          key: const ValueKey(
                                            'pip_video_danmaku_overlay',
                                          ),
                                          videoController: videoController,
                                          danmakuList:
                                              widget.danmakuController.items,
                                          origin: DanmakuOrigin.video,
                                          option: _danmakuOption(
                                            _overlayStyle.videoDanmakuStyle,
                                          ),
                                        ),
                                      if (_overlayStyle.chatDanmakuEnabled)
                                        DanmakuOverlay(
                                          key: const ValueKey(
                                            'pip_chat_danmaku_overlay',
                                          ),
                                          videoController: videoController,
                                          danmakuList:
                                              widget.danmakuController.items,
                                          origin: DanmakuOrigin.chat,
                                          option: _danmakuOption(
                                            _overlayStyle.chatDanmakuStyle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
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
    required this.showVideoDanmaku,
    required this.showChatDanmaku,
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
      showFullscreen: true,
      showVolume: desktop && width >= 460,
      showSync: width >= 520,
      showPlaybackRoute: width >= 600,
      showSpeed: width >= 680,
      showVideoDanmaku: width >= 740,
      showChatDanmaku: false,
      showSubtitles: width >= 860,
      showPictureInPicture: width >= 920,
      showSendDanmaku: width >= 980,
      showSettings: width >= 460,
    );
  }

  final bool showTime;
  final bool showFullscreen;
  final bool showVolume;
  final bool showSync;
  final bool showPlaybackRoute;
  final bool showSpeed;
  final bool showVideoDanmaku;
  final bool showChatDanmaku;
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

/// Returns the letterboxed video rectangle used by the player overlays.
Size videoContentSize(Size viewport, {double aspectRatio = 16 / 9}) {
  if (viewport.isEmpty || !aspectRatio.isFinite || aspectRatio <= 0) {
    return Size.zero;
  }
  final width = min(viewport.width, viewport.height * aspectRatio);
  return Size(width, width / aspectRatio);
}

Color subtitleBackgroundColor(double opacity, {int color = 0xFF000000}) {
  final normalized = opacity.isFinite
      ? opacity.clamp(0.0, 1.0).toDouble()
      : 0.0;
  return normalized <= 0
      ? Colors.transparent
      : Color(color).withValues(alpha: normalized);
}

DanmakuOption _danmakuOption(DanmakuOverlayStyle style) => DanmakuOption(
  fontSize: style.fontSize,
  opacity: style.opacity,
  duration: style.duration,
  area: style.area,
  strokeWidth: style.strokeWidth,
  massiveMode: style.massiveMode,
  hideTop: style.hideTop,
  hideBottom: style.hideBottom,
  hideScroll: style.hideScroll,
  safeArea: true,
);

enum _OverlaySettingsSection { subtitle, videoDanmaku, chatDanmaku }

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with SingleTickerProviderStateMixin {
  bool _showControls = true;
  bool _showDetailedStatistics = false;
  Size _viewportSize = Size.zero;
  bool? _loopPlaybackOverride;
  bool? _shufflePlaybackOverride;
  bool _playModeChangePending = false;
  Timer? _hideTimer;
  bool _isDragging = false;
  bool _isVerticalDragging = false;
  bool _showVideoDanmaku = true;
  bool _showChatDanmaku = true;
  bool _p2pMediaEnabled = false;
  double _lastAudibleVolume = 1.0;
  Timer? _volumeOverlayHideTimer;
  final GlobalKey _volumeAnchorKey = GlobalKey();
  final GlobalKey<_PlaybackSpeedMenuButtonState> _speedMenuKey = GlobalKey();
  OverlayEntry? _volumeOverlayEntry;
  bool _isVolumeButtonHovered = false;
  bool _isVolumeMenuHovered = false;
  bool _isVolumeSliderDragging = false;
  bool _isPlaybackSpeedMenuOpen = false;
  bool _isDesktopPointerInside = false;
  Future<bool?>? _overflowMenuFuture;

  bool get _isVolumeControlHovered =>
      _isVolumeButtonHovered || _isVolumeMenuHovered;

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
  late PlaybackOverlayPreferenceValues _overlayPreferences;

  PlaybackOverlayPreferenceValues get _overlayStyle => _overlayPreferences;

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
    _p2pMediaEnabled = widget.p2pMediaPreferences?.enabled ?? false;
    widget.p2pMediaPreferences?.addListener(_onP2pPreferenceChanged);
    _overlayPreferences =
        widget.overlayPreferences?.value ??
        const PlaybackOverlayPreferenceValues();
    _showVideoDanmaku = _overlayPreferences.videoDanmakuEnabled;
    _showChatDanmaku = _overlayPreferences.chatDanmakuEnabled;
    widget.overlayPreferences?.addListener(_onOverlayPreferencesChanged);
    _restorePersistedVolume();
    _startHideTimer();
    unawaited(_loadDefaultSubtitles());
  }

  void _onDanmakuUpdate() {
    if (mounted) setState(() {});
  }

  void _onOverlayPreferencesChanged() {
    if (!mounted || widget.overlayPreferences == null) return;
    setState(() {
      _overlayPreferences = widget.overlayPreferences!.value;
      _showVideoDanmaku = _overlayPreferences.videoDanmakuEnabled;
      _showChatDanmaku = _overlayPreferences.chatDanmakuEnabled;
    });
  }

  void _onP2pPreferenceChanged() {
    if (!mounted || widget.p2pMediaPreferences == null) return;
    setState(() => _p2pMediaEnabled = widget.p2pMediaPreferences!.enabled);
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
    if (widget.overlayPreferences != oldWidget.overlayPreferences) {
      oldWidget.overlayPreferences?.removeListener(
        _onOverlayPreferencesChanged,
      );
      widget.overlayPreferences?.addListener(_onOverlayPreferencesChanged);
      _overlayPreferences =
          widget.overlayPreferences?.value ??
          const PlaybackOverlayPreferenceValues();
      _showVideoDanmaku = _overlayPreferences.videoDanmakuEnabled;
      _showChatDanmaku = _overlayPreferences.chatDanmakuEnabled;
    }
    if (widget.p2pMediaPreferences != oldWidget.p2pMediaPreferences) {
      oldWidget.p2pMediaPreferences?.removeListener(_onP2pPreferenceChanged);
      widget.p2pMediaPreferences?.addListener(_onP2pPreferenceChanged);
      _p2pMediaEnabled = widget.p2pMediaPreferences?.enabled ?? false;
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
    widget.p2pMediaPreferences?.removeListener(_onP2pPreferenceChanged);
    widget.overlayPreferences?.removeListener(_onOverlayPreferencesChanged);
    _hideTimer?.cancel();
    _closeVolumeMenu();
    _overflowMenuFuture = null;
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
      format: subtitle['format']?.toString(),
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
    String? format,
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
        if (_parseBilibiliJsonSubtitles(content, format: format)) {
          // Bilibili player-v2 subtitle documents use JSON body entries.
        } else if (content.contains('[Script Info]') ||
            content.contains('[Events]')) {
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

  bool _parseBilibiliJsonSubtitles(String content, {String? format}) {
    if (format?.trim().toLowerCase() != 'json') return false;
    try {
      final decoded = jsonDecode(content);
      if (decoded is! Map || decoded['body'] is! List) return false;

      final items = <_SubtitleItem>[];
      for (final value in decoded['body'] as List) {
        if (value is! Map) continue;
        final startSeconds = _subtitleSeconds(value['from']);
        final endSeconds = _subtitleSeconds(value['to']);
        final text = sanitizeSubtitleText(value['content']?.toString() ?? '');
        if (startSeconds == null ||
            endSeconds == null ||
            endSeconds < startSeconds ||
            text.isEmpty) {
          continue;
        }
        items.add(
          _SubtitleItem(
            Duration(milliseconds: (startSeconds * 1000).round()),
            Duration(milliseconds: (endSeconds * 1000).round()),
            text,
          ),
        );
      }
      _subtitleItems
        ..clear()
        ..addAll(items);
      debugPrint('Parsed ${_subtitleItems.length} Bilibili subtitles');
      return true;
    } catch (error) {
      debugPrint('Bilibili subtitle JSON parse error: $error');
      return false;
    }
  }

  double? _subtitleSeconds(Object? value) => switch (value) {
    num value => value.toDouble(),
    String value => double.tryParse(value),
    _ => null,
  };

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
    widget.danmakuController!.replaceVideoItems(danmakuItems);
    debugPrint(
      'Parsed and added ${danmakuItems.length} danmaku items from ASS',
    );
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
    _isDesktopPointerInside = true;
    _hideTimer?.cancel();
    if (mounted && !_showControls) {
      setState(() => _showControls = true);
    }
  }

  void _handleDesktopPointerHover(PointerHoverEvent event) {
    _showDesktopControls();
  }

  void _hideDesktopControlsIfIdle() {
    if (!mounted ||
        !widget.controller.value.isPlaying ||
        _isDragging ||
        _isSliderDragging ||
        _isVolumeControlHovered ||
        _isVolumeSliderDragging ||
        _isPlaybackSpeedMenuOpen ||
        _isDesktopPointerInside) {
      return;
    }
    setState(() {
      _showControls = false;
    });
    _closeVolumeMenu();
  }

  void _scheduleDesktopControlsHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(
      const Duration(milliseconds: 900),
      _hideDesktopControlsIfIdle,
    );
  }

  void _handlePlaybackSpeedMenuVisibilityChanged(bool isVisible) {
    _isPlaybackSpeedMenuOpen = isVisible;
    if (isVisible) {
      _hideTimer?.cancel();
    } else if (_isDesktopMode && !_isDesktopPointerInside) {
      _scheduleDesktopControlsHide();
    }
  }

  void _handleDesktopPointerExit(PointerExitEvent event) {
    if (!_isDesktopMode) return;
    _isDesktopPointerInside = false;
    if (!widget.controller.value.isPlaying) return;
    _scheduleDesktopControlsHide();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
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

  Widget _buildSpeedControl(
    VideoPlayerValue value,
    double iconSize, {
    VoidCallback? onChanged,
    Key? key,
  }) {
    return _PlaybackSpeedMenuButton(
      key: key,
      currentSpeed: value.playbackSpeed,
      options: _playbackSpeedOptions(),
      dimension: widget.isFullScreen ? 40 : max(32.0, iconSize + 12),
      iconSize: widget.isFullScreen ? 24 : iconSize,
      onMenuVisibilityChanged: _handlePlaybackSpeedMenuVisibilityChanged,
      onSelected: (speed) async {
        await _setPlaybackSpeedFromUser(speed);
        onChanged?.call();
      },
    );
  }

  void _toggleDanmaku(DanmakuOrigin source) {
    final preferences = widget.overlayPreferences;
    setState(() {
      switch (source) {
        case DanmakuOrigin.video:
          _showVideoDanmaku = !_showVideoDanmaku;
          break;
        case DanmakuOrigin.chat:
          _showChatDanmaku = !_showChatDanmaku;
          break;
      }
    });
    if (preferences == null) return;
    final value = preferences.value.copyWith(
      videoDanmakuEnabled: _showVideoDanmaku,
      chatDanmakuEnabled: _showChatDanmaku,
    );
    unawaited(preferences.save(value));
  }

  bool _danmakuEnabled(DanmakuOrigin source) => switch (source) {
    DanmakuOrigin.video => _showVideoDanmaku,
    DanmakuOrigin.chat => _showChatDanmaku,
  };

  Widget _buildDanmakuControl(
    double iconSize, {
    required DanmakuOrigin source,
    VoidCallback? onChanged,
  }) {
    final enabled = _danmakuEnabled(source);
    final isVideo = source == DanmakuOrigin.video;
    return _PlayerIconButton(
      key: ValueKey(
        isVideo
            ? 'playback_video_danmaku_button'
            : 'playback_chat_danmaku_button',
      ),
      icon: isVideo ? Icons.subtitles_rounded : Icons.forum_rounded,
      tooltip: switch ((source, enabled)) {
        (DanmakuOrigin.video, true) => context.l10n.disableVideoDanmaku,
        (DanmakuOrigin.video, false) => context.l10n.enableVideoDanmaku,
        (DanmakuOrigin.chat, true) => context.l10n.disableChatDanmaku,
        (DanmakuOrigin.chat, false) => context.l10n.enableChatDanmaku,
      },
      selected: enabled,
      onPressed: () {
        _toggleDanmaku(source);
        onChanged?.call();
      },
      padding: widget.isFullScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
      constraints: widget.isFullScreen ? null : const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  Widget _buildP2pMediaControl(double iconSize) {
    return _PlayerIconButton(
      key: const Key('playback_p2p_media_button'),
      icon: Icons.hub_rounded,
      tooltip: context.l10n.p2pMedia,
      selected: _p2pMediaEnabled,
      onPressed: () => _setP2pMediaEnabled(!_p2pMediaEnabled),
      padding: widget.isFullScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
      constraints: widget.isFullScreen ? null : const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  Widget _buildOverlaySettingsControl(
    double iconSize, {
    required String tooltip,
    required VoidCallback onPressed,
    required Key key,
  }) {
    return _PlayerIconButton(
      key: key,
      icon: Icons.tune_rounded,
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      iconSize: widget.isFullScreen ? 24 : iconSize,
    );
  }

  void _setP2pMediaEnabled(bool enabled) {
    final preferences = widget.p2pMediaPreferences;
    if (preferences == null || preferences.enabled == enabled) return;
    unawaited(preferences.setEnabled(enabled));
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

  Future<void> _openOverflowMenu(
    BuildContext anchorContext,
    List<
      ({
        String label,
        IconData icon,
        Widget Function(VoidCallback onChanged) build,
        VoidCallback? onPressed,
        bool Function()? switchValue,
        ValueChanged<bool>? onSwitchChanged,
        bool dismissOnSwitch,
      })
    >
    controls,
  ) async {
    if (_overflowMenuFuture != null) return;
    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    final overlayBox =
        Navigator.of(
              context,
              rootNavigator: true,
            ).overlay?.context.findRenderObject()
            as RenderBox?;
    if (renderBox == null || overlayBox == null || !renderBox.hasSize) return;

    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final bottomRight = renderBox.localToGlobal(
      renderBox.size.bottomRight(Offset.zero),
      ancestor: overlayBox,
    );
    final menuWidth = min(280.0, max(48.0, overlayBox.size.width - 16));
    final menuLeft = (bottomRight.dx - menuWidth)
        .clamp(8.0, max(8.0, overlayBox.size.width - menuWidth - 8))
        .toDouble();
    final controlsHeight = controls.fold<double>(
      0,
      (height, control) => height + (control.onSwitchChanged == null ? 40 : 52),
    );
    final contentHeight =
        8.0 +
        (widget.onFreeModeChanged == null ? 0 : 52.0) +
        (controls.isEmpty
            ? 0
            : controlsHeight + max(0, controls.length - 1) * 4.0);
    final menuHeight = 16.0 + contentHeight;
    final menuTop = (topLeft.dy - menuHeight - 8)
        .clamp(8.0, max(8.0, overlayBox.size.height - menuHeight - 8))
        .toDouble();
    var freeModeEnabled = widget.freeModeEnabled;

    final future = showMenu<bool>(
      context: context,
      useRootNavigator: true,
      popUpAnimationStyle: playerControlPopupAnimationStyle,
      color: const Color(0xF21A1A24),
      constraints: BoxConstraints.tightFor(width: menuWidth),
      position: RelativeRect.fromLTRB(
        menuLeft,
        menuTop,
        overlayBox.size.width - bottomRight.dx,
        overlayBox.size.height - bottomRight.dy + 8,
      ),
      items: [
        _PlayerControlsPopupEntry(
          key: const Key('playback_overflow_controls'),
          entryHeight: contentHeight,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: StatefulBuilder(
              builder: (context, setMenuState) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.onFreeModeChanged != null)
                    _PlayerOverflowSwitchRow(
                      key: const Key('free_mode_toggle'),
                      icon: Icons.explore_rounded,
                      label: context.l10n.freeMode,
                      value: freeModeEnabled,
                      onChanged: (enabled) {
                        setMenuState(() => freeModeEnabled = enabled);
                        widget.onFreeModeChanged?.call(enabled);
                      },
                    ),
                  if (controls.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (
                          var index = 0;
                          index < controls.length;
                          index++
                        ) ...[
                          if (index > 0) const SizedBox(height: 4),
                          if (controls[index].onSwitchChanged
                              case final onSwitchChanged?)
                            SizedBox(
                              key: ValueKey(
                                'playback_overflow_control_slot_$index',
                              ),
                              height: 52,
                              child: _PlayerOverflowSwitchRow(
                                icon: controls[index].icon,
                                label: controls[index].label,
                                value:
                                    controls[index].switchValue?.call() ??
                                    false,
                                onChanged: (enabled) {
                                  if (controls[index].dismissOnSwitch) {
                                    Navigator.of(context).pop();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          onSwitchChanged(enabled);
                                        });
                                    return;
                                  }
                                  onSwitchChanged(enabled);
                                  if (context.mounted) {
                                    setMenuState(() {});
                                  }
                                },
                              ),
                            )
                          else
                            SizedBox(
                              key: ValueKey(
                                'playback_overflow_control_slot_$index',
                              ),
                              height: 40,
                              child: _PlayerOverflowActionRow(
                                icon: controls[index].icon,
                                label: controls[index].label,
                                onPressed: controls[index].onPressed == null
                                    ? null
                                    : () {
                                        controls[index].onPressed!.call();
                                        if (context.mounted) {
                                          setMenuState(() {});
                                        }
                                      },
                              ),
                            ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
    _overflowMenuFuture = future;
    unawaited(
      future.whenComplete(() {
        if (!mounted) return;
        if (identical(_overflowMenuFuture, future)) {
          _overflowMenuFuture = null;
        }
      }),
    );
  }

  Widget _buildOverflowButton(
    BuildContext anchorContext,
    List<
      ({
        String label,
        IconData icon,
        Widget Function(VoidCallback onChanged) build,
        VoidCallback? onPressed,
        bool Function()? switchValue,
        ValueChanged<bool>? onSwitchChanged,
        bool dismissOnSwitch,
      })
    >
    controls,
    double iconSize,
  ) {
    return _PlayerIconButton(
      key: const Key('playback_overflow_button'),
      icon: Icons.settings_rounded,
      tooltip: context.l10n.moreActions,
      onPressed: () => unawaited(_openOverflowMenu(anchorContext, controls)),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: EdgeInsets.zero,
      iconSize: iconSize,
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

  void _showVolumeMenu(double buttonSize) {
    _volumeOverlayHideTimer?.cancel();
    _hideTimer?.cancel();
    if (_volumeOverlayEntry == null) _openVolumeMenu(buttonSize);
  }

  void _openVolumeMenu(double buttonSize) {
    final anchorBox =
        _volumeAnchorKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox =
        Navigator.of(
              context,
              rootNavigator: true,
            ).overlay?.context.findRenderObject()
            as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize || overlayBox == null) return;
    final overlay = Overlay.of(context, rootOverlay: true);

    final anchorTopLeft = anchorBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    const menuSize = Size(44, 132);
    final left = (anchorTopLeft.dx + (buttonSize - menuSize.width) / 2)
        .clamp(0.0, max(0.0, overlayBox.size.width - menuSize.width))
        .toDouble();
    final top = (anchorTopLeft.dy - menuSize.height)
        .clamp(0.0, max(0.0, overlayBox.size.height - menuSize.height))
        .toDouble();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: left,
        top: top,
        child: MouseRegion(
          key: const Key('desktop_volume_menu_hover_region'),
          onEnter: (_) {
            _isVolumeMenuHovered = true;
            _volumeOverlayHideTimer?.cancel();
          },
          onHover: (_) {
            _isVolumeMenuHovered = true;
            _volumeOverlayHideTimer?.cancel();
          },
          onExit: (_) {
            _isVolumeMenuHovered = false;
            _scheduleVolumeMenuHide();
          },
          child: Material(
            color: const Color(0xF21A1A24),
            elevation: 8,
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: menuSize.width,
              height: menuSize.height,
              child: _buildVolumeSlider(),
            ),
          ),
        ),
      ),
    );
    _volumeOverlayEntry = entry;
    overlay.insert(entry);
  }

  Widget _buildVolumeSlider() => ValueListenableBuilder<VideoPlayerValue>(
    valueListenable: widget.controller,
    builder: (context, value, _) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 3,
          activeTrackColor: const Color(0xFF5D5FEF),
          inactiveTrackColor: Colors.white24,
          thumbColor: Colors.white,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        ),
        child: RotatedBox(
          quarterTurns: 3,
          child: Slider(
            key: const Key('desktop_volume_slider'),
            value: value.volume.clamp(0.0, 1.0).toDouble(),
            min: 0,
            max: 1,
            onChangeStart: (_) {
              _isVolumeSliderDragging = true;
              _volumeOverlayHideTimer?.cancel();
            },
            onChanged: _setPlayerVolume,
            onChangeEnd: (_) {
              _isVolumeSliderDragging = false;
              if (!_isVolumeControlHovered) _scheduleVolumeMenuHide();
            },
          ),
        ),
      ),
    ),
  );

  void _closeVolumeMenu() {
    _volumeOverlayHideTimer?.cancel();
    _isVolumeButtonHovered = false;
    _isVolumeMenuHovered = false;
    final entry = _volumeOverlayEntry;
    _volumeOverlayEntry = null;
    entry?.remove();
    entry?.dispose();
  }

  void _scheduleVolumeMenuHide() {
    _volumeOverlayHideTimer?.cancel();
    _volumeOverlayHideTimer = Timer(playerControlHoverDismissDelay, () {
      if (_isVolumeControlHovered || _isVolumeSliderDragging) return;
      _closeVolumeMenu();
      if (_isDesktopMode && !_isDesktopPointerInside) {
        _scheduleDesktopControlsHide();
      } else {
        _startHideTimer();
      }
    });
  }

  Widget _buildHoverVolumeControl(
    VideoPlayerValue videoValue, {
    required double iconSize,
    VoidCallback? onChanged,
  }) {
    final buttonSize = max(32.0, iconSize + 12);
    return MouseRegion(
      key: _volumeAnchorKey,
      onEnter: (_) {
        _isVolumeButtonHovered = true;
        _showVolumeMenu(buttonSize);
      },
      onHover: (_) {
        _isVolumeButtonHovered = true;
        _showVolumeMenu(buttonSize);
      },
      onExit: (_) {
        _isVolumeButtonHovered = false;
        _scheduleVolumeMenuHide();
      },
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
        onPressed: () async {
          await _toggleMute();
          onChanged?.call();
        },
      ),
    );
  }

  void _showSubtitleMenu() {
    final hasSubtitles = widget.subtitles?.isNotEmpty == true;
    if (!hasSubtitles) return;

    showAppBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AppSafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: AppSingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.closed_caption_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.l10n.chooseSubtitles,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      AppIconButton(
                        tooltip: context.l10n.close,
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.close_rounded,
                      ),
                    ],
                  ),
                ),
                _PlayerSubtitleSelectionRow(
                  icon: Icons.subtitles_off_rounded,
                  label: context.l10n.disableSubtitles,
                  selected: _subtitlesDisabled || _selectedSubtitleKey == null,
                  onPressed: () {
                    _subtitlesDisabled = true;
                    _selectedSubtitleKey = null;
                    _clearSubtitles();
                    widget.onSubtitleP2pDeactivated?.call();
                    Navigator.pop(context);
                  },
                ),
                for (final e in widget.subtitles!.entries)
                  _PlayerSubtitleSelectionRow(
                    icon: Icons.closed_caption_rounded,
                    label: subtitleDisplayLabel(e.key, e.value),
                    selected:
                        !_subtitlesDisabled && _selectedSubtitleKey == e.key,
                    onPressed: () {
                      unawaited(_loadSubtitleByKey(e.key));
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlaySettings(_OverlaySettingsSection section) {
    if (widget.overlayPreferences == null) return;
    showAppBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AppSafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: AppSingleChildScrollView(
            child: _buildOverlaySettingsSection(context, section: section),
          ),
        ),
      ),
    );
  }

  void _showSubtitleSettings() =>
      _showOverlaySettings(_OverlaySettingsSection.subtitle);

  void _showVideoDanmakuSettings() =>
      _showOverlaySettings(_OverlaySettingsSection.videoDanmaku);

  void _showChatDanmakuSettings() =>
      _showOverlaySettings(_OverlaySettingsSection.chatDanmaku);

  Widget _buildOverlaySettingsSection(
    BuildContext context, {
    required _OverlaySettingsSection section,
  }) {
    final preferences = widget.overlayPreferences;
    if (preferences == null) return const SizedBox.shrink();
    PlaybackOverlayPreferenceValues updateDanmakuStyle(
      PlaybackOverlayPreferenceValues values,
      DanmakuOverlayStyle Function(DanmakuOverlayStyle style) update,
    ) => switch (section) {
      _OverlaySettingsSection.videoDanmaku => values.copyWith(
        videoDanmakuStyle: update(values.videoDanmakuStyle),
      ),
      _OverlaySettingsSection.chatDanmaku => values.copyWith(
        chatDanmakuStyle: update(values.chatDanmakuStyle),
      ),
      _OverlaySettingsSection.subtitle => values,
    };
    Widget slider({
      required String label,
      required double value,
      required double min,
      required double max,
      required PlaybackOverlayPreferenceValues Function(
        PlaybackOverlayPreferenceValues style,
        double value,
      )
      update,
      String Function(double value)? valueLabel,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  valueLabel?.call(value) ?? value.toStringAsFixed(0),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) * 10).round(),
              onChanged: (next) =>
                  unawaited(preferences.save(update(preferences.value, next))),
            ),
          ],
        ),
      );
    }

    return ListenableBuilder(
      listenable: preferences,
      builder: (context, _) {
        final values = preferences.value;
        final danmakuStyle = switch (section) {
          _OverlaySettingsSection.videoDanmaku => values.videoDanmakuStyle,
          _OverlaySettingsSection.chatDanmaku => values.chatDanmakuStyle,
          _OverlaySettingsSection.subtitle => const DanmakuOverlayStyle(),
        };
        return ExpansionTile(
          key: const Key('playback_overlay_settings'),
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            section == _OverlaySettingsSection.subtitle
                ? context.l10n.subtitleSettings
                : section == _OverlaySettingsSection.videoDanmaku
                ? context.l10n.videoDanmakuSettings
                : context.l10n.chatDanmakuSettings,
            style: const TextStyle(color: Colors.white),
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white70,
          children: [
            if (section == _OverlaySettingsSection.subtitle) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Text(
                    context.l10n.subtitleStyle,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              slider(
                label: context.l10n.subtitleSize,
                value: values.subtitleFontSize,
                min: 12,
                max: 48,
                update: (s, v) => s.copyWith(subtitleFontSize: v),
              ),
              slider(
                label: context.l10n.subtitleOpacity,
                value: values.subtitleOpacity,
                min: 0,
                max: 1,
                update: (s, v) => s.copyWith(subtitleOpacity: v),
                valueLabel: (v) => '${(v * 100).round()}%',
              ),
              slider(
                label: context.l10n.subtitleBackground,
                value: values.subtitleBackgroundOpacity,
                min: 0,
                max: 1,
                update: (s, v) => s.copyWith(subtitleBackgroundOpacity: v),
                valueLabel: (v) => '${(v * 100).round()}%',
              ),
              slider(
                label: context.l10n.subtitlePosition,
                value: values.subtitleBottom,
                min: 0,
                max: 0.3,
                update: (s, v) => s.copyWith(subtitleBottom: v),
                valueLabel: (v) => '${(v * 100).round()}%',
              ),
              _buildColorSelector(
                context,
                label: context.l10n.subtitleColor,
                value: Color(_overlayStyle.subtitleColor),
                onChanged: (color) => unawaited(
                  preferences.save(
                    preferences.value.copyWith(subtitleColor: color.toARGB32()),
                  ),
                ),
              ),
              _buildColorSelector(
                context,
                label: context.l10n.subtitleBackgroundColor,
                value: Color(_overlayStyle.subtitleBackgroundColor),
                onChanged: (color) => unawaited(
                  preferences.save(
                    preferences.value.copyWith(
                      subtitleBackgroundColor: color.toARGB32(),
                    ),
                  ),
                ),
              ),
              slider(
                label: context.l10n.subtitleOutline,
                value: values.subtitleOutlineWidth,
                min: 0,
                max: 6,
                update: (s, v) => s.copyWith(subtitleOutlineWidth: v),
                valueLabel: (v) => v.toStringAsFixed(1),
              ),
            ],
            if (section != _OverlaySettingsSection.subtitle) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Text(
                    section == _OverlaySettingsSection.videoDanmaku
                        ? context.l10n.videoDanmakuStyle
                        : context.l10n.chatDanmakuStyle,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              slider(
                label: context.l10n.danmakuSize,
                value: danmakuStyle.fontSize,
                min: 12,
                max: 64,
                update: (s, v) => updateDanmakuStyle(
                  s,
                  (style) => style.copyWith(fontSize: v),
                ),
              ),
              slider(
                label: context.l10n.danmakuOpacity,
                value: danmakuStyle.opacity,
                min: 0,
                max: 1,
                update: (s, v) => updateDanmakuStyle(
                  s,
                  (style) => style.copyWith(opacity: v),
                ),
                valueLabel: (v) => '${(v * 100).round()}%',
              ),
              slider(
                label: context.l10n.danmakuSpeed,
                value: danmakuStyle.duration,
                min: 3,
                max: 20,
                update: (s, v) => updateDanmakuStyle(
                  s,
                  (style) => style.copyWith(duration: v),
                ),
                valueLabel: (v) => '${v.toStringAsFixed(0)}s',
              ),
              slider(
                label: context.l10n.danmakuArea,
                value: danmakuStyle.area,
                min: 0.1,
                max: 1,
                update: (s, v) =>
                    updateDanmakuStyle(s, (style) => style.copyWith(area: v)),
                valueLabel: (v) => '${(v * 100).round()}%',
              ),
              slider(
                label: context.l10n.danmakuOutline,
                value: danmakuStyle.strokeWidth,
                min: 0,
                max: 6,
                update: (s, v) => updateDanmakuStyle(
                  s,
                  (style) => style.copyWith(strokeWidth: v),
                ),
                valueLabel: (v) => v.toStringAsFixed(1),
              ),
              SwitchListTile(
                value: danmakuStyle.massiveMode,
                title: Text(
                  context.l10n.danmakuMassiveMode,
                  style: const TextStyle(color: Colors.white),
                ),
                onChanged: (value) => unawaited(
                  preferences.save(
                    updateDanmakuStyle(
                      values,
                      (style) => style.copyWith(massiveMode: value),
                    ),
                  ),
                ),
              ),
              for (final entry in <(String, bool, ValueChanged<bool>)>[
                (
                  context.l10n.danmakuTop,
                  !danmakuStyle.hideTop,
                  (v) => unawaited(
                    preferences.save(
                      updateDanmakuStyle(
                        values,
                        (style) => style.copyWith(hideTop: !v),
                      ),
                    ),
                  ),
                ),
                (
                  context.l10n.danmakuBottom,
                  !danmakuStyle.hideBottom,
                  (v) => unawaited(
                    preferences.save(
                      updateDanmakuStyle(
                        values,
                        (style) => style.copyWith(hideBottom: !v),
                      ),
                    ),
                  ),
                ),
                (
                  context.l10n.danmakuScroll,
                  !danmakuStyle.hideScroll,
                  (v) => unawaited(
                    preferences.save(
                      updateDanmakuStyle(
                        values,
                        (style) => style.copyWith(hideScroll: !v),
                      ),
                    ),
                  ),
                ),
              ])
                SwitchListTile(
                  value: entry.$2,
                  title: Text(
                    entry.$1,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onChanged: entry.$3,
                ),
            ],
            TextButton.icon(
              onPressed: () => unawaited(preferences.reset()),
              icon: const Icon(Icons.restore_rounded),
              label: Text(context.l10n.resetOverlaySettings),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorSelector(
    BuildContext context, {
    required String label,
    required Color value,
    required ValueChanged<Color> onChanged,
  }) {
    const colors = <Color>[
      Colors.white,
      Colors.yellow,
      Colors.cyan,
      Colors.lightGreen,
      Colors.orange,
      Colors.red,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          for (final color in colors)
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Semantics(
                label: label,
                button: true,
                selected: value.toARGB32() == color.toARGB32(),
                child: InkWell(
                  onTap: () => onChanged(color),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: value.toARGB32() == color.toARGB32()
                            ? Colors.white
                            : Colors.white38,
                        width: value.toARGB32() == color.toARGB32() ? 2 : 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Shadow> get _subtitleShadows {
    final width = _overlayStyle.subtitleOutlineWidth;
    if (width <= 0) return const [];
    return [
      Shadow(offset: Offset(width, 0), blurRadius: width, color: Colors.black),
      Shadow(offset: Offset(-width, 0), blurRadius: width, color: Colors.black),
      Shadow(offset: Offset(0, width), blurRadius: width, color: Colors.black),
      Shadow(offset: Offset(0, -width), blurRadius: width, color: Colors.black),
    ];
  }

  Widget _buildDanmakuOverlay(
    DanmakuOrigin source,
    DanmakuOverlayStyle style,
    bool enabled,
  ) {
    final sourceKey = source == DanmakuOrigin.video ? 'video' : 'chat';
    return DanmakuOverlay(
      key: ValueKey(
        '${sourceKey}_danmaku_${style.fontSize}_${style.opacity}_'
        '${style.duration}_${style.area}_${style.strokeWidth}_'
        '${style.massiveMode}_${style.hideTop}_${style.hideBottom}_'
        '${style.hideScroll}',
      ),
      videoController: widget.controller,
      danmakuList: widget.danmakuController?.items ?? const [],
      origin: source,
      isEnabled: enabled,
      option: _danmakuOption(style),
    );
  }

  Widget _buildVideoContent(VideoPlayerValue videoValue) {
    final aspectRatio = videoValue.aspectRatio > 0
        ? videoValue.aspectRatio
        : 16 / 9;
    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentHeight = constraints.maxHeight;
            final controlsInset = _showControls
                ? (widget.isFullScreen ? 72.0 : 48.0)
                : 8.0;
            return Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayer(widget.controller),
                Positioned.fill(
                  child: IgnorePointer(
                    child: ExcludeSemantics(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildDanmakuOverlay(
                            DanmakuOrigin.video,
                            _overlayStyle.videoDanmakuStyle,
                            _showVideoDanmaku,
                          ),
                          _buildDanmakuOverlay(
                            DanmakuOrigin.chat,
                            _overlayStyle.chatDanmakuStyle,
                            _showChatDanmaku,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_currentSubtitle.isNotEmpty)
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: min(
                      contentHeight * 0.28,
                      max(
                        8.0,
                        controlsInset +
                            contentHeight * _overlayStyle.subtitleBottom,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: subtitleBackgroundColor(
                            _overlayStyle.subtitleBackgroundOpacity,
                            color: _overlayStyle.subtitleBackgroundColor,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth - 24,
                            ),
                            child: Text(
                              _currentSubtitle,
                              textScaler: const TextScaler.linear(1),
                              style: TextStyle(
                                color: Color(_overlayStyle.subtitleColor)
                                    .withValues(
                                      alpha: _overlayStyle.subtitleOpacity,
                                    ),
                                fontSize: _overlayStyle.subtitleFontSize,
                                height: 1.2,
                                shadows: _subtitleShadows,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
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
          onHover: _handleDesktopPointerHover,
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
                _buildVideoContent(videoValue),
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
                                final controlGap = widget.isFullScreen
                                    ? 0.0
                                    : 4.0;
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
                                    <
                                      ({
                                        String label,
                                        IconData icon,
                                        Widget Function(VoidCallback onChanged)
                                        build,
                                        VoidCallback? onPressed,
                                        bool Function()? switchValue,
                                        ValueChanged<bool>? onSwitchChanged,
                                        bool dismissOnSwitch,
                                        bool visible,
                                      })
                                    >[
                                      if (_isDesktopMode)
                                        (
                                          label: videoValue.volume <= 0.01
                                              ? context.l10n.unmute
                                              : context.l10n.mute,
                                          icon: _volumeIcon(videoValue.volume),
                                          build: (onChanged) =>
                                              _buildHoverVolumeControl(
                                                widget.controller.value,
                                                iconSize: widget.isFullScreen
                                                    ? 24
                                                    : 20,
                                                onChanged: onChanged,
                                              ),
                                          onPressed: () {
                                            unawaited(_toggleMute());
                                          },
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: visibility.showVolume,
                                        ),
                                      if (widget.subtitles?.isNotEmpty == true)
                                        (
                                          label: context.l10n.subtitles,
                                          icon: Icons.closed_caption_rounded,
                                          build: (_) =>
                                              _buildSubtitleControl(iconSize),
                                          onPressed: _showSubtitleMenu,
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: visibility.showSubtitles,
                                        ),
                                      if (widget.canControlPlayback &&
                                          !widget.isLive)
                                        (
                                          label: context.l10n.playbackSpeed,
                                          icon: Icons.speed_rounded,
                                          build: (onChanged) =>
                                              _buildSpeedControl(
                                                widget.controller.value,
                                                iconSize,
                                                onChanged: onChanged,
                                                key: _speedMenuKey,
                                              ),
                                          onPressed: () => _speedMenuKey
                                              .currentState
                                              ?.openMenuFromOverflow(),
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: visibility.showSpeed,
                                        ),
                                      (
                                        label: context.l10n.videoDanmaku,
                                        icon: Icons.subtitles_rounded,
                                        build: (onChanged) =>
                                            _buildDanmakuControl(
                                              iconSize,
                                              source: DanmakuOrigin.video,
                                              onChanged: onChanged,
                                            ),
                                        onPressed: () =>
                                            _toggleDanmaku(DanmakuOrigin.video),
                                        switchValue: () => _showVideoDanmaku,
                                        onSwitchChanged: (_) =>
                                            _toggleDanmaku(DanmakuOrigin.video),
                                        dismissOnSwitch: false,
                                        visible: visibility.showVideoDanmaku,
                                      ),
                                      (
                                        label: context.l10n.chatDanmaku,
                                        icon: Icons.forum_rounded,
                                        build: (onChanged) =>
                                            _buildDanmakuControl(
                                              iconSize,
                                              source: DanmakuOrigin.chat,
                                              onChanged: onChanged,
                                            ),
                                        onPressed: () =>
                                            _toggleDanmaku(DanmakuOrigin.chat),
                                        switchValue: () => _showChatDanmaku,
                                        onSwitchChanged: (_) =>
                                            _toggleDanmaku(DanmakuOrigin.chat),
                                        dismissOnSwitch: false,
                                        visible: false,
                                      ),
                                      if (widget.p2pMediaPreferences
                                          case final p2pPreferences?)
                                        (
                                          label: context.l10n.p2pMedia,
                                          icon: Icons.hub_rounded,
                                          build: (_) =>
                                              _buildP2pMediaControl(iconSize),
                                          onPressed: () => unawaited(
                                            p2pPreferences.setEnabled(
                                              !p2pPreferences.enabled,
                                            ),
                                          ),
                                          switchValue: () =>
                                              p2pPreferences.enabled,
                                          onSwitchChanged: (enabled) =>
                                              unawaited(
                                                p2pPreferences.setEnabled(
                                                  enabled,
                                                ),
                                              ),
                                          dismissOnSwitch: true,
                                          visible: false,
                                        ),
                                      if (widget.overlayPreferences != null)
                                        (
                                          label: context.l10n.subtitleSettings,
                                          icon: Icons.closed_caption_rounded,
                                          build: (_) =>
                                              _buildOverlaySettingsControl(
                                                iconSize,
                                                tooltip: context
                                                    .l10n
                                                    .subtitleSettings,
                                                onPressed:
                                                    _showSubtitleSettings,
                                                key: const Key(
                                                  'playback_subtitle_settings_button',
                                                ),
                                              ),
                                          onPressed: _showSubtitleSettings,
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: false,
                                        ),
                                      if (widget.overlayPreferences != null &&
                                          widget.danmakuController != null)
                                        (
                                          label:
                                              context.l10n.videoDanmakuSettings,
                                          icon: Icons.subtitles_rounded,
                                          build: (_) =>
                                              _buildOverlaySettingsControl(
                                                iconSize,
                                                tooltip: context
                                                    .l10n
                                                    .videoDanmakuSettings,
                                                onPressed:
                                                    _showVideoDanmakuSettings,
                                                key: const Key(
                                                  'playback_video_danmaku_settings_button',
                                                ),
                                              ),
                                          onPressed: _showVideoDanmakuSettings,
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: false,
                                        ),
                                      if (widget.overlayPreferences != null &&
                                          widget.danmakuController != null)
                                        (
                                          label:
                                              context.l10n.chatDanmakuSettings,
                                          icon: Icons.forum_rounded,
                                          build: (_) =>
                                              _buildOverlaySettingsControl(
                                                iconSize,
                                                tooltip: context
                                                    .l10n
                                                    .chatDanmakuSettings,
                                                onPressed:
                                                    _showChatDanmakuSettings,
                                                key: const Key(
                                                  'playback_chat_danmaku_settings_button',
                                                ),
                                              ),
                                          onPressed: _showChatDanmakuSettings,
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: false,
                                        ),
                                      if (widget.onSync != null)
                                        (
                                          label: widget.isLive
                                              ? context.l10n.reload
                                              : context.l10n.sync,
                                          icon: widget.isLive
                                              ? Icons.refresh_rounded
                                              : Icons.sync_rounded,
                                          build: (_) =>
                                              _buildSyncControl(iconSize),
                                          onPressed: widget.onSync,
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: visibility.showSync,
                                        ),
                                      if (widget.extraBottomWidget
                                          case final control?)
                                        (
                                          label: context.l10n.playbackRoute,
                                          icon: Icons.route_rounded,
                                          build: (_) => control,
                                          onPressed: null,
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: visibility.showPlaybackRoute,
                                        ),
                                      if (widget.isFullScreen &&
                                          widget.onSendDanmaku != null)
                                        (
                                          label: context.l10n.sendDanmaku,
                                          icon: Icons.send_rounded,
                                          build: (_) =>
                                              _buildSendDanmakuControl(),
                                          onPressed: _showDanmakuInput,
                                          switchValue: null,
                                          onSwitchChanged: null,
                                          dismissOnSwitch: false,
                                          visible: visibility.showSendDanmaku,
                                        ),
                                      if (widget.onEnterPictureInPicture !=
                                          null)
                                        (
                                          label: context.l10n.pictureInPicture,
                                          icon: Icons
                                              .picture_in_picture_alt_rounded,
                                          build: (_) => PictureInPictureControl(
                                            tooltip:
                                                context.l10n.pictureInPicture,
                                            onPressed:
                                                widget.onEnterPictureInPicture!,
                                            iconSize: widget.isFullScreen
                                                ? 24
                                                : iconSize,
                                          ),
                                          onPressed:
                                              widget.onEnterPictureInPicture,
                                          switchValue: () => false,
                                          onSwitchChanged: (enabled) {
                                            if (enabled) {
                                              widget.onEnterPictureInPicture
                                                  ?.call();
                                            }
                                          },
                                          dismissOnSwitch: true,
                                          visible:
                                              visibility.showPictureInPicture,
                                        ),
                                    ];
                                final hiddenControls =
                                    <
                                      ({
                                        String label,
                                        IconData icon,
                                        Widget Function(VoidCallback onChanged)
                                        build,
                                        VoidCallback? onPressed,
                                        bool Function()? switchValue,
                                        ValueChanged<bool>? onSwitchChanged,
                                        bool dismissOnSwitch,
                                      })
                                    >[
                                      for (final entry in controls)
                                        if (!entry.visible)
                                          (
                                            label: entry.label,
                                            icon: entry.icon,
                                            build: entry.build,
                                            onPressed: entry.onPressed,
                                            switchValue: entry.switchValue,
                                            onSwitchChanged:
                                                entry.onSwitchChanged,
                                            dismissOnSwitch:
                                                entry.dismissOnSwitch,
                                          ),
                                    ];
                                final fullscreenControl =
                                    widget.onToggleFullScreen == null
                                    ? null
                                    : _buildFullscreenControl(iconSize);
                                final showOverflow =
                                    hiddenControls.isNotEmpty ||
                                    widget.onFreeModeChanged != null;

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
                                            SizedBox(width: controlGap),
                                            entry.build(() {}),
                                          ],
                                        if (showOverflow) ...[
                                          SizedBox(width: controlGap),
                                          Builder(
                                            builder: (anchorContext) =>
                                                _buildOverflowButton(
                                                  anchorContext,
                                                  hiddenControls,
                                                  iconSize,
                                                ),
                                          ),
                                        ],
                                        if (fullscreenControl != null &&
                                            visibility.showFullscreen) ...[
                                          SizedBox(width: controlGap),
                                          fullscreenControl,
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

class _PlaybackSpeedMenuButton extends StatefulWidget {
  final double currentSpeed;
  final List<_PlaybackSpeedOption> options;
  final double dimension;
  final double iconSize;
  final ValueChanged<bool> onMenuVisibilityChanged;
  final ValueChanged<double> onSelected;

  const _PlaybackSpeedMenuButton({
    super.key,
    required this.currentSpeed,
    required this.options,
    required this.dimension,
    required this.iconSize,
    required this.onMenuVisibilityChanged,
    required this.onSelected,
  });

  @override
  State<_PlaybackSpeedMenuButton> createState() =>
      _PlaybackSpeedMenuButtonState();
}

class _PlaybackSpeedMenuButtonState extends State<_PlaybackSpeedMenuButton> {
  final Object _tapRegionGroup = Object();
  OverlayEntry? _menuOverlayEntry;
  Timer? _menuHideTimer;
  bool _isButtonHovered = false;
  bool _isMenuHovered = false;

  void _keepMenuOpen() => _menuHideTimer?.cancel();

  void _scheduleMenuHide() {
    _menuHideTimer?.cancel();
    if (_menuOverlayEntry == null) return;
    _menuHideTimer = Timer(playerControlHoverDismissDelay, () {
      if (!mounted || _isButtonHovered || _isMenuHovered) return;
      _closeMenu();
    });
  }

  void _openMenu() {
    _keepMenuOpen();
    if (_menuOverlayEntry != null) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final overlayBox =
        Navigator.of(
              context,
              rootNavigator: true,
            ).overlay?.context.findRenderObject()
            as RenderBox?;
    if (overlayBox == null || !overlayBox.hasSize) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    const menuWidth = 132.0;
    final left = (topLeft.dx + (renderBox.size.width - menuWidth) / 2)
        .clamp(8.0, max(8.0, overlayBox.size.width - menuWidth - 8))
        .toDouble();
    final menuHeight = widget.options.length * 36.0 + 16;
    final top = (topLeft.dy - menuHeight)
        .clamp(8.0, max(8.0, overlayBox.size.height - menuHeight - 8))
        .toDouble();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: left,
        top: top,
        child: TapRegion(
          groupId: _tapRegionGroup,
          child: MouseRegion(
            key: const Key('playback_speed_menu_hover_region'),
            onEnter: (_) {
              _isMenuHovered = true;
              _keepMenuOpen();
            },
            onHover: (_) {
              _isMenuHovered = true;
              _keepMenuOpen();
            },
            onExit: (_) {
              _isMenuHovered = false;
              _scheduleMenuHide();
            },
            child: Material(
              color: const Color(0xF21A1A24),
              elevation: 8,
              borderRadius: BorderRadius.circular(6),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: menuWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in widget.options)
                        SizedBox(
                          height: 36,
                          child: InkWell(
                            key: ValueKey(
                              'playback_speed_option_${option.speed}',
                            ),
                            onTap: () {
                              _closeMenu();
                              widget.onSelected(option.speed);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    (widget.currentSpeed - option.speed).abs() <
                                            0.001
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    size: 18,
                                    color:
                                        (widget.currentSpeed - option.speed)
                                                .abs() <
                                            0.001
                                        ? const Color(0xFF7CFFB2)
                                        : Colors.white70,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    option.label,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    _menuOverlayEntry = entry;
    overlay.insert(entry);
    widget.onMenuVisibilityChanged(true);
  }

  void openMenuFromOverflow() {
    _openMenu();
  }

  void _closeMenu() {
    _menuHideTimer?.cancel();
    _isMenuHovered = false;
    final entry = _menuOverlayEntry;
    _menuOverlayEntry = null;
    if (entry == null) return;
    entry.remove();
    entry.dispose();
    widget.onMenuVisibilityChanged(false);
  }

  @override
  void didUpdateWidget(_PlaybackSpeedMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final entry = _menuOverlayEntry;
    if (entry == null ||
        (oldWidget.currentSpeed == widget.currentSpeed &&
            _samePlaybackSpeedOptions(oldWidget.options, widget.options))) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && identical(_menuOverlayEntry, entry)) {
        entry.markNeedsBuild();
      }
    });
  }

  bool _samePlaybackSpeedOptions(
    List<_PlaybackSpeedOption> previous,
    List<_PlaybackSpeedOption> next,
  ) {
    if (previous.length != next.length) return false;
    for (var index = 0; index < previous.length; index++) {
      if (previous[index].speed != next[index].speed ||
          previous[index].label != next[index].label) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.playbackSpeed,
      child: TapRegion(
        groupId: _tapRegionGroup,
        onTapOutside: (_) => _closeMenu(),
        child: AppTooltip(
          message: context.l10n.playbackSpeedValue(
            widget.currentSpeed.toStringAsFixed(2),
          ),
          child: MouseRegion(
            onEnter: (_) {
              _isButtonHovered = true;
              _keepMenuOpen();
              _openMenu();
            },
            onHover: (_) {
              _isButtonHovered = true;
              _keepMenuOpen();
            },
            onExit: (_) {
              _isButtonHovered = false;
              _scheduleMenuHide();
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _openMenu,
              child: AppInkSurface(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(widget.dimension / 2),
                child: SizedBox.square(
                  dimension: widget.dimension,
                  child: Center(
                    child: Icon(
                      Icons.speed_rounded,
                      color: Colors.white,
                      size: widget.iconSize,
                    ),
                  ),
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
