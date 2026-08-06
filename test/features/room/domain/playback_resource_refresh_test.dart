import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/domain/playback_resource_refresh.dart';

void main() {
  test('active source remains usable until its hard expiry', () {
    final now = DateTime.utc(2026, 8, 5, 12);

    expect(
      activePlaybackSourceCanContinue(
        expireAt:
            now.add(const Duration(minutes: 5)).millisecondsSinceEpoch ~/ 1000,
        now: now,
      ),
      isTrue,
    );
    expect(
      activePlaybackSourceCanContinue(
        expireAt:
            now.add(const Duration(seconds: 60)).millisecondsSinceEpoch ~/ 1000,
        now: now,
      ),
      isTrue,
    );
    expect(
      activePlaybackSourceCanContinue(
        expireAt: now.millisecondsSinceEpoch ~/ 1000,
        now: now,
      ),
      isFalse,
    );
    expect(activePlaybackSourceCanContinue(expireAt: null, now: now), isFalse);
  });

  test('refresh deadline includes the complete playback snapshot', () {
    expect(
      earliestPlaybackResourceExpiration(
        selectedMediaExpireAt: 200,
        playbackExpireAt: 100,
      ),
      100,
    );
    expect(
      earliestPlaybackResourceExpiration(
        selectedMediaExpireAt: 100,
        playbackExpireAt: 200,
      ),
      100,
    );
    expect(
      earliestPlaybackResourceExpiration(
        selectedMediaExpireAt: null,
        playbackExpireAt: 200,
      ),
      200,
    );
  });

  test('refreshes a playback resource before its server expiry', () {
    final now = DateTime.utc(2026, 8, 5, 12);

    expect(
      playbackResourceRefreshDelay(
        expireAt:
            now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
        now: now,
      ),
      const Duration(minutes: 59),
    );
  });

  test('uses a bounded minimum delay inside the refresh window', () {
    final now = DateTime.utc(2026, 8, 5, 12);

    expect(
      playbackResourceRefreshDelay(
        expireAt:
            now.add(const Duration(seconds: 30)).millisecondsSinceEpoch ~/ 1000,
        now: now,
      ),
      playbackResourceRefreshMinimumDelay,
    );
    expect(playbackResourceRefreshDelay(expireAt: null, now: now), isNull);
  });

  test('refresh retries stay bounded and continue after hard expiry', () {
    final now = DateTime.utc(2026, 8, 5, 12);
    final expireAt =
        now.add(const Duration(seconds: 40)).millisecondsSinceEpoch ~/ 1000;
    expect(
      playbackResourceRefreshRetryDelay(
        attempt: 1,
        expireAt: expireAt,
        now: now,
      ),
      const Duration(seconds: 5),
    );
    expect(
      playbackResourceRefreshRetryDelay(
        attempt: 2,
        expireAt: expireAt,
        now: now,
      ),
      const Duration(seconds: 15),
    );
    expect(
      playbackResourceRefreshRetryDelay(
        attempt: 3,
        expireAt: expireAt,
        now: now,
      ),
      playbackResourceRefreshMaximumRetryDelay,
    );
    expect(
      playbackResourceRefreshRetryDelay(
        attempt: 4,
        expireAt:
            now.add(const Duration(seconds: 10)).millisecondsSinceEpoch ~/ 1000,
        now: now,
      ),
      const Duration(seconds: 9),
    );
    expect(
      playbackResourceRefreshRetryDelay(
        attempt: 8,
        expireAt:
            now.subtract(const Duration(seconds: 1)).millisecondsSinceEpoch ~/
            1000,
        now: now,
      ),
      playbackResourceRefreshMaximumRetryDelay,
    );
  });
}
