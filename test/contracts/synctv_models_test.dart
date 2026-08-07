import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

void main() {
  group('RoomMediaEntry playback URL fallback', () {
    test('keeps provider paths as display-only metadata', () {
      expect(
        RoomMediaEntry.playbackUrlFromResource(
          metadata: const {'source': '/Videos/Movie.mkv'},
          sourceConfig: const {},
        ),
        isEmpty,
      );
    });

    test('accepts SyncTV API and network playback resources', () {
      for (final source in const [
        '/api/media/med_1/stream',
        'https://cdn.example/video.m3u8',
        'rtmp://live.example/app/stream',
      ]) {
        expect(
          RoomMediaEntry.playbackUrlFromResource(
            metadata: {'source': source},
            sourceConfig: const {},
          ),
          source,
        );
      }
    });

    test('prefers typed direct source config', () {
      expect(
        RoomMediaEntry.playbackUrlFromResource(
          metadata: const {'source': '/Videos/Movie.mkv'},
          sourceConfig: const {'url': 'https://origin.example/movie.mp4'},
        ),
        'https://origin.example/movie.mp4',
      );
    });
  });

  test('playback source identity distinguishes duplicate static media', () {
    final first = SyncTvPlaybackStatus(
      playingMediaId: 'med_73',
      targetHash: 'empty-target',
    );
    final duplicate = SyncTvPlaybackStatus(
      playingMediaId: 'med_74',
      targetHash: 'empty-target',
    );
    final refreshed = SyncTvPlaybackStatus(
      playingMediaId: 'med_73',
      targetHash: 'empty-target',
    );

    expect(first.hasSamePlaybackSource(duplicate), isFalse);
    expect(first.hasSamePlaybackSource(refreshed), isTrue);
  });

  test('room settings preserve typed auto-play configuration', () {
    final settings = SyncTvRoomSettings.fromJson({
      'autoPlay': {
        'enabled': true,
        'mode': client.PlayMode.PLAY_MODE_SHUFFLE.value,
        'delay': 7,
      },
    });

    expect(settings.autoPlayEnabled, isTrue);
    expect(settings.autoPlayMode, client.PlayMode.PLAY_MODE_SHUFFLE);
    expect(settings.autoPlayDelay, 7);
    expect(settings.toJson()['autoPlay'], {
      'enabled': true,
      'mode': client.PlayMode.PLAY_MODE_SHUFFLE.value,
      'delay': 7,
    });
  });
}
