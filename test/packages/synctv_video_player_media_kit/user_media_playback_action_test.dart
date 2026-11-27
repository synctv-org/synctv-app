import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';

void main() {
  group('UserMediaPlaybackAction.parse', () {
    test('maps play and pause actions', () {
      expect(
        UserMediaPlaybackAction.parse('play'),
        isA<UserMediaPlaybackAction>()
            .having(
              (action) => action.kind,
              'kind',
              UserMediaPlaybackActionKind.play,
            )
            .having((action) => action.seconds, 'seconds', isNull),
      );
      expect(
        UserMediaPlaybackAction.parse('pause'),
        isA<UserMediaPlaybackAction>()
            .having(
              (action) => action.kind,
              'kind',
              UserMediaPlaybackActionKind.pause,
            )
            .having((action) => action.seconds, 'seconds', isNull),
      );
    });

    test('keeps the browser-provided seek offset when positive', () {
      final action = UserMediaPlaybackAction.parse(
        'seekforward',
        seekOffsetSeconds: 15,
      );
      expect(action?.kind, UserMediaPlaybackActionKind.seekForward);
      expect(action?.seconds, 15);
    });

    test(
      'falls back to the default seek offset when the browser omits one',
      () {
        for (final offset in [
          null,
          0.0,
          -5.0,
          double.nan,
          double.infinity,
        ]) {
          expect(
            UserMediaPlaybackAction.parse(
              'seekbackward',
              seekOffsetSeconds: offset,
            )?.seconds,
            defaultUserMediaSeekOffset,
          );
        }
      },
    );

    test('accepts a seek to position zero', () {
      final action = UserMediaPlaybackAction.parse(
        'seekto',
        seekTimeSeconds: 0,
      );
      expect(action?.kind, UserMediaPlaybackActionKind.seekTo);
      expect(action?.seconds, 0);
    });

    test('drops a seek with a missing or broken position', () {
      for (final time in [null, -1.0, double.nan, double.infinity]) {
        expect(
          UserMediaPlaybackAction.parse('seekto', seekTimeSeconds: time),
          isNull,
        );
      }
    });

    test('drops actions this player does not handle', () {
      for (final action in [
        'previoustrack',
        'nexttrack',
        'seekbackforward',
        '',
      ]) {
        expect(UserMediaPlaybackAction.parse(action), isNull);
      }
    });
  });
}
