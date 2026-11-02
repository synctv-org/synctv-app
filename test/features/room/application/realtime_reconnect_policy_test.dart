import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/realtime_reconnect_policy.dart';

/// Deterministic random source for jitter tests: returns [value] scaled to
/// whatever the policy asks for (0 → minimum, 1 → maximum).
class _FixedRandom implements math.Random {
  _FixedRandom(this.value);

  final double value;

  @override
  int nextInt(int max) => (value * (max - 1)).round().clamp(0, max - 1);

  @override
  bool nextBool() => value >= 0.5;

  @override
  double nextDouble() => value;
}

void main() {
  group('RealtimeReconnectPolicy', () {
    test('delay grows exponentially and is capped', () {
      final policy = RealtimeReconnectPolicy(
        baseDelay: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 30),
        random: _FixedRandom(1),
      );

      // Full jitter value (random = 1) keeps the whole computed delay.
      expect(policy.nextDelay(), const Duration(seconds: 1));
      expect(policy.nextDelay(), const Duration(seconds: 2));
      expect(policy.nextDelay(), const Duration(seconds: 4));
      expect(policy.nextDelay(), const Duration(seconds: 8));
      expect(policy.nextDelay(), const Duration(seconds: 16));
      expect(policy.nextDelay(), const Duration(seconds: 30));
      expect(policy.nextDelay(), const Duration(seconds: 30));
    });

    test('equal jitter floors the delay at half', () {
      final policy = RealtimeReconnectPolicy(
        baseDelay: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 30),
        random: _FixedRandom(0),
      );

      expect(policy.nextDelay(), const Duration(milliseconds: 500));
      expect(policy.nextDelay(), const Duration(seconds: 1));
      expect(policy.nextDelay(), const Duration(seconds: 2));
    });

    test('reset zeroes the backoff after success', () {
      final policy = RealtimeReconnectPolicy(random: _FixedRandom(1));
      policy
        ..nextDelay()
        ..nextDelay()
        ..nextDelay()
        ..reset();

      expect(policy.attempts, 0);
      expect(policy.nextDelay(), const Duration(seconds: 1));
    });

    test('exhausts after the configured attempts', () {
      final policy = RealtimeReconnectPolicy(
        maxAttempts: 2,
        random: _FixedRandom(0),
      );
      expect(policy.exhausted, isFalse);
      policy.nextDelay();
      policy.nextDelay();
      expect(policy.exhausted, isTrue);
    });
  });
}
