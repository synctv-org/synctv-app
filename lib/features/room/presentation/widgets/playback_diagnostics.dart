import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

@immutable
class PlaybackDiagnosticsContext {
  const PlaybackDiagnosticsContext({
    this.roomId = '',
    this.mediaId = '',
    this.playlistId = '',
    this.targetHash = '',
    this.provider = '',
    this.providerInstance = '',
    this.resourceType = '',
    this.playbackRoute = '',
    this.adaptiveTrack = '',
    this.codec = '',
    this.bitrate,
    this.roomPlaybackVersion,
    this.playMode = '',
    this.serverLatency,
    this.playbackDeviationSeconds,
    this.httpBytes = 0,
    this.p2pDownloadBytes = 0,
    this.p2pUploadBytes = 0,
    this.httpDownloadRate = 0,
    this.p2pDownloadRate = 0,
    this.p2pUploadRate = 0,
    this.connectedPeers = 0,
    this.cacheBytes = 0,
    this.cacheHits = 0,
    this.cacheMisses = 0,
    this.integrityChecks = 0,
    this.integrityMismatches = 0,
    this.integrityUnavailable = 0,
  });

  final String roomId;
  final String mediaId;
  final String playlistId;
  final String targetHash;
  final String provider;
  final String providerInstance;
  final String resourceType;
  final String playbackRoute;
  final String adaptiveTrack;
  final String codec;
  final int? bitrate;
  final int? roomPlaybackVersion;
  final String playMode;
  final Duration? serverLatency;
  final double? playbackDeviationSeconds;
  final int httpBytes;
  final int p2pDownloadBytes;
  final int p2pUploadBytes;
  final double httpDownloadRate;
  final double p2pDownloadRate;
  final double p2pUploadRate;
  final int connectedPeers;
  final int cacheBytes;
  final int cacheHits;
  final int cacheMisses;
  final int integrityChecks;
  final int integrityMismatches;
  final int integrityUnavailable;
}

@immutable
class PlaybackBufferRange {
  const PlaybackBufferRange({required this.start, required this.end});

  final Duration start;
  final Duration end;
}

@immutable
class PlaybackDiagnosticsSnapshot {
  const PlaybackDiagnosticsSnapshot({
    required this.capturedAt,
    required this.title,
    required this.isLive,
    required this.isInitialized,
    required this.isPlaying,
    required this.isBuffering,
    required this.isCompleted,
    required this.isLooping,
    required this.position,
    required this.duration,
    required this.buffered,
    required this.viewportSize,
    required this.videoSize,
    required this.volume,
    required this.playbackSpeed,
    required this.context,
    this.errorDescription,
  });

  final DateTime capturedAt;
  final String title;
  final bool isLive;
  final bool isInitialized;
  final bool isPlaying;
  final bool isBuffering;
  final bool isCompleted;
  final bool isLooping;
  final Duration position;
  final Duration duration;
  final List<PlaybackBufferRange> buffered;
  final Size viewportSize;
  final Size videoSize;
  final double volume;
  final double playbackSpeed;
  final String? errorDescription;
  final PlaybackDiagnosticsContext context;

  Duration get bufferHealth {
    var furthestEnd = position;
    for (final range in buffered) {
      if (range.end > position && range.end > furthestEnd) {
        furthestEnd = range.end;
      }
    }
    return furthestEnd - position;
  }

  int get totalDownloadBytes => context.httpBytes + context.p2pDownloadBytes;

  double get totalDownloadRate =>
      context.httpDownloadRate + context.p2pDownloadRate;

  double get p2pDownloadRatio {
    final total = totalDownloadBytes;
    return total == 0 ? 0 : context.p2pDownloadBytes / total;
  }

  double get cacheHitRatio {
    final total = context.cacheHits + context.cacheMisses;
    return total == 0 ? 0 : context.cacheHits / total;
  }

  Map<String, Object?> toJson() {
    return {
      'schemaVersion': 1,
      'capturedAt': capturedAt.toUtc().toIso8601String(),
      'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
      'room': {
        'id': context.roomId,
        'playbackVersion': context.roomPlaybackVersion,
        'playMode': context.playMode,
      },
      'resource': {
        'title': _sanitizeDiagnosticText(title),
        'mediaId': context.mediaId,
        'playlistId': context.playlistId,
        'targetHash': context.targetHash,
        'provider': _sanitizeDiagnosticText(context.provider),
        'providerInstance': _sanitizeDiagnosticText(context.providerInstance),
        'type': _sanitizeDiagnosticText(context.resourceType),
        'playbackRoute': _sanitizeDiagnosticText(context.playbackRoute),
        'adaptiveTrack': _sanitizeDiagnosticText(context.adaptiveTrack),
        'codec': _sanitizeDiagnosticText(context.codec),
        'bitrate': context.bitrate,
      },
      'player': {
        'live': isLive,
        'initialized': isInitialized,
        'playing': isPlaying,
        'buffering': isBuffering,
        'completed': isCompleted,
        'looping': isLooping,
        'positionMs': position.inMilliseconds,
        'durationMs': duration.inMilliseconds,
        'bufferHealthMs': bufferHealth.inMilliseconds,
        'buffered': [
          for (final range in buffered)
            {
              'startMs': range.start.inMilliseconds,
              'endMs': range.end.inMilliseconds,
            },
        ],
        'viewport': _sizeJson(viewportSize),
        'videoResolution': _sizeJson(videoSize),
        'volume': volume,
        'playbackSpeed': playbackSpeed,
        'error': errorDescription == null
            ? null
            : _sanitizeDiagnosticText(errorDescription!),
      },
      'synchronization': {
        'serverLatencyMs': context.serverLatency?.inMilliseconds,
        'playbackDeviationMs': context.playbackDeviationSeconds == null
            ? null
            : (context.playbackDeviationSeconds! * 1000).round(),
      },
      'delivery': {
        'httpBytes': context.httpBytes,
        'p2pDownloadBytes': context.p2pDownloadBytes,
        'p2pUploadBytes': context.p2pUploadBytes,
        'httpDownloadBytesPerSecond': context.httpDownloadRate.round(),
        'p2pDownloadBytesPerSecond': context.p2pDownloadRate.round(),
        'p2pUploadBytesPerSecond': context.p2pUploadRate.round(),
        'connectedPeers': context.connectedPeers,
        'cacheBytes': context.cacheBytes,
        'cacheHits': context.cacheHits,
        'cacheMisses': context.cacheMisses,
        'integrityChecks': context.integrityChecks,
        'integrityMismatches': context.integrityMismatches,
        'integrityUnavailable': context.integrityUnavailable,
      },
    };
  }

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());

  static Map<String, int> _sizeJson(Size size) => {
    'width': size.width.round(),
    'height': size.height.round(),
  };
}

String _sanitizeDiagnosticText(String value) {
  var sanitized = value;
  sanitized = sanitized.replaceAll(
    RegExp(r'\b(?:https?|rtmps?|wss?|ftps?)://\S+', caseSensitive: false),
    '[redacted-url]',
  );
  sanitized = sanitized.replaceAll(
    RegExp(
      r'\b(?:authorization|proxy-authorization|cookie|set-cookie)\s*:\s*[^\r\n,;]+',
      caseSensitive: false,
    ),
    '[redacted-header]',
  );
  sanitized = sanitized.replaceAll(
    RegExp(
      r'\b(?:access[_-]?token|refresh[_-]?token|client[_-]?secret|password)\s*[:=]\s*[^\s,;]+',
      caseSensitive: false,
    ),
    '[redacted-secret]',
  );
  return sanitized;
}

class PlaybackStatisticsPanel extends StatefulWidget {
  const PlaybackStatisticsPanel({
    super.key,
    required this.snapshot,
    required this.onClose,
  });

  final PlaybackDiagnosticsSnapshot snapshot;
  final VoidCallback onClose;

  @override
  State<PlaybackStatisticsPanel> createState() =>
      _PlaybackStatisticsPanelState();
}

class _PlaybackStatisticsPanelState extends State<PlaybackStatisticsPanel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows(context);
    return AppPanelSurface(
      key: const Key('playback_detailed_statistics'),
      color: const Color(0xFF111116),
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: Colors.white24),
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monitor_heart_outlined,
                color: Color(0xFF7CFFB2),
                size: 18,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  context.l10n.detailedPlaybackStatistics,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AppIconButton(
                key: const Key('close_playback_detailed_statistics'),
                icon: Icons.close_rounded,
                tooltip: context.l10n.close,
                onPressed: widget.onClose,
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
                padding: EdgeInsets.zero,
                iconSize: 18,
              ),
            ],
          ),
          const AppDivider(height: 10, color: Colors.white12),
          Flexible(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              interactive: true,
              radius: const Radius.circular(4),
              thickness: 4,
              child: AppSingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    for (final row in rows)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 112,
                              child: Text(
                                row.$1,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                row.$2,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<(String, String)> _rows(BuildContext context) {
    final snapshot = widget.snapshot;
    final details = snapshot.context;
    final resourceId = details.mediaId.isNotEmpty
        ? details.mediaId
        : details.playlistId.isNotEmpty
        ? details.playlistId
        : _shortHash(details.targetHash);
    final provider = [
      details.provider,
      details.providerInstance,
    ].where((value) => value.isNotEmpty).join(' / ');
    final format = [
      details.resourceType.toUpperCase(),
      details.codec.toUpperCase(),
      if (details.bitrate != null && details.bitrate! > 0)
        _formatBitrate(details.bitrate!),
    ].where((value) => value.isNotEmpty).join(' · ');
    final route = [
      details.playbackRoute,
      details.adaptiveTrack,
    ].where((value) => value.isNotEmpty).join(' / ');
    final state = snapshot.isBuffering
        ? context.l10n.playerStateBuffering
        : snapshot.isPlaying
        ? context.l10n.playerStatePlaying
        : context.l10n.playerStatePaused;
    final sync = [
      if (details.serverLatency != null)
        context.l10n.playerLatencyMilliseconds(
          details.serverLatency!.inMilliseconds,
        ),
      if (details.playbackDeviationSeconds != null)
        context.l10n.playerDeviationMilliseconds(
          (details.playbackDeviationSeconds! * 1000).round(),
        ),
    ].join(' · ');
    final rows = <(String, String)>[
      (context.l10n.playerResource, resourceId.isEmpty ? '-' : resourceId),
      (context.l10n.playerProvider, provider.isEmpty ? '-' : provider),
      (context.l10n.playerPlaybackRoute, route.isEmpty ? '-' : route),
      (context.l10n.playerFormat, format.isEmpty ? '-' : format),
      (
        context.l10n.playerViewportVideo,
        '${_formatSize(snapshot.viewportSize)} / ${_formatSize(snapshot.videoSize)}',
      ),
      (
        context.l10n.playerPlaybackState,
        '$state · ${_formatDuration(snapshot.position)} / ${_formatDuration(snapshot.duration)}',
      ),
      (
        context.l10n.playerBufferHealth,
        '${(snapshot.bufferHealth.inMilliseconds / 1000).toStringAsFixed(1)} s · ${context.l10n.playerBufferRangeCount(snapshot.buffered.length)}',
      ),
      (
        context.l10n.playerSpeedVolume,
        '${snapshot.playbackSpeed.toStringAsFixed(2)}x · ${(snapshot.volume * 100).round()}%',
      ),
      (context.l10n.playerSynchronization, sync.isEmpty ? '-' : sync),
      (
        context.l10n.playerThroughput,
        '${_formatByteRate(snapshot.totalDownloadRate)} · ${_formatBytes(snapshot.totalDownloadBytes)}',
      ),
      (
        context.l10n.playerP2pDelivery,
        '${context.l10n.playerConnectedPeerCount(details.connectedPeers)} · ${(snapshot.p2pDownloadRatio * 100).toStringAsFixed(1)}% · ${_formatByteRate(details.p2pDownloadRate)}',
      ),
      (
        context.l10n.playerCache,
        '${_formatBytes(details.cacheBytes)} · ${(snapshot.cacheHitRatio * 100).toStringAsFixed(1)}%',
      ),
    ];
    if (snapshot.errorDescription?.isNotEmpty == true) {
      rows.add((context.l10n.playerError, snapshot.errorDescription!));
    }
    return rows;
  }
}

String _shortHash(String value) {
  if (value.length <= 16) return value;
  return '${value.substring(0, 8)}...${value.substring(value.length - 8)}';
}

String _formatSize(Size size) {
  if (size.width <= 0 || size.height <= 0) return '-';
  return '${size.width.round()}x${size.height.round()}';
}

String _formatDuration(Duration value) {
  final totalSeconds = value.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

String _formatBytes(num bytes) {
  const units = ['B', 'KiB', 'MiB', 'GiB', 'TiB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(unit == 0 || value >= 100 ? 0 : 1)} ${units[unit]}';
}

String _formatByteRate(num bytesPerSecond) =>
    '${_formatBytes(bytesPerSecond)}/s';

String _formatBitrate(int bitrate) => bitrate >= 1000000
    ? '${(bitrate / 1000000).toStringAsFixed(1)} Mbps'
    : '${(bitrate / 1000).toStringAsFixed(0)} Kbps';
