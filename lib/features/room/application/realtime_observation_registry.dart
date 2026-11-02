import 'package:fixnum/fixnum.dart';

import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

/// One active observation: the parameters last requested by the app plus
/// the most recent event cursor the server delivered for it.
///
/// The cursor powers transparent resubscription: when the transport
/// reconnects, the observation is replayed with `afterEventSequence` set to
/// the last seen sequence so the server resumes the event stream instead of
/// restarting it.
class RealtimeObservation {
  RealtimeObservation({required this.observe})
    : lastSequence = Int64.ZERO,
      hasCursor = false;

  final client.ObserveResource observe;

  Int64 lastSequence;
  bool hasCursor;

  String get observeId => observe.observeId;

  /// Returns a copy of the requested observation with the replay cursor
  /// patched onto whichever resource field it applies to.
  client.ObserveResource toReplayObserve() {
    if (!hasCursor) return observe;
    return _withSequence(observe, lastSequence) ?? observe;
  }
}

client.ObserveResource? _withSequence(
  client.ObserveResource observe,
  Int64 sequence,
) {
  final patched = client.ObserveResource()
    ..observeId = observe.observeId
    ..deliveryMode = observe.deliveryMode;
  switch (observe.whichResource()) {
    case client.ObserveResource_Resource.playbackState:
      patched.playbackState = observe.playbackState;
    case client.ObserveResource_Resource.playback:
      patched.playback = observe.playback;
    case client.ObserveResource_Resource.roomSettings:
      patched.roomSettings = observe.roomSettings
        ..afterEventSequence = sequence;
    case client.ObserveResource_Resource.playlistItems:
      patched.playlistItems = observe.playlistItems
        ..afterEventSequence = sequence;
    case client.ObserveResource_Resource.playbackHistory:
      patched.playbackHistory = observe.playbackHistory
        ..afterEventSequence = sequence;
    case client.ObserveResource_Resource.roomMemberEvents:
      patched.roomMemberEvents = observe.roomMemberEvents
        ..afterEventSequence = sequence;
    case client.ObserveResource_Resource.chatEvents:
      patched.chatEvents = observe.chatEvents..afterEventSequence = sequence;
    case client.ObserveResource_Resource.chatPinEvents:
      patched.chatPinEvents = observe.chatPinEvents
        ..afterEventSequence = sequence;
    case client.ObserveResource_Resource.onlineCount:
      patched.onlineCount = observe.onlineCount;
    case client.ObserveResource_Resource.onlineEvent:
      patched.onlineEvent = observe.onlineEvent;
    case client.ObserveResource_Resource.selfRoomMember:
      patched.selfRoomMember = observe.selfRoomMember
        ..afterEventSequence = sequence;
    case client.ObserveResource_Resource.notSet:
      return null;
  }
  return patched;
}

/// Tracks the active realtime observations of one room realtime session.
///
/// The registry replaces the codec's former static maps: each session owns
/// its observations, so cursors and playlist contexts can never leak across
/// rooms or tests. The send path records every observe request here; the
/// receive path advances cursors; reconnects replay everything with cursors.
class RealtimeObservationRegistry {
  final Map<String, RealtimeObservation> _observations = {};

  /// Records (or replaces) the observation keyed by its observe id.
  ///
  /// Re-requests (pagination, search, permission rescoping) keep the stored
  /// cursor: the server's event stream position did not move backwards.
  void record(client.ObserveResource observe) {
    final existing = _observations[observe.observeId];
    if (existing == null) {
      _observations[observe.observeId] = RealtimeObservation(observe: observe);
      return;
    }
    _observations[observe.observeId] = RealtimeObservation(observe: observe)
      ..lastSequence = existing.lastSequence
      ..hasCursor = existing.hasCursor;
  }

  void remove(String observeId) {
    _observations.remove(observeId);
  }

  void clear() => _observations.clear();

  bool get isEmpty => _observations.isEmpty;

  int get length => _observations.length;

  Iterable<String> get observeIds => _observations.keys.toList(growable: false);

  client.ResourceDeliveryMode? deliveryMode(String observeId) =>
      _observations[observeId]?.observe.deliveryMode;

  /// Parent playlist id and requested page for a playlist observation, used
  /// by the codec to annotate decoded library pages.
  ({String parentId, int? page})? playlistContext(String observeId) {
    final observation = _observations[observeId];
    if (observation == null) return null;
    final request = observation.observe.playlistItems.request;
    final page = switch (request.whichPagination()) {
      client.ListPlaylistItemsRequest_Pagination.page => request.page.page,
      _ => null,
    };
    return (parentId: request.playlistId, page: page);
  }

  /// Advances the stored cursor from an incoming server message's event
  /// cursor. Monotonic: an out-of-order or stale cursor never rewinds the
  /// replay position.
  void advanceCursor(String observeId, client.EventCursor cursor) {
    final observation = _observations[observeId];
    if (observation == null) return;
    if (!observation.hasCursor || cursor.sequence > observation.lastSequence) {
      observation
        ..lastSequence = cursor.sequence
        ..hasCursor = true;
    }
  }

  /// Bytes of the `ClientMessage`s that resubscribe every active
  /// observation after a transport reconnect, newest cursors applied.
  List<List<int>> replayMessages() {
    if (_observations.isEmpty) return const [];
    return _observations.values
        .map(
          (observation) => client.ClientMessage(
            observeResource: observation.toReplayObserve(),
          ).writeToBuffer(),
        )
        .toList(growable: false);
  }

  /// Encodes the initial observation set for a brand-new session: the
  /// recorded parameters with any cursors the registry already holds (a
  /// session recreated mid-lifecycle keeps its resume positions).
  List<List<int>> initialMessages() => replayMessages();
}
