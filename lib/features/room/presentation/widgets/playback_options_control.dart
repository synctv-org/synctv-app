import 'dart:math';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/player_control_popup_style.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';

typedef PlaybackMediaSelection = Future<void> Function(
  SyncTvPlaybackModeOption mode,
  int mediaIndex,
);

class PlaybackRouteControl extends StatelessWidget {
  const PlaybackRouteControl({
    super.key,
    required this.modes,
    required this.selectedModeKey,
    required this.selectedMediaIndex,
    required this.tooltip,
    required this.onMediaSelected,
    this.compact = false,
  });

  final List<SyncTvPlaybackModeOption> modes;
  final String selectedModeKey;
  final int selectedMediaIndex;
  final String tooltip;
  final PlaybackMediaSelection onMediaSelected;
  final bool compact;

  SyncTvPlaybackModeOption? get _selectedMode {
    if (modes.isEmpty) return null;
    return modes.firstWhere(
      (mode) => mode.key == selectedModeKey,
      orElse: () => modes.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = _selectedMode;
    if (mode == null) return const SizedBox.shrink();
    return PlaybackPopupButton(
      buttonKey: Key(
        compact ? 'playback_route_button_compact' : 'playback_route_button',
      ),
      icon: Icons.route_rounded,
      label: playbackModeLabel(context, mode, mediaIndex: selectedMediaIndex),
      tooltip: tooltip,
      compact: compact,
      onPressed: (anchorContext) => _openMenu(context, anchorContext),
    );
  }

  Future<void> _openMenu(
    BuildContext context,
    BuildContext anchorContext,
  ) async {
    final items = <PopupMenuEntry<_RouteSelection>>[];
    for (final mode in modes) {
      if (modes.length > 1) {
        items.add(
          PopupMenuItem<_RouteSelection>(
            enabled: false,
            height: 28,
            child: _MenuSectionLabel(playbackModeLabel(context, mode)),
          ),
        );
      }
      for (var index = 0; index < mode.urls.length; index++) {
        final selected =
            mode.key == selectedModeKey && index == selectedMediaIndex;
        items.add(
          PopupMenuItem<_RouteSelection>(
            key: Key('playback_route_option_${mode.key}_$index'),
            value: _RouteSelection(mode, index),
            child: Row(
              children: [
                _selectionIcon(selected),
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
        );
      }
    }
    final selected = await showPlaybackPopupMenu<_RouteSelection>(
      context: context,
      anchorContext: anchorContext,
      items: items,
    );
    if (selected != null) {
      await onMediaSelected(selected.mode, selected.mediaIndex);
    }
  }
}

class AdaptiveVideoTrackControl extends StatelessWidget {
  const AdaptiveVideoTrackControl({
    super.key,
    required this.tracks,
    required this.tooltip,
    required this.onTrackSelected,
    this.compact = false,
  });

  final AdaptiveVideoTrackSnapshot tracks;
  final String tooltip;
  final Future<void> Function(String trackId) onTrackSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final selected = tracks.selectedTrackId == 'auto'
        ? context.l10n.automatic
        : tracks.tracks
                  .where((track) => track.id == tracks.selectedTrackId)
                  .map((track) => adaptiveVideoTrackLabel(context, track))
                  .firstOrNull ??
              context.l10n.automatic;
    return PlaybackPopupButton(
      buttonKey: Key(
        compact
            ? 'adaptive_video_track_button_compact'
            : 'adaptive_video_track_button',
      ),
      icon: Icons.high_quality_rounded,
      label: selected,
      tooltip: tooltip,
      compact: compact,
      onPressed: (anchorContext) => _openMenu(context, anchorContext),
    );
  }

  Future<void> _openMenu(
    BuildContext context,
    BuildContext anchorContext,
  ) async {
    final sortedTracks = [...tracks.tracks]..sort(compareAdaptiveVideoTracks);
    final items = <PopupMenuEntry<String>>[
      if (tracks.automaticSelectionAvailable)
        PopupMenuItem<String>(
          key: const Key('adaptive_video_track_auto'),
          value: 'auto',
          child: Row(
            children: [
              _selectionIcon(tracks.selectedTrackId == 'auto'),
              const SizedBox(width: 10),
              Text(
                context.l10n.automatic,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      for (final track in sortedTracks)
        PopupMenuItem<String>(
          key: Key('adaptive_video_track_${track.id}'),
          value: track.id,
          child: Row(
            children: [
              _selectionIcon(tracks.selectedTrackId == track.id),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  adaptiveVideoTrackLabel(context, track),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
    ];
    final selected = await showPlaybackPopupMenu<String>(
      context: context,
      anchorContext: anchorContext,
      items: items,
    );
    if (selected != null) await onTrackSelected(selected);
  }
}

class AdaptiveAudioTrackControl extends StatelessWidget {
  const AdaptiveAudioTrackControl({
    super.key,
    required this.tracks,
    required this.tooltip,
    required this.onTrackSelected,
    this.compact = false,
  });

  final AdaptiveAudioTrackSnapshot tracks;
  final String tooltip;
  final Future<void> Function(String trackId) onTrackSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final selected = tracks.selectedTrackId == 'auto'
        ? context.l10n.automatic
        : tracks.tracks
                  .where((track) => track.id == tracks.selectedTrackId)
                  .map((track) => adaptiveAudioTrackLabel(context, track))
                  .firstOrNull ??
              context.l10n.automatic;
    return PlaybackPopupButton(
      buttonKey: Key(
        compact
            ? 'adaptive_audio_track_button_compact'
            : 'adaptive_audio_track_button',
      ),
      icon: Icons.audiotrack_rounded,
      label: selected,
      tooltip: tooltip,
      compact: compact,
      onPressed: (anchorContext) => _openMenu(context, anchorContext),
    );
  }

  Future<void> _openMenu(
    BuildContext context,
    BuildContext anchorContext,
  ) async {
    final items = <PopupMenuEntry<String>>[
      if (tracks.automaticSelectionAvailable)
        PopupMenuItem<String>(
          key: const Key('adaptive_audio_track_auto'),
          value: 'auto',
          child: Row(
            children: [
              _selectionIcon(tracks.selectedTrackId == 'auto'),
              const SizedBox(width: 10),
              Text(
                context.l10n.automatic,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      for (final track in tracks.tracks)
        PopupMenuItem<String>(
          key: Key('adaptive_audio_track_${track.id}'),
          value: track.id,
          child: Row(
            children: [
              _selectionIcon(tracks.selectedTrackId == track.id),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  adaptiveAudioTrackLabel(context, track),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
    ];
    final selected = await showPlaybackPopupMenu<String>(
      context: context,
      anchorContext: anchorContext,
      items: items,
    );
    if (selected != null) await onTrackSelected(selected);
  }
}

class PlaybackPopupButton extends StatelessWidget {
  const PlaybackPopupButton({
    super.key,
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.compact,
    required this.onPressed,
    this.dimension = 40,
    this.iconSize = 20,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final String tooltip;
  final bool compact;
  final Future<void> Function(BuildContext anchorContext) onPressed;
  final double dimension;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchorContext) {
      final button = compact
          ? InkWell(
              key: buttonKey,
              borderRadius: BorderRadius.circular(dimension / 2),
              hoverColor: Colors.white12,
              focusColor: Colors.white12,
              highlightColor: Colors.white24,
              onTap: () => onPressed(anchorContext),
              child: SizedBox.square(
                dimension: dimension,
                child: Center(
                  child: Icon(icon, size: iconSize, color: Colors.white),
                ),
              ),
            )
          : InkWell(
              key: buttonKey,
              borderRadius: BorderRadius.circular(16),
              onTap: () => onPressed(anchorContext),
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
                    Icon(icon, size: 18, color: Colors.white),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        label,
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
        label: tooltip,
        child: AppTooltip(message: tooltip, child: button),
      );
    },
  );
}

Future<T?> showPlaybackPopupMenu<T>({
  required BuildContext context,
  required BuildContext anchorContext,
  required List<PopupMenuEntry<T>> items,
}) async {
  if (items.isEmpty) return null;
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
  final menuHeight =
      16 + items.fold<double>(0, (height, item) => height + item.height);
  final menuTop = (topLeft.dy - menuHeight - 8)
      .clamp(8.0, max(8.0, overlay.size.height - menuHeight - 8))
      .toDouble();
  return showMenu<T>(
    context: context,
    useRootNavigator: true,
    popUpAnimationStyle: playerControlPopupAnimationStyle,
    color: const Color(0xF21A1D21),
    constraints: const BoxConstraints(minWidth: 240, maxWidth: 360),
    position: RelativeRect.fromLTRB(
      topLeft.dx,
      menuTop,
      overlay.size.width - bottomRight.dx,
      overlay.size.height - bottomRight.dy + 8,
    ),
    items: items,
  );
}

String playbackModeLabel(
  BuildContext context,
  SyncTvPlaybackModeOption mode, {
  int? mediaIndex,
}) {
  final key = mode.key.trim();
  final display = _modeKeyLabel(context, key);
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

String _modeKeyLabel(BuildContext context, String key) {
  final lower = key.toLowerCase();
  if (lower.startsWith('proxy_') && lower != 'proxy_direct') {
    return '${_modeKeyLabel(context, key.substring('proxy_'.length))} · ${context.l10n.proxy}';
  }
  if (lower.endsWith('_proxy') && lower != 'direct_proxy') {
    return '${_modeKeyLabel(context, key.substring(0, key.length - '_proxy'.length))} · ${context.l10n.proxy}';
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

int compareAdaptiveVideoTracks(
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

String adaptiveVideoTrackLabel(
  BuildContext context,
  AdaptiveVideoTrackInfo track,
) {
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

String adaptiveAudioTrackLabel(
  BuildContext context,
  AdaptiveAudioTrackInfo track,
) {
  final parts = <String>[
    if (track.title?.trim().isNotEmpty == true) track.title!.trim(),
    if (track.language?.trim().isNotEmpty == true)
      track.language!.trim().toUpperCase(),
    if (track.codec?.trim().isNotEmpty == true)
      track.codec!.trim().toUpperCase(),
    if (track.channels != null && track.channels! > 0) '${track.channels}ch',
    if (track.sampleRate != null && track.sampleRate! > 0)
      '${(track.sampleRate! / 1000).toStringAsFixed(track.sampleRate! % 1000 == 0 ? 0 : 1)}kHz',
    if (track.bitrate != null && track.bitrate! > 0)
      '${(track.bitrate! / 1000).round()}kbps',
  ];
  return parts.isEmpty
      ? context.l10n.qualityTrack(track.id)
      : parts.toSet().join(' · ');
}

String _humanizeModeKey(String key) {
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

Icon _selectionIcon(bool selected) => Icon(
  selected
      ? Icons.radio_button_checked_rounded
      : Icons.radio_button_unchecked_rounded,
  color: selected ? const Color(0xFF7CFFB2) : Colors.white54,
);

class _RouteSelection {
  const _RouteSelection(this.mode, this.mediaIndex);

  final SyncTvPlaybackModeOption mode;
  final int mediaIndex;
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
