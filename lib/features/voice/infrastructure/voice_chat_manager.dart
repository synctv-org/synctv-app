import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/features/voice/application/voice_chat_session.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_audio_session.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_microphone.dart';
import 'package:synctv_app/core/webrtc/webrtc_negotiation_state.dart';

final class NativeVoiceChatSessionFactory implements VoiceChatSessionFactory {
  const NativeVoiceChatSessionFactory();

  @override
  VoiceChatSession create({
    required VoiceSignalingCallback onSignalingMessage,
    required VoiceIceServersLoader loadIceServers,
    required void Function() onStateChange,
  }) {
    return VoiceChatManager(
      onSignalingMessage: onSignalingMessage,
      loadIceServers: loadIceServers,
      onStateChange: onStateChange,
    );
  }
}

class VoiceChatManager implements VoiceChatSession {
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, Object> _peerOperations = {};
  final Future<RTCPeerConnection> Function(Map<String, dynamic>)
  _createConnection;
  final WebRtcNegotiationState<String, RTCIceCandidate> _negotiation =
      WebRtcNegotiationState();
  MediaStream? _localStream;
  final Set<String> _connectedPeers = {};
  final VoiceSignalingCallback onSignalingMessage;
  final VoidCallback onStateChange;
  final VoiceIceServersLoader loadIceServers;
  List<Map<String, dynamic>>? _iceServers;

  bool _isConnected = false;
  String? _joinOperationId;
  int _generation = 0;
  bool _disposed = false;
  Future<void>? _joining;
  Future<void>? _leaving;
  final Future<MediaStream> Function() _acquireMicrophone;
  final Future<void> Function(bool) _configureVoiceCallMode;
  final Future<void> Function(bool) _configureSpeakerphone;
  Future<void> _audioRouting = Future<void>.value();
  @override
  bool get isConnected => _isConnected;
  @override
  bool get hasPeersConnected => _connectedPeers.isNotEmpty;
  @override
  int get participantCount => _connectedPeers.length + (_isConnected ? 1 : 0);

  VoiceChatManager({
    required this.onSignalingMessage,
    required this.onStateChange,
    required this.loadIceServers,
    Future<MediaStream> Function()? acquireMicrophone,
    Future<RTCPeerConnection> Function(Map<String, dynamic>)? createConnection,
    Future<void> Function(bool)? configureVoiceCallMode,
    Future<void> Function(bool)? configureSpeakerphone,
  }) : _acquireMicrophone = acquireMicrophone ?? acquireVoiceMicrophone,
       _configureVoiceCallMode =
           configureVoiceCallMode ?? VoiceAudioSession.setVoiceCallMode,
       _configureSpeakerphone =
           configureSpeakerphone ?? _configurePlatformSpeakerphone,
       _createConnection = createConnection ?? createPeerConnection;

  static Future<void> _configurePlatformSpeakerphone(bool enabled) async {
    // The WebRTC helper uses native method channels, including on web.
    if (kIsWeb) return;
    await Helper.setSpeakerphoneOn(enabled);
  }

  @override
  void handleSignalingMessage(String type, Map<String, dynamic> data) {
    if (_disposed || (!_isConnected && _joinOperationId == null)) return;
    final fromId = data['from'];
    if (fromId is! String || fromId.trim().isEmpty) return;

    switch (type) {
      case 'join':
        handleJoin(fromId);
        break;
      case 'offer':
        handleOffer(fromId, data);
        break;
      case 'answer':
        handleAnswer(fromId, data);
        break;
      case 'candidate':
        handleCandidate(fromId, data);
        break;
      case 'leave':
        handleLeave(fromId);
        break;
    }
  }

  @visibleForTesting
  Future<List<Map<String, dynamic>>> loadIceServerConfigurationForTest() {
    return _loadIceServerConfiguration();
  }

  @override
  Future<void> join({required String clientOperationId}) {
    if (_disposed) return Future.error(StateError('Voice session is disposed'));
    if (_isConnected) return Future.value();
    final pending = _joining;
    if (pending != null) return pending;
    final generation = _generation;
    late final Future<void> operation;
    operation = _join(clientOperationId, generation).whenComplete(() {
      if (identical(_joining, operation)) _joining = null;
    });
    return _joining = operation;
  }

  bool _isCurrentJoin(int generation) =>
      !_disposed && generation == _generation;

  Future<void> _join(String clientOperationId, int generation) async {
    await _leaving;
    if (!_isCurrentJoin(generation)) return;

    // Validate signaling prerequisites before acquiring the microphone or
    // creating server-side voice presence. A failed bootstrap can then
    // leave no partially joined session behind.
    await _loadIceServerConfiguration();
    if (!_isCurrentJoin(generation)) return;

    try {
      await VoiceAudioSession.stopPlaying();
      if (!_isCurrentJoin(generation)) return;

      await _setVoiceCallMode(true);
      if (!_isCurrentJoin(generation)) return;

      final stream = await _acquireMicrophone();
      if (!_isCurrentJoin(generation)) {
        await releaseVoiceMicrophone(stream);
        return;
      }
      _localStream = stream;

      await _setSpeakerphoneOn(true);
      if (!_isCurrentJoin(generation)) return;

      _joinOperationId = clientOperationId;
      onSignalingMessage('join', {'client_operation_id': clientOperationId});
      if (!_isCurrentJoin(generation)) return;

      _isConnected = true;
      onStateChange();
    } catch (e) {
      if (!_isCurrentJoin(generation)) return;
      debugPrint('WebRTC Join Error: $e');
      try {
        await leave();
      } catch (_) {
        debugPrint('Failed to clean up after voice join failure');
      }
      rethrow;
    }
  }

  bool _ownsPeer(String remoteId, RTCPeerConnection pc) =>
      !_disposed && identical(_peerConnections[remoteId], pc);

  Future<RTCPeerConnection?> _createPeerConnection(
    String remoteId,
    Object operation,
  ) async {
    final configuration = {'iceServers': await _loadIceServerConfiguration()};
    if (!identical(_peerOperations[remoteId], operation)) return null;

    final pc = await _createConnection(configuration);
    if (!identical(_peerOperations[remoteId], operation)) {
      await pc.close();
      return null;
    }
    _peerConnections[remoteId] = pc;

    final stream = _localStream;
    try {
      if (stream != null) {
        for (final track in stream.getTracks()) {
          await pc.addTrack(track, stream);
          if (!_ownsPeer(remoteId, pc)) return null;
        }
      }
    } catch (_) {
      await _closeFailedPeer(remoteId, pc);
      rethrow;
    }

    pc.onIceCandidate = (candidate) {
      if (!_ownsPeer(remoteId, pc)) return;
      onSignalingMessage('candidate', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'to': remoteId,
      });
    };

    pc.onConnectionState = (state) {
      if (!_ownsPeer(remoteId, pc)) return;
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        debugPrint('WebRTC Peer Connected: $remoteId');
        _connectedPeers.add(remoteId);
        onStateChange();
      } else if (state ==
              RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        _connectedPeers.remove(remoteId);
        onStateChange();
      }
    };

    pc.onTrack = (event) {
      if (!_ownsPeer(remoteId, pc)) return;
      if (event.track.kind == 'audio') {
        event.track.enabled = true;
        unawaited(_setSpeakerphoneOn(true));
      }
    };

    return pc;
  }

  Future<List<Map<String, dynamic>>> _loadIceServerConfiguration() async {
    final cached = _iceServers;
    if (cached != null) return cached;

    final mapped = (await loadIceServers())
        .where((server) => server.urls.isNotEmpty)
        .map((server) {
          final entry = <String, dynamic>{'urls': server.urls};
          if (server.username.isNotEmpty) entry['username'] = server.username;
          if (server.credential.isNotEmpty) {
            entry['credential'] = server.credential;
          }
          return entry;
        })
        .toList(growable: false);

    if (mapped.isEmpty) {
      throw StateError('服务端未提供可用的 WebRTC ICE 服务器');
    }

    _iceServers = mapped;
    return mapped;
  }

  Future<void> handleJoin(String fromId) async {
    RTCPeerConnection? pc;
    try {
      pc = await _replacePeerConnection(fromId);
      if (pc == null || !_ownsPeer(fromId, pc)) return;
      final tieBreaker = _negotiation.beginLocalOffer(fromId);
      final offer = await pc.createOffer();
      if (!_ownsPeer(fromId, pc)) return;
      await pc.setLocalDescription(offer);
      if (!_ownsPeer(fromId, pc)) return;

      onSignalingMessage('offer', {
        'sdp': offer.sdp,
        'type': offer.type,
        'to': fromId,
        'tie_breaker': tieBreaker,
      });
    } catch (e) {
      await _closeFailedPeer(fromId, pc);
      debugPrint('Handle Join Error: $e');
    }
  }

  Future<void> handleOffer(String fromId, Map<String, dynamic> data) async {
    final tieBreaker = data['tie_breaker'];
    if (tieBreaker != null && (tieBreaker is! num || !tieBreaker.isFinite)) {
      return;
    }
    final incomingTieBreaker = (tieBreaker as num?)?.toInt() ?? 0;
    if (!_negotiation.shouldAcceptRemoteOffer(fromId, incomingTieBreaker)) {
      return;
    }
    RTCPeerConnection? pc;
    try {
      pc = await _replacePeerConnection(fromId);
      if (pc == null || !_ownsPeer(fromId, pc)) return;
      final description = RTCSessionDescription(data['sdp'], data['type']);
      await pc.setRemoteDescription(description);
      if (!_ownsPeer(fromId, pc)) return;
      _negotiation.markRemoteDescription(fromId);

      final answer = await pc.createAnswer();
      if (!_ownsPeer(fromId, pc)) return;
      await pc.setLocalDescription(answer);
      if (!_ownsPeer(fromId, pc)) return;

      onSignalingMessage('answer', {
        'sdp': answer.sdp,
        'type': answer.type,
        'to': fromId,
      });
      await _flushCandidates(fromId, pc);
    } catch (e) {
      await _closeFailedPeer(fromId, pc);
      debugPrint('Handle Offer Error: $e');
    }
  }

  Future<void> handleAnswer(String fromId, Map<String, dynamic> data) async {
    final pc = _peerConnections[fromId];
    try {
      if (pc == null) return;

      final description = RTCSessionDescription(data['sdp'], data['type']);
      await pc.setRemoteDescription(description);
      if (!_ownsPeer(fromId, pc)) return;
      _negotiation.markRemoteDescription(fromId, completesLocalOffer: true);
      await _flushCandidates(fromId, pc);
    } catch (e) {
      await _closeFailedPeer(fromId, pc);
      debugPrint('Handle Answer Error: $e');
    }
  }

  Future<void> handleCandidate(String fromId, Map<String, dynamic> data) async {
    try {
      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );

      final pc = _peerConnections[fromId];
      if (pc == null || !_negotiation.hasRemoteDescription(fromId)) {
        _negotiation.queueCandidate(fromId, candidate);
        return;
      }

      await pc.addCandidate(candidate);
    } catch (e) {
      debugPrint('Handle Candidate Error: $e');
    }
  }

  Future<void> handleLeave(String fromId) => _closePeer(fromId);

  Future<RTCPeerConnection?> _replacePeerConnection(String remoteId) async {
    if (_disposed || (!_isConnected && _joinOperationId == null)) return null;
    final generation = _generation;
    final pending = _negotiation.takeCandidates(remoteId);
    final closing = _closePeer(remoteId);
    final operation = Object();
    _peerOperations[remoteId] = operation;
    await closing;
    if (generation != _generation ||
        !identical(_peerOperations[remoteId], operation)) {
      return null;
    }
    _negotiation.restoreCandidates(remoteId, pending);
    return _createPeerConnection(remoteId, operation);
  }

  Future<void> _flushCandidates(String remoteId, RTCPeerConnection pc) async {
    for (final candidate in _negotiation.takeCandidates(remoteId)) {
      if (!_ownsPeer(remoteId, pc)) return;
      await pc.addCandidate(candidate);
    }
  }

  Future<void> _closeFailedPeer(String remoteId, RTCPeerConnection? pc) async {
    if (pc == null || !_ownsPeer(remoteId, pc)) return;
    try {
      await _closePeer(remoteId);
    } catch (_) {
      debugPrint('Failed to close a failed voice peer');
    }
  }

  Future<void> _closePeer(String remoteId) async {
    _peerOperations.remove(remoteId);
    final pc = _peerConnections.remove(remoteId);
    final changed = _connectedPeers.remove(remoteId);
    _negotiation.clearPeer(remoteId);
    Object? notificationError;
    StackTrace? notificationStack;
    try {
      if (changed && !_disposed) onStateChange();
    } catch (error, stack) {
      notificationError = error;
      notificationStack = stack;
    }
    await pc?.close();
    if (notificationError != null) {
      Error.throwWithStackTrace(notificationError, notificationStack!);
    }
  }

  @override
  Future<bool> rejectJoin(String clientOperationId) async {
    if (_joinOperationId != clientOperationId) return false;
    await _leave(notifyServer: false);
    return true;
  }

  @override
  Future<void> leave() => _leave(notifyServer: true);

  Future<void> _leave({required bool notifyServer}) {
    _generation++;
    _joining = null;
    final pending = _leaving;
    if (pending != null) return pending;
    final announce = _isConnected && notifyServer;
    _isConnected = false;
    _joinOperationId = null;
    final stream = _localStream;
    _localStream = null;
    final peers = _peerConnections.values.toList();
    _peerConnections.clear();
    _peerOperations.clear();
    _connectedPeers.clear();
    _negotiation.clear();
    late final Future<void> operation;
    operation = _releaseSession(stream, peers, announce).whenComplete(() {
      if (identical(_leaving, operation)) _leaving = null;
    });
    return _leaving = operation;
  }

  Future<void> _releaseSession(
    MediaStream? stream,
    List<RTCPeerConnection> peers,
    bool announce,
  ) async {
    Object? firstError;
    StackTrace? firstStack;
    Future<void> attempt(FutureOr<void> Function() cleanup) async {
      try {
        await cleanup();
      } catch (error, stack) {
        firstError ??= error;
        firstStack ??= stack;
      }
    }

    final microphoneRelease = stream == null
        ? Future<void>.value()
        : attempt(() => releaseVoiceMicrophone(stream));

    await attempt(() => _setSpeakerphoneOn(false));
    await attempt(() => _setVoiceCallMode(false));
    if (announce) {
      await attempt(() => onSignalingMessage('leave', {}));
    }

    await microphoneRelease;

    for (final pc in peers) {
      await attempt(pc.close);
    }
    if (!_disposed) await attempt(onStateChange);
    if (firstError != null) Error.throwWithStackTrace(firstError!, firstStack!);
  }

  @override
  Future<void> dispose() {
    _disposed = true;
    return _leave(notifyServer: false);
  }

  @override
  void toggleMute() {
    if (_localStream != null) {
      final audioTracks = _localStream!.getAudioTracks();
      for (var track in audioTracks) {
        track.enabled = !track.enabled;
      }
      onStateChange();
    }
  }

  @override
  bool get isMuted {
    if (_localStream != null && _localStream!.getAudioTracks().isNotEmpty) {
      return !_localStream!.getAudioTracks().first.enabled;
    }
    return false;
  }

  Future<void> _routeAudio(Future<void> Function() operation) {
    final pending = _audioRouting.then((_) => operation());
    // Preserve errors for the caller while allowing cleanup to follow a failure.
    _audioRouting = pending.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return pending;
  }

  Future<void> _setVoiceCallMode(bool enabled) =>
      _routeAudio(() => _configureVoiceCallMode(enabled));

  Future<void> _setSpeakerphoneOn(bool enabled) => _routeAudio(() async {
    try {
      await _configureSpeakerphone(enabled);
    } on MissingPluginException catch (error) {
      debugPrint('WebRTC speakerphone control is unavailable: $error');
    } on PlatformException catch (error) {
      debugPrint('WebRTC speakerphone control failed: $error');
    }
  });
}
