import 'dart:math';

class WebRtcNegotiationState<K, C> {
  WebRtcNegotiationState({
    int Function()? nextTieBreaker,
    this.maxPendingCandidatesPerPeer = defaultMaxPendingCandidatesPerPeer,
    this.maxPendingPeers = defaultMaxPendingPeers,
  }) : _nextTieBreaker = nextTieBreaker ?? _secureTieBreaker;

  /// Candidates buffered for one peer before its remote description lands.
  /// Trickle ICE yields a few dozen per connection at most; the remainder
  /// comes from peers that never complete an offer and is dropped.
  static const defaultMaxPendingCandidatesPerPeer = 64;

  /// Peers allowed to hold a pending queue at once. Legitimate queues exist
  /// only for the short window between first candidate and remote
  /// description, so this bounds key-space growth from unsolicited senders.
  static const defaultMaxPendingPeers = 128;

  final int maxPendingCandidatesPerPeer;
  final int maxPendingPeers;

  final int Function() _nextTieBreaker;
  final Map<K, List<C>> _pendingCandidates = {};
  final Set<K> _remoteDescriptions = {};
  final Map<K, int> _localOfferTieBreakers = {};

  static final Random _random = Random.secure();
  static int _secureTieBreaker() => _random.nextInt(0x100000000);

  int get pendingPeerCount => _pendingCandidates.length;

  int pendingCandidateCount(K peer) => _pendingCandidates[peer]?.length ?? 0;

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

  /// Returns false when the candidate was dropped by a bound.
  bool queueCandidate(K peer, C candidate) {
    final queue = _pendingCandidates[peer];
    if (queue == null) {
      if (_pendingCandidates.length >= maxPendingPeers) return false;
      _pendingCandidates[peer] = [candidate];
      return true;
    }
    if (queue.length >= maxPendingCandidatesPerPeer) return false;
    queue.add(candidate);
    return true;
  }

  List<C> takeCandidates(K peer) => _pendingCandidates.remove(peer) ?? const [];

  /// Re-queues candidates taken from a peer that is being replaced. The peer
  /// is already admitted, so only the per-peer bound applies.
  void restoreCandidates(K peer, Iterable<C> candidates) {
    final values = candidates.toList();
    if (values.isEmpty) return;
    // New candidates may arrive while the old peer is closing.
    values.addAll(_pendingCandidates[peer] ?? const []);
    if (values.length > maxPendingCandidatesPerPeer) {
      values.removeRange(maxPendingCandidatesPerPeer, values.length);
    }
    _pendingCandidates[peer] = values;
  }

  void clearPeer(K peer, {bool preserveCandidates = false}) {
    if (!preserveCandidates) _pendingCandidates.remove(peer);
    _remoteDescriptions.remove(peer);
    _localOfferTieBreakers.remove(peer);
  }

  /// Drops pending queues for peers that [isLive] rejects — peers that never
  /// obtained a connection and therefore never drain their queue.
  void prunePendingCandidates(bool Function(K peer) isLive) {
    _pendingCandidates.removeWhere((peer, _) => !isLive(peer));
  }

  void clear() {
    _pendingCandidates.clear();
    _remoteDescriptions.clear();
    _localOfferTieBreakers.clear();
  }
}
