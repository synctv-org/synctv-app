import 'dart:typed_data';

import 'package:synctv_app/features/room/application/realtime_transport_selector.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';

/// Lifecycle transitions of a realtime engine, in order of occurrence.
sealed class RoomRealtimeLifecycle {
  const RoomRealtimeLifecycle();
}

/// A connection attempt started (initial or reconnect).
final class RoomRealtimeConnecting extends RoomRealtimeLifecycle {
  const RoomRealtimeConnecting({required this.attempt, this.transport});

  /// 0 for the initial connection, 1+ for reconnect attempts.
  final int attempt;

  /// Transport being tried, when the planner provides one.
  final RealtimeTransport? transport;
}

/// A channel was established and the recorded observations replayed.
final class RoomRealtimeConnected extends RoomRealtimeLifecycle {
  const RoomRealtimeConnected({this.transport});

  /// Transport that established the channel, when known.
  final RealtimeTransport? transport;
}

/// The channel dropped or failed; the engine will reconnect unless it was
/// closed or terminated.
final class RoomRealtimeDisconnected extends RoomRealtimeLifecycle {
  const RoomRealtimeDisconnected({required this.retryPlanned});

  /// False when the engine gave up ([RoomRealtimeClosed] follows) or the
  /// caller closed it.
  final bool retryPlanned;
}

/// The server ended the session deliberately (revoked access, room gone).
/// Terminal: the engine will not reconnect.
final class RoomRealtimeTerminatedEvent extends RoomRealtimeLifecycle {
  const RoomRealtimeTerminatedEvent(this.termination);

  final RoomRealtimeTermination termination;
}

/// The engine stopped and will not reconnect.
final class RoomRealtimeClosed extends RoomRealtimeLifecycle {
  const RoomRealtimeClosed();
}

/// Owns the realtime connection lifecycle for one room: connecting,
/// heartbeats, decoding, observation bookkeeping, and reconnection with
/// backoff. The transport is plugged in as a [RoomRealtimeChannelFactory].
abstract interface class RoomRealtimeEngine {
  /// Decoded realtime messages (chat, playback, resources, terminations).
  Stream<RoomRealtimeMessage> get messages;

  /// Lifecycle transitions; a single-subscription stream.
  Stream<RoomRealtimeLifecycle> get lifecycle;

  /// Whether a channel is currently established.
  bool get isConnected;

  /// Queues a message for delivery. Observation/unobserve messages are
  /// recorded so they survive reconnects. Returns false while no channel is
  /// established (the engine is already reconnecting in that case).
  bool send(List<int> bytes);

  /// Starts connecting. Ignored if already started.
  void start();

  /// Stops the engine permanently and closes the current channel.
  Future<void> close();
}

/// Creates per-room engines.
abstract interface class RoomRealtimeEngineFactory {
  RoomRealtimeEngine create(
    String roomId, {
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  });
}
