import 'dart:async';
import 'dart:typed_data';

import 'package:synctv_app/features/room/application/realtime_observation_registry.dart';
import 'package:synctv_app/features/room/application/realtime_reconnect_policy.dart';
import 'package:synctv_app/features/room/application/realtime_transport_selector.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/application/room_realtime_engine.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

/// [RoomRealtimeEngine] on top of any [RoomRealtimeChannelFactory].
///
/// Responsibilities (all transport-independent):
/// - connect / reconnect with exponential backoff + jitter;
/// - resubscribe every recorded observation with its last event cursor
///   after a reconnect, so event streams resume instead of restarting;
/// - heartbeats while connected;
/// - decoding frames and advancing observation cursors;
/// - stopping permanently on server termination.
class ReconnectingRoomRealtimeEngine implements RoomRealtimeEngine {
  ReconnectingRoomRealtimeEngine({
    required this._roomId,
    required this.planner,
    RealtimeReconnectPolicy? reconnectPolicy,
    required this._nowMillis,
    this.heartbeatInterval = const Duration(seconds: 25),
    this._onOutgoing,
    this._onIncoming,
  }) : _reconnectPolicy =
           reconnectPolicy ??
           RealtimeReconnectPolicy(
             baseDelay: const Duration(milliseconds: 500),
             maxDelay: const Duration(seconds: 30),
           ) {
    _codec = RoomRealtimeCodec(registry: _registry);
  }

  final String _roomId;
  final RealtimeTransportPlanner planner;
  final RealtimeReconnectPolicy _reconnectPolicy;
  final int Function() _nowMillis;
  final Duration heartbeatInterval;
  final void Function(List<int> bytes)? _onOutgoing;
  final void Function(Uint8List bytes)? _onIncoming;

  final RealtimeObservationRegistry _registry = RealtimeObservationRegistry();
  late final RoomRealtimeCodec _codec;

  final StreamController<RoomRealtimeMessage> _messages =
      StreamController<RoomRealtimeMessage>.broadcast();
  final StreamController<RoomRealtimeLifecycle> _lifecycle =
      StreamController<RoomRealtimeLifecycle>.broadcast();

  RoomRealtimeChannel? _channel;
  StreamSubscription<Uint8List>? _channelSubscription;
  Timer? _heartbeatTimer;
  Future<void>? _runLoopFuture;
  Completer<void>? _closeRequested;
  RoomRealtimeTermination? _termination;
  bool _started = false;
  bool _closed = false;

  @override
  Stream<RoomRealtimeMessage> get messages => _messages.stream;

  @override
  Stream<RoomRealtimeLifecycle> get lifecycle => _lifecycle.stream;

  @override
  bool get isConnected => _heartbeatTimer != null;

  @override
  void start() {
    if (_started) return;
    _started = true;
    _runLoopFuture = _runLoop();
  }

  @override
  bool send(List<int> bytes) {
    if (bytes.isEmpty) return false;
    _recordOutgoing(bytes);
    final channel = _channel;
    if (channel == null) return false;
    try {
      channel.send(bytes);
      return true;
    } catch (_) {
      // The channel is unusable; the run loop reconnects.
      _abortChannel();
      return false;
    }
  }

  @override
  Future<void> close() => _closeFuture ??= _close();

  Future<void>? _closeFuture;

  Future<void> _close() async {
    _closed = true;
    _closeRequested?.complete();
    _stopHeartbeat();
    // Wake the run loop first: cancelling the subscription would swallow
    // the channel's done event it is waiting on.
    final channelEnded = _channelEnded;
    if (channelEnded != null && !channelEnded.isCompleted) {
      channelEnded.complete();
    }
    await _channelSubscription?.cancel();
    _channelSubscription = null;
    await _channel?.close();
    _channel = null;
    final runLoop = _runLoopFuture;
    if (runLoop != null) {
      await runLoop.quietly();
    }
    if (!_lifecycle.isClosed) {
      _lifecycle.add(const RoomRealtimeClosed());
      await _lifecycle.close();
    }
    if (!_messages.isClosed) {
      await _messages.close();
    }
  }

  Completer<void>? _channelEnded;
  RealtimeTransport? _activeTransport;

  Future<void> _runLoop() async {
    try {
      while (!_closed) {
        final connected = await _tryConnectOnce();
        if (!connected) {
          if (_closed) return;
          if (!_scheduleRetry()) return;
          await _waitRetry();
          continue;
        }

        _reconnectPolicy.reset();
        _startHeartbeat();
        _lifecycle.add(RoomRealtimeConnected(transport: _activeTransport));

        await _channelEnded!.future;
        _channelEnded = null;
        await _dropChannel();
        if (_closed || _termination != null) return;
        _lifecycle.add(const RoomRealtimeDisconnected(retryPlanned: true));
        if (!_scheduleRetry()) return;
        await _waitRetry();
      }
    } finally {
      _stopHeartbeat();
      if (!_lifecycle.isClosed) {
        _lifecycle.add(const RoomRealtimeClosed());
        await _lifecycle.close();
      }
      if (!_messages.isClosed) {
        await _messages.close();
      }
    }
  }

  /// Tries every planned candidate once (transport failover within one
  /// cycle): a candidate whose connect/ready fails is reported and the next
  /// is tried immediately.
  Future<bool> _tryConnectOnce() async {
    for (final option in planner.candidates()) {
      if (_closed) return false;
      _lifecycle.add(
        RoomRealtimeConnecting(
          attempt: _reconnectPolicy.attempts,
          transport: option.transport,
        ),
      );
      final channelEnded = Completer<void>();
      RoomRealtimeChannel channel;
      try {
        channel = option.factory.connect(
          _roomId,
          initialMessages: _registry.replayMessages(),
          onOutgoing: _onOutgoing,
          onIncoming: _onIncoming,
        );
      } catch (_) {
        planner.reportFailure(option.transport);
        continue;
      }
      _channel = channel;
      _channelSubscription = channel.stream.listen(
        _handleFrame,
        onError: (Object error) {
          if (!channelEnded.isCompleted) channelEnded.complete();
        },
        onDone: () {
          if (!channelEnded.isCompleted) channelEnded.complete();
        },
        cancelOnError: true,
      );
      try {
        await channel.ready;
      } catch (_) {
        await _dropChannel();
        planner.reportFailure(option.transport);
        if (_closed) return false;
        continue;
      }
      if (_closed) {
        await _dropChannel();
        return false;
      }
      _channelEnded = channelEnded;
      _activeTransport = option.transport;
      planner.reportSuccess(option.transport);
      return true;
    }
    return false;
  }

  /// Arms the next retry. Returns false when retries are exhausted (the
  /// caller must stop).
  bool _scheduleRetry() {
    if (_reconnectPolicy.exhausted) {
      _lifecycle.add(const RoomRealtimeDisconnected(retryPlanned: false));
      _lifecycle.add(const RoomRealtimeClosed());
      return false;
    }
    return true;
  }

  Future<void> _waitRetry() async {
    _closeRequested ??= Completer<void>();
    final delay = _reconnectPolicy.nextDelay();
    if (delay > Duration.zero) {
      await Future.any([Future<void>.delayed(delay), _closeRequested!.future]);
    }
  }

  void _handleFrame(Uint8List bytes) {
    final envelope = tryDecodeServerMessage(bytes);
    if (envelope == null) return;
    _advanceCursors(envelope);
    final message = _codec.decode(bytes);
    if (message.kind == RoomRealtimeMessageKind.terminated) {
      _termination = message.termination;
      if (!_messages.isClosed) _messages.add(message);
      if (!_lifecycle.isClosed) {
        _lifecycle.add(RoomRealtimeTerminatedEvent(message.termination!));
      }
      // Ends the channel; the run loop sees the termination and stops.
      _abortChannel();
      return;
    }
    if (!_messages.isClosed) _messages.add(message);
  }

  static client.ServerMessage? tryDecodeServerMessage(Uint8List bytes) {
    try {
      return client.ServerMessage.fromBuffer(bytes);
    } catch (_) {
      return null;
    }
  }

  void _advanceCursors(client.ServerMessage envelope) {
    switch (envelope.whichMessage()) {
      case client.ServerMessage_Message.resourceObserved:
        final observed = envelope.resourceObserved;
        if (observed.hasEventCursor()) {
          _registry.advanceCursor(observed.observeId, observed.eventCursor);
        }
      case client.ServerMessage_Message.resourceEvent:
        final changed = envelope.resourceEvent;
        if (changed.hasEventCursor()) {
          _registry.advanceCursor(changed.observeId, changed.eventCursor);
        }
      default:
        break;
    }
  }

  /// Records observe/unobserve requests so reconnects replay the full
  /// observation set.
  void _recordOutgoing(List<int> bytes) {
    final message = tryDecodeClientMessage(bytes);
    if (message == null) return;
    switch (message.whichMessage()) {
      case client.ClientMessage_Message.observeResource:
        if (message.observeResource.observeId.isNotEmpty) {
          _registry.record(message.observeResource);
        }
      case client.ClientMessage_Message.unobserveResource:
        _registry.remove(message.unobserveResource.observeId);
      default:
        break;
    }
  }

  static client.ClientMessage? tryDecodeClientMessage(List<int> bytes) {
    try {
      return client.ClientMessage.fromBuffer(bytes);
    } catch (_) {
      return null;
    }
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
      final channel = _channel;
      if (channel == null) return;
      try {
        channel.send(
          RoomRealtimeCodec.encodeSync(timestampMillis: _nowMillis()),
        );
      } catch (_) {
        _abortChannel();
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> _dropChannel() async {
    _stopHeartbeat();
    final subscription = _channelSubscription;
    _channelSubscription = null;
    final channel = _channel;
    _channel = null;
    await subscription?.cancel();
    await channel?.close();
  }

  /// Closes the channel without waiting; the run loop drives the rest.
  void _abortChannel() {
    final channel = _channel;
    if (channel != null) {
      unawaited(channel.close());
    }
  }
}

extension<T> on Future<T> {
  /// Waits for the future while treating an already-completed error as a
  /// no-op (the run loop never errors by construction).
  Future<void> quietly() async {
    try {
      await this;
    } catch (_) {
      // Ignored by design.
    }
  }
}

/// Factory producing [ReconnectingRoomRealtimeEngine]s for a room.
class ReconnectingRoomRealtimeEngineFactory
    implements RoomRealtimeEngineFactory {
  const ReconnectingRoomRealtimeEngineFactory({
    required this.planner,
    required this.nowMillis,
    this.heartbeatInterval = const Duration(seconds: 25),
  });

  final RealtimeTransportPlanner planner;
  final int Function() nowMillis;
  final Duration heartbeatInterval;

  @override
  RoomRealtimeEngine create(
    String roomId, {
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    return ReconnectingRoomRealtimeEngine(
      roomId: roomId,
      planner: planner,
      nowMillis: nowMillis,
      heartbeatInterval: heartbeatInterval,
      onOutgoing: onOutgoing,
      onIncoming: onIncoming,
    );
  }
}
