import 'package:synctv_app/features/room/presentation/models/playback_player_update.dart';

final playbackExpiryChecks = <String, void Function()>{
  for (final entry in <String, int?>{
    'Missing expiry': null,
    'Zero expiry': 0,
    'Negative expiry': -1,
    'Beyond DateTime range': 8640000000001,
    'Maximum exact web integer': 9007199254740991,
  }.entries)
    entry.key: () => _check(entry.value, DateTime.utc(2024), false),
  'Expired source': () => _check(1704067199, DateTime.utc(2024), false),
  'Exact expiry instant': () => _check(1704067200, DateTime.utc(2024), false),
  'One microsecond before expiry': () => _check(
    1704067200,
    DateTime.utc(2024).subtract(const Duration(microseconds: 1)),
    true,
  ),
  'One microsecond after expiry': () => _check(
    1704067200,
    DateTime.utc(2024).add(const Duration(microseconds: 1)),
    false,
  ),
  'Future source': () => _check(1704067201, DateTime.utc(2024), true),
  'Local clock instant': () =>
      _check(1704067201, DateTime.utc(2024).toLocal(), true),
  'Maximum DateTime expiry': () =>
      _check(8640000000000, DateTime.utc(2024), true),
};

void _check(int? seconds, DateTime now, bool expected) {
  final actual = activePlaybackSourceCanContinue(expireAt: seconds, now: now);
  if (actual != expected) {
    throw StateError(
      'Expiry $seconds at $now: expected $expected, got $actual',
    );
  }
}
