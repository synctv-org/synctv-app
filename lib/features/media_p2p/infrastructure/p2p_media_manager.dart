import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_peer_performance.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_transfer_protocol.dart';
import 'package:synctv_app/core/webrtc/webrtc_negotiation_state.dart';

class P2pMediaManager implements P2pMediaSession {
  P2pMediaManager({
    required this.onSignalingMessage,
    required this.loadIceServers,
    required this.loadCachedPiece,
    required this.onStateChange,
  }) {
    _availabilityPruneTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _prunePieceAvailability(),
    );
    _peerMaintenanceTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => unawaited(_maintainPeers()),
    );
    _swarmAnnounceTimer = Timer.periodic(
      _swarmAnnounceInterval,
      (_) => _announceActiveSwarms(),
    );
  }

  static const int _chunkSize = 16 * 1024;
  static const int _maxPieceBytes = 16 * 1024 * 1024;
  static const int _maxBufferedBytes = 512 * 1024;
  static const Duration _bufferWait = Duration(milliseconds: 10);
  static const Duration _peerDiscoveryTimeout = Duration(milliseconds: 1200);
  static const Duration _latencyProbeInterval = Duration(seconds: 10);
  static const Duration _latencyProbeTimeout = Duration(seconds: 1);
  static const Duration _initialLatencyProbeWait = Duration(milliseconds: 150);
  static const Duration _availabilityQueryTimeout = Duration(milliseconds: 250);
  static const Duration _transferIdleTimeout = Duration(seconds: 2);
  static const Duration _transferCompletionBudget = Duration(minutes: 2);
  static const Duration _availablePieceTtl = Duration(seconds: 30);
  static const Duration _missingPieceTtl = Duration(seconds: 2);
  static const int _maxAvailabilityCandidates = 8;
  static const int _maxTransferCandidates = 3;
  static const int _targetPeersPerSwarm = 12;
  static const int _hardPeersPerSwarm = 20;
  static const int _maxOutgoingPeersPerSwarm = 8;
  static const Duration _peerChurnGracePeriod = Duration(seconds: 15);
  static const Duration _swarmAnnounceInterval = Duration(seconds: 30);
  static const Duration _remoteSwarmTtl = Duration(seconds: 90);
  static const int _maxAvailabilityEntries = 4096;
  static const int _maxConcurrentDownloads = 3;
  static const int _maxConcurrentUploads = 3;

  final P2pMediaSignalingCallback onSignalingMessage;
  final P2pIceServersLoader loadIceServers;
  final P2pCachedPieceLoader loadCachedPiece;
  final VoidCallback onStateChange;
  final Map<_PeerKey, RTCPeerConnection> _peerConnections = {};
  final Map<_PeerKey, RTCDataChannel> _channels = {};
  final WebRtcNegotiationState<_PeerKey, RTCIceCandidate> _negotiation =
      WebRtcNegotiationState();
  final Set<_PeerKey> _outgoingPeers = {};
  final Set<_PeerKey> _connectingPeers = {};
  final Map<_PeerKey, DateTime> _remoteSwarmMemberships = {};
  final Map<_TransferKey, P2pIncomingTransfer> _incomingTransfers = {};
  final Map<_PeerKey, P2pPeerPerformance> _peerPerformance = {};
  final Map<_PeerKey, DateTime> _peerConnectedAt = {};
  final Map<_TransferKey, _LatencyProbe> _latencyProbes = {};
  final Map<_TransferKey, Completer<bool>> _availabilityQueries = {};
  final LinkedHashMap<_PeerPieceKey, _PieceAvailability> _pieceAvailability =
      LinkedHashMap();
  final Map<_TransferKey, _UploadCancellation> _uploadCancellations = {};
  final Set<_PeerKey> _uploadingPeers = {};
  final Set<Future<void>> _uploadTasks = {};
  final Map<_PeerKey, _ControlRateLimit> _controlRateLimits = {};
  final Set<_PeerKey> _integrityBlockedPeers = {};
  final Map<String, String> _activeSwarms = {};
  final Map<String, DateTime> _peerDiscoveryDeadlines = {};
  final Map<String, Completer<void>> _peerDiscoverySignals = {};
  final Random _random = Random.secure();
  List<Map<String, dynamic>>? _iceServers;
  bool _disposed = false;
  int _uploadedBytes = 0;
  final P2pPermitPool _downloadPermits = P2pPermitPool(_maxConcurrentDownloads);
  final P2pPermitPool _uploadPermits = P2pPermitPool(_maxConcurrentUploads);
  final SerialAsyncOperationCoordinator _membershipOperations =
      SerialAsyncOperationCoordinator();
  late final Timer _availabilityPruneTimer;
  late final Timer _peerMaintenanceTimer;
  late final Timer _swarmAnnounceTimer;

  @override
  Set<String> get activeSwarms => Set.unmodifiable(_activeSwarms.keys);
  @override
  int get connectedPeerCount => _channels.values
      .where(
        (channel) => channel.state == RTCDataChannelState.RTCDataChannelOpen,
      )
      .length;
  @override
  int get uploadedBytes => _uploadedBytes;

  @override
  bool hasConnectedPeer(String swarmId) => _channels.entries.any(
    (entry) =>
        entry.key.swarmId == swarmId &&
        entry.value.state == RTCDataChannelState.RTCDataChannelOpen,
  );

  @override
  bool canRequestPeer(String swarmId) {
    if (hasConnectedPeer(swarmId)) return true;
    final deadline = _peerDiscoveryDeadlines[swarmId];
    return deadline != null && deadline.isAfter(DateTime.now());
  }

  @override
  Future<void> setActiveSwarms(Map<String, String> swarms) {
    final next = Map<String, String>.fromEntries(
      swarms.entries.where(
        (entry) => entry.key.isNotEmpty && entry.value.isNotEmpty,
      ),
    );
    return _membershipOperations.run(() => _setActiveSwarms(next));
  }

  Future<void> _setActiveSwarms(Map<String, String> next) async {
    if (_disposed) return;
    final removed = _activeSwarms.keys.toSet().difference(next.keys.toSet());
    final added = next.keys.toSet().difference(_activeSwarms.keys.toSet());
    final changed = next.keys
        .where(
          (swarmId) =>
              _activeSwarms.containsKey(swarmId) &&
              _activeSwarms[swarmId] != next[swarmId],
        )
        .toSet();
    for (final swarmId in removed) {
      _sendSwarmMembership(
        'media_swarm_leave',
        swarmId,
        _activeSwarms[swarmId]!,
      );
    }
    _activeSwarms
      ..clear()
      ..addAll(next);
    for (final swarmId in removed) {
      _finishPeerDiscovery(swarmId);
      _integrityBlockedPeers.removeWhere((peer) => peer.swarmId == swarmId);
    }
    for (final swarmId in added.followedBy(changed)) {
      _startPeerDiscovery(swarmId);
    }
    for (final key
        in _peerConnections.keys
            .where((key) => removed.contains(key.swarmId))
            .toList(growable: false)) {
      await _closePeer(key);
    }
    for (final swarmId in added.followedBy(changed)) {
      _sendSwarmMembership('media_swarm_join', swarmId, next[swarmId]!);
    }
    onStateChange();
  }

  @override
  Future<void> resetSignalingSession() =>
      _membershipOperations.run(_resetSignalingSession);

  Future<void> _resetSignalingSession() async {
    if (_disposed) return;
    for (final key in _peerConnections.keys.toList(growable: false)) {
      await _closePeer(key);
    }
    _remoteSwarmMemberships.clear();
    if (_activeSwarms.isNotEmpty) {
      for (final swarmId in _activeSwarms.keys) {
        _startPeerDiscovery(swarmId);
      }
      _announceActiveSwarms();
    }
  }

  @override
  void handleSignalingMessage(String type, Map<String, dynamic> data) {
    if (_disposed) return;
    if (type == 'media_swarm_peers') {
      unawaited(_handleSwarmPeers(data));
      return;
    }
    final remoteId = data['from']?.toString() ?? '';
    if (remoteId.isEmpty) return;
    switch (type) {
      case 'media_swarm_join':
        unawaited(_handleSwarmJoin(remoteId, data));
      case 'media_swarm_leave':
        unawaited(_handleSwarmLeave(remoteId, data));
      case 'offer':
        unawaited(_handleOffer(remoteId, data));
      case 'answer':
        unawaited(_handleAnswer(remoteId, data));
      case 'candidate':
        unawaited(_handleCandidate(remoteId, data));
    }
  }

  @override
  Future<P2pPeerPiece?> requestPiece(
    String swarmId,
    String pieceKey,
    P2pPieceRequestCancellation cancellation,
  ) async {
    try {
      final acquired = await _downloadPermits.acquire(
        cancelled: cancellation.whenCancelled,
      );
      if (!acquired) return null;
    } on StateError {
      return null;
    }
    try {
      if (cancellation.isCancelled) return null;
      return await _requestPieceWithinSlot(swarmId, pieceKey, cancellation);
    } finally {
      _downloadPermits.release();
    }
  }

  Future<P2pPeerPiece?> _requestPieceWithinSlot(
    String swarmId,
    String pieceKey,
    P2pPieceRequestCancellation cancellation,
  ) async {
    await _waitForPeerDiscovery(swarmId, cancellation);
    if (cancellation.isCancelled) return null;
    final peers = _channels.entries
        .where(
          (entry) =>
              entry.key.swarmId == swarmId &&
              !_integrityBlockedPeers.contains(entry.key) &&
              entry.value.state == RTCDataChannelState.RTCDataChannelOpen,
        )
        .toList(growable: false);
    await Future.any<void>([
      _refreshPeerLatencies(peers),
      cancellation.whenCancelled,
    ]);
    if (cancellation.isCancelled) return null;
    peers.shuffle(_random);
    peers.sort(
      (left, right) => compareP2pPeerPerformance(
        _performanceFor(left.key),
        _performanceFor(right.key),
      ),
    );
    final candidates = await _findPeersWithPiece(
      peers.take(_maxAvailabilityCandidates).toList(growable: false),
      pieceKey,
      cancellation,
    );
    for (final peer in candidates.take(_maxTransferCandidates)) {
      if (cancellation.isCancelled) return null;
      final requestId = _nextRequestId();
      final transferKey = _TransferKey(peer.key, requestId);
      final transfer = P2pIncomingTransfer();
      _incomingTransfers[transferKey] = transfer;
      final stopwatch = Stopwatch()..start();
      final performance = _performanceFor(peer.key)..beginRequest();
      try {
        await peer.value.send(
          RTCDataChannelMessage(
            jsonEncode({'v': 1, 't': 'get', 'r': requestId, 'k': pieceKey}),
          ),
        );
        final bytes = await Future.any<Uint8List?>([
          transfer.wait(
            idleTimeout: _transferIdleTimeout,
            completionBudget: _transferCompletionBudget,
          ),
          cancellation.whenCancelled.then((_) => null),
        ]);
        if (cancellation.isCancelled) {
          await _sendControl(peer.value, {
            'v': 1,
            't': 'cancel',
            'r': requestId,
          });
          return null;
        }
        if (bytes != null) {
          _recordPieceAvailability(peer.key, pieceKey, true);
          performance.recordSuccess(bytes.length, stopwatch.elapsed);
          return P2pPeerPiece(
            bytes: bytes,
            source: P2pPeerSource(
              peerId: peer.key.remoteId,
              swarmId: peer.key.swarmId,
            ),
          );
        }
        _recordPieceAvailability(peer.key, pieceKey, false);
      } on TimeoutException {
        performance.recordFailure();
        await _sendControl(peer.value, {'v': 1, 't': 'cancel', 'r': requestId});
      } catch (error) {
        performance.recordFailure();
        debugPrint('P2P media piece request failed: $error');
      } finally {
        performance.endRequest();
        _incomingTransfers.remove(transferKey);
      }
    }
    return null;
  }

  @override
  Future<void> reportPeerIntegrity(P2pPeerSource source, bool valid) async {
    if (_disposed || valid) return;
    final peer = _PeerKey(source.peerId, source.swarmId);
    _integrityBlockedPeers.add(peer);
    await _closePeer(peer);
  }

  Future<void> _handleSwarmJoin(
    String remoteId,
    Map<String, dynamic> data,
  ) async {
    final swarmId = data['media_swarm_id']?.toString() ?? '';
    if (!_activeSwarms.containsKey(swarmId)) return;
    final key = _PeerKey(remoteId, swarmId);
    if (_integrityBlockedPeers.contains(key)) return;
    final isKnownPeer = _remoteSwarmMemberships.containsKey(key);
    if (!isKnownPeer &&
        _remoteSwarmMembershipCount(swarmId) >= _hardPeersPerSwarm) {
      return;
    }
    _remoteSwarmMemberships[key] = DateTime.now().add(_remoteSwarmTtl);
    await _connectRemoteSwarm(key);
  }

  Future<void> _handleSwarmLeave(
    String remoteId,
    Map<String, dynamic> data,
  ) async {
    final swarmId = data['media_swarm_id']?.toString() ?? '';
    if (swarmId.isEmpty) return;
    final key = _PeerKey(remoteId, swarmId);
    _remoteSwarmMemberships.remove(key);
    await _closePeer(key);
  }

  Future<void> _handleSwarmPeers(Map<String, dynamic> data) async {
    final swarmId = data['media_swarm_id']?.toString() ?? '';
    if (!_activeSwarms.containsKey(swarmId)) return;
    final renewedTicket = data['media_swarm_ticket']?.toString() ?? '';
    if (renewedTicket.isNotEmpty) {
      _activeSwarms[swarmId] = renewedTicket;
    }
    final peers = data['peers'];
    if (peers is! List) return;
    for (final value in peers) {
      if (value is! Map) continue;
      final userId = value['user_id']?.toString() ?? '';
      final connectionId = value['conn_id']?.toString() ?? '';
      if (userId.isEmpty || connectionId.isEmpty) continue;
      await _handleSwarmJoin('$userId:$connectionId', {
        'media_swarm_id': swarmId,
      });
    }
  }

  Future<void> _connectRemoteSwarm(_PeerKey key) async {
    if (_integrityBlockedPeers.contains(key) ||
        !_activeSwarms.containsKey(key.swarmId) ||
        _peerConnections.containsKey(key) ||
        _connectingPeers.contains(key)) {
      return;
    }
    final existing = _peerCountForSwarm(key.swarmId);
    if (existing >= _targetPeersPerSwarm ||
        _outgoingPeerCountForSwarm(key.swarmId) >= _maxOutgoingPeersPerSwarm) {
      return;
    }
    if (!_connectingPeers.add(key)) return;
    _outgoingPeers.add(key);
    RTCPeerConnection? pc;
    try {
      pc = await _createPeerConnection(key);
      if (!identical(_peerConnections[key], pc)) return;
      final tieBreaker = _negotiation.beginLocalOffer(key);
      final channel = await pc.createDataChannel(
        'synctv-media-v1',
        RTCDataChannelInit()..ordered = true,
      );
      if (!identical(_peerConnections[key], pc)) {
        await channel.close();
        return;
      }
      _registerChannel(key, channel);
      final offer = await pc.createOffer();
      if (!identical(_peerConnections[key], pc)) return;
      await pc.setLocalDescription(offer);
      if (!identical(_peerConnections[key], pc)) return;
      _signal('offer', key, {
        'sdp': offer.sdp,
        'type': offer.type,
        'tie_breaker': tieBreaker,
      });
    } catch (error) {
      debugPrint('P2P media swarm negotiation failed: $error');
      if (pc == null || identical(_peerConnections[key], pc)) {
        await _closePeer(key);
      }
    } finally {
      _connectingPeers.remove(key);
    }
  }

  Future<void> _maintainPeers() async {
    if (_disposed) return;
    final unhealthy = _peerPerformance.entries
        .where(
          (entry) =>
              entry.value.consecutiveFailures >= 3 &&
              entry.value.inFlightRequests == 0,
        )
        .map((entry) => entry.key)
        .toList(growable: false);
    for (final peer in unhealthy) {
      await _closePeer(peer);
    }
    final now = DateTime.now();
    for (final swarmId in _activeSwarms.keys) {
      final peers = _peerConnections.keys
          .where((key) => key.swarmId == swarmId)
          .toList(growable: true);
      if (peers.length <= _targetPeersPerSwarm) continue;
      final removable =
          peers
              .where(
                (key) =>
                    now.difference(_peerConnectedAt[key] ?? now) >=
                        _peerChurnGracePeriod &&
                    (_peerPerformance[key]?.inFlightRequests ?? 0) == 0,
              )
              .toList(growable: true)
            ..sort(
              (left, right) => compareP2pPeerPerformance(
                _performanceFor(right),
                _performanceFor(left),
              ),
            );
      final excess = peers.length - _targetPeersPerSwarm;
      for (final peer in removable.take(excess)) {
        await _closePeer(peer);
      }
    }
    final expired = _remoteSwarmMemberships.entries
        .where((entry) => !entry.value.isAfter(now))
        .map((entry) => entry.key)
        .toList(growable: false);
    for (final key in expired) {
      _remoteSwarmMemberships.remove(key);
    }
    for (final key in _remoteSwarmMemberships.keys.toList(growable: false)) {
      await _connectRemoteSwarm(key);
    }
  }

  Future<void> _handleOffer(String remoteId, Map<String, dynamic> data) async {
    final swarmId = data['media_swarm_id']?.toString() ?? '';
    if (!_activeSwarms.containsKey(swarmId)) return;
    final key = _PeerKey(remoteId, swarmId);
    if (_integrityBlockedPeers.contains(key)) return;
    if (!_peerConnections.containsKey(key) &&
        _peerCountForSwarm(swarmId) >= _hardPeersPerSwarm) {
      return;
    }
    final incomingTieBreaker = data['tie_breaker'] as int? ?? 0;
    if (!_negotiation.shouldAcceptRemoteOffer(key, incomingTieBreaker)) {
      return;
    }
    if (!_connectingPeers.add(key)) return;
    try {
      final pendingCandidates = _negotiation.takeCandidates(key);
      await _closePeer(key);
      _negotiation.restoreCandidates(key, pendingCandidates);
      final pc = await _createPeerConnection(key);
      await pc.setRemoteDescription(
        RTCSessionDescription(
          data['sdp']?.toString(),
          data['type']?.toString(),
        ),
      );
      _negotiation.markRemoteDescription(key);
      final answer = await pc.createAnswer();
      await pc.setLocalDescription(answer);
      _signal('answer', key, {'sdp': answer.sdp, 'type': answer.type});
      await _flushCandidates(key, pc);
    } catch (error) {
      debugPrint('P2P media offer failed: $error');
      await _closePeer(key);
    } finally {
      _connectingPeers.remove(key);
    }
  }

  Future<void> _handleAnswer(String remoteId, Map<String, dynamic> data) async {
    final key = _PeerKey(remoteId, data['media_swarm_id']?.toString() ?? '');
    if (_integrityBlockedPeers.contains(key)) return;
    final pc = _peerConnections[key];
    if (pc == null) return;
    try {
      await pc.setRemoteDescription(
        RTCSessionDescription(
          data['sdp']?.toString(),
          data['type']?.toString(),
        ),
      );
      _negotiation.markRemoteDescription(key, completesLocalOffer: true);
      await _flushCandidates(key, pc);
    } catch (error) {
      debugPrint('P2P media answer failed: $error');
    }
  }

  Future<void> _handleCandidate(
    String remoteId,
    Map<String, dynamic> data,
  ) async {
    final key = _PeerKey(remoteId, data['media_swarm_id']?.toString() ?? '');
    if (_integrityBlockedPeers.contains(key) ||
        !_activeSwarms.containsKey(key.swarmId)) {
      return;
    }
    final candidate = RTCIceCandidate(
      data['candidate']?.toString(),
      data['sdpMid']?.toString(),
      data['sdpMLineIndex'] as int?,
    );
    final pc = _peerConnections[key];
    if (pc == null || !_negotiation.hasRemoteDescription(key)) {
      _negotiation.queueCandidate(key, candidate);
      return;
    }
    try {
      await pc.addCandidate(candidate);
    } catch (error) {
      debugPrint('P2P media ICE candidate failed: $error');
    }
  }

  Future<RTCPeerConnection> _createPeerConnection(_PeerKey key) async {
    final pc = await createPeerConnection({
      'iceServers': await _loadIceServerConfiguration(),
    });
    if (_disposed || !_activeSwarms.containsKey(key.swarmId)) {
      await pc.close();
      throw StateError('P2P media peer creation was superseded');
    }
    _peerConnections[key] = pc;
    _peerConnectedAt[key] = DateTime.now();
    pc.onIceCandidate = (candidate) {
      if (!identical(_peerConnections[key], pc)) return;
      _signal('candidate', key, {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };
    pc.onDataChannel = (channel) {
      if (identical(_peerConnections[key], pc)) {
        _registerChannel(key, channel);
      } else {
        unawaited(channel.close());
      }
    };
    pc.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        if (identical(_peerConnections[key], pc)) {
          unawaited(_closePeer(key));
        }
      }
      onStateChange();
    };
    return pc;
  }

  void _registerChannel(_PeerKey key, RTCDataChannel channel) {
    if (_integrityBlockedPeers.contains(key)) {
      unawaited(channel.close());
      return;
    }
    final previous = _channels[key];
    if (previous != null && !identical(previous, channel)) {
      unawaited(previous.close());
    }
    _channels[key] = channel;
    channel.bufferedAmountLowThreshold = _maxBufferedBytes ~/ 2;
    channel.onDataChannelState = (_) {
      if (channel.state == RTCDataChannelState.RTCDataChannelOpen) {
        _finishPeerDiscovery(key.swarmId);
        unawaited(_ensureLatencyProbe(key, channel));
      }
      onStateChange();
    };
    channel.onMessage = (message) {
      if (message.isBinary) {
        _handleBinary(key, message.binary);
      } else {
        unawaited(_handleControl(key, channel, message.text));
      }
    };
    if (channel.state == RTCDataChannelState.RTCDataChannelOpen) {
      _finishPeerDiscovery(key.swarmId);
      unawaited(_ensureLatencyProbe(key, channel));
    }
    onStateChange();
  }

  void _startPeerDiscovery(String swarmId) {
    _finishPeerDiscovery(swarmId);
    _peerDiscoveryDeadlines[swarmId] = DateTime.now().add(
      _peerDiscoveryTimeout,
    );
    _peerDiscoverySignals[swarmId] = Completer<void>();
  }

  void _finishPeerDiscovery(String swarmId) {
    _peerDiscoveryDeadlines.remove(swarmId);
    final signal = _peerDiscoverySignals.remove(swarmId);
    if (signal != null && !signal.isCompleted) signal.complete();
  }

  Future<void> _waitForPeerDiscovery(
    String swarmId,
    P2pPieceRequestCancellation cancellation,
  ) async {
    if (hasConnectedPeer(swarmId)) {
      _finishPeerDiscovery(swarmId);
      return;
    }
    final deadline = _peerDiscoveryDeadlines[swarmId];
    final signal = _peerDiscoverySignals[swarmId];
    if (deadline == null || signal == null) return;
    final remaining = deadline.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      _finishPeerDiscovery(swarmId);
      return;
    }
    await Future.any<void>([
      signal.future.timeout(remaining, onTimeout: () {}),
      cancellation.whenCancelled,
    ]);
    if (DateTime.now().isAfter(deadline)) _finishPeerDiscovery(swarmId);
  }

  Future<void> _handleControl(
    _PeerKey peer,
    RTCDataChannel channel,
    String text,
  ) async {
    if (_disposed) return;
    Object? decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException {
      return;
    }
    if (decoded is! Map) return;
    final type = decoded['t'];
    final requestId = decoded['r'];
    if (requestId is! int) return;
    final transferKey = _TransferKey(peer, requestId);
    if (type == 'cancel') {
      _uploadCancellations[transferKey]?.cancel();
      return;
    }
    if (!_controlRateLimits.putIfAbsent(peer, _ControlRateLimit.new).allow()) {
      return;
    }
    if (type == 'probe') {
      await _sendControl(channel, {'v': 1, 't': 'probe_ack', 'r': requestId});
      return;
    }
    if (type == 'probe_ack') {
      _latencyProbes[transferKey]?.complete();
      return;
    }
    if (type == 'has') {
      final pieceKey = decoded['k']?.toString() ?? '';
      final available =
          pieceKey.isNotEmpty &&
          await loadCachedPiece(peer.swarmId, pieceKey) != null;
      await _sendControl(channel, {
        'v': 1,
        't': 'has_result',
        'r': requestId,
        'a': available,
      });
      return;
    }
    if (type == 'has_result') {
      final query = _availabilityQueries[transferKey];
      if (query != null && !query.isCompleted) {
        query.complete(decoded['a'] == true);
      }
      return;
    }
    if (type == 'get') {
      final pieceKey = decoded['k']?.toString() ?? '';
      _startUpload(peer, channel, requestId, pieceKey);
      return;
    }
    final transfer = _incomingTransfers[transferKey];
    if (transfer == null) return;
    switch (type) {
      case 'begin':
        final expectedLength = decoded['n'] as int?;
        if (expectedLength == null ||
            expectedLength < 0 ||
            expectedLength > _maxPieceBytes) {
          transfer.completeInvalid();
          return;
        }
        transfer.begin(expectedLength);
      case 'end':
        transfer.complete();
      case 'missing':
        transfer.completeMissing();
      case 'busy':
        transfer.completeMissing();
    }
  }

  Future<void> _serveUpload(
    _PeerKey peer,
    RTCDataChannel channel,
    int requestId,
    String pieceKey,
  ) async {
    if (_uploadingPeers.contains(peer)) {
      await _sendControl(channel, {'v': 1, 't': 'busy', 'r': requestId});
      return;
    }
    final transferKey = _TransferKey(peer, requestId);
    final cancellation = _UploadCancellation();
    _uploadingPeers.add(peer);
    _uploadCancellations[transferKey] = cancellation;
    var acquired = false;
    try {
      await _uploadPermits.acquire();
      acquired = true;
      if (_disposed || cancellation.isCancelled) return;
      final bytes = await loadCachedPiece(peer.swarmId, pieceKey);
      if (cancellation.isCancelled) return;
      if (bytes == null || bytes.length > _maxPieceBytes) {
        await _sendControl(channel, {'v': 1, 't': 'missing', 'r': requestId});
        return;
      }
      await _upload(channel, requestId, bytes, cancellation);
    } finally {
      _uploadCancellations.remove(transferKey);
      _uploadingPeers.remove(peer);
      if (acquired) _uploadPermits.release();
    }
  }

  void _startUpload(
    _PeerKey peer,
    RTCDataChannel channel,
    int requestId,
    String pieceKey,
  ) {
    if (_disposed) return;
    late final Future<void> task;
    task = _runUpload(
      peer,
      channel,
      requestId,
      pieceKey,
    ).whenComplete(() => _uploadTasks.remove(task));
    _uploadTasks.add(task);
  }

  Future<void> _runUpload(
    _PeerKey peer,
    RTCDataChannel channel,
    int requestId,
    String pieceKey,
  ) async {
    try {
      await _serveUpload(peer, channel, requestId, pieceKey);
    } catch (error, stackTrace) {
      if (!_disposed) {
        debugPrint('P2P media upload failed: $error\n$stackTrace');
      }
    }
  }

  void _handleBinary(_PeerKey peer, Uint8List message) {
    if (message.length < 4) return;
    final requestId = ByteData.sublistView(message, 0, 4).getUint32(0);
    final transfer = _incomingTransfers[_TransferKey(peer, requestId)];
    transfer?.add(Uint8List.sublistView(message, 4), _maxPieceBytes);
  }

  Future<void> _upload(
    RTCDataChannel channel,
    int requestId,
    Uint8List bytes,
    _UploadCancellation cancellation,
  ) async {
    await _sendControl(channel, {
      'v': 1,
      't': 'begin',
      'r': requestId,
      'n': bytes.length,
    });
    for (var offset = 0; offset < bytes.length; offset += _chunkSize) {
      if (cancellation.isCancelled) return;
      while ((channel.bufferedAmount ?? 0) > _maxBufferedBytes) {
        await Future<void>.delayed(_bufferWait);
        if (cancellation.isCancelled ||
            channel.state != RTCDataChannelState.RTCDataChannelOpen) {
          return;
        }
      }
      final end = min(offset + _chunkSize, bytes.length);
      final message = Uint8List(4 + end - offset);
      ByteData.sublistView(message, 0, 4).setUint32(0, requestId);
      message.setRange(4, message.length, bytes, offset);
      await channel.send(RTCDataChannelMessage.fromBinary(message));
      _uploadedBytes += end - offset;
    }
    if (!cancellation.isCancelled) {
      await _sendControl(channel, {'v': 1, 't': 'end', 'r': requestId});
    }
    onStateChange();
  }

  Future<void> _sendControl(RTCDataChannel channel, Map<String, Object> value) {
    return channel.send(RTCDataChannelMessage(jsonEncode(value)));
  }

  Future<List<Map<String, dynamic>>> _loadIceServerConfiguration() async {
    final cached = _iceServers;
    if (cached != null) return cached;
    final servers = (await loadIceServers())
        .where((server) => server.urls.isNotEmpty)
        .map(
          (server) => <String, dynamic>{
            'urls': server.urls,
            if (server.username.isNotEmpty) 'username': server.username,
            if (server.credential.isNotEmpty) 'credential': server.credential,
          },
        )
        .toList(growable: false);
    _iceServers = servers;
    return servers;
  }

  Future<void> _flushCandidates(_PeerKey key, RTCPeerConnection pc) async {
    final candidates = _negotiation.takeCandidates(key);
    for (final candidate in candidates) {
      await pc.addCandidate(candidate);
    }
  }

  Future<void> _closePeer(_PeerKey key) async {
    final channel = _channels.remove(key);
    await channel?.close();
    final pc = _peerConnections.remove(key);
    await pc?.close();
    _negotiation.clearPeer(key);
    _outgoingPeers.remove(key);
    _peerPerformance.remove(key);
    _peerConnectedAt.remove(key);
    _controlRateLimits.remove(key);
    _pieceAvailability.removeWhere((piece, _) => piece.peer == key);
    for (final probeKey
        in _latencyProbes.keys
            .where((probeKey) => probeKey.peer == key)
            .toList(growable: false)) {
      _latencyProbes.remove(probeKey)?.complete();
    }
    for (final queryKey
        in _availabilityQueries.keys
            .where((queryKey) => queryKey.peer == key)
            .toList(growable: false)) {
      final query = _availabilityQueries.remove(queryKey);
      if (query != null && !query.isCompleted) query.complete(false);
    }
    for (final transferKey
        in _incomingTransfers.keys
            .where((transferKey) => transferKey.peer == key)
            .toList(growable: false)) {
      _incomingTransfers.remove(transferKey)?.completeMissing();
    }
    onStateChange();
  }

  void _signal(String type, _PeerKey key, Map<String, dynamic> payload) {
    onSignalingMessage(type, {
      ...payload,
      'to': key.remoteId,
      'media_swarm_id': key.swarmId,
    });
  }

  void _announceActiveSwarms() {
    if (_disposed) return;
    for (final entry in _activeSwarms.entries) {
      _sendSwarmMembership('media_swarm_join', entry.key, entry.value);
    }
  }

  void _sendSwarmMembership(String type, String swarmId, String ticket) {
    onSignalingMessage(type, {
      'media_swarm_id': swarmId,
      'media_swarm_ticket': ticket,
    });
  }

  int _nextRequestId() => _random.nextInt(0x7fffffff) + 1;

  P2pPeerPerformance _performanceFor(_PeerKey key) =>
      _peerPerformance.putIfAbsent(key, P2pPeerPerformance.new);

  Future<void> _refreshPeerLatencies(
    List<MapEntry<_PeerKey, RTCDataChannel>> peers,
  ) async {
    if (peers.isEmpty) return;
    final probes = peers
        .map((peer) => _ensureLatencyProbe(peer.key, peer.value))
        .toList(growable: false);
    await Future.wait(probes)
        .timeout(_initialLatencyProbeWait, onTimeout: () => const <void>[]);
  }

  Future<void> _ensureLatencyProbe(_PeerKey key, RTCDataChannel channel) async {
    if (channel.state != RTCDataChannelState.RTCDataChannelOpen) return;
    final existing = _latencyProbes.entries
        .where((entry) => entry.key.peer == key)
        .firstOrNull;
    if (existing != null) {
      await existing.value.completer.future;
      return;
    }
    final performance = _performanceFor(key);
    final now = DateTime.now();
    if (!performance.shouldProbe(now, _latencyProbeInterval)) return;
    performance.markProbeStarted(now);
    final requestId = _nextRequestId();
    final probeKey = _TransferKey(key, requestId);
    final probe = _LatencyProbe();
    _latencyProbes[probeKey] = probe;
    try {
      await _sendControl(channel, {'v': 1, 't': 'probe', 'r': requestId});
      await probe.completer.future.timeout(_latencyProbeTimeout);
      performance.recordRoundTrip(probe.stopwatch.elapsed);
    } on TimeoutException {
      // A media request can still succeed when a best-effort probe is lost.
    } catch (error) {
      debugPrint('P2P media latency probe failed: $error');
    } finally {
      _latencyProbes.remove(probeKey);
    }
  }

  Future<List<MapEntry<_PeerKey, RTCDataChannel>>> _findPeersWithPiece(
    List<MapEntry<_PeerKey, RTCDataChannel>> peers,
    String pieceKey,
    P2pPieceRequestCancellation cancellation,
  ) async {
    final results = await Future.wait(
      peers.map((peer) async {
        final available = await _queryPieceAvailability(
          peer.key,
          peer.value,
          pieceKey,
          cancellation,
        );
        return (peer: peer, available: available);
      }),
    );
    final available = results
        .where((result) => result.available == true)
        .map((result) => result.peer)
        .toList(growable: true);
    final unknown = results
        .where((result) => result.available == null)
        .map((result) => result.peer);
    available.addAll(unknown);
    return available;
  }

  Future<bool?> _queryPieceAvailability(
    _PeerKey peer,
    RTCDataChannel channel,
    String pieceKey,
    P2pPieceRequestCancellation cancellation,
  ) async {
    if (cancellation.isCancelled) return false;
    final cacheKey = _PeerPieceKey(peer, pieceKey);
    final cached = _pieceAvailability[cacheKey];
    if (cached != null && !cached.isExpired) {
      _pieceAvailability
        ..remove(cacheKey)
        ..[cacheKey] = cached;
      return cached.available;
    }
    _pieceAvailability.remove(cacheKey);

    final requestId = _nextRequestId();
    final queryKey = _TransferKey(peer, requestId);
    final completer = Completer<bool>();
    _availabilityQueries[queryKey] = completer;
    try {
      await _sendControl(channel, {
        'v': 1,
        't': 'has',
        'r': requestId,
        'k': pieceKey,
      });
      final available = await Future.any<bool?>([
        completer.future.timeout(_availabilityQueryTimeout),
        cancellation.whenCancelled.then((_) => null),
      ]);
      if (available == null) return null;
      _recordPieceAvailability(peer, pieceKey, available);
      return available;
    } on TimeoutException {
      return null;
    } catch (error) {
      debugPrint('P2P media availability query failed: $error');
      return null;
    } finally {
      _availabilityQueries.remove(queryKey);
    }
  }

  void _recordPieceAvailability(
    _PeerKey peer,
    String pieceKey,
    bool available,
  ) {
    final key = _PeerPieceKey(peer, pieceKey);
    _pieceAvailability.remove(key);
    _pieceAvailability[key] = _PieceAvailability(
      available,
      DateTime.now().add(available ? _availablePieceTtl : _missingPieceTtl),
    );
    _prunePieceAvailability();
  }

  int _peerCountForSwarm(String swarmId) {
    final peers = _peerConnections.keys
        .where((key) => key.swarmId == swarmId)
        .toSet();
    peers.addAll(_connectingPeers.where((key) => key.swarmId == swarmId));
    return peers.length;
  }

  int _remoteSwarmMembershipCount(String swarmId) => _remoteSwarmMemberships
      .keys
      .where((key) => key.swarmId == swarmId)
      .length;

  int _outgoingPeerCountForSwarm(String swarmId) =>
      _outgoingPeers.where((key) => key.swarmId == swarmId).length;

  void _prunePieceAvailability() {
    _pieceAvailability.removeWhere((_, value) => value.isExpired);
    while (_pieceAvailability.length > _maxAvailabilityEntries) {
      _pieceAvailability.remove(_pieceAvailability.keys.first);
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _membershipOperations.run(() async {});
    for (final entry in _activeSwarms.entries) {
      _sendSwarmMembership('media_swarm_leave', entry.key, entry.value);
    }
    _availabilityPruneTimer.cancel();
    _peerMaintenanceTimer.cancel();
    _swarmAnnounceTimer.cancel();
    _downloadPermits.close();
    _uploadPermits.close();
    for (final cancellation in _uploadCancellations.values) {
      cancellation.cancel();
    }
    _activeSwarms.clear();
    for (final swarmId in _peerDiscoverySignals.keys.toList(growable: false)) {
      _finishPeerDiscovery(swarmId);
    }
    for (final key in _peerConnections.keys.toList(growable: false)) {
      await _closePeer(key);
    }
    await Future.wait(_uploadTasks.toList(growable: false));
    _remoteSwarmMemberships.clear();
    _negotiation.clear();
    _integrityBlockedPeers.clear();
    _incomingTransfers.clear();
  }
}

@immutable
class _PeerKey {
  const _PeerKey(this.remoteId, this.swarmId);

  final String remoteId;
  final String swarmId;

  @override
  bool operator ==(Object other) =>
      other is _PeerKey &&
      other.remoteId == remoteId &&
      other.swarmId == swarmId;

  @override
  int get hashCode => Object.hash(remoteId, swarmId);
}

@immutable
class _TransferKey {
  const _TransferKey(this.peer, this.requestId);

  final _PeerKey peer;
  final int requestId;

  @override
  bool operator ==(Object other) =>
      other is _TransferKey &&
      other.peer == peer &&
      other.requestId == requestId;

  @override
  int get hashCode => Object.hash(peer, requestId);
}

@immutable
class _PeerPieceKey {
  const _PeerPieceKey(this.peer, this.pieceKey);

  final _PeerKey peer;
  final String pieceKey;

  @override
  bool operator ==(Object other) =>
      other is _PeerPieceKey &&
      other.peer == peer &&
      other.pieceKey == pieceKey;

  @override
  int get hashCode => Object.hash(peer, pieceKey);
}

class _PieceAvailability {
  const _PieceAvailability(this.available, this.expiresAt);

  final bool available;
  final DateTime expiresAt;

  bool get isExpired => !expiresAt.isAfter(DateTime.now());
}

class _UploadCancellation {
  bool isCancelled = false;

  void cancel() => isCancelled = true;
}

class _ControlRateLimit {
  static const int _capacity = 120;
  static const Duration _window = Duration(seconds: 10);

  DateTime _windowStartedAt = DateTime.now();
  int _used = 0;

  bool allow() {
    final now = DateTime.now();
    if (now.difference(_windowStartedAt) >= _window) {
      _windowStartedAt = now;
      _used = 0;
    }
    if (_used >= _capacity) return false;
    _used++;
    return true;
  }
}

class _LatencyProbe {
  final Completer<void> completer = Completer<void>();
  final Stopwatch stopwatch = Stopwatch()..start();

  void complete() {
    if (!completer.isCompleted) completer.complete();
  }
}
