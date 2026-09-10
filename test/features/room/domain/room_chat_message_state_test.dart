import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/features/room/domain/room_chat_message_state.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';

const _pin = ChatPinInfo(
  pinnedByUserId: 'user',
  pinnedByUsername: 'User',
  note: '',
  pinnedAt: 100,
);
RoomRealtimeChatEntry _entry(
  int version, {
  String id = 'message',
  String userId = 'user',
  bool deleted = false,
  bool pinned = false,
  int reactions = 0,
}) => RoomRealtimeChatEntry(
  id: id,
  userId: userId,
  username: 'User',
  content: 'Version $version',
  timestampMillis: 100,
  version: version,
  isDeleted: deleted,
  pin: pinned ? _pin : null,
  reactionCount: reactions,
);

void main() {
  test('removing a user clears their projections and keeps other users', () {
    final state = RoomChatMessageState()
      ..merge(_entry(1, pinned: true), addToTimeline: true)
      ..merge(
        _entry(1, id: 'other', userId: 'other-user', pinned: true),
        addToTimeline: true,
      );
    final removed = state.removeUser('user');
    expect(removed.map((entry) => entry.id).toSet(), {'message'});
    expect(state.messages.single.id, 'other');
    expect(state.pinnedMessages.single.id, 'other');
    expect(state.cache.keys, ['other']);
  });

  test('removed user history cannot reappear through uncached fallback', () {
    final state = RoomChatMessageState();
    final pending = state.beginSnapshot();
    state.removeUser('user');
    state.prependHistory([
      _entry(1),
      _entry(1, id: 'other', userId: 'other-user'),
    ], snapshotRevision: pending);
    expect(state.messages.single.id, 'other');
    expect(state.cache.containsKey('message'), isFalse);
  });

  test('removed user pin and mutation responses are rejected', () {
    final state = RoomChatMessageState();
    final pending = state.beginSnapshot();
    state.removeUser('user');
    state.replacePins([_entry(9, pinned: true)], snapshotRevision: pending);
    expect(state.merge(_entry(9), snapshotRevision: pending), isFalse);
    expect(
      state.merge(
        _entry(9, pinned: true),
        updatePin: true,
        snapshotRevision: pending,
      ),
      isFalse,
    );
    expect(state.cache, isEmpty);
    expect(state.pinnedMessages, isEmpty);
  });

  test('new user reads remain valid when obsolete responses finish later', () {
    final state = RoomChatMessageState();
    final old = state.beginSnapshot();
    state.removeUser('user');
    final fresh = state.beginSnapshot();
    state.prependHistory([_entry(2)], snapshotRevision: fresh);
    state.prependHistory([_entry(9)], snapshotRevision: old);
    expect(state.messages.single.version, 2);
    expect(state.isCurrentUserSnapshot('user', old), isFalse);
    expect(state.isCurrentUserSnapshot('user', fresh), isTrue);
    expect(state.isCurrentUserSnapshot('other-user', old), isTrue);
  });

  test('old empty pin snapshot preserves post-removal live pins', () {
    final state = RoomChatMessageState();
    final old = state.beginSnapshot();
    state.removeUser('user');
    state.merge(_entry(2, pinned: true), updatePin: true);
    state.replacePins([], snapshotRevision: old);
    expect(state.pinnedMessages.single.version, 2);
  });

  test('room reset invalidates all earlier user snapshots', () {
    final state = RoomChatMessageState();
    state.removeUser('user');
    final pending = state.beginSnapshot();
    state.clear();
    expect(state.isCurrentUserSnapshot('user', pending), isFalse);
    expect(state.isCurrentUserSnapshot('other-user', pending), isFalse);
    final fresh = state.beginSnapshot();
    expect(state.isCurrentUserSnapshot('user', fresh), isTrue);
  });

  test('clear removes every projection and invalidates pending reads', () {
    final state = RoomChatMessageState()
      ..merge(_entry(1, pinned: true), addToTimeline: true);
    final pending = state.beginSnapshot();
    state.clear();
    expect(state.messages, isEmpty);
    expect(state.pinnedMessages, isEmpty);
    expect(state.cache, isEmpty);
    expect(state.isCurrentSnapshot(pending), isFalse);
    expect(state.isCurrentSnapshot(state.beginSnapshot()), isTrue);
  });

  test('pre-clear history cannot reinsert uncached messages', () {
    final state = RoomChatMessageState();
    final pending = state.beginSnapshot();
    state.clear();
    state.prependHistory([_entry(9)], snapshotRevision: pending);
    expect(state.messages, isEmpty);
    expect(state.cache, isEmpty);
  });

  test('pre-clear pin and mutation responses cannot restore messages', () {
    final state = RoomChatMessageState();
    final pending = state.beginSnapshot();
    state.clear();
    state.replacePins([_entry(9, pinned: true)], snapshotRevision: pending);
    expect(state.merge(_entry(9), snapshotRevision: pending), isFalse);
    expect(
      state.merge(
        _entry(9, pinned: true),
        updatePin: true,
        snapshotRevision: pending,
      ),
      isFalse,
    );
    expect(state.cache, isEmpty);
    expect(state.pinnedMessages, isEmpty);
  });

  test('new reads after clear load independently of old tombstones', () {
    final state = RoomChatMessageState()..merge(_entry(9, deleted: true));
    final pending = state.beginSnapshot();
    state.clear();
    final current = state.beginSnapshot();
    state.prependHistory([_entry(1)], snapshotRevision: current);
    state.prependHistory([_entry(9, deleted: true)], snapshotRevision: pending);
    expect(state.messages.single.version, 1);
    expect(state.cache['message']!.isDeleted, isFalse);
  });

  test('old empty pin response cannot clear pins loaded after reset', () {
    final state = RoomChatMessageState();
    final pending = state.beginSnapshot();
    state.clear();
    state.replacePins([
      _entry(1, pinned: true),
    ], snapshotRevision: state.beginSnapshot());
    state.replacePins([], snapshotRevision: pending);
    expect(state.pinnedMessages.single.id, 'message');
  });

  test('newer initially empty pin snapshot blocks an older nonempty list', () {
    final state = RoomChatMessageState();
    final first = state.beginSnapshot();
    final second = state.beginSnapshot();
    state.replacePins([], snapshotRevision: second);
    state.replacePins([_entry(1, pinned: true)], snapshotRevision: first);
    expect(state.pinnedMessages, isEmpty);
  });

  test('older same-version history cannot overwrite a newer snapshot', () {
    final state = RoomChatMessageState();
    final first = state.beginSnapshot();
    final second = state.beginSnapshot();
    state.prependHistory([_entry(1, reactions: 3)], snapshotRevision: second);
    state.prependHistory([_entry(1, reactions: 1)], snapshotRevision: first);
    expect(state.messages.single.reactionCount, 3);
    expect(state.cache['message']!.reactionCount, 3);
  });

  test('older empty pin snapshot cannot remove a newer snapshot pin', () {
    final state = RoomChatMessageState();
    final first = state.beginSnapshot();
    final second = state.beginSnapshot();
    state.replacePins([_entry(1, pinned: true)], snapshotRevision: second);
    state.replacePins([], snapshotRevision: first);
    expect(state.pinnedMessages.single.id, 'message');
  });

  test('older pin snapshot cannot undo a newer snapshot removal', () {
    final state = RoomChatMessageState()..merge(_entry(1, pinned: true));
    final first = state.beginSnapshot();
    final second = state.beginSnapshot();
    state.replacePins([], snapshotRevision: second);
    state.replacePins([_entry(1, pinned: true)], snapshotRevision: first);
    expect(state.pinnedMessages, isEmpty);
    expect(state.cache['message']!.isPinned, isFalse);
  });

  test('reaction event cannot suppress a pending pin response', () {
    final state = RoomChatMessageState()..merge(_entry(1), addToTimeline: true);
    final revision = state.revision;
    state.merge(_entry(1, reactions: 2));
    expect(
      state.merge(
        _entry(1, pinned: true),
        updatePin: true,
        snapshotRevision: revision,
      ),
      isTrue,
    );
    expect(state.messages.single.reactionCount, 2);
    expect(state.messages.single.isPinned, isTrue);
    expect(state.pinnedMessages.single.reactionCount, 2);
  });

  test('pin event cannot suppress a pending reaction response', () {
    final state = RoomChatMessageState()..merge(_entry(1), addToTimeline: true);
    final revision = state.revision;
    state.merge(_entry(1, pinned: true), updatePin: true);
    expect(
      state.merge(_entry(1, reactions: 2), snapshotRevision: revision),
      isTrue,
    );
    expect(state.messages.single.isPinned, isTrue);
    expect(state.pinnedMessages.single.reactionCount, 2);
  });

  test('empty pin snapshot applies without reverting a newer reaction', () {
    final state = RoomChatMessageState()
      ..merge(_entry(1, pinned: true), addToTimeline: true);
    final revision = state.revision;
    state.merge(_entry(1, reactions: 3));
    state.replacePins([], snapshotRevision: revision);
    expect(state.pinnedMessages, isEmpty);
    expect(state.messages.single.reactionCount, 3);
    expect(state.cache['message']!.isPinned, isFalse);
  });

  test('pin metadata from older content cannot regress an edited message', () {
    final state = RoomChatMessageState()..merge(_entry(3), addToTimeline: true);
    expect(state.merge(_entry(1, pinned: true), updatePin: true), isTrue);
    expect(state.messages.single.version, 3);
    expect(state.pinnedMessages.single.content, 'Version 3');
  });

  test('pin event cannot revive a deleted message', () {
    final state = RoomChatMessageState()..merge(_entry(3, deleted: true));
    expect(state.merge(_entry(1, pinned: true), updatePin: true), isFalse);
    expect(state.pinnedMessages, isEmpty);
    expect(state.cache['message']!.isDeleted, isTrue);
  });

  test('concurrent initial history and pin snapshots both contribute', () {
    final state = RoomChatMessageState();
    final revision = state.revision;
    state.prependHistory([_entry(1)], snapshotRevision: revision);
    state.replacePins([_entry(1, pinned: true)], snapshotRevision: revision);
    expect(state.messages.single.isPinned, isTrue);
    expect(state.pinnedMessages.single.id, 'message');
  });

  test('older response cannot regress timeline, pin or reply cache', () {
    final state = RoomChatMessageState();
    state.merge(_entry(3, pinned: true), addToTimeline: true);
    expect(state.merge(_entry(2), addToTimeline: true), isFalse);
    expect(state.messages.single.version, 3);
    expect(state.pinnedMessages.single.version, 3);
    expect(state.cache['message']!.version, 3);
  });

  test('new content updates all projections while retaining the pin', () {
    final state = RoomChatMessageState();
    state.merge(_entry(1, pinned: true), addToTimeline: true);
    state.merge(_entry(2), addToTimeline: true);
    expect(state.messages.single.version, 2);
    expect(state.messages.single.pin, same(_pin));
    expect(state.pinnedMessages.single, same(state.cache['message']));
  });

  test('deletion removes both lists and retains a terminal tombstone', () {
    final state = RoomChatMessageState();
    state.merge(_entry(1, pinned: true), addToTimeline: true);
    state.merge(_entry(2, deleted: true), addToTimeline: true);
    for (final version in [1, 2, 3]) {
      expect(state.merge(_entry(version), addToTimeline: true), isFalse);
    }
    expect(state.messages, isEmpty);
    expect(state.pinnedMessages, isEmpty);
    expect(state.cache['message']!.isDeleted, isTrue);
    expect(state.cache['message']!.isPinned, isFalse);
  });

  test('stale deletion cannot remove a newer known message', () {
    final state = RoomChatMessageState()..merge(_entry(4), addToTimeline: true);
    expect(state.merge(_entry(3, deleted: true)), isFalse);
    expect(state.messages.single.version, 4);
  });

  test('history uses newer cached content and excludes known deletions', () {
    final state = RoomChatMessageState();
    final revision = state.revision;
    state.merge(_entry(3));
    state.merge(_entry(2, id: 'deleted', deleted: true));
    state.prependHistory([
      _entry(1),
      _entry(1, id: 'deleted'),
    ], snapshotRevision: revision);
    expect(state.messages.single.version, 3);
    expect(state.cache['deleted']!.isDeleted, isTrue);
  });

  test('history tombstones remove existing visible messages', () {
    final state = RoomChatMessageState()..merge(_entry(1), addToTimeline: true);
    state.prependHistory([
      _entry(2, deleted: true),
    ], snapshotRevision: state.revision);
    expect(state.messages, isEmpty);
    expect(state.cache['message']!.isDeleted, isTrue);
  });

  test('same-version snapshot cannot undo a newer reaction event', () {
    final state = RoomChatMessageState()..merge(_entry(1), addToTimeline: true);
    final revision = state.revision;
    state.merge(_entry(1, reactions: 2));
    expect(state.merge(_entry(1), snapshotRevision: revision), isFalse);
    expect(state.messages.single.reactionCount, 2);
    expect(state.cache['message']!.reactionCount, 2);
  });

  test('a newer content version can supersede changes during a snapshot', () {
    final state = RoomChatMessageState()..merge(_entry(1), addToTimeline: true);
    final revision = state.revision;
    state.merge(_entry(1, reactions: 2));
    expect(state.merge(_entry(2), snapshotRevision: revision), isTrue);
    expect(state.messages.single.version, 2);
  });

  test(
    'another message update does not invalidate an unrelated snapshot entry',
    () {
      final state = RoomChatMessageState()..merge(_entry(1));
      final revision = state.revision;
      state.merge(_entry(2, id: 'other'));
      expect(
        state.merge(_entry(1, reactions: 3), snapshotRevision: revision),
        isTrue,
      );
      expect(state.cache['message']!.reactionCount, 3);
    },
  );

  test('pin refresh cannot re-pin a message unpinned during the request', () {
    final state = RoomChatMessageState()
      ..merge(_entry(1, pinned: true), addToTimeline: true);
    final revision = state.revision;
    state.merge(_entry(1), updatePin: true);
    state.replacePins([_entry(1, pinned: true)], snapshotRevision: revision);
    expect(state.pinnedMessages, isEmpty);
    expect(state.messages.single.isPinned, isFalse);
  });

  test('empty pin refresh preserves pins added during the request', () {
    final state = RoomChatMessageState();
    final revision = state.revision;
    state.merge(_entry(1, pinned: true), updatePin: true);
    state.replacePins([], snapshotRevision: revision);
    expect(state.pinnedMessages.single.id, 'message');
  });

  test(
    'fresh empty pin snapshot removes obsolete pins from every projection',
    () {
      final state = RoomChatMessageState()
        ..merge(_entry(1, pinned: true), addToTimeline: true);
      state.replacePins([], snapshotRevision: state.revision);
      expect(state.pinnedMessages, isEmpty);
      expect(state.messages.single.isPinned, isFalse);
      expect(state.cache['message']!.isPinned, isFalse);
    },
  );

  test('pin-only snapshot does not insert messages into the timeline', () {
    final state = RoomChatMessageState();
    state.replacePins([
      _entry(1, pinned: true),
    ], snapshotRevision: state.revision);
    expect(state.messages, isEmpty);
    expect(state.pinnedMessages.single.id, 'message');
  });
}
