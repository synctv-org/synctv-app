import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/playback_danmaku.dart';

void main() {
  final entry = RoomMediaEntry(id: 'med_1', name: 'Movie', url: 'movie.mp4');

  test(
    'denied history never polls and can resume after permission changes',
    () async {
      final loader = PlaybackDanmakuLoader();
      var requests = 0;
      Future<PlaybackDanmakuFetchResult?> poll(bool allowed) => loader.load(
        canViewChatHistory: allowed,
        loadMessages: (_) async {
          requests++;
          return [];
        },
        roomId: 'room_1',
        entry: entry,
        positionSeconds: 10,
      );
      for (var i = 0; i < 100; i++) {
        expect(await poll(false), isNull);
      }
      expect(requests, 0);
      expect(await poll(true), isNotNull);
      expect(requests, 1);
    },
  );

  test(
    'failed polling cools down despite advancing playback, then recovers',
    () async {
      var now = DateTime.utc(2026);
      final loader = PlaybackDanmakuLoader(now: () => now);
      var requests = 0;
      var failing = true;
      Future<PlaybackDanmakuFetchResult?> poll(double position) => loader.load(
        canViewChatHistory: true,
        loadMessages: (_) async {
          requests++;
          if (failing) throw StateError('temporarily unavailable');
          return [];
        },
        roomId: 'room_1',
        entry: entry,
        positionSeconds: position,
      );
      await expectLater(poll(0), throwsStateError);
      for (var tick = 1; tick < 300; tick++) {
        now = now.add(const Duration(milliseconds: 100));
        expect(await poll(tick / 10), isNull);
      }
      expect(requests, 1);
      failing = false;
      now = now.add(const Duration(milliseconds: 100));
      expect(await poll(30), isNotNull);
      expect(requests, 2);
      expect(await poll(120), isNotNull);
      expect(requests, 3);
    },
  );

  test(
    'an in-flight request is not duplicated and another source can recover',
    () async {
      final loader = PlaybackDanmakuLoader();
      final pending = Completer<List<RoomChatMessageInfo>>();
      var requests = 0;
      Future<PlaybackDanmakuFetchResult?> poll(RoomMediaEntry media) =>
          loader.load(
            canViewChatHistory: true,
            loadMessages: (_) {
              requests++;
              return pending.future;
            },
            roomId: 'room_1',
            entry: media,
            positionSeconds: 10,
          );
      final first = poll(entry);
      expect(await poll(entry), isNull);
      expect(requests, 1);
      final error = expectLater(first, throwsStateError);
      pending.completeError(StateError('failed'));
      await error;
      final next = await loader.load(
        canViewChatHistory: true,
        loadMessages: (_) async => [],
        roomId: 'room_1',
        entry: RoomMediaEntry(id: 'med_2', name: 'Next', url: 'next.mp4'),
        positionSeconds: 0,
      );
      expect(next, isNotNull);
    },
  );
}
