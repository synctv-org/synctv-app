import 'package:synctv_app/core/time/synced_clock.dart';

const _baseNanos = 1700000000000000000;

final syncedClockChecks = <String, void Function()>{
  for (final previous in [false, true])
    for (final invalid in [
      'client reversed',
      'server reversed',
      'negative RTT',
    ])
      '$invalid / ${previous ? 'preserve sample' : 'stay unsynced'}': () {
        SyncedClock.reset();
        try {
          if (previous) _validSample();
          final syncedAt = SyncedClock.syncedAt;
          final roundTrip = SyncedClock.roundTripTime;
          SyncedClock.updateFromServerTime(
            clientSentAtNanos: _baseNanos,
            clientReceivedAtNanos:
                _baseNanos +
                (invalid == 'client reversed' ? -100000000 : 100000000),
            serverReceivedAtNanos: _baseNanos + 1000000000,
            serverSentAtNanos:
                _baseNanos +
                (invalid == 'server reversed'
                    ? 900000000
                    : invalid == 'negative RTT'
                    ? 1200000000
                    : 1000000000),
          );
          _require(SyncedClock.isSynced == previous, 'sync state changed');
          _require(
            SyncedClock.syncedAt == syncedAt,
            'sample timestamp changed',
          );
          _require(SyncedClock.roundTripTime == roundTrip, 'RTT changed');
          _expectOffset(previous ? 2000000 : 0);
        } finally {
          SyncedClock.reset();
        }
      },
  for (final offset in [-2000000, 0, 2000000])
    'valid offset ${offset ~/ 1000} ms': () {
      SyncedClock.reset();
      try {
        _validSample(offsetMicros: offset);
        _require(SyncedClock.isSynced, 'sample was not accepted');
        _require(
          SyncedClock.roundTripTime == const Duration(milliseconds: 100),
          'wrong RTT',
        );
        _require(
          SyncedClock.estimatedLatency == const Duration(milliseconds: 50),
          'wrong latency',
        );
        _expectOffset(offset);
      } finally {
        SyncedClock.reset();
      }
    },
  'zero network RTT remains valid': () {
    SyncedClock.reset();
    try {
      SyncedClock.updateFromServerTime(
        clientSentAtNanos: _baseNanos,
        clientReceivedAtNanos: _baseNanos + 100000000,
        serverReceivedAtNanos: _baseNanos,
        serverSentAtNanos: _baseNanos + 100000000,
      );
      _require(SyncedClock.isSynced, 'zero RTT rejected');
      _require(SyncedClock.roundTripTime == Duration.zero, 'wrong zero RTT');
      _expectOffset(0);
    } finally {
      SyncedClock.reset();
    }
  },
};

void _validSample({int offsetMicros = 2000000}) {
  SyncedClock.updateFromServerTime(
    clientSentAtNanos: _baseNanos,
    clientReceivedAtNanos: _baseNanos + 110000000,
    serverReceivedAtNanos: _baseNanos + offsetMicros * 1000 + 50000000,
    serverSentAtNanos: _baseNanos + offsetMicros * 1000 + 60000000,
  );
}

void _expectOffset(int offsetMicros) {
  final before = DateTime.now().microsecondsSinceEpoch + offsetMicros;
  final actual = SyncedClock.now().microsecondsSinceEpoch;
  final after = DateTime.now().microsecondsSinceEpoch + offsetMicros;
  _require(actual >= before && actual <= after, 'unexpected clock offset');
}

void _require(bool condition, String message) {
  if (!condition) throw StateError(message);
}
