enum WebPlaybackEngine { progressive, nativeHls, hlsJs, dashJs, mpegTsJs }

enum WebPlaybackTransport { progressive, hls, dash, flv, mpegTs }

WebPlaybackTransport detectWebPlaybackTransport({
  required String? formatHint,
  required Uri uri,
}) {
  final hint = formatHint?.trim().toLowerCase() ?? '';
  final path = uri.path.toLowerCase();
  if (hint == 'hls' || hint == 'm3u8' || path.endsWith('.m3u8')) {
    return WebPlaybackTransport.hls;
  }
  if (hint == 'dash' || hint == 'mpd' || path.endsWith('.mpd')) {
    return WebPlaybackTransport.dash;
  }
  if (hint == 'flv' ||
      hint == 'httpflv' ||
      hint == 'http-flv' ||
      hint == 'http_flv' ||
      path.endsWith('.flv')) {
    return WebPlaybackTransport.flv;
  }
  if (hint == 'mpegts' ||
      hint == 'mpeg-ts' ||
      hint == 'mpeg_ts' ||
      hint == 'ts' ||
      path.endsWith('.ts')) {
    return WebPlaybackTransport.mpegTs;
  }
  return WebPlaybackTransport.progressive;
}

WebPlaybackEngine selectWebPlaybackEngine({
  required WebPlaybackTransport transport,
  required bool nativeHls,
}) => switch (transport) {
  WebPlaybackTransport.progressive => WebPlaybackEngine.progressive,
  WebPlaybackTransport.hls =>
    nativeHls ? WebPlaybackEngine.nativeHls : WebPlaybackEngine.hlsJs,
  WebPlaybackTransport.dash => WebPlaybackEngine.dashJs,
  WebPlaybackTransport.flv ||
  WebPlaybackTransport.mpegTs => WebPlaybackEngine.mpegTsJs,
};

String hlsSelectedTrackId({int? manualLevel}) {
  final selectedLevel = manualLevel ?? -1;
  return selectedLevel < 0 ? 'auto' : 'hls:$selectedLevel';
}

/// What to do with a fatal hls.js ERROR event.
enum WebHlsFatalErrorAction {
  startLoad,
  recoverMediaError,
  swapAudioCodecAndRecoverMediaError,
  report,
}

/// Recovery decisions for fatal hls.js errors, following the recovery
/// recipe used by Jellyfin's web client: fatal network errors resume
/// loading (startLoad(), or loadSource() for the manifest details, which
/// startLoad() cannot re-trigger), fatal media errors recover via
/// recoverMediaError() and, on a quick recurrence, swapAudioCodec() plus
/// another recovery. Errors outside these families, rejected requests, and
/// exhausted recovery budgets report so the player can be torn down.
class WebHlsFatalErrorPolicy {
  WebHlsFatalErrorPolicy({
    this.maxNetworkRecoveries = 5,
    this.networkRecoveryWindow = const Duration(seconds: 30),
    this.mediaRecoveryCooldown = const Duration(seconds: 3),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// A fatal network error may resume loading this many times before the
  /// stream is given up on; the budget refills after a quiet
  /// [networkRecoveryWindow] so a long outage across player restarts or a
  /// recovered network gets fresh attempts.
  final int maxNetworkRecoveries;
  final Duration networkRecoveryWindow;

  /// A fatal media error recurring within this window means the first
  /// recovery failed; the second attempt swaps the audio codec first, and a
  /// third error inside the window gives up.
  final Duration mediaRecoveryCooldown;

  final DateTime Function() _now;
  DateTime? _lastNetworkRecoveryAt;
  int _networkRecoveries = 0;
  DateTime? _lastMediaRecoveryAt;
  bool _swappedAudioCodec = false;

  /// Consumes one fatal error and returns the recovery action. [statusCode]
  /// is the HTTP status from the error's `response` when present.
  WebHlsFatalErrorAction handle({String? type, required int? statusCode}) {
    final now = _now();
    switch (type) {
      case 'networkError':
        // A 4xx answer rejects the request itself, which reloading cannot
        // turn into a success; timeouts and 5xx are worth resuming.
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return WebHlsFatalErrorAction.report;
        }
        final last = _lastNetworkRecoveryAt;
        if (last == null || now.difference(last) > networkRecoveryWindow) {
          _networkRecoveries = 0;
        }
        if (_networkRecoveries >= maxNetworkRecoveries) {
          return WebHlsFatalErrorAction.report;
        }
        _lastNetworkRecoveryAt = now;
        _networkRecoveries++;
        return WebHlsFatalErrorAction.startLoad;
      case 'mediaError':
        final last = _lastMediaRecoveryAt;
        final withinCooldown =
            last != null && now.difference(last) < mediaRecoveryCooldown;
        if (!withinCooldown) {
          _lastMediaRecoveryAt = now;
          _swappedAudioCodec = false;
          return WebHlsFatalErrorAction.recoverMediaError;
        }
        if (!_swappedAudioCodec) {
          _lastMediaRecoveryAt = now;
          _swappedAudioCodec = true;
          return WebHlsFatalErrorAction.swapAudioCodecAndRecoverMediaError;
        }
        return WebHlsFatalErrorAction.report;
      default:
        return WebHlsFatalErrorAction.report;
    }
  }
}
