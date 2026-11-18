@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/domain/playback_sync_executor.dart';

/// Records every command the sync loop issues, in order, and lets a test
/// flip staleness or throw from any step.
class _FakeSyncPlayer implements SyncedPlaybackPlayer {
  _FakeSyncPlayer({
    this.position = Duration.zero,
    this.duration = const Duration(minutes: 10),
    this.isPlaying = false,
    this.playbackSpeed = 1,
  });

  @override
  bool isInitialized = true;
  @override
  bool isPlaying;
  @override
  double playbackSpeed;
  @override
  Duration position;
  @override
  Duration duration;
  Object? seekError;

  final ops = <String>[];
  int staleAfterOps = 1 << 31;
  int _opCount = 0;

  bool get _stale => _opCount >= staleAfterOps;

  void _record(String op) {
    ops.add(op);
    _opCount++;
  }

  Future<void> _step(String op, Future<void> Function() action) async {
    _record(op);
    return action();
  }

  @override
  Future<void> setPlaybackSpeed(double speed) =>
      _step('speed:$speed', () async => playbackSpeed = speed);

  @override
  Future<void> pause() => _step('pause', () async => isPlaying = false);

  @override
  Future<void> seekTo(Duration target) =>
      _step('seek:${target.inMilliseconds}', () async {
        if (seekError != null) throw seekError!;
        position = target;
      });

  @override
  Future<void> play() => _step('play', () async => isPlaying = true);
}

void main() {
  // Anchor "now" so derivedCurrentTime(status) is deterministic: the status
  // below targets exactly 10s at [now].
  final now = DateTime.fromMillisecondsSinceEpoch(60_000);
  DateTime nowFn() => now;

  SyncTvPlaybackStatus status({
    bool isPlaying = true,
    double currentTime = 10,
    double playbackRate = 1,
    bool live = false,
  }) {
    return SyncTvPlaybackStatus(
      isPlaying: isPlaying,
      currentTime: currentTime,
      playbackRate: playbackRate,
      generatedAtMillis: now.millisecondsSinceEpoch,
      entry: live
          ? RoomMediaEntry(
              id: 'live',
              name: 'live',
              url: 'rtmp://x',
              live: true,
            )
          : RoomMediaEntry(id: 'vod', name: 'vod', url: 'https://x/v.mp4'),
    );
  }

  Future<void> run(
    _FakeSyncPlayer player,
    SyncTvPlaybackStatus status, {
    bool forceSeek = false,
    PlaybackModeConfig config = const PlaybackModeConfig(),
    bool Function()? isCurrentSyncOverride,
    List<Object>? syncErrors,
    int mutateCount = 0,
  }) {
    var mutations = 0;
    return runPlaybackSync(
      player: player,
      status: status,
      config: config,
      forceSeek: forceSeek,
      isCurrentSync: isCurrentSyncOverride ?? () => !player._stale,
      onPlayerMutated: () => mutations++,
      onSyncError: syncErrors == null ? (error) {} : syncErrors.add,
      now: nowFn,
    ).then((_) {
      if (mutateCount > 0) expect(mutations, mutateCount);
    });
  }

  test(
    'sync corrects rate, pauses, and skips seek inside drift tolerance',
    () async {
      final player = _FakeSyncPlayer(
        isPlaying: true,
        playbackSpeed: 1,
        position: const Duration(milliseconds: 10200),
      );
      // Paused server status at 10s; player sits 0.2s ahead (below the 1.2s
      // auto-seek threshold), so the loop must fix rate and pause but not seek.
      await run(player, status(isPlaying: false, playbackRate: 2));

      expect(player.ops, ['speed:2.0', 'pause']);
    },
  );

  test('sync seeks on large drift before starting playback', () async {
    final player = _FakeSyncPlayer(isPlaying: false, position: Duration.zero);
    await run(player, status(isPlaying: true, currentTime: 10));

    expect(player.ops, ['seek:10000', 'play']);
  });

  test('a fresh player matching the status only refreshes the UI', () async {
    final player = _FakeSyncPlayer(
      isPlaying: true,
      position: const Duration(seconds: 10),
    );
    await run(player, status(isPlaying: true, currentTime: 10), mutateCount: 1);

    expect(player.ops, isEmpty);
  });

  test('past-end status seeks to the end and forces a pause', () async {
    final player = _FakeSyncPlayer(
      isPlaying: true,
      position: const Duration(seconds: 30),
      duration: const Duration(seconds: 60),
    );
    await run(player, status(isPlaying: true, currentTime: 120));

    expect(player.ops, ['pause', 'seek:60000']);
  });

  test('forced seeks respect the tighter manual drift threshold', () async {
    final player = _FakeSyncPlayer(
      isPlaying: true,
      position: const Duration(milliseconds: 10500),
    );
    // 0.5s drift is below auto-seek (1.2s) but above manual (0.2s).
    await run(
      player,
      status(isPlaying: true, currentTime: 10),
      forceSeek: true,
    );

    expect(player.ops, ['seek:10000']);
  });

  test('free mode never auto-seeks but honors explicit forced seeks', () async {
    final player = _FakeSyncPlayer(isPlaying: false, position: Duration.zero);
    await run(
      player,
      status(isPlaying: true, currentTime: 10),
      config: const PlaybackModeConfig(freeModeEnabled: true),
    );
    expect(player.ops, ['play'], reason: 'drift correction is suppressed');

    final forced = _FakeSyncPlayer(isPlaying: false, position: Duration.zero);
    await run(
      forced,
      status(isPlaying: true, currentTime: 10),
      forceSeek: true,
      config: const PlaybackModeConfig(freeModeEnabled: true),
    );
    expect(forced.ops, ['seek:10000', 'play']);
  });

  test('live playback syncs play state without position seeking', () async {
    final player = _FakeSyncPlayer(isPlaying: false, position: Duration.zero);
    await run(player, status(isPlaying: true, currentTime: 10, live: true));

    expect(player.ops, ['play']);
  });

  test('unknown duration still seeks to the derived position', () async {
    final player = _FakeSyncPlayer(
      isPlaying: false,
      position: Duration.zero,
      duration: Duration.zero,
    );
    await run(player, status(isPlaying: true, currentTime: 50));

    expect(player.ops, ['seek:50000', 'play']);
  });

  test('a superseded sync stops after the step that made it stale', () async {
    final player = _FakeSyncPlayer(isPlaying: true, playbackSpeed: 1);
    // Staleness flips right after the rate step: rate is applied but the
    // pause decision must never run against the replaced status.
    player.staleAfterOps = 1;
    await run(player, status(isPlaying: false, playbackRate: 2));

    expect(player.ops, ['speed:2.0']);
  });

  test('staleness after seeking skips the playback start', () async {
    final player = _FakeSyncPlayer(isPlaying: false, position: Duration.zero);
    player.staleAfterOps = 1;
    await run(player, status(isPlaying: true, currentTime: 10));

    expect(player.ops, ['seek:10000']);
  });

  test('player errors are reported to the caller and stop the loop', () async {
    final player = _FakeSyncPlayer(isPlaying: false, position: Duration.zero)
      ..seekError = StateError('player exploded');
    final errors = <Object>[];
    await run(
      player,
      status(isPlaying: true, currentTime: 10),
      syncErrors: errors,
    );

    expect(player.ops, ['seek:10000']);
    expect(errors, hasLength(1), reason: 'the seek failure is surfaced once');
  });

  test('an initially stale sync issues no player commands', () async {
    final player = _FakeSyncPlayer(isPlaying: true);
    await run(
      player,
      status(isPlaying: false, playbackRate: 2),
      isCurrentSyncOverride: () => false,
    );

    expect(player.ops, isEmpty);
  });
}
