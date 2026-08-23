import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

void main() {
  group('mergePlaybackStatusSnapshot', () {
    final currentEntry = RoomPlaybackEntry(
      id: 'med_11',
      name: 'Current video',
      url: 'http://127.0.0.1/video.mp4',
      parentId: 'med_11',
    );
    final current = SyncTvPlaybackStatus(
      entry: currentEntry,
      isPlaying: true,
      currentTime: 12,
      playbackRate: 1.5,
      generatedAtMillis: 1000,
      version: 7,
      playingMediaId: 'med_11',
      playingPlaylistId: 'pl_6',
      targetHash: 'target',
      historyCursorId: 'history_165',
    );

    test('clears playback identity and entry from a stopped state event', () {
      final result = mergePlaybackStatusSnapshot(
        current: current,
        incoming: SyncTvPlaybackStatus(
          isPlaying: false,
          generatedAtMillis: 2000,
          version: 8,
        ),
        incomingHasTiming: true,
      );

      expect(result.entry, isNull);
      expect(result.playingMediaId, isEmpty);
      expect(result.playingPlaylistId, isEmpty);
      expect(result.targetHash, isEmpty);
      expect(result.historyCursorId, isEmpty);
      expect(result.isPlaying, isFalse);
      expect(result.version, 8);
    });

    test('playback resource payload preserves state identity guards', () {
      final result = mergePlaybackStatusSnapshot(
        current: current,
        incoming: SyncTvPlaybackStatus(
          entry: RoomPlaybackEntry(
            id: 'med_11',
            name: 'Refreshed video',
            url: 'http://127.0.0.1/refreshed.mp4',
            parentId: 'med_11',
          ),
        ),
        incomingHasTiming: false,
      );

      expect(result.entry?.url, 'http://127.0.0.1/refreshed.mp4');
      expect(result.playingMediaId, current.playingMediaId);
      expect(result.playingPlaylistId, current.playingPlaylistId);
      expect(result.targetHash, current.targetHash);
      expect(result.historyCursorId, current.historyCursorId);
    });

    test('reuses a loaded entry for a matching observe snapshot', () {
      final result = mergePlaybackStatusSnapshot(
        current: current,
        incoming: SyncTvPlaybackStatus(
          version: 8,
          playingMediaId: 'med_11',
          playingPlaylistId: 'pl_6',
          targetHash: 'target',
          historyCursorId: 'history_166',
        ),
        incomingHasTiming: false,
      );

      expect(result.entry, same(currentEntry));
      expect(result.currentTime, current.currentTime);
      expect(result.isPlaying, current.isPlaying);
      expect(result.historyCursorId, current.historyCursorId);
      expect(result.version, 8);
    });

    test('reuses a loaded entry for a matching playback state update', () {
      final result = mergePlaybackStatusSnapshot(
        current: current,
        incoming: SyncTvPlaybackStatus(
          isPlaying: false,
          currentTime: 18,
          playbackRate: 1,
          generatedAtMillis: 2000,
          version: 8,
          playingMediaId: 'med_11',
          playingPlaylistId: 'pl_6',
          targetHash: 'target',
          historyCursorId: 'history_166',
        ),
        incomingHasTiming: true,
      );

      expect(result.entry, same(currentEntry));
      expect(result.isPlaying, isFalse);
      expect(result.currentTime, 18);
      expect(result.version, 8);
      expect(result.historyCursorId, 'history_166');
    });

    test('does not reuse an entry for a different playback source', () {
      final result = mergePlaybackStatusSnapshot(
        current: current,
        incoming: SyncTvPlaybackStatus(
          version: 8,
          playingMediaId: 'med_12',
          playingPlaylistId: 'pl_6',
          historyCursorId: 'history_166',
        ),
        incomingHasTiming: false,
      );

      expect(result.entry, isNull);
      expect(result.playingMediaId, current.playingMediaId);
      expect(result.historyCursorId, current.historyCursorId);
    });

    test('rejects a stale playback resource for a different static media', () {
      final result = mergePlaybackStatusSnapshot(
        current: current,
        incoming: SyncTvPlaybackStatus(
          entry: RoomPlaybackEntry(
            id: 'med_12',
            name: 'Stale video',
            url: 'http://127.0.0.1/stale.mp4',
          ),
          playingMediaId: 'med_12',
        ),
        incomingHasTiming: false,
      );

      expect(result.entry, same(currentEntry));
      expect(result.playingMediaId, 'med_11');
      expect(result.version, 7);
    });

    test('accepts a playback resource for the current static media', () {
      final refreshedEntry = RoomPlaybackEntry(
        id: 'med_11',
        name: 'Refreshed video',
        url: 'http://127.0.0.1/refreshed.mp4',
      );
      final result = mergePlaybackStatusSnapshot(
        current: current,
        incoming: SyncTvPlaybackStatus(
          entry: refreshedEntry,
          playingMediaId: 'med_11',
        ),
        incomingHasTiming: false,
      );

      expect(result.entry, same(refreshedEntry));
      expect(result.playingMediaId, 'med_11');
      expect(result.version, 7);
    });

    test('preserves a client route across matching resource snapshots', () {
      SyncTvPlaybackModeOption mode(String key, String url) =>
          SyncTvPlaybackModeOption(
            key: key,
            urls: [SyncTvPlaybackUrlOption(name: key, url: url)],
          );
      final selectedEntry = RoomPlaybackEntry(
        id: 'med_11',
        name: 'Current video',
        url: 'http://127.0.0.1/proxy-old.mp4',
        playbackModes: [
          mode('direct', 'http://127.0.0.1/direct-old.mp4'),
          mode('proxy', 'http://127.0.0.1/proxy-old.mp4'),
        ],
        selectedPlaybackMode: 'proxy',
        live: true,
        liveStreamAvailability: SyncTvLiveStreamAvailability.live,
        liveStreamGenerationId: 'generation-1',
      );
      final selectedCurrent = current.copyWith(entry: selectedEntry);
      final refreshedEntry = RoomPlaybackEntry(
        id: 'med_11',
        name: 'Refreshed video',
        url: 'http://127.0.0.1/direct-new.mp4',
        playbackModes: [
          mode('direct', 'http://127.0.0.1/direct-new.mp4'),
          mode('proxy', 'http://127.0.0.1/proxy-new.mp4'),
        ],
        selectedPlaybackMode: 'direct',
        live: true,
        liveStreamAvailability: SyncTvLiveStreamAvailability.live,
        liveStreamGenerationId: 'generation-2',
      );

      final result = mergePlaybackStatusSnapshot(
        current: selectedCurrent,
        incoming: SyncTvPlaybackStatus(
          entry: refreshedEntry,
          playingMediaId: 'med_11',
        ),
        incomingHasTiming: false,
      );

      expect(result.entry?.selectedPlaybackMode, 'proxy');
      expect(result.entry?.url, 'http://127.0.0.1/proxy-new.mp4');
      expect(result.entry?.liveStreamGenerationId, 'generation-2');
    });

    test('rejects a stale playback resource for another dynamic target', () {
      final dynamicCurrentEntry = RoomPlaybackEntry(
        id: 'target-a',
        name: 'Target A',
        url: 'http://127.0.0.1/a.mp4',
        parentId: 'pl_6',
        subPath: 'target-a',
      );
      final dynamicCurrent = SyncTvPlaybackStatus(
        entry: dynamicCurrentEntry,
        version: 9,
        playingPlaylistId: 'pl_6',
        targetHash: 'hash-a',
      );

      final result = mergePlaybackStatusSnapshot(
        current: dynamicCurrent,
        incoming: SyncTvPlaybackStatus(
          entry: RoomPlaybackEntry(
            id: 'target-b',
            name: 'Target B',
            url: 'http://127.0.0.1/b.mp4',
            parentId: 'pl_6',
            subPath: 'target-b',
          ),
          playingPlaylistId: 'pl_6',
        ),
        incomingHasTiming: false,
      );

      expect(result.entry, same(dynamicCurrentEntry));
      expect(result.targetHash, 'hash-a');
      expect(result.version, 9);
    });
  });
}
