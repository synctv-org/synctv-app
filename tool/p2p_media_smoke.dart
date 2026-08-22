import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_manager.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';

const _publicIceServers = [
  IceServerInfo(
    urls: ['stun:stun.cloudflare.com:3478'],
    username: '',
    credential: '',
  ),
  IceServerInfo(
    urls: ['stun:stun.l.google.com:19302'],
    username: '',
    credential: '',
  ),
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _P2pMediaSmokeApp());
}

class _P2pMediaSmokeApp extends StatefulWidget {
  const _P2pMediaSmokeApp();

  @override
  State<_P2pMediaSmokeApp> createState() => _P2pMediaSmokeAppState();
}

class _P2pMediaSmokeAppState extends State<_P2pMediaSmokeApp> {
  String _status = 'Connecting local media peers...';

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    const swarmId = 'smoke_room_media_representation';
    const pieceKey = 'root:piece:0';
    final expected = Uint8List.fromList(
      List<int>.generate(128 * 1024, (index) => index % 251),
    );
    late P2pMediaManager first;
    late P2pMediaManager second;
    final signals = <String>[];
    var resultFinalized = false;

    void updateStatus() {
      if (!mounted || resultFinalized) return;
      setState(() {
        _status =
            'Connecting local media peers... '
            'first=${first.connectedPeerCount}, '
            'second=${second.connectedPeerCount}, '
            'signals=${signals.join(',')}';
      });
    }

    void relay(
      P2pMediaManager target,
      String from,
      String type,
      Map<String, dynamic> data,
    ) {
      signals.add('$from:$type');
      updateStatus();
      scheduleMicrotask(() {
        target.handleSignalingMessage(type, {...data, 'from': from});
      });
    }

    first = P2pMediaManager(
      onSignalingMessage: (type, data) =>
          relay(second, 'first:connection', type, data),
      loadIceServers: () async => _publicIceServers,
      loadCachedPiece: (swarm, key) async =>
          swarm == swarmId && key == pieceKey ? expected : null,
      onStateChange: updateStatus,
    );
    second = P2pMediaManager(
      onSignalingMessage: (type, data) =>
          relay(first, 'second:connection', type, data),
      loadIceServers: () async => _publicIceServers,
      loadCachedPiece: (swarm, key) async => null,
      onStateChange: updateStatus,
    );

    try {
      await first.setActiveSwarms(const {swarmId: 'first-smoke-ticket'});
      await second.setActiveSwarms(const {swarmId: 'second-smoke-ticket'});
      await _waitUntil(
        () => first.connectedPeerCount == 1 && second.connectedPeerCount == 1,
        timeout: const Duration(seconds: 15),
      );
      final cancellation = P2pPieceRequestCancellation();
      final received = await second
          .requestPiece(swarmId, pieceKey, cancellation)
          .timeout(const Duration(seconds: 5));
      if (received == null || !_bytesEqual(received.bytes, expected)) {
        throw StateError('peer returned different media bytes');
      }

      await second.setActiveSwarms(const {});
      await _waitUntil(
        () => first.connectedPeerCount == 0,
        timeout: const Duration(seconds: 5),
      );
      final result = 'P2P_MEDIA_SMOKE_OK bytes=${received.bytes.length}';
      debugPrint(result);
      resultFinalized = true;
      if (mounted) setState(() => _status = result);
    } catch (error, stackTrace) {
      debugPrint('P2P_MEDIA_SMOKE_FAILED $error\n$stackTrace');
      resultFinalized = true;
      if (mounted) {
        setState(() {
          _status =
              'P2P media smoke failed: $error; '
              'first=${first.connectedPeerCount}, '
              'second=${second.connectedPeerCount}, '
              'signals=${signals.join(',')}';
        });
      }
    } finally {
      await first.dispose();
      await second.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text(_status))),
    );
  }
}

Future<void> _waitUntil(
  bool Function() condition, {
  required Duration timeout,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('condition was not met', timeout);
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

bool _bytesEqual(Uint8List left, Uint8List right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}
