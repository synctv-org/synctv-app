import 'room_realtime.dart';

/// Canonical message content and the visible projections for one room lifetime.
class RoomChatMessageState {
  final messages = <RoomRealtimeChatEntry>[];
  final pinnedMessages = <RoomRealtimeChatEntry>[];
  final cache = <String, RoomRealtimeChatEntry>{};
  final _updatedAt = <String, int>{};
  final _pinUpdatedAt = <String, int>{};
  final _snapshotAt = <String, int>{};
  final _pinSnapshotAt = <String, int>{};
  final _userResetAt = <String, int>{};
  int _revision = 0;
  int _latestPinSnapshot = -1;
  int _resetRevision = 0;

  int get revision => _revision;
  int beginSnapshot() => ++_revision;

  bool isCurrentSnapshot(int revision) => revision >= _resetRevision;

  bool isCurrentUserSnapshot(String userId, int revision) =>
      isCurrentSnapshot(revision) && revision >= (_userResetAt[userId] ?? 0);

  List<RoomRealtimeChatEntry> removeUser(String userId) {
    _userResetAt[userId] = ++_revision;
    final removed = [
      ...messages.where((entry) => entry.userId == userId),
      ...pinnedMessages.where((entry) => entry.userId == userId),
      ...cache.values.where((entry) => entry.userId == userId),
    ];
    messages.removeWhere((entry) => entry.userId == userId);
    pinnedMessages.removeWhere((entry) => entry.userId == userId);
    cache.removeWhere((_, entry) => entry.userId == userId);
    for (final entry in removed) {
      _updatedAt.remove(entry.id);
      _pinUpdatedAt.remove(entry.id);
      _snapshotAt.remove(entry.id);
      _pinSnapshotAt.remove(entry.id);
    }
    return removed;
  }

  void clear() {
    _resetRevision = ++_revision;
    messages.clear();
    pinnedMessages.clear();
    cache.clear();
    _updatedAt.clear();
    _pinUpdatedAt.clear();
    _snapshotAt.clear();
    _pinSnapshotAt.clear();
    _userResetAt.clear();
    _latestPinSnapshot = -1;
  }

  bool accepts(RoomRealtimeChatEntry entry, {int? snapshotRevision}) {
    if (snapshotRevision != null &&
        !isCurrentUserSnapshot(entry.userId, snapshotRevision)) {
      return false;
    }
    final current = cache[entry.id];
    if (current == null) return true;
    if (current.isDeleted && !entry.isDeleted) return false;
    if (entry.version < current.version) return false;
    if (snapshotRevision != null &&
        (_updatedAt[entry.id] ?? 0) > snapshotRevision &&
        entry.version <= current.version) {
      return false;
    }
    return true;
  }

  bool merge(
    RoomRealtimeChatEntry entry, {
    bool addToTimeline = false,
    bool updatePin = false,
    bool fromSnapshot = false,
    int maxEntries = 100,
    int? snapshotRevision,
  }) {
    if (snapshotRevision != null &&
        !isCurrentUserSnapshot(entry.userId, snapshotRevision)) {
      return false;
    }
    final current = cache[entry.id];
    final acceptContent =
        accepts(entry, snapshotRevision: snapshotRevision) &&
        (!fromSnapshot ||
            snapshotRevision == null ||
            current == null ||
            entry.version > current.version ||
            (_snapshotAt[entry.id] ?? 0) <= snapshotRevision) &&
        (!updatePin ||
            current == null ||
            entry.version > current.version ||
            entry.isDeleted);
    final acceptPin =
        updatePin &&
        !entry.isDeleted &&
        current?.isDeleted != true &&
        (!fromSnapshot ||
            snapshotRevision == null ||
            (_pinSnapshotAt[entry.id] ?? 0) <= snapshotRevision) &&
        (snapshotRevision == null ||
            (_pinUpdatedAt[entry.id] ?? 0) <= snapshotRevision);
    if (!acceptContent && !acceptPin) return false;
    final content = acceptContent ? entry : current!;
    final merged = content.isDeleted
        ? content.copyWith(clearPin: true)
        : acceptPin
        ? content.copyWith(pin: entry.pin, clearPin: entry.pin == null)
        : current != null
        ? content.copyWith(pin: current.pin, clearPin: current.pin == null)
        : content;
    if (entry.id.isNotEmpty) {
      cache[entry.id] = merged;
      if (!fromSnapshot) {
        final revision = ++_revision;
        if (acceptContent) _updatedAt[entry.id] = revision;
        if (acceptPin || merged.isDeleted) _pinUpdatedAt[entry.id] = revision;
      } else if (snapshotRevision != null) {
        if (acceptContent) _snapshotAt[entry.id] = snapshotRevision;
        if (acceptPin || merged.isDeleted) {
          _pinSnapshotAt[entry.id] = snapshotRevision;
        }
      }
    }
    final index = messages.indexWhere(
      (item) => item.dedupeKey == entry.dedupeKey,
    );
    if (merged.isDeleted) {
      if (index >= 0) messages.removeAt(index);
    } else if (index >= 0) {
      messages[index] = merged;
    } else if (addToTimeline) {
      messages.add(merged);
      messages.trimToLatest(maxEntries);
    }
    pinnedMessages.removeWhere((item) => item.id == entry.id);
    if (merged.isPinned && !merged.isDeleted) {
      pinnedMessages.add(merged);
      _sortPins();
    }
    return true;
  }

  void prependHistory(
    Iterable<RoomRealtimeChatEntry> entries, {
    required int snapshotRevision,
    int maxEntries = 100,
  }) {
    if (!isCurrentSnapshot(snapshotRevision)) return;
    final incoming = <RoomRealtimeChatEntry>[];
    for (final entry in entries) {
      if (!isCurrentUserSnapshot(entry.userId, snapshotRevision)) continue;
      merge(entry, snapshotRevision: snapshotRevision, fromSnapshot: true);
      final current = cache[entry.id] ?? entry;
      if (!current.isDeleted) incoming.add(current);
    }
    messages.prependUnique(incoming, maxEntries: maxEntries);
  }

  void replacePins(
    Iterable<RoomRealtimeChatEntry> entries, {
    required int snapshotRevision,
  }) {
    if (!isCurrentSnapshot(snapshotRevision)) return;
    if (snapshotRevision < _latestPinSnapshot) return;
    _latestPinSnapshot = snapshotRevision;
    final previous = List<RoomRealtimeChatEntry>.of(pinnedMessages);
    final received = <String>{};
    for (final entry in entries) {
      received.add(entry.id);
      merge(
        entry,
        updatePin: true,
        snapshotRevision: snapshotRevision,
        fromSnapshot: true,
      );
    }
    for (final entry in previous) {
      if (!received.contains(entry.id) &&
          (_pinUpdatedAt[entry.id] ?? 0) <= snapshotRevision &&
          (_pinSnapshotAt[entry.id] ?? 0) <= snapshotRevision) {
        merge(
          entry.copyWith(clearPin: true),
          updatePin: true,
          fromSnapshot: true,
          snapshotRevision: snapshotRevision,
        );
      }
    }
  }

  void _sortPins() {
    pinnedMessages.sort((a, b) {
      final pinnedAt = (b.pin?.pinnedAt ?? 0).compareTo(a.pin?.pinnedAt ?? 0);
      return pinnedAt != 0
          ? pinnedAt
          : b.timestampMillis.compareTo(a.timestampMillis);
    });
  }
}
