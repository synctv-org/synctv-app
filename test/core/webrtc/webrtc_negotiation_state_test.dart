import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/webrtc/webrtc_negotiation_state.dart';

void main() {
  test('restored candidate queues accept later arrivals', () {
    final state = WebRtcNegotiationState<String, int>();
    state.restoreCandidates('peer', [1]);
    state.queueCandidate('peer', 2);
    expect(state.takeCandidates('peer'), [1, 2]);
  });

  test('restoration preserves arrivals during peer replacement in order', () {
    final state = WebRtcNegotiationState<String, int>();
    state.queueCandidate('peer', 1);
    final old = state.takeCandidates('peer');
    state.clearPeer('peer');
    state.queueCandidate('peer', 2);
    state.restoreCandidates('peer', old);
    expect(state.takeCandidates('peer'), [1, 2]);
  });

  test(
    'empty restore keeps arrivals and restored input remains independent',
    () {
      final state = WebRtcNegotiationState<String, int>();
      final source = [1];
      state.restoreCandidates('peer', source);
      source.add(99);
      state.restoreCandidates('peer', []);
      expect(state.takeCandidates('peer'), [1]);
    },
  );

  test('higher remote tie breaker wins simultaneous offer negotiation', () {
    final state = WebRtcNegotiationState<String, int>(nextTieBreaker: () => 20);

    expect(state.beginLocalOffer('peer'), 20);
    expect(state.shouldAcceptRemoteOffer('peer', 19), isFalse);
    expect(state.shouldAcceptRemoteOffer('peer', 20), isTrue);
    expect(state.shouldAcceptRemoteOffer('peer', 21), isTrue);
  });

  test('queues candidates until a remote description is installed', () {
    final state = WebRtcNegotiationState<String, int>();
    state.queueCandidate('peer', 1);
    state.queueCandidate('peer', 2);

    expect(state.hasRemoteDescription('peer'), isFalse);
    state.markRemoteDescription('peer');
    expect(state.hasRemoteDescription('peer'), isTrue);
    expect(state.takeCandidates('peer'), [1, 2]);
  });

  test('candidate queue survives a deliberate peer replacement', () {
    final state = WebRtcNegotiationState<String, int>();
    state.queueCandidate('peer', 1);
    final pending = state.takeCandidates('peer');
    state.clearPeer('peer');
    state.restoreCandidates('peer', pending);

    expect(state.takeCandidates('peer'), [1]);
  });

  test('per-peer pending candidates are capped and extras are dropped', () {
    final state = WebRtcNegotiationState<String, int>(
      maxPendingCandidatesPerPeer: 3,
    );
    expect(state.queueCandidate('peer', 1), isTrue);
    expect(state.queueCandidate('peer', 2), isTrue);
    expect(state.queueCandidate('peer', 3), isTrue);
    expect(state.queueCandidate('peer', 4), isFalse);
    expect(state.pendingCandidateCount('peer'), 3);
    expect(state.takeCandidates('peer'), [1, 2, 3]);
  });

  test('pending peer key space is capped', () {
    final state = WebRtcNegotiationState<String, int>(maxPendingPeers: 2);
    expect(state.queueCandidate('a', 1), isTrue);
    expect(state.queueCandidate('b', 1), isTrue);
    expect(state.queueCandidate('c', 1), isFalse);
    expect(state.pendingPeerCount, 2);
    // Draining a peer frees a slot.
    state.takeCandidates('a');
    expect(state.queueCandidate('c', 1), isTrue);
  });

  test('restore trims to the per-peer cap and bypasses the peer cap', () {
    final state = WebRtcNegotiationState<String, int>(
      maxPendingCandidatesPerPeer: 2,
      maxPendingPeers: 1,
    );
    state.queueCandidate('other', 9);
    state.restoreCandidates('peer', [1, 2, 3]);
    expect(state.pendingPeerCount, 2);
    expect(state.takeCandidates('peer'), [1, 2]);
  });

  test('prune drops queues of peers that are no longer live', () {
    final state = WebRtcNegotiationState<String, int>();
    state.queueCandidate('live', 1);
    state.queueCandidate('stale', 1);
    state.prunePendingCandidates((peer) => peer == 'live');
    expect(state.pendingPeerCount, 1);
    expect(state.takeCandidates('stale'), isEmpty);
    expect(state.takeCandidates('live'), [1]);
  });
}
