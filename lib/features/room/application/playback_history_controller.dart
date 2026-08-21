import 'package:flutter/foundation.dart';
import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

@immutable
class PlaybackHistoryState {
  const PlaybackHistoryState({
    this.entries = const <client.PlaybackHistoryEntry>[],
    this.cursorId = '',
    this.version = '',
    this.loading = false,
    this.loadingMore = false,
    this.playingEntryId = '',
    this.deletingEntryIds = const <String>{},
    this.clearing = false,
    this.nextCursorId = '',
    this.sortDirection = client_enum.SortDirection.SORT_DIRECTION_DESC,
  });

  final List<client.PlaybackHistoryEntry> entries;
  final String cursorId;
  final String version;
  final bool loading;
  final bool loadingMore;
  final String playingEntryId;
  final Set<String> deletingEntryIds;
  final bool clearing;
  final String nextCursorId;
  final client_enum.SortDirection sortDirection;

  bool get hasMore => nextCursorId.isNotEmpty;

  PlaybackHistoryState copyWith({
    List<client.PlaybackHistoryEntry>? entries,
    String? cursorId,
    String? version,
    bool? loading,
    bool? loadingMore,
    String? playingEntryId,
    Set<String>? deletingEntryIds,
    bool? clearing,
    String? nextCursorId,
    client_enum.SortDirection? sortDirection,
  }) {
    return PlaybackHistoryState(
      entries: entries ?? this.entries,
      cursorId: cursorId ?? this.cursorId,
      version: version ?? this.version,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      playingEntryId: playingEntryId ?? this.playingEntryId,
      deletingEntryIds: deletingEntryIds ?? this.deletingEntryIds,
      clearing: clearing ?? this.clearing,
      nextCursorId: nextCursorId ?? this.nextCursorId,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

class PlaybackHistoryController extends ChangeNotifier {
  PlaybackHistoryController({required this._gateway, required this._roomId});

  final RoomPlaybackGateway _gateway;
  final String _roomId;
  PlaybackHistoryState _state = const PlaybackHistoryState();
  String _pendingCursorId = '';
  Future<void>? _refreshOperation;
  int _realtimeRevision = 0;

  PlaybackHistoryState get state => _state;

  static String _nextCursor(client.ListPlaybackHistoryResponse page) =>
      page.nextCursorEntryId.isNotEmpty
      ? page.nextCursorEntryId
      : page.nextBeforeEntryId;

  void observe(String version) {
    if (version != _state.version) {
      _realtimeRevision++;
      _state = _state.copyWith(version: version);
      notifyListeners();
    }
  }

  Future<void> requestRefresh({String expectedCursorId = ''}) {
    if (expectedCursorId.isNotEmpty && expectedCursorId != _state.cursorId) {
      _pendingCursorId = expectedCursorId;
    }
    return refresh();
  }

  Future<void> refresh() {
    return _refreshOperation ??= _refreshLoop();
  }

  Future<void> _refreshLoop() async {
    try {
      do {
        _pendingCursorId = '';
        _setState(_state.copyWith(loading: true));
        final requestRevision = _realtimeRevision;
        final page = await _gateway.listHistory(
          _roomId,
          sortDirection: _state.sortDirection,
        );
        if (requestRevision != _realtimeRevision) {
          _pendingCursorId = 'realtime-update';
          continue;
        }
        _setState(
          _state.copyWith(
            entries: List.unmodifiable(page.entries),
            cursorId: page.historyCursorId,
            nextCursorId: _nextCursor(page),
            loading: false,
          ),
        );
      } while (_pendingCursorId.isNotEmpty);
    } finally {
      _refreshOperation = null;
      if (_state.loading) _setState(_state.copyWith(loading: false));
    }
  }

  void applyRealtimeHistory(
    client.ListPlaybackHistoryResponse page,
    String version,
  ) {
    _realtimeRevision++;
    _setState(
      _state.copyWith(
        entries: List.unmodifiable(page.entries),
        cursorId: page.historyCursorId,
        nextCursorId: _nextCursor(page),
        version: version,
        loading: false,
      ),
    );
  }

  Future<void> setSortDirection(client_enum.SortDirection sortDirection) {
    if (sortDirection == _state.sortDirection) return Future.value();
    _realtimeRevision++;
    _pendingCursorId = 'sort-direction';
    _setState(
      _state.copyWith(
        entries: const <client.PlaybackHistoryEntry>[],
        nextCursorId: '',
        sortDirection: sortDirection,
      ),
    );
    return refresh();
  }

  Future<void> loadMore() async {
    if (_state.loading || _state.loadingMore || !_state.hasMore) return;
    final requestRevision = _realtimeRevision;
    final cursor = _state.nextCursorId;
    final sortDirection = _state.sortDirection;
    _setState(_state.copyWith(loadingMore: true));
    try {
      final page = await _gateway.listHistory(
        _roomId,
        cursorEntryId: cursor,
        sortDirection: sortDirection,
      );
      if (requestRevision != _realtimeRevision ||
          sortDirection != _state.sortDirection) {
        return;
      }
      final entriesById = <String, client.PlaybackHistoryEntry>{
        for (final entry in _state.entries) entry.id: entry,
        for (final entry in page.entries) entry.id: entry,
      };
      _setState(
        _state.copyWith(
          entries: List.unmodifiable(entriesById.values),
          cursorId: page.historyCursorId,
          nextCursorId: _nextCursor(page),
        ),
      );
    } finally {
      if (_state.loadingMore) {
        _setState(_state.copyWith(loadingMore: false));
      }
    }
  }

  Future<void> play(String entryId) async {
    if (_state.playingEntryId.isNotEmpty) return;
    _setState(_state.copyWith(playingEntryId: entryId));
    try {
      await _gateway.playHistoryEntry(_roomId, entryId);
      await refresh();
    } finally {
      _setState(_state.copyWith(playingEntryId: ''));
    }
  }

  Future<bool> deleteEntry(String entryId) async {
    if (_state.clearing || _state.deletingEntryIds.contains(entryId)) {
      return false;
    }
    _setState(
      _state.copyWith(
        deletingEntryIds: Set.unmodifiable({
          ..._state.deletingEntryIds,
          entryId,
        }),
      ),
    );
    try {
      final deleted = await _gateway.deleteHistoryEntry(_roomId, entryId);
      _realtimeRevision++;
      _setState(
        _state.copyWith(
          entries: List.unmodifiable(
            _state.entries.where((entry) => entry.id != entryId),
          ),
          cursorId: _state.cursorId == entryId ? '' : _state.cursorId,
        ),
      );
      await refresh();
      return deleted;
    } finally {
      final deletingEntryIds = {..._state.deletingEntryIds}..remove(entryId);
      _setState(
        _state.copyWith(deletingEntryIds: Set.unmodifiable(deletingEntryIds)),
      );
    }
  }

  Future<int> clear() async {
    if (_state.clearing || _state.deletingEntryIds.isNotEmpty) return 0;
    _setState(_state.copyWith(clearing: true));
    try {
      final deletedCount = await _gateway.clearHistory(_roomId);
      _realtimeRevision++;
      _setState(
        _state.copyWith(
          entries: const <client.PlaybackHistoryEntry>[],
          cursorId: '',
          nextCursorId: '',
        ),
      );
      await refresh();
      return deletedCount;
    } finally {
      _setState(_state.copyWith(clearing: false));
    }
  }

  void _setState(PlaybackHistoryState state) {
    _state = state;
    notifyListeners();
  }
}
