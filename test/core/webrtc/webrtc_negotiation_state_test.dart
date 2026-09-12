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
}
