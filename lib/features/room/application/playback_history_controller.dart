import 'package:flutter/foundation.dart';
import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

@immutable
class PlaybackHistoryState {
  const PlaybackHistoryState({
    this.entries = const <client.PlaybackHistoryEntry>[],
    this.cursorId = '',
    this.version = '',
    this.loading = false,
    this.playingEntryId = '',
  });

  final List<client.PlaybackHistoryEntry> entries;
  final String cursorId;
  final String version;
  final bool loading;
  final String playingEntryId;

  PlaybackHistoryState copyWith({
    List<client.PlaybackHistoryEntry>? entries,
    String? cursorId,
    String? version,
    bool? loading,
    String? playingEntryId,
  }) {
    return PlaybackHistoryState(
      entries: entries ?? this.entries,
      cursorId: cursorId ?? this.cursorId,
      version: version ?? this.version,
      loading: loading ?? this.loading,
      playingEntryId: playingEntryId ?? this.playingEntryId,
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
        final page = await _gateway.listHistory(_roomId);
        if (requestRevision != _realtimeRevision) {
          _pendingCursorId = 'realtime-update';
          continue;
        }
        _setState(
          _state.copyWith(
            entries: List.unmodifiable(page.entries),
            cursorId: page.historyCursorId,
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
        version: version,
        loading: false,
      ),
    );
  }

  Future<void> play(String entryId) async {
    if (_state.playingEntryId.isNotEmpty) return;
    _setState(_state.copyWith(playingEntryId: entryId));
    try {
      await _gateway.playHistoryEntry(_roomId, entryId);
      requestRefresh();
      await _refreshOperation;
    } finally {
      _setState(_state.copyWith(playingEntryId: ''));
    }
  }

  void _setState(PlaybackHistoryState state) {
    _state = state;
    notifyListeners();
  }
}
