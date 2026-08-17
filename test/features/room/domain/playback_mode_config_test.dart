import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/features/room/presentation/playback_control_reporter.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_mode_store.dart';
import 'package:synctv_app/features/room/data/protobuf_room_realtime_protocol.dart';
import 'package:synctv_app/features/room/domain/playback_sync_target.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

const _realtimeProtocol = ProtobufRoomRealtimeProtocol();

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

  test('client playback mode config is normalized and persisted', () async {
    SharedPreferences.setMockInitialValues({});

    final controller = PlaybackModePreferencesController(
      store: const SharedPreferencesPlaybackModeStore(),
    );
    await controller.update(
      const PlaybackModeConfig(
        autoSeekDriftThresholdSeconds: 0,
        manualSeekDriftThresholdSeconds: 0,
        freeModeEnabled: true,
      ),
    );
    final restored = PlaybackModePreferencesController(
      store: const SharedPreferencesPlaybackModeStore(),
    );
    await restored.load();

    expect(restored.value.autoSeekDriftThresholdSeconds, 0.05);
    expect(restored.value.manualSeekDriftThresholdSeconds, 0.1);
    expect(restored.value.freeModeEnabled, isTrue);
    expect(restored.value.toJson()['freeModeEnabled'], isTrue);
  });

  test('free mode is disabled by default', () {
    expect(PlaybackModeConfig.defaults.freeModeEnabled, isFalse);
  });

  test('manual sync uses 0.2 second minimum seek drift by default', () {
    expect(PlaybackModeConfig.defaults.manualSeekDriftThresholdSeconds, 0.2);
  });

  test('manual sync minimum seek drift is capped at 5 seconds', () {
    const config = PlaybackModeConfig(manualSeekDriftThresholdSeconds: 10);

    expect(config.normalized().manualSeekDriftThresholdSeconds, 5);
  });

  test('user playback controls build realtime update messages', () {
    final reporter = PlaybackControlReporter(
      currentStatus: SyncTvPlaybackStatus(
        isPlaying: true,
        playingMediaId: 'media_public',
        playingPlaylistId: 'playlist_public',
        targetHash: 'target_hash',
      ),
      isLive: false,
      boundPosition: (position) => position.clamp(0.0, 10.0).toDouble(),
      protocol: _realtimeProtocol,
    );
    const value = VideoPlayerValue(
      duration: Duration(seconds: 20),
      position: Duration(milliseconds: 1234),
      isInitialized: true,
      isPlaying: true,
      playbackSpeed: 1.5,
    );

    final play = client.ClientMessage.fromBuffer(
      reporter.playbackStateChanged(value: value, isPlaying: true)!,
    );
    expect(
      play.playbackStateUpdate.type,
      client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PLAY,
    );
    expect(play.playbackStateUpdate.playing, isTrue);
    expect(play.playbackStateUpdate.position, 1.234);
    expect(play.playbackStateUpdate.hasSpeed(), isFalse);
    expect(play.playbackStateUpdate.expectedMediaId, 'media_public');
    expect(play.playbackStateUpdate.expectedPlaylistId, 'playlist_public');
    expect(play.playbackStateUpdate.expectedTargetHash, 'target_hash');

    final seek = client.ClientMessage.fromBuffer(
      reporter.seek(
        value: value,
        position: const Duration(milliseconds: 12_345),
      )!,
    );
    expect(
      seek.playbackStateUpdate.type,
      client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK,
    );
    expect(seek.playbackStateUpdate.position, 10.0);
    expect(seek.playbackStateUpdate.hasSpeed(), isFalse);

    final speed = client.ClientMessage.fromBuffer(
      reporter.playbackSpeedChanged(value: value, speed: 2.0)!,
    );
    expect(
      speed.playbackStateUpdate.type,
      client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED,
    );
    expect(speed.playbackStateUpdate.speed, 2.0);
    expect(speed.playbackStateUpdate.playing, isTrue);
  });

  test('explicit playback controls remain reportable during local sync', () {
    final reporter = PlaybackControlReporter(
      currentStatus: SyncTvPlaybackStatus(),
      isLive: false,
      boundPosition: (position) => position,
      protocol: _realtimeProtocol,
    );
    const value = VideoPlayerValue(
      duration: Duration(seconds: 20),
      position: Duration(seconds: 3),
      isInitialized: true,
      isPlaying: true,
      playbackSpeed: 1.0,
    );

    final pause = client.ClientMessage.fromBuffer(
      reporter.playbackStateChanged(value: value, isPlaying: false)!,
    );
    expect(pause.playbackStateUpdate.hasExpectedMediaId(), isFalse);
    expect(pause.playbackStateUpdate.hasExpectedPlaylistId(), isFalse);
    expect(pause.playbackStateUpdate.hasExpectedTargetHash(), isFalse);
    expect(
      reporter.seek(value: value, position: const Duration(seconds: 8)),
      isNotNull,
    );
    expect(reporter.playbackSpeedChanged(value: value, speed: 1.25), isNotNull);
  });

  test(
    'seek and speed preserve paused server intent during controller races',
    () {
      final reporter = PlaybackControlReporter(
        currentStatus: SyncTvPlaybackStatus(isPlaying: false),
        isLive: false,
        boundPosition: (position) => position,
        protocol: _realtimeProtocol,
      );
      const transientlyPlayingValue = VideoPlayerValue(
        duration: Duration(seconds: 20),
        position: Duration(seconds: 3),
        isInitialized: true,
        isPlaying: true,
        playbackSpeed: 1.0,
      );

      final seek = client.ClientMessage.fromBuffer(
        reporter.seek(
          value: transientlyPlayingValue,
          position: const Duration(seconds: 8),
        )!,
      );
      expect(seek.playbackStateUpdate.playing, isFalse);

      final speed = client.ClientMessage.fromBuffer(
        reporter.playbackSpeedChanged(
          value: transientlyPlayingValue,
          speed: 1.25,
        )!,
      );
      expect(speed.playbackStateUpdate.playing, isFalse);
    },
  );

  test('live playback controls omit progress and suppress seeking', () {
    final reporter = PlaybackControlReporter(
      currentStatus: SyncTvPlaybackStatus(),
      isLive: true,
      boundPosition: (position) => position,
      protocol: _realtimeProtocol,
    );
    const value = VideoPlayerValue(
      duration: Duration.zero,
      position: Duration(seconds: 30),
      isInitialized: true,
      isPlaying: true,
      playbackSpeed: 1.0,
    );

    final pause = client.ClientMessage.fromBuffer(
      reporter.playbackStateChanged(value: value, isPlaying: false)!,
    );
    expect(
      pause.playbackStateUpdate.type,
      client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PAUSE,
    );
    expect(pause.playbackStateUpdate.playing, isFalse);
    expect(pause.playbackStateUpdate.hasPosition(), isFalse);
    expect(
      reporter.seek(value: value, position: const Duration(seconds: 8)),
      isNull,
    );
  });

  test('sync target clamps past-duration playback to video end', () {
    final target = resolvePlaybackSyncTarget(
      status: SyncTvPlaybackStatus(
        isPlaying: true,
        currentTime: 12.5,
        playbackRate: 1.0,
      ),
      duration: const Duration(seconds: 4),
      now: DateTime.fromMillisecondsSinceEpoch(0),
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
    'non-free mode retries automatic sync after delayed playback falls behind',
    () {
      final target = resolvePlaybackSyncTarget(
        status: SyncTvPlaybackStatus(
          isPlaying: true,
          currentTime: 10,
          generatedAtMillis: 1_000,
        ),
        duration: const Duration(seconds: 30),
        now: DateTime.fromMillisecondsSinceEpoch(4_000),
      );

      expect(
        shouldAutoSeekToPlaybackSyncTarget(
          currentPositionSeconds: 10,
          target: target,
          driftThresholdSeconds: 1.2,
          freeModeEnabled: false,
        ),
        isTrue,
      );
      expect(
        shouldAutoSeekToPlaybackSyncTarget(
          currentPositionSeconds: 10,
          target: target,
          driftThresholdSeconds: 1.2,
          freeModeEnabled: true,
        ),
        isFalse,
      );
    },
  );

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
        now: DateTime.fromMillisecondsSinceEpoch(0),
      );

      expect(target.positionSeconds, 12.5);
      expect(target.isAtEnd, isFalse);
    },
  );
}
