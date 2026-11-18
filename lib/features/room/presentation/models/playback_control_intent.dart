enum PlaybackControlIntentKind { playbackState, seek, speed }

class PlaybackControlIntent {
  const PlaybackControlIntent({
    required this.kind,
    required this.clientOperationId,
    required this.clientTimeMillis,
    this.isPlaying,
    this.position,
    this.speed,
  });

  final PlaybackControlIntentKind kind;
  final String clientOperationId;
  final int clientTimeMillis;
  final bool? isPlaying;
  final Duration? position;
  final double? speed;
}
