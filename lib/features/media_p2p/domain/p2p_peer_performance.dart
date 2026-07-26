import 'dart:math';

class P2pPeerPerformance {
  static const int defaultEstimatedPieceBytes = 1024 * 1024;
  static const double _defaultBytesPerSecond = 2 * 1024 * 1024;
  static const double _defaultRoundTripSeconds = 0.25;

  Duration? roundTripTime;
  double bytesPerSecond = 0;
  int consecutiveFailures = 0;
  int inFlightRequests = 0;
  DateTime? lastProbeAt;

  bool shouldProbe(DateTime now, Duration interval) {
    final lastProbe = lastProbeAt;
    return lastProbe == null || now.difference(lastProbe) >= interval;
  }

  void markProbeStarted(DateTime now) {
    lastProbeAt = now;
  }

  void recordRoundTrip(Duration sample) {
    final current = roundTripTime;
    if (current == null) {
      roundTripTime = sample;
      return;
    }
    roundTripTime = Duration(
      microseconds:
          (current.inMicroseconds * 0.75 + sample.inMicroseconds * 0.25)
              .round(),
    );
  }

  void beginRequest() {
    inFlightRequests++;
  }

  void recordSuccess(int bytes, Duration elapsed) {
    final roundTripMicros = roundTripTime?.inMicroseconds ?? 0;
    final transferMicros = max(
      elapsed.inMicroseconds - roundTripMicros / 2,
      1000,
    );
    final sample = bytes * Duration.microsecondsPerSecond / transferMicros;
    bytesPerSecond = bytesPerSecond == 0
        ? sample
        : bytesPerSecond * 0.7 + sample * 0.3;
    consecutiveFailures = 0;
  }

  void recordFailure() {
    consecutiveFailures = min(consecutiveFailures + 1, 8);
  }

  void endRequest() {
    inFlightRequests = max(inFlightRequests - 1, 0);
  }

  double estimatedCompletionSeconds({
    int estimatedBytes = defaultEstimatedPieceBytes,
  }) {
    final latencySeconds = roundTripTime == null
        ? _defaultRoundTripSeconds
        : max(
            roundTripTime!.inMicroseconds / Duration.microsecondsPerSecond,
            0.001,
          );
    final throughput = bytesPerSecond > 0
        ? bytesPerSecond
        : _defaultBytesPerSecond;
    final base = latencySeconds + estimatedBytes / throughput;
    final loadMultiplier = inFlightRequests + 1;
    final failureMultiplier = 1 + consecutiveFailures * 0.75;
    return base * loadMultiplier * failureMultiplier;
  }
}

int compareP2pPeerPerformance(
  P2pPeerPerformance left,
  P2pPeerPerformance right, {
  int estimatedBytes = P2pPeerPerformance.defaultEstimatedPieceBytes,
}) => left
    .estimatedCompletionSeconds(estimatedBytes: estimatedBytes)
    .compareTo(
      right.estimatedCompletionSeconds(estimatedBytes: estimatedBytes),
    );
