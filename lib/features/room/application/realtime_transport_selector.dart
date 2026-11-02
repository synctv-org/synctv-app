import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

/// Which realtime transport a [RoomRealtimeChannelFactory] speaks.
enum RealtimeTransport {
  webSocket,
  sse,
  webTransport;

  static RealtimeTransport? fromProto(
    client_enum.RealtimeTransportKind kind,
  ) => switch (kind) {
    client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_WEB_SOCKET =>
      webSocket,
    client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE => sse,
    client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_WEB_TRANSPORT =>
      webTransport,
    _ => null,
  };
}

/// One candidate transport produced by the selector.
class RealtimeTransportOption {
  const RealtimeTransportOption({
    required this.transport,
    required this.factory,
  });

  final RealtimeTransport transport;
  final RoomRealtimeChannelFactory factory;
}

/// Supplies ranked transport candidates for connection attempts and absorbs
/// success/failure feedback. Implemented by [SelectorRealtimeTransportPlanner].
abstract interface class RealtimeTransportPlanner {
  /// Candidate transports for one connection cycle, best first. Empty means
  /// no transport is currently available.
  List<RealtimeTransportOption> candidates();

  /// A candidate established a working channel.
  void reportSuccess(RealtimeTransport transport);

  /// A candidate failed to connect.
  void reportFailure(RealtimeTransport transport);
}

/// [RealtimeTransportPlanner] over a [RealtimeTransportSelector]; the server
/// advertisement is re-read every cycle so a refreshed `ServerInfo` changes
/// candidates without rebuilding the planner.
class SelectorRealtimeTransportPlanner implements RealtimeTransportPlanner {
  SelectorRealtimeTransportPlanner({
    required this.selector,
    required this.advertisedTransports,
  });

  final RealtimeTransportSelector selector;

  /// The server's advertised realtime transports, re-read per cycle.
  final List<client_enum.RealtimeTransportKind> Function() advertisedTransports;

  @override
  List<RealtimeTransportOption> candidates() =>
      selector.rank(advertisedTransports());

  @override
  void reportSuccess(RealtimeTransport transport) =>
      selector.reportSuccess(transport);

  @override
  void reportFailure(RealtimeTransport transport) =>
      selector.reportFailure(transport);
}

/// Single-transport planner for tests and forced-transport debugging.
class FixedTransportPlanner implements RealtimeTransportPlanner {
  FixedTransportPlanner(this.option);

  final RealtimeTransportOption option;

  @override
  List<RealtimeTransportOption> candidates() => [option];

  @override
  void reportSuccess(RealtimeTransport transport) {}

  @override
  void reportFailure(RealtimeTransport transport) {}
}

/// Chooses the realtime transport for a connection attempt.
///
/// Inputs, in priority order:
/// 1. the server's advertised transports (`GetServerInfoResponse.transports`)
///    — a transport the server does not offer is never tried;
/// 2. the platform's available factories (e.g. WebTransport only where the
///    platform supports it);
/// 3. health: a transport that recently failed several times is demoted for
///    a cooldown window, then re-promoted;
/// 4. the last transport that worked (sticky preference) is tried first.
///
/// Client preference among advertised transports: WebTransport → SSE →
/// WebSocket (single bidirectional QUIC stream beats the SSE+REST pair,
/// which beats the browser-constrained WebSocket).
class RealtimeTransportSelector {
  RealtimeTransportSelector({
    required this.webSocketFactory,
    this.sseFactory,
    this.webTransportFactory,
    this.failureThreshold = 2,
    this.demotionCooldown = const Duration(minutes: 5),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final RoomRealtimeChannelFactory webSocketFactory;
  final RealtimeChannelFactoryGetter? sseFactory;
  final RealtimeChannelFactoryGetter? webTransportFactory;

  /// Consecutive failures on one transport before it is demoted.
  final int failureThreshold;

  /// How long a demoted transport stays demoted.
  final Duration demotionCooldown;

  final DateTime Function() _now;

  final Map<RealtimeTransport, int> _consecutiveFailures = {};
  final Map<RealtimeTransport, DateTime> _demotedUntil = {};

  /// Sticky transport the caller can persist per server (optional input).
  RealtimeTransport? preferred;

  /// Ranks the transports available for this connection attempt.
  ///
  /// [advertised] is the server's transport list; empty means "unknown"
  /// (older servers), in which case WebSocket — the only transport every
  /// server generation supports — is the sole candidate.
  List<RealtimeTransportOption> rank(
    List<client_enum.RealtimeTransportKind> advertised,
  ) {
    final allowed = advertised
        .map(RealtimeTransport.fromProto)
        .whereType<RealtimeTransport>()
        .toSet();
    if (allowed.isEmpty) {
      allowed.add(RealtimeTransport.webSocket);
    }

    final now = _now();
    final options = <RealtimeTransportOption>[];
    void add(RealtimeTransport transport, RoomRealtimeChannelFactory? factory) {
      if (factory == null) return;
      if (!allowed.contains(transport)) return;
      final demotedUntil = _demotedUntil[transport];
      if (demotedUntil != null && demotedUntil.isAfter(now)) return;
      options.add(
        RealtimeTransportOption(transport: transport, factory: factory),
      );
    }

    // Client preference order: WebTransport → SSE → WebSocket, filtered by
    // server advertisement, platform availability, and demotion state.
    for (final transport in _clientPreferenceOrder) {
      final factory = switch (transport) {
        RealtimeTransport.webSocket => webSocketFactory,
        RealtimeTransport.sse => sseFactory?.call(),
        RealtimeTransport.webTransport => webTransportFactory?.call(),
      };
      add(transport, factory);
    }

    // Sticky preference first among the survivors.
    final preferred = this.preferred;
    if (preferred != null) {
      final index = options.indexWhere(
        (option) => option.transport == preferred,
      );
      if (index > 0) {
        options.insert(0, options.removeAt(index));
      }
    }

    // A demoted-or-missing preferred transport must not strand the client:
    // WebSocket is always the final candidate when the server offers it.
    if (options.isEmpty && allowed.contains(RealtimeTransport.webSocket)) {
      options.add(
        RealtimeTransportOption(
          transport: RealtimeTransport.webSocket,
          factory: webSocketFactory,
        ),
      );
    }
    return options;
  }

  static const _clientPreferenceOrder = [
    RealtimeTransport.webTransport,
    RealtimeTransport.sse,
    RealtimeTransport.webSocket,
  ];

  /// Records a successful connection on [transport]; clears its failure
  /// count, lifts any demotion, and makes it sticky.
  void reportSuccess(RealtimeTransport transport) {
    preferred = transport;
    _consecutiveFailures.remove(transport);
    _demotedUntil.remove(transport);
  }

  /// Records a failed connection attempt on [transport]; after
  /// [failureThreshold] consecutive failures the transport is demoted for
  /// [demotionCooldown].
  void reportFailure(RealtimeTransport transport) {
    final failures = (_consecutiveFailures[transport] ?? 0) + 1;
    _consecutiveFailures[transport] = failures;
    if (failures >= failureThreshold) {
      _demotedUntil[transport] = _now().add(demotionCooldown);
      _consecutiveFailures[transport] = 0;
    }
  }
}

/// Lazily provides a factory whose platform support may change (native
/// WebTransport loaded per platform).
typedef RealtimeChannelFactoryGetter = RoomRealtimeChannelFactory? Function();
