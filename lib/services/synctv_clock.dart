class SyncedClock {
  static int _offsetMicros = 0;
  static int? _roundTripMicros;
  static DateTime? _syncedAt;

  static DateTime now() {
    final local = DateTime.now();
    if (_offsetMicros == 0) return local;
    return DateTime.fromMicrosecondsSinceEpoch(
      local.microsecondsSinceEpoch + _offsetMicros,
    );
  }

  static int nowMillis() => now().millisecondsSinceEpoch;

  static int localUnixNanos() => DateTime.now().microsecondsSinceEpoch * 1000;

  static bool get isSynced => _syncedAt != null;

  static DateTime? get syncedAt => _syncedAt;

  static Duration? get roundTripTime => _roundTripMicros == null
      ? null
      : Duration(microseconds: _roundTripMicros!);

  static Duration? get estimatedLatency => _roundTripMicros == null
      ? null
      : Duration(microseconds: _roundTripMicros! ~/ 2);

  static void updateFromServerTime({
    required int clientSentAtNanos,
    required int clientReceivedAtNanos,
    required int serverReceivedAtNanos,
    required int serverSentAtNanos,
  }) {
    if (clientSentAtNanos <= 0 ||
        clientReceivedAtNanos <= 0 ||
        serverReceivedAtNanos <= 0 ||
        serverSentAtNanos <= 0) {
      return;
    }

    final offsetNanos =
        (serverReceivedAtNanos -
            clientSentAtNanos +
            serverSentAtNanos -
            clientReceivedAtNanos) ~/
        2;
    final roundTripNanos =
        (clientReceivedAtNanos - clientSentAtNanos) -
        (serverSentAtNanos - serverReceivedAtNanos);
    _offsetMicros = offsetNanos ~/ 1000;
    _roundTripMicros = roundTripNanos <= 0 ? 0 : roundTripNanos ~/ 1000;
    _syncedAt = DateTime.now();
  }

  static void reset() {
    _offsetMicros = 0;
    _roundTripMicros = null;
    _syncedAt = null;
  }
}
