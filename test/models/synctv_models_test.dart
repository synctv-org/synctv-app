import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/models/synctv_models.dart';

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
}
