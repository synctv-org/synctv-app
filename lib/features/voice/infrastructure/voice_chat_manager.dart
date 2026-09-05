import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/features/voice/application/voice_chat_session.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_audio_session.dart';
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
  static const Duration _getUserMediaTimeout = Duration(seconds: 12);

  final Map<String, RTCPeerConnection> _peerConnections = {};
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
  });

  @override
  void handleSignalingMessage(String type, Map<String, dynamic> data) {
    final fromId = data['from'];
    if (fromId == null) return;

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
  Future<void> join({required String clientOperationId}) async {
    if (_isConnected) return;

    // Validate signaling prerequisites before acquiring the microphone or
    // creating server-side voice presence. A failed bootstrap can then
    // leave no partially joined session behind.
    await _loadIceServerConfiguration();

    try {
      await VoiceAudioSession.stopPlaying();

      await VoiceAudioSession.setVoiceCallMode(true);

      final mediaConstraints = {'audio': true, 'video': false};

      _localStream = await navigator.mediaDevices
          .getUserMedia(mediaConstraints)
          .timeout(
            _getUserMediaTimeout,
            onTimeout: () => throw TimeoutException(
              '获取麦克风权限超时，请检查系统麦克风权限',
              _getUserMediaTimeout,
            ),
          );

      await _setSpeakerphoneOn(true);

      _joinOperationId = clientOperationId;
      onSignalingMessage('join', {'client_operation_id': clientOperationId});

      _isConnected = true;
      onStateChange();
    } catch (e) {
      debugPrint('WebRTC Join Error: $e');
      await leave();
      rethrow;
    }
  }

  Future<RTCPeerConnection> _createPeerConnection(String remoteId) async {
    final configuration = {'iceServers': await _loadIceServerConfiguration()};

    final pc = await createPeerConnection(configuration);

    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    pc.onIceCandidate = (candidate) {
      onSignalingMessage('candidate', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'to': remoteId,
      });
    };

    pc.onConnectionState = (state) {
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
      if (event.track.kind == 'audio') {
        event.track.enabled = true;
        unawaited(_setSpeakerphoneOn(true));
      }
    };

    _peerConnections[remoteId] = pc;
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
    try {
      final pc = await _replacePeerConnection(fromId);
      final tieBreaker = _negotiation.beginLocalOffer(fromId);
      final offer = await pc.createOffer();
      await pc.setLocalDescription(offer);

      onSignalingMessage('offer', {
        'sdp': offer.sdp,
        'type': offer.type,
        'to': fromId,
        'tie_breaker': tieBreaker,
      });
    } catch (e) {
      debugPrint('Handle Join Error: $e');
    }
  }

  Future<void> handleOffer(String fromId, Map<String, dynamic> data) async {
    final incomingTieBreaker = (data['tie_breaker'] as num?)?.toInt() ?? 0;
    if (!_negotiation.shouldAcceptRemoteOffer(fromId, incomingTieBreaker)) {
      return;
    }
    try {
      final pc = await _replacePeerConnection(fromId);
      final description = RTCSessionDescription(data['sdp'], data['type']);
      await pc.setRemoteDescription(description);
      _negotiation.markRemoteDescription(fromId);

      final answer = await pc.createAnswer();
      await pc.setLocalDescription(answer);

      onSignalingMessage('answer', {
        'sdp': answer.sdp,
        'type': answer.type,
        'to': fromId,
      });
      await _flushCandidates(fromId, pc);
    } catch (e) {
      debugPrint('Handle Offer Error: $e');
    }
  }

  Future<void> handleAnswer(String fromId, Map<String, dynamic> data) async {
    try {
      final pc = _peerConnections[fromId];
      if (pc == null) return;

      final description = RTCSessionDescription(data['sdp'], data['type']);
      await pc.setRemoteDescription(description);
      _negotiation.markRemoteDescription(fromId, completesLocalOffer: true);
      await _flushCandidates(fromId, pc);
    } catch (e) {
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

  Future<RTCPeerConnection> _replacePeerConnection(String remoteId) async {
    final pending = _negotiation.takeCandidates(remoteId);
    await _closePeer(remoteId);
    _negotiation.restoreCandidates(remoteId, pending);
    return _createPeerConnection(remoteId);
  }

  Future<void> _flushCandidates(String remoteId, RTCPeerConnection pc) async {
    for (final candidate in _negotiation.takeCandidates(remoteId)) {
      await pc.addCandidate(candidate);
    }
  }

  Future<void> _closePeer(String remoteId) async {
    final pc = _peerConnections.remove(remoteId);
    await pc?.close();
    _connectedPeers.remove(remoteId);
    _negotiation.clearPeer(remoteId);
  }

  @override
  Future<bool> rejectJoin(String clientOperationId) async {
    if (_joinOperationId != clientOperationId) return false;
    await _leave(notifyServer: false);
    return true;
  }

  @override
  Future<void> leave() => _leave(notifyServer: true);

  Future<void> _leave({required bool notifyServer}) async {
    await _setSpeakerphoneOn(false);
    await VoiceAudioSession.setVoiceCallMode(false);
    if (_isConnected && notifyServer) {
      onSignalingMessage('leave', {});
    }

    _localStream?.getTracks().forEach((track) => track.stop());
    await _localStream?.dispose();
    _localStream = null;

    for (var pc in _peerConnections.values) {
      await pc.close();
    }
    _peerConnections.clear();
    _connectedPeers.clear();
    _negotiation.clear();

    _isConnected = false;
    _joinOperationId = null;
    onStateChange();
  }

  @override
  Future<void> dispose() => _leave(notifyServer: false);

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

  Future<void> _setSpeakerphoneOn(bool enabled) async {
    try {
      await Helper.setSpeakerphoneOn(enabled);
    } on MissingPluginException catch (error) {
      debugPrint('WebRTC speakerphone control is unavailable: $error');
    } on PlatformException catch (error) {
      debugPrint('WebRTC speakerphone control failed: $error');
    }
  }
}
