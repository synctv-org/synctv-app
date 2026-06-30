import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/models/playback_control_reporter.dart';
import 'package:synctv_app/models/playback_sync_config.dart';
import 'package:synctv_app/models/playback_sync_target.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

void main() {
  test('playback status derives current position from generated time', () {
    final status = SyncTvPlaybackStatus(
      isPlaying: true,
      currentTime: 10,
      playbackRate: 1.5,
      generatedAtMillis: 1_000,
    );

    expect(
      status.derivedCurrentTime(
        now: DateTime.fromMillisecondsSinceEpoch(3_000),
      ),
      13,
    );
  });

  test('paused playback status keeps anchor position', () {
    final status = SyncTvPlaybackStatus(
      isPlaying: false,
      currentTime: 10,
      playbackRate: 2,
      generatedAtMillis: 1_000,
    );

    expect(
      status.derivedCurrentTime(
        now: DateTime.fromMillisecondsSinceEpoch(5_000),
      ),
      10,
    );
  });

  test('client playback sync config is normalized and persisted', () async {
    SharedPreferences.setMockInitialValues({});

    await SyncTvService.savePlaybackSyncConfig(
      const PlaybackSyncConfig(
        autoSeekDriftThresholdSeconds: 0,
        manualSeekDriftThresholdSeconds: 0,
        autoSyncEnabled: false,
      ),
    );
    await SyncTvService.loadPlaybackSyncConfig();

    expect(
      SyncTvService.playbackSyncConfig.autoSeekDriftThresholdSeconds,
      0.05,
    );
    expect(
      SyncTvService.playbackSyncConfig.manualSeekDriftThresholdSeconds,
      0.1,
    );
    expect(SyncTvService.playbackSyncConfig.autoSyncEnabled, isFalse);
  });

  test('manual sync uses 0.2 second minimum seek drift by default', () {
    expect(PlaybackSyncConfig.defaults.manualSeekDriftThresholdSeconds, 0.2);
  });

  test('manual sync minimum seek drift is capped at 5 seconds', () {
    const config = PlaybackSyncConfig(manualSeekDriftThresholdSeconds: 10);

    expect(config.normalized().manualSeekDriftThresholdSeconds, 5);
  });

  test('user playback controls build realtime update messages', () {
    final reporter = PlaybackControlReporter(
      currentStatus: SyncTvPlaybackStatus(
        playingMediaId: 'media_public',
        playingPlaylistId: 'playlist_public',
        targetHash: 'target_hash',
      ),
      isSyncing: false,
      boundPosition: (position) => position.clamp(0.0, 10.0).toDouble(),
    );
    const value = VideoPlayerValue(
      duration: Duration(seconds: 20),
      position: Duration(milliseconds: 1234),
      isInitialized: true,
      isPlaying: true,
      playbackSpeed: 1.5,
    );

    final play = reporter.playbackStateChanged(value: value, isPlaying: true)!;
    expect(
      play.playbackStateUpdate.type,
      client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PLAY,
    );
    expect(play.playbackStateUpdate.playing, isTrue);
    expect(play.playbackStateUpdate.position, 1.234);
    expect(play.playbackStateUpdate.speed, 1.5);
    expect(play.playbackStateUpdate.expectedMediaId, 'media_public');
    expect(play.playbackStateUpdate.expectedPlaylistId, 'playlist_public');
    expect(play.playbackStateUpdate.expectedTargetHash, 'target_hash');

    final seek = reporter.seek(
      value: value,
      position: const Duration(milliseconds: 12_345),
    )!;
    expect(
      seek.playbackStateUpdate.type,
      client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK,
    );
    expect(seek.playbackStateUpdate.position, 10.0);

    final speed = reporter.playbackSpeedChanged(value: value, speed: 2.0)!;
    expect(
      speed.playbackStateUpdate.type,
      client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED,
    );
    expect(speed.playbackStateUpdate.speed, 2.0);
    expect(speed.playbackStateUpdate.playing, isTrue);
  });

  test('programmatic playback sync suppresses realtime update messages', () {
    final reporter = PlaybackControlReporter(
      currentStatus: SyncTvPlaybackStatus(),
      isSyncing: true,
      boundPosition: (position) => position,
    );
    const value = VideoPlayerValue(
      duration: Duration(seconds: 20),
      position: Duration(seconds: 3),
      isInitialized: true,
      isPlaying: true,
      playbackSpeed: 1.0,
    );

    expect(
      reporter.playbackStateChanged(value: value, isPlaying: false),
      isNull,
    );
    expect(
      reporter.seek(value: value, position: const Duration(seconds: 8)),
      isNull,
    );
    expect(reporter.playbackSpeedChanged(value: value, speed: 1.25), isNull);
  });

  test('sync target clamps past-duration playback to video end', () {
    final target = resolvePlaybackSyncTarget(
      status: SyncTvPlaybackStatus(
        isPlaying: true,
        currentTime: 12.5,
        playbackRate: 1.0,
      ),
      duration: const Duration(seconds: 4),
    );

    expect(target.positionSeconds, 4.0);
    expect(target.isAtEnd, isTrue);
  });

  test('sync target keeps in-range derived playback position', () {
    final target = resolvePlaybackSyncTarget(
      status: SyncTvPlaybackStatus(
        isPlaying: true,
        currentTime: 1.5,
        playbackRate: 2.0,
        generatedAtMillis: 1_000,
      ),
      duration: const Duration(seconds: 10),
      now: DateTime.fromMillisecondsSinceEpoch(2_000),
    );

    expect(target.positionSeconds, 3.5);
    expect(target.isAtEnd, isFalse);
  });

  test(
    'sync target preserves derived playback position without known duration',
    () {
      final target = resolvePlaybackSyncTarget(
        status: SyncTvPlaybackStatus(
          isPlaying: true,
          currentTime: 12.5,
          playbackRate: 1.0,
        ),
        duration: Duration.zero,
      );

      expect(target.positionSeconds, 12.5);
      expect(target.isAtEnd, isFalse);
    },
  );
}
