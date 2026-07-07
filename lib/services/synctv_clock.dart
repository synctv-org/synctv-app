class SyncedClock {
  static int _offsetMicros = 0;
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
    _offsetMicros = offsetNanos ~/ 1000;
    _syncedAt = DateTime.now();
  }

  static void reset() {
    _offsetMicros = 0;
    _syncedAt = null;
  }
}
