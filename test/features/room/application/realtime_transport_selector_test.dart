import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/realtime_transport_selector.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

class _StubFactory implements RoomRealtimeChannelFactory {
  const _StubFactory();

  @override
  RoomRealtimeChannel connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) => throw UnimplementedError();
}

const _ws = RealtimeTransportOption(
  transport: RealtimeTransport.webSocket,
  factory: _StubFactory(),
);
const _sse = RealtimeTransportOption(
  transport: RealtimeTransport.sse,
  factory: _StubFactory(),
);
const _wt = RealtimeTransportOption(
  transport: RealtimeTransport.webTransport,
  factory: _StubFactory(),
);

RealtimeTransportSelector buildSelector({
  bool sse = true,
  bool webTransport = true,
  DateTime Function()? now,
}) {
  return RealtimeTransportSelector(
    webSocketFactory: _ws.factory,
    sseFactory: sse ? () => _sse.factory : null,
    webTransportFactory: webTransport ? () => _wt.factory : null,
    failureThreshold: 2,
    demotionCooldown: const Duration(minutes: 5),
    now: now,
  );
}

void main() {
  group('RealtimeTransportSelector', () {
    test('prefers WebTransport, then SSE, then WebSocket', () {
      final selector = buildSelector();
      final ranked = selector
          .rank([
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_SOCKET,
            client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
          ])
          .map((option) => option.transport)
          .toList();

      expect(ranked, [
        RealtimeTransport.webTransport,
        RealtimeTransport.sse,
        RealtimeTransport.webSocket,
      ]);
    });

    test('never offers transports the server does not advertise', () {
      final selector = buildSelector();
      final ranked = selector
          .rank([
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_SOCKET,
          ])
          .map((option) => option.transport)
          .toList();

      expect(ranked, [RealtimeTransport.webSocket]);
    });

    test('unknown advertisement falls back to WebSocket only', () {
      final selector = buildSelector();
      final ranked = selector.rank(const []).map((option) => option.transport);
      expect(ranked, [RealtimeTransport.webSocket]);
    });

    test('missing platform factories drop their transport', () {
      final selector = buildSelector(webTransport: false);
      final ranked = selector
          .rank([
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_SOCKET,
            client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
          ])
          .map((option) => option.transport)
          .toList();

      expect(ranked, [RealtimeTransport.sse, RealtimeTransport.webSocket]);
    });

    test('sticky preference wins over default order', () {
      final selector = buildSelector()..preferred = RealtimeTransport.sse;
      final ranked = selector
          .rank([
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_SOCKET,
            client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
          ])
          .map((option) => option.transport)
          .toList();

      expect(ranked.first, RealtimeTransport.sse);
    });

    test('demotes after consecutive failures, re-promotes after cooldown', () {
      var now = DateTime(2026, 1, 1);
      final selector = buildSelector(now: () => now);

      // failureThreshold is 2: a single failure must not demote.
      selector.reportFailure(RealtimeTransport.webTransport);
      expect(
        selector
            .rank([
              client_enum
                  .RealtimeTransportKind
                  .REALTIME_TRANSPORT_KIND_WEB_SOCKET,
              client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
              client_enum
                  .RealtimeTransportKind
                  .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
            ])
            .map((option) => option.transport),
        contains(RealtimeTransport.webTransport),
      );

      selector.reportFailure(RealtimeTransport.webTransport);
      expect(
        selector
            .rank([
              client_enum
                  .RealtimeTransportKind
                  .REALTIME_TRANSPORT_KIND_WEB_SOCKET,
              client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
              client_enum
                  .RealtimeTransportKind
                  .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
            ])
            .map((option) => option.transport),
        isNot(contains(RealtimeTransport.webTransport)),
      );

      // Still demoted within the cooldown.
      now = now.add(const Duration(minutes: 4));
      expect(
        selector.rank([
          client_enum
              .RealtimeTransportKind
              .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
        ]),
        isEmpty,
      );

      // Cooldown elapsed: re-promoted (but WebSocket stays the fallback).
      now = now.add(const Duration(minutes: 2));
      expect(
        selector
            .rank([
              client_enum
                  .RealtimeTransportKind
                  .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
            ])
            .map((option) => option.transport),
        [RealtimeTransport.webTransport],
      );
    });

    test('success clears failures and sets the sticky preference', () {
      final selector = buildSelector();
      selector.reportFailure(RealtimeTransport.sse);
      selector.reportSuccess(RealtimeTransport.sse);
      expect(selector.preferred, RealtimeTransport.sse);

      // A single failure after success does not demote.
      selector.reportFailure(RealtimeTransport.sse);
      expect(
        selector.rank([
          client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
        ]),
        hasLength(1),
      );
    });

    test('every transport demoted still yields WebSocket', () {
      var now = DateTime(2026, 1, 1);
      final selector = buildSelector(now: () => now);
      for (final transport in RealtimeTransport.values) {
        selector.reportFailure(transport);
        selector.reportFailure(transport);
      }
      final ranked = selector
          .rank([
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_SOCKET,
            client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
            client_enum
                .RealtimeTransportKind
                .REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
          ])
          .map((option) => option.transport)
          .toList();

      expect(ranked, [RealtimeTransport.webSocket]);
    });
  });

  group('RealtimeTransportPlanner', () {
    test('planner delegates to the selector and re-reads advertisement', () {
      var advertised = const <client_enum.RealtimeTransportKind>[];
      final planner = SelectorRealtimeTransportPlanner(
        selector: buildSelector(),
        advertisedTransports: () => advertised,
      );

      expect(planner.candidates(), hasLength(1));
      advertised = [
        client_enum.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_SSE,
      ];
      expect(planner.candidates().map((option) => option.transport), [
        RealtimeTransport.sse,
      ]);
    });

    test('fixed planner always returns its single option', () {
      final planner = FixedTransportPlanner(_ws);
      expect(planner.candidates(), [_ws]);
    });
  });
}
