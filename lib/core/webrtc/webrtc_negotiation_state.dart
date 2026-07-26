import 'dart:math';

class WebRtcNegotiationState<K, C> {
  WebRtcNegotiationState({int Function()? nextTieBreaker})
    : _nextTieBreaker = nextTieBreaker ?? _secureTieBreaker;

  final int Function() _nextTieBreaker;
  final Map<K, List<C>> _pendingCandidates = {};
  final Set<K> _remoteDescriptions = {};
  final Map<K, int> _localOfferTieBreakers = {};

  static final Random _random = Random.secure();
  static int _secureTieBreaker() => _random.nextInt(0x100000000);

  int beginLocalOffer(K peer) {
    final value = _nextTieBreaker();
    _localOfferTieBreakers[peer] = value;
    return value;
  }

  bool shouldAcceptRemoteOffer(K peer, int remoteTieBreaker) {
    final local = _localOfferTieBreakers[peer];
    return local == null || local <= remoteTieBreaker;
  }

  bool hasRemoteDescription(K peer) => _remoteDescriptions.contains(peer);

  void markRemoteDescription(K peer, {bool completesLocalOffer = false}) {
    _remoteDescriptions.add(peer);
    if (completesLocalOffer) _localOfferTieBreakers.remove(peer);
  }

  void queueCandidate(K peer, C candidate) {
    _pendingCandidates.putIfAbsent(peer, () => []).add(candidate);
  }

  List<C> takeCandidates(K peer) => _pendingCandidates.remove(peer) ?? const [];

  void restoreCandidates(K peer, Iterable<C> candidates) {
    final values = candidates.toList(growable: false);
    if (values.isNotEmpty) _pendingCandidates[peer] = values;
  }

  void clearPeer(K peer, {bool preserveCandidates = false}) {
    if (!preserveCandidates) _pendingCandidates.remove(peer);
    _remoteDescriptions.remove(peer);
    _localOfferTieBreakers.remove(peer);
  }

  void clear() {
    _pendingCandidates.clear();
    _remoteDescriptions.clear();
    _localOfferTieBreakers.clear();
  }
}
