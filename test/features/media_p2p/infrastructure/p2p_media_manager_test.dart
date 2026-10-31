import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/webrtc/webrtc_negotiation_state.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_manager.dart';

import '../../../support/p2p_replacement_candidates.dart';

void main() {
  test('disposal closes remaining peers after a transport failure', () async {
    expect(await p2pDisposalAfterPeerFailure(), [
      'close 0',
      'close 1',
      'original failure',
    ]);
  });
  test(
    'concurrent and subsequent disposal report the same shutdown failure',
    () async {
      expect(await p2pConcurrentDisposalWaits(failClose: true), isTrue);
    },
  );
  test('concurrent disposal waits for peer shutdown', () async {
    expect(await p2pConcurrentDisposalWaits(), isTrue);
  });
  for (final duringClose in [false, true]) {
    test(
      'replaced channel ignores stale callbacks (during close: $duringClose)',
      () async {
        expect(await p2pReplacedChannelEvents(duringClose: duringClose), [
          'state',
          'current cache read',
        ]);
      },
    );
  }

  test(
    'replacement detaches old peer before awaiting its data channel',
    () async {
      expect(await p2pReplacementCandidates(delayChannel: true), [
        'During old peer close',
        'After replacement',
      ]);
    },
  );

  test(
    'replacement preserves candidates received while old peer closes',
    () async {
      expect(await p2pReplacementCandidates(), [
        'During old peer close',
        'After replacement',
      ]);
    },
  );

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

  test('peer requests stay enabled only for active swarm discovery', () {
    fakeAsync((async) {
      final manager = P2pMediaManager(
        onSignalingMessage: (_, _) {},
        loadIceServers: () async => const [],
        loadCachedPiece: (_, _) async => null,
        onStateChange: () {},
      );

      expect(manager.canRequestPeer('sm1_test'), isFalse);
      unawaited(manager.setActiveSwarms({'sm1_test': 'ticket'}));
      async.flushMicrotasks();
      expect(manager.canRequestPeer('sm1_test'), isTrue);

      unawaited(manager.setActiveSwarms(const {}));
      async.flushMicrotasks();
      expect(manager.canRequestPeer('sm1_test'), isFalse);
      unawaited(manager.dispose());
      async.flushMicrotasks();
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

  test(
    'media, subtitle, and danmaku swarms stay active independently',
    () async {
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

      await manager.setActiveSwarms({
        'sm3_media': 'media-ticket',
        'sm3_subtitle': 'subtitle-ticket-1',
        'sm3_danmaku': 'danmaku-ticket',
      });
      expect(manager.activeSwarms, {
        'sm3_media',
        'sm3_subtitle',
        'sm3_danmaku',
      });

      signals.clear();
      await manager.setActiveSwarms({
        'sm3_media': 'media-ticket',
        'sm3_subtitle': 'subtitle-ticket-2',
        'sm3_danmaku': 'danmaku-ticket',
      });
      expect(signals, hasLength(1));
      expect(signals.single.type, 'media_swarm_join');
      expect(signals.single.data['media_swarm_id'], 'sm3_subtitle');
      expect(signals.single.data['media_swarm_ticket'], 'subtitle-ticket-2');

      signals.clear();
      await manager.setActiveSwarms({
        'sm3_media': 'media-ticket',
        'sm3_danmaku': 'danmaku-ticket',
      });
      expect(signals, hasLength(1));
      expect(signals.single.type, 'media_swarm_leave');
      expect(signals.single.data['media_swarm_id'], 'sm3_subtitle');
      expect(manager.activeSwarms, {'sm3_media', 'sm3_danmaku'});
    },
  );

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

  group('ICE candidate admission', () {
    P2pMediaManager buildManager() => P2pMediaManager(
      onSignalingMessage: (_, _) {},
      loadIceServers: () async => const [],
      loadCachedPiece: (swarmId, pieceKey) async => null,
      onStateChange: () {},
      createConnection: (_) async => throw StateError('no transport'),
    );

    void sendCandidate(
      P2pMediaManager manager,
      String from,
      String swarm, [
      Object? sdpMLineIndex = 0,
    ]) {
      manager.handleSignalingMessage('candidate', {
        'from': from,
        'media_swarm_id': swarm,
        'candidate': 'candidate:1 1 udp 1 192.0.2.1 9 typ host',
        'sdpMid': '0',
        'sdpMLineIndex': sdpMLineIndex,
      });
    }

    test('candidates from unregistered peers are dropped', () async {
      final manager = buildManager();
      await manager.setActiveSwarms({'sm1_test': 'ticket'});
      for (var i = 0; i < 5000; i++) {
        sendCandidate(manager, 'attacker-$i:conn', 'sm1_test');
      }
      await Future<void>.delayed(Duration.zero);
      expect(manager.pendingCandidatePeerCount, 0);
      await manager.dispose();
    });

    test(
      'per-peer candidate floods are capped even for admitted peers',
      () async {
        final manager = buildManager();
        await manager.setActiveSwarms({'sm1_test': 'ticket'});
        manager.handleSignalingMessage('media_swarm_join', {
          'from': 'peer:1',
          'media_swarm_id': 'sm1_test',
        });
        await Future<void>.delayed(Duration.zero);
        for (var i = 0; i < 5000; i++) {
          sendCandidate(manager, 'peer:1', 'sm1_test');
        }
        await Future<void>.delayed(Duration.zero);
        expect(manager.pendingCandidatePeerCount, 1);
        expect(
          manager.pendingCandidateCount('peer:1', 'sm1_test'),
          WebRtcNegotiationState.defaultMaxPendingCandidatesPerPeer,
        );
        await manager.dispose();
      },
    );

    test(
      'swarm registration admits candidates from registered peers',
      () async {
        final manager = buildManager();
        await manager.setActiveSwarms({'sm1_test': 'ticket'});
        manager.handleSignalingMessage('media_swarm_join', {
          'from': 'peer:1',
          'media_swarm_id': 'sm1_test',
        });
        await Future<void>.delayed(Duration.zero);
        sendCandidate(manager, 'peer:1', 'sm1_test');
        await Future<void>.delayed(Duration.zero);
        expect(manager.pendingCandidatePeerCount, 1);
        await manager.dispose();
      },
    );

    test('signaling session reset reclaims never-connected queues', () async {
      final manager = buildManager();
      await manager.setActiveSwarms({'sm1_test': 'ticket'});
      manager.handleSignalingMessage('media_swarm_join', {
        'from': 'peer:1',
        'media_swarm_id': 'sm1_test',
      });
      await Future<void>.delayed(Duration.zero);
      sendCandidate(manager, 'peer:1', 'sm1_test');
      await Future<void>.delayed(Duration.zero);
      expect(manager.pendingCandidatePeerCount, 1);

      await manager.resetSignalingSession();
      expect(manager.pendingCandidatePeerCount, 0);
      await manager.dispose();
    });

    test('leaving the swarm reclaims its pending queues', () async {
      final manager = buildManager();
      await manager.setActiveSwarms({'sm1_test': 'ticket'});
      manager.handleSignalingMessage('media_swarm_join', {
        'from': 'peer:1',
        'media_swarm_id': 'sm1_test',
      });
      await Future<void>.delayed(Duration.zero);
      sendCandidate(manager, 'peer:1', 'sm1_test');
      await Future<void>.delayed(Duration.zero);
      expect(manager.pendingCandidatePeerCount, 1);

      await manager.setActiveSwarms({});
      expect(manager.pendingCandidatePeerCount, 0);
      await manager.dispose();
    });

    test('malformed candidate fields do not escape as zone errors', () async {
      final manager = buildManager();
      await manager.setActiveSwarms({'sm1_test': 'ticket'});
      manager.handleSignalingMessage('media_swarm_join', {
        'from': 'peer:1',
        'media_swarm_id': 'sm1_test',
      });
      await Future<void>.delayed(Duration.zero);
      expect(
        () => sendCandidate(manager, 'peer:1', 'sm1_test', 'not-a-number'),
        returnsNormally,
      );
      manager.handleSignalingMessage('offer', {
        'from': 'peer:1',
        'media_swarm_id': 'sm1_test',
        'sdp': 'v=0',
        'type': 'offer',
        'tie_breaker': 'bogus',
      });
      await Future<void>.delayed(Duration.zero);
      await manager.dispose();
    });
  });
}
