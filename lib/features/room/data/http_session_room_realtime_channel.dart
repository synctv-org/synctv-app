import 'dart:async';
import 'dart:typed_data';

import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

/// Realtime channel over an HTTP realtime session: SSE downlink + REST
/// uplink.
///
/// Wire mapping onto the [RoomRealtimeChannel] contract:
/// - `connect` creates the session (`POST .../realtime/sessions`) with the
///   initial observations, then attaches the SSE downlink. `ready` resolves
///   once the session exists; an attach failure surfaces on the stream and
///   the engine reconnects (the session survives brief detaches by lease).
/// - `send` posts any `ClientMessage` (`POST .../messages`); messages sent
///   before the session exists are buffered. REST uplink is not strictly
///   ordered — server-side version checks and client operation ids absorb
///   reordering for interactive traffic.
/// - `close` detaches and deletes the session.
class HttpSessionRoomRealtimeChannel implements RoomRealtimeChannel {
  HttpSessionRoomRealtimeChannel._(this._gateway, this._roomId);

  /// Connects a session channel for [roomId].
  ///
  /// [initialMessages] must be encoded `ClientMessage`s carrying
  /// `observeResource` — they become the session's initial observations.
  factory HttpSessionRoomRealtimeChannel.connect(
    RoomSessionGateway gateway,
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    final channel = HttpSessionRoomRealtimeChannel._(gateway, roomId)
      .._onOutgoing = onOutgoing
      .._onIncoming = onIncoming;
    channel._open(initialMessages);
    return channel;
  }

  final RoomSessionGateway _gateway;
  final String _roomId;

  void Function(List<int> bytes)? _onOutgoing;
  void Function(Uint8List bytes)? _onIncoming;

  final StreamController<Uint8List> _incoming = StreamController<Uint8List>();
  final _pendingSends = <List<int>>[];
  StreamSubscription<Uint8List>? _eventsSubscription;

  String? _sessionId;
  Future<void>? _ready;
  Future<void>? _closed;
  bool _closing = false;

  /// Messages buffered before the session exists are capped; beyond that
  /// the caller is producing far faster than a session can be created.
  static const _maxPendingSends = 128;

  @override
  Stream<Uint8List> get stream => _incoming.stream;

  @override
  Future<void> get ready =>
      _ready ?? (throw StateError('channel was not opened'));

  void _open(Iterable<List<int>> initialMessages) {
    _ready = _createSession(initialMessages).then((sessionId) {
      _sessionId = sessionId;
      final buffered = List<List<int>>.of(_pendingSends);
      _pendingSends.clear();
      for (final bytes in buffered) {
        _post(bytes);
      }
      _attachEvents();
    });
    unawaited(
      _ready!.then<void>(
        (_) {},
        onError: (Object error, StackTrace stackTrace) {
          _fail(error, stackTrace);
        },
      ),
    );
  }

  Future<String> _createSession(Iterable<List<int>> initialMessages) async {
    final observations = <client.ObserveResource>[];
    for (final bytes in initialMessages) {
      try {
        final message = client.ClientMessage.fromBuffer(bytes);
        if (message.hasObserveResource() &&
            message.observeResource.observeId.isNotEmpty) {
          observations.add(message.observeResource);
        }
      } catch (_) {
        // Skip undecodable frames; observations are also replayed by the
        // engine after connect.
      }
    }
    final response = await _gateway.createRealtimeSession(
      _roomId,
      observations,
    );
    return response.sessionId;
  }

  void _attachEvents() {
    final sessionId = _sessionId;
    if (sessionId == null || _closing) return;
    _eventsSubscription = _gateway
        .openRealtimeSessionEvents(_roomId, sessionId)
        .listen(
          (bytes) {
            _onIncoming?.call(bytes);
            if (!_incoming.isClosed) _incoming.add(bytes);
          },
          onError: (Object error, StackTrace stackTrace) {
            _fail(error, stackTrace);
          },
          onDone: () {
            if (!_closing) {
              _fail(
                StateError('Realtime session downlink closed'),
                StackTrace.current,
              );
            }
          },
        );
  }

  @override
  void send(List<int> bytes) {
    if (bytes.isEmpty || _closing) return;
    if (_sessionId == null) {
      if (_pendingSends.length < _maxPendingSends) {
        _pendingSends.add(bytes);
      }
      return;
    }
    _post(bytes);
  }

  void _post(List<int> bytes) {
    final sessionId = _sessionId;
    if (sessionId == null) return;
    _onOutgoing?.call(bytes);
    unawaited(
      _gateway
          .sendRealtimeSessionMessage(
            _roomId,
            sessionId,
            client.ClientMessage.fromBuffer(bytes),
          )
          .catchError((Object error, StackTrace stackTrace) {
            _fail(error, stackTrace);
          }),
    );
  }

  void _fail(Object error, StackTrace stackTrace) {
    if (_incoming.isClosed) return;
    _incoming.addError(error, stackTrace);
    unawaited(close());
  }

  @override
  Future<void> close() => _closed ??= _close();

  Future<void> _close() async {
    _closing = true;
    final eventsSubscription = _eventsSubscription;
    _eventsSubscription = null;
    await eventsSubscription?.cancel();
    final sessionId = _sessionId;
    _sessionId = null;
    if (sessionId != null) {
      try {
        await _gateway.endRealtimeSession(_roomId, sessionId);
      } catch (_) {
        // Best-effort: the lease reaps the session anyway.
      }
    }
    unawaited(_incoming.close());
  }
}

/// [RoomRealtimeChannelFactory] over HTTP realtime sessions (SSE downlink +
/// REST uplink).
final class HttpSessionRoomRealtimeChannelFactory
    implements RoomRealtimeChannelFactory {
  const HttpSessionRoomRealtimeChannelFactory({required this.sessionGateway});

  final RoomSessionGateway sessionGateway;

  @override
  RoomRealtimeChannel connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    return HttpSessionRoomRealtimeChannel.connect(
      sessionGateway,
      roomId,
      initialMessages: initialMessages,
      onOutgoing: onOutgoing,
      onIncoming: onIncoming,
    );
  }
}
