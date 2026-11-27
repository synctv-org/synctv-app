import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/domain/user_media_seek_target.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';

Duration _milliseconds(int milliseconds) =>
    Duration(milliseconds: milliseconds);

void main() {
  group('resolveUserMediaSeekTarget', () {
    test('seekTo uses the action position as-is inside the bounds', () {
      final target = resolveUserMediaSeekTarget(
        action: const UserMediaPlaybackAction.seekTo(42.5),
        position: _milliseconds(1000),
        duration: _milliseconds(120000),
      );
      expect(target, _milliseconds(42500));
    });

    test('seekTo clamps a position past the end to the media duration', () {
      final target = resolveUserMediaSeekTarget(
        action: const UserMediaPlaybackAction.seekTo(999),
        position: Duration.zero,
        duration: _milliseconds(120000),
      );
      expect(target, _milliseconds(120000));
    });

    test('relative seeks move from the current position', () {
      expect(
        resolveUserMediaSeekTarget(
          action: const UserMediaPlaybackAction.seekForward(10),
          position: _milliseconds(30000),
          duration: _milliseconds(120000),
        ),
        _milliseconds(40000),
      );
      expect(
        resolveUserMediaSeekTarget(
          action: const UserMediaPlaybackAction.seekBackward(10),
          position: _milliseconds(30000),
          duration: _milliseconds(120000),
        ),
        _milliseconds(20000),
      );
    });

    test('relative seeks clamp to the media bounds', () {
      expect(
        resolveUserMediaSeekTarget(
          action: const UserMediaPlaybackAction.seekBackward(10),
          position: _milliseconds(5000),
          duration: _milliseconds(120000),
        ),
        Duration.zero,
      );
      expect(
        resolveUserMediaSeekTarget(
          action: const UserMediaPlaybackAction.seekForward(30),
          position: _milliseconds(119000),
          duration: _milliseconds(120000),
        ),
        _milliseconds(120000),
      );
    });

    test('an unknown duration only clamps the lower bound', () {
      expect(
        resolveUserMediaSeekTarget(
          action: const UserMediaPlaybackAction.seekBackward(10),
          position: _milliseconds(5000),
          duration: Duration.zero,
        ),
        Duration.zero,
      );
      expect(
        resolveUserMediaSeekTarget(
          action: const UserMediaPlaybackAction.seekForward(30),
          position: _milliseconds(119000),
          duration: Duration.zero,
        ),
        _milliseconds(149000),
      );
    });

    test('play and pause commands carry no seek target', () {
      for (final action in [
        const UserMediaPlaybackAction.play(),
        const UserMediaPlaybackAction.pause(),
      ]) {
        expect(
          resolveUserMediaSeekTarget(
            action: action,
            position: _milliseconds(5000),
            duration: _milliseconds(120000),
          ),
          isNull,
        );
      }
    });
  });
}
