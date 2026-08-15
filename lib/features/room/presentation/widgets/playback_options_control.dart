import 'dart:math';

import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/player_control_popup_style.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';

class PlaybackOptionsControl extends StatefulWidget {
  const PlaybackOptionsControl({
    super.key,
    required this.modes,
    required this.selectedModeKey,
    required this.selectedMediaIndex,
    required this.adaptiveTracks,
    required this.tooltip,
    required this.onMediaSelected,
    required this.onAdaptiveTrackSelected,
    this.compact = false,
  });

  final List<SyncTvPlaybackModeOption> modes;
  final String selectedModeKey;
  final int selectedMediaIndex;
  final AdaptiveVideoTrackSnapshot adaptiveTracks;
  final String tooltip;
  final Future<void> Function(SyncTvPlaybackModeOption mode, int mediaIndex)
  onMediaSelected;
  final Future<void> Function(String trackId) onAdaptiveTrackSelected;
  final bool compact;

  @override
  State<PlaybackOptionsControl> createState() => _PlaybackOptionsControlState();
}

class _PlaybackOptionsControlState extends State<PlaybackOptionsControl> {
  SyncTvPlaybackModeOption get _selectedMode => widget.modes.firstWhere(
    (mode) => mode.key == widget.selectedModeKey,
    orElse: () => widget.modes.first,
  );

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (anchorContext) {
        final button = widget.compact
            ? InkWell(
                key: const Key('playback_route_button_compact'),
                borderRadius: BorderRadius.circular(20),
                hoverColor: Colors.white12,
                focusColor: Colors.white12,
                highlightColor: Colors.white24,
                onTap: () => _openMenu(anchorContext),
                child: const SizedBox.square(
                  dimension: 40,
                  child: Center(
                    child: Icon(
                      Icons.route_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : InkWell(
                key: const Key('playback_route_button'),
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openMenu(anchorContext),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.route_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _modeLabel(
                            _selectedMode,
                            mediaIndex: widget.selectedMediaIndex,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
        return Semantics(
          button: true,
          label: widget.tooltip,
          child: AppTooltip(message: widget.tooltip, child: button),
        );
      },
    );
  }

  Future<void> _openMenu(BuildContext anchorContext) async {
    var page = _PlaybackMenuPage.quality;
    while (true) {
      if (!mounted || !anchorContext.mounted) return;
      final items = switch (page) {
        _PlaybackMenuPage.quality => _buildQualityMenu(),
        _PlaybackMenuPage.routes => _buildRouteMenu(),
      };
      final position = _menuPosition(
        anchorContext,
        menuHeight: _menuHeight(items),
      );
      if (position == null) return;
      final action = await showMenu<_PlaybackMenuAction>(
        context: context,
        useRootNavigator: true,
        popUpAnimationStyle: playerControlPopupAnimationStyle,
        color: const Color(0xF21A1D21),
        constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
        position: position,
        items: items,
      );
      if (!mounted || !anchorContext.mounted || action == null) return;
      switch (action.kind) {
        case _PlaybackMenuActionKind.quality:
          page = _PlaybackMenuPage.quality;
        case _PlaybackMenuActionKind.routes:
          page = _PlaybackMenuPage.routes;
        case _PlaybackMenuActionKind.media:
          await widget.onMediaSelected(action.mode!, action.mediaIndex!);
          return;
        case _PlaybackMenuActionKind.track:
          await widget.onAdaptiveTrackSelected(action.trackId!);
          return;
      }
    }
  }

  RelativeRect? _menuPosition(
    BuildContext anchorContext, {
    required double menuHeight,
  }) {
    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    final overlay =
        Navigator.of(
              context,
              rootNavigator: true,
            ).overlay?.context.findRenderObject()
            as RenderBox?;
    if (renderBox == null || overlay == null || !renderBox.hasSize) return null;
    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight = renderBox.localToGlobal(
      renderBox.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );
    final menuTop = (topLeft.dy - menuHeight - 8)
        .clamp(8.0, max(8.0, overlay.size.height - menuHeight - 8))
        .toDouble();
    return RelativeRect.fromLTRB(
      topLeft.dx,
      menuTop,
      overlay.size.width - bottomRight.dx,
      overlay.size.height - bottomRight.dy + 8,
    );
  }

  double _menuHeight<T>(List<PopupMenuEntry<T>> items) {
    return 16 + items.fold<double>(0, (height, item) => height + item.height);
  }

  List<PopupMenuEntry<_PlaybackMenuAction>> _buildQualityMenu() {
    final mode = _selectedMode;
    final adaptiveTracks = [...widget.adaptiveTracks.tracks]
      ..sort(_compareAdaptiveTracks);
    final hasAdaptiveQualities = adaptiveTracks.length > 1;
    final showMediaLinks = mode.urls.length > 1 || !hasAdaptiveQualities;
    return <PopupMenuEntry<_PlaybackMenuAction>>[
      if (widget.modes.length > 1)
        PopupMenuItem<_PlaybackMenuAction>(
          key: const Key('playback_route_selector'),
          value: const _PlaybackMenuAction.routes(),
          child: Row(
            children: [
              const Icon(Icons.route_rounded, color: Colors.white70),
              const SizedBox(width: 10),
              Expanded(
                child: _MenuText(
                  label: context.l10n.route,
                  value: _modeLabel(
                    mode,
                    mediaIndex: widget.selectedMediaIndex,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            ],
          ),
        ),
      if (widget.modes.length > 1) const PopupMenuDivider(height: 10),
      if (showMediaLinks)
        PopupMenuItem<_PlaybackMenuAction>(
          enabled: false,
          height: 28,
          child: _MenuSectionLabel(context.l10n.qualityAndMediaLinks),
        ),
      if (showMediaLinks)
        for (var index = 0; index < mode.urls.length; index++)
          PopupMenuItem<_PlaybackMenuAction>(
            key: Key('playback_media_option_${mode.key}_$index'),
            value: _PlaybackMenuAction.media(mode, index),
            child: Row(
              children: [
                Icon(
                  index == widget.selectedMediaIndex
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: index == widget.selectedMediaIndex
                      ? const Color(0xFF7CFFB2)
                      : Colors.white54,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    mode.urls[index].label(index),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
      if (hasAdaptiveQualities)
        PopupMenuItem<_PlaybackMenuAction>(
          enabled: false,
          height: 28,
          child: _MenuSectionLabel(context.l10n.manifestQualities),
        ),
      if (hasAdaptiveQualities &&
          widget.adaptiveTracks.automaticSelectionAvailable)
        PopupMenuItem<_PlaybackMenuAction>(
          key: const Key('adaptive_video_track_auto'),
          value: const _PlaybackMenuAction.track('auto'),
          child: Row(
            children: [
              _trackSelectionIcon('auto'),
              const SizedBox(width: 10),
              Text(
                context.l10n.automatic,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      if (hasAdaptiveQualities)
        for (final track in adaptiveTracks)
          PopupMenuItem<_PlaybackMenuAction>(
            key: Key('adaptive_video_track_${track.id}'),
            value: _PlaybackMenuAction.track(track.id),
            child: Row(
              children: [
                _trackSelectionIcon(track.id),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _adaptiveTrackLabel(track),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
    ];
  }

  List<PopupMenuEntry<_PlaybackMenuAction>> _buildRouteMenu() {
    return <PopupMenuEntry<_PlaybackMenuAction>>[
      PopupMenuItem<_PlaybackMenuAction>(
        key: const Key('playback_route_back_button'),
        value: const _PlaybackMenuAction.quality(),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_rounded, color: Colors.white70),
            const SizedBox(width: 10),
            Text(
              context.l10n.selectPlaybackRoute,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(height: 10),
      for (final mode in widget.modes)
        PopupMenuItem<_PlaybackMenuAction>(
          key: Key('playback_route_option_${mode.key}'),
          value: _PlaybackMenuAction.media(mode, _mediaIndexForRoute(mode)),
          child: Row(
            children: [
              Icon(
                mode.key == widget.selectedModeKey
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: mode.key == widget.selectedModeKey
                    ? const Color(0xFF7CFFB2)
                    : Colors.white54,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _modeLabel(mode, mediaIndex: _mediaIndexForRoute(mode)),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
    ];
  }

  int _mediaIndexForRoute(SyncTvPlaybackModeOption targetMode) {
    if (targetMode.urls.isEmpty) return targetMode.safeDefaultUrlIndex;
    final sourceMode = _selectedMode;
    if (sourceMode.urls.isEmpty) return targetMode.safeDefaultUrlIndex;
    final sourceIndex =
        widget.selectedMediaIndex >= 0 &&
            widget.selectedMediaIndex < sourceMode.urls.length
        ? widget.selectedMediaIndex
        : sourceMode.safeDefaultUrlIndex;
    final source = sourceMode.urls[sourceIndex];

    final sourceSwarmId = source.p2pDelivery?.swarmId.trim() ?? '';
    if (sourceSwarmId.isNotEmpty) {
      final swarmIndex = targetMode.urls.indexWhere(
        (option) => option.p2pDelivery?.swarmId.trim() == sourceSwarmId,
      );
      if (swarmIndex >= 0) return swarmIndex;
    }

    final sourceName = source.name.trim().toLowerCase();
    final sourceFormat = _normalizedFormat(source.format);
    if (sourceName.isNotEmpty) {
      final namedIndex = targetMode.urls.indexWhere(
        (option) =>
            option.name.trim().toLowerCase() == sourceName &&
            _normalizedFormat(option.format) == sourceFormat,
      );
      if (namedIndex >= 0) return namedIndex;
    }

    final sourceResolution = source.resolution.trim().toLowerCase();
    if (sourceResolution.isNotEmpty) {
      final qualityIndex = targetMode.urls.indexWhere(
        (option) =>
            option.resolution.trim().toLowerCase() == sourceResolution &&
            _normalizedFormat(option.format) == sourceFormat,
      );
      if (qualityIndex >= 0) return qualityIndex;
    }

    if (sourceIndex < targetMode.urls.length &&
        sourceMode.urls.length == targetMode.urls.length &&
        _normalizedFormat(targetMode.urls[sourceIndex].format) ==
            sourceFormat) {
      return sourceIndex;
    }
    return targetMode.safeDefaultUrlIndex;
  }

  String _normalizedFormat(String value) =>
      switch (value.trim().toLowerCase()) {
        'm3u8' => 'hls',
        'mpd' => 'dash',
        final format => format,
      };

  String _modeLabel(SyncTvPlaybackModeOption mode, {int? mediaIndex}) {
    final key = mode.key.trim();
    final display = _modeKeyLabel(key);
    final effectiveIndex =
        mediaIndex != null && mediaIndex >= 0 && mediaIndex < mode.urls.length
        ? mediaIndex
        : mode.safeDefaultUrlIndex;
    final selectedFormat = mode.urls.isEmpty
        ? ''
        : mode.urls[effectiveIndex].format.trim();
    final rawFormat = (selectedFormat.isEmpty ? mode.format : selectedFormat)
        .trim()
        .toLowerCase();
    final format = switch (rawFormat) {
      'm3u8' || 'hls' => 'HLS',
      'mpd' || 'dash' => 'DASH',
      _ => rawFormat.toUpperCase(),
    };
    return format.isEmpty || format == display.toUpperCase()
        ? display
        : '$display · $format';
  }

  String _modeKeyLabel(String key) {
    final lower = key.toLowerCase();
    if (lower.startsWith('proxy_') && lower != 'proxy_direct') {
      return '${_modeKeyLabel(key.substring('proxy_'.length))} · ${context.l10n.proxy}';
    }
    if (lower.endsWith('_proxy') && lower != 'direct_proxy') {
      return '${_modeKeyLabel(key.substring(0, key.length - '_proxy'.length))} · ${context.l10n.proxy}';
    }
    return switch (lower) {
      'main' => context.l10n.playbackRouteMain,
      _ when lower.startsWith('backup_') => context.l10n.playbackRouteBackup(
        int.tryParse(lower.substring('backup_'.length)) ?? 1,
      ),
      'direct' || 'raw' || 'original' => context.l10n.playbackRouteOriginal,
      'proxy' ||
      'proxied' ||
      'proxy_direct' ||
      'direct_proxy' => context.l10n.proxy,
      'h264' => 'H.264',
      'av1' => 'AV1',
      'hevc' => 'HEVC',
      'dash' => 'DASH',
      'hls' => 'HLS',
      'mp4' => 'MP4',
      'progressive' => context.l10n.playbackRouteProgressive,
      'transcoded' => context.l10n.playbackRouteTranscoded,
      'video_hls' => context.l10n.playbackRouteVideoHls,
      'audio_hls' => context.l10n.playbackRouteAudioHls,
      _ when lower.endsWith('_transcode') =>
        '${_humanizeModeKey(key.substring(0, key.length - '_transcode'.length))} '
            '${context.l10n.playbackRouteTranscoded}',
      _ when lower.startsWith('transcoded_') => _humanizeModeKey(
        key.substring('transcoded_'.length),
      ),
      _ => _humanizeModeKey(key),
    };
  }

  static int _compareAdaptiveTracks(
    AdaptiveVideoTrackInfo left,
    AdaptiveVideoTrackInfo right,
  ) {
    final leftPixels = (left.width ?? 0) * (left.height ?? 0);
    final rightPixels = (right.width ?? 0) * (right.height ?? 0);
    final byResolution = rightPixels.compareTo(leftPixels);
    if (byResolution != 0) return byResolution;
    final byBitrate = (right.bitrate ?? 0).compareTo(left.bitrate ?? 0);
    if (byBitrate != 0) return byBitrate;
    return right.id.compareTo(left.id);
  }

  static String _humanizeModeKey(String key) {
    final words = key
        .split(RegExp(r'[_\-\s]+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) => word.length == 1
              ? word.toUpperCase()
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .toList();
    return words.isEmpty ? key : words.join(' ');
  }

  Icon _trackSelectionIcon(String trackId) => Icon(
    widget.adaptiveTracks.selectedTrackId == trackId
        ? Icons.radio_button_checked_rounded
        : Icons.radio_button_unchecked_rounded,
    color: widget.adaptiveTracks.selectedTrackId == trackId
        ? const Color(0xFF7CFFB2)
        : Colors.white54,
  );

  String _adaptiveTrackLabel(AdaptiveVideoTrackInfo track) {
    final parts = <String>[];
    if (track.title?.trim().isNotEmpty == true) parts.add(track.title!.trim());
    if (track.resolution.isNotEmpty) parts.add(track.resolution);
    if (track.fps != null && track.fps! > 0) {
      parts.add('${track.fps!.round()}fps');
    }
    if (track.bitrate != null && track.bitrate! > 0) {
      final mbps = track.bitrate! / 1000000;
      parts.add('${mbps.toStringAsFixed(mbps >= 10 ? 0 : 1)}Mbps');
    }
    if (track.codec?.trim().isNotEmpty == true) {
      parts.add(track.codec!.trim().toUpperCase());
    }
    return parts.isEmpty
        ? context.l10n.qualityTrack(track.id)
        : parts.join(' · ');
  }
}

enum _PlaybackMenuPage { quality, routes }

enum _PlaybackMenuActionKind { quality, routes, media, track }

class _PlaybackMenuAction {
  const _PlaybackMenuAction.quality()
    : kind = _PlaybackMenuActionKind.quality,
      mode = null,
      mediaIndex = null,
      trackId = null;

  const _PlaybackMenuAction.routes()
    : kind = _PlaybackMenuActionKind.routes,
      mode = null,
      mediaIndex = null,
      trackId = null;

  const _PlaybackMenuAction.media(this.mode, this.mediaIndex)
    : kind = _PlaybackMenuActionKind.media,
      trackId = null;

  const _PlaybackMenuAction.track(this.trackId)
    : kind = _PlaybackMenuActionKind.track,
      mode = null,
      mediaIndex = null;

  final _PlaybackMenuActionKind kind;
  final SyncTvPlaybackModeOption? mode;
  final int? mediaIndex;
  final String? trackId;
}

class _MenuSectionLabel extends StatelessWidget {
  const _MenuSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _MenuText extends StatelessWidget {
  const _MenuText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(label, style: const TextStyle(color: Colors.white70)),
      const Spacer(),
      const SizedBox(width: 12),
      Flexible(
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
