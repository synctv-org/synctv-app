import 'dart:math' as math;

/// Exponential backoff with equal jitter for realtime reconnects.
///
/// Delay after the n-th consecutive failure grows exponentially from
/// [baseDelay] up to [maxDelay]; the actual wait is half the computed delay
/// plus a uniform random remainder, so a fleet of reconnecting clients
/// spreads out instead of thundering the server in lockstep while the first
/// retry stays prompt.
class RealtimeReconnectPolicy {
  RealtimeReconnectPolicy({
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.maxAttempts = double.infinity,
    math.Random? random,
  }) : _random = random ?? math.Random();

  final Duration baseDelay;
  final Duration maxDelay;

  /// Attempts before [exhausted] flips true; `double.infinity` retries
  /// forever.
  final double maxAttempts;

  final math.Random _random;

  int _attempts = 0;

  /// Consecutive failed attempts so far.
  int get attempts => _attempts;

  /// True once [maxAttempts] consecutive failures were recorded.
  bool get exhausted => _attempts >= maxAttempts;

  /// The delay to wait before the next attempt. Advances the attempt
  /// counter; call only when an attempt actually failed.
  Duration nextDelay() {
    final exponential = baseDelay * (1 << _attempts.clamp(0, 30));
    final capped = exponential < maxDelay ? exponential : maxDelay;
    _attempts++;
    final half = capped.inMicroseconds ~/ 2;
    final jitterMicros = _random.nextInt(half + 1);
    return Duration(microseconds: half + jitterMicros);
  }

  /// Zeroes the backoff after a successful connection.
  void reset() => _attempts = 0;
}
