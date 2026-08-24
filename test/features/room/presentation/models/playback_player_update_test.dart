import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/models/playback_player_update.dart';

RoomPlaybackEntry liveEntry({
  required SyncTvLiveStreamAvailability availability,
  required String generation,
  String url = 'https://example.test/live.m3u8',
}) {
  return RoomPlaybackEntry(
    id: 'med_live',
    name: 'Live',
    url: url,
    live: true,
    liveStreamAvailability: availability,
    liveStreamGenerationId: generation,
  );
}

void main() {
  test('live playback retries a missed play-state synchronization', () {
    expect(
      playbackSyncCorrectionRequired(
        isLive: true,
        targetIsPlaying: true,
        playerIsPlaying: false,
        positionRequiresCorrection: false,
      ),
      isTrue,
    );
    expect(
      playbackSyncCorrectionRequired(
        isLive: true,
        targetIsPlaying: true,
        playerIsPlaying: true,
        positionRequiresCorrection: true,
      ),
      isFalse,
    );
  });

  test('on-demand playback retries state and position mismatches', () {
    expect(
      playbackSyncCorrectionRequired(
        isLive: false,
        targetIsPlaying: false,
        playerIsPlaying: true,
        positionRequiresCorrection: false,
      ),
      isTrue,
    );
    expect(
      playbackSyncCorrectionRequired(
        isLive: false,
        targetIsPlaying: true,
        playerIsPlaying: true,
        positionRequiresCorrection: true,
      ),
      isTrue,
    );
  });

  test('live providers without managed RTMP state remain playable', () {
    final entry = RoomPlaybackEntry(
      id: 'med_provider_live',
      name: 'Provider live',
      url: 'https://example.test/provider-live.m3u8',
      live: true,
    );

    expect(entry.liveStreamAvailability, isNull);
    expect(entry.isLiveStreamPlayable, isTrue);
  });

  test(
    'unspecified managed RTMP state waits for an authoritative snapshot',
    () {
      final entry = liveEntry(
        availability: SyncTvLiveStreamAvailability.unspecified,
        generation: '',
      );

      expect(entry.isLiveStreamPlayable, isFalse);
    },
  );

  test('offline live snapshots drain a player that has produced media', () {
    final previous = liveEntry(
      availability: SyncTvLiveStreamAvailability.live,
      generation: 'generation-1',
    );

    expect(
      playbackPlayerUpdateAction(
        previous: previous,
        next: liveEntry(
          availability: SyncTvLiveStreamAvailability.offline,
          generation: '',
        ),
        hasController: true,
        controllerHasPlayed: true,
        isDrainingEndedLiveStream: false,
        samePlayerSource: true,
      ),
      PlaybackPlayerUpdateAction.drain,
    );
  });

  test('offline live snapshots dispose a player without playback progress', () {
    final previous = liveEntry(
      availability: SyncTvLiveStreamAvailability.live,
      generation: 'generation-1',
    );

    expect(
      playbackPlayerUpdateAction(
        previous: previous,
        next: liveEntry(
          availability: SyncTvLiveStreamAvailability.offline,
          generation: '',
        ),
        hasController: true,
        controllerHasPlayed: false,
        isDrainingEndedLiveStream: false,
        samePlayerSource: true,
      ),
      PlaybackPlayerUpdateAction.dispose,
    );
  });

  test('repeated offline snapshots keep draining the same live media', () {
    final offline = liveEntry(
      availability: SyncTvLiveStreamAvailability.offline,
      generation: '',
    );

    expect(
      playbackPlayerUpdateAction(
        previous: offline,
        next: offline,
        hasController: true,
        controllerHasPlayed: true,
        isDrainingEndedLiveStream: true,
        samePlayerSource: true,
      ),
      PlaybackPlayerUpdateAction.drain,
    );
  });

  test('new live generation reloads an unchanged URL', () {
    final previous = liveEntry(
      availability: SyncTvLiveStreamAvailability.live,
      generation: 'generation-1',
    );
    final next = liveEntry(
      availability: SyncTvLiveStreamAvailability.live,
      generation: 'generation-2',
    );

    expect(
      playbackPlayerUpdateAction(
        previous: previous,
        next: next,
        hasController: true,
        controllerHasPlayed: true,
        isDrainingEndedLiveStream: false,
        samePlayerSource: true,
      ),
      PlaybackPlayerUpdateAction.reload,
    );
  });

  test('new live generation interrupts an offline drain', () {
    final previous = liveEntry(
      availability: SyncTvLiveStreamAvailability.offline,
      generation: '',
    );
    final next = liveEntry(
      availability: SyncTvLiveStreamAvailability.live,
      generation: 'generation-2',
    );

    expect(
      playbackPlayerUpdateAction(
        previous: previous,
        next: next,
        hasController: true,
        controllerHasPlayed: true,
        isDrainingEndedLiveStream: true,
        samePlayerSource: true,
      ),
      PlaybackPlayerUpdateAction.reload,
    );
  });

  test('unchanged live generation keeps the active player', () {
    final previous = liveEntry(
      availability: SyncTvLiveStreamAvailability.live,
      generation: 'generation-1',
    );
    final next = liveEntry(
      availability: SyncTvLiveStreamAvailability.live,
      generation: 'generation-1',
    );

    expect(
      playbackPlayerUpdateAction(
        previous: previous,
        next: next,
        hasController: true,
        controllerHasPlayed: true,
        isDrainingEndedLiveStream: false,
        samePlayerSource: true,
      ),
      PlaybackPlayerUpdateAction.keep,
    );
  });

  test('a refreshed URL keeps a still-valid active source', () {
    final previous = RoomPlaybackEntry(
      id: 'med_vod',
      name: 'Video',
      url: 'https://example.test/old.m3u8',
      selectedPlaybackMode: 'direct',
    );
    final refreshed = previous.copyWith(
      url: 'https://example.test/refreshed.m3u8',
    );

    expect(
      shouldRetainActivePlaybackSource(
        previous: previous,
        next: refreshed,
        authoritativeSourceChanged: false,
        activeSourceCanContinue: true,
      ),
      isTrue,
    );
    expect(
      shouldRetainActivePlaybackSource(
        previous: previous,
        next: refreshed,
        authoritativeSourceChanged: true,
        activeSourceCanContinue: true,
      ),
      isFalse,
    );
    expect(
      shouldRetainActivePlaybackSource(
        previous: previous,
        next: refreshed,
        authoritativeSourceChanged: false,
        activeSourceCanContinue: false,
      ),
      isFalse,
    );
  });

  test('a playback route change activates the selected source', () {
    final direct = RoomPlaybackEntry(
      id: 'med_vod',
      name: 'Video',
      url: 'https://example.test/direct.m3u8',
      selectedPlaybackMode: 'direct',
    );
    final proxy = direct.copyWith(
      url: 'https://example.test/proxy.m3u8',
      selectedPlaybackMode: 'proxy',
    );

    expect(
      shouldRetainActivePlaybackSource(
        previous: direct,
        next: proxy,
        authoritativeSourceChanged: false,
        activeSourceCanContinue: true,
      ),
      isFalse,
    );
  });

  test('an offline snapshot for another media stops the active drain', () {
    final previous = liveEntry(
      availability: SyncTvLiveStreamAvailability.offline,
      generation: '',
    );
    final next = RoomPlaybackEntry(
      id: 'med_other',
      name: 'Other live',
      url: 'https://example.test/other-live.m3u8',
      live: true,
      liveStreamAvailability: SyncTvLiveStreamAvailability.offline,
    );

    expect(
      playbackPlayerUpdateAction(
        previous: previous,
        next: next,
        hasController: true,
        controllerHasPlayed: true,
        isDrainingEndedLiveStream: true,
        samePlayerSource: false,
      ),
      PlaybackPlayerUpdateAction.dispose,
    );
  });

  test('an authoritative empty source disposes the active player', () {
    final previous = RoomPlaybackEntry(
      id: 'med_vod',
      name: 'Video',
      url: 'https://example.test/video.mp4',
    );

    expect(
      playbackPlayerUpdateAction(
        previous: previous,
        next: null,
        hasController: true,
        controllerHasPlayed: true,
        isDrainingEndedLiveStream: false,
        samePlayerSource: false,
      ),
      PlaybackPlayerUpdateAction.dispose,
    );
  });
}
