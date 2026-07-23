import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/managers/p2p_media_manager.dart';

void main() {
  test('active swarm presence is announced periodically', () {
    fakeAsync((async) {
      final signals = <({String type, Map<String, dynamic> data})>[];
      final manager = P2pMediaManager(
        onSignalingMessage: (type, data) {
          signals.add((type: type, data: data));
        },
        loadIceServers: () async => const [],
        loadCachedPiece: (swarmId, pieceKey) async => null,
        onStateChange: () {},
      );

      unawaited(manager.setActiveSwarms({'sm1_test': 'ticket'}));
      async.flushMicrotasks();
      expect(signals.map((signal) => signal.type), ['media_swarm_join']);

      signals.clear();
      async.elapse(const Duration(seconds: 30));
      expect(signals, hasLength(1));
      expect(signals.single.type, 'media_swarm_join');
      expect(signals.single.data['media_swarm_id'], 'sm1_test');
      expect(signals.single.data['media_swarm_ticket'], 'ticket');

      unawaited(manager.dispose());
      async.flushMicrotasks();
      signals.clear();
      async.elapse(const Duration(minutes: 1));
      expect(signals, isEmpty);
    });
  });

  test('a refreshed ticket is announced for the active swarm', () async {
    final signals = <({String type, Map<String, dynamic> data})>[];
    final manager = P2pMediaManager(
      onSignalingMessage: (type, data) {
        signals.add((type: type, data: data));
      },
      loadIceServers: () async => const [],
      loadCachedPiece: (swarmId, pieceKey) async => null,
      onStateChange: () {},
    );
    addTearDown(manager.dispose);

    await manager.setActiveSwarms({'sm1_test': 'ticket-1'});
    signals.clear();
    await manager.setActiveSwarms({'sm1_test': 'ticket-2'});

    expect(signals, hasLength(1));
    expect(signals.single.type, 'media_swarm_join');
    expect(signals.single.data['media_swarm_ticket'], 'ticket-2');
  });

  test('server peer discovery renews a ticket without a sender id', () {
    fakeAsync((async) {
      final signals = <({String type, Map<String, dynamic> data})>[];
      final manager = P2pMediaManager(
        onSignalingMessage: (type, data) {
          signals.add((type: type, data: data));
        },
        loadIceServers: () async => const [],
        loadCachedPiece: (swarmId, pieceKey) async => null,
        onStateChange: () {},
      );
      unawaited(manager.setActiveSwarms({'sm1_test': 'ticket-1'}));
      async.flushMicrotasks();
      signals.clear();

      manager.handleSignalingMessage('media_swarm_peers', {
        'media_swarm_id': 'sm1_test',
        'media_swarm_ticket': 'ticket-2',
        'peers': const [],
      });
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 30));

      expect(signals, hasLength(1));
      expect(signals.single.type, 'media_swarm_join');
      expect(signals.single.data['media_swarm_ticket'], 'ticket-2');
      unawaited(manager.dispose());
      async.flushMicrotasks();
    });
  });
}
