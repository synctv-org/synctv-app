import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_manager.dart';

Future<List<String?>> p2pReplacementCandidates({
  bool delayChannel = false,
}) async {
  final closing = Completer<void>();
  final released = Completer<void>();
  Future<void> closeOperation() {
    if (!closing.isCompleted) closing.complete();
    return released.future;
  }

  final old = _Peer()..closeOperation = delayChannel ? null : closeOperation;
  final replacement = _Peer();
  final answers = [Completer<void>(), Completer<void>()];
  var answerCount = 0;
  var creationCount = 0;
  final manager = P2pMediaManager(
    onSignalingMessage: (type, _) {
      if (type == 'answer') answers[answerCount++].complete();
    },
    loadIceServers: () async => [],
    loadCachedPiece: (_, _) async => null,
    onStateChange: () {},
    createConnection: (_) async => creationCount++ == 0 ? old : replacement,
  );
  const offer = {
    'from': 'peer',
    'media_swarm_id': 'swarm',
    'sdp': 'offer',
    'type': 'offer',
  };
  void candidate(String value) => manager.handleSignalingMessage('candidate', {
    'from': 'peer',
    'media_swarm_id': 'swarm',
    'candidate': value,
    'sdpMid': '0',
    'sdpMLineIndex': 0,
  });
  try {
    await manager.setActiveSwarms({'swarm': 'ticket'});
    manager.handleSignalingMessage('offer', offer);
    await answers[0].future;
    await Future<void>.delayed(Duration.zero);
    if (delayChannel) old.onDataChannel!(_Channel(closeOperation));
    manager.handleSignalingMessage('offer', offer);
    await closing.future;
    candidate('During old peer close');
    released.complete();
    await answers[1].future;
    await Future<void>.delayed(Duration.zero);
    candidate('After replacement');
    await Future<void>.delayed(Duration.zero);
    return replacement.candidates.toList();
  } finally {
    if (!released.isCompleted) released.complete();
    await manager.dispose();
  }
}

Future<List<String>> p2pReplacedChannelEvents({
  bool duringClose = false,
}) async {
  final peer = _Peer();
  final answered = Completer<void>();
  final events = <String>[];
  final manager = P2pMediaManager(
    onSignalingMessage: (type, _) {
      if (type == 'answer') answered.complete();
    },
    loadIceServers: () async => [],
    loadCachedPiece: (_, key) async {
      events.add(key);
      return null;
    },
    onStateChange: () => events.add('state'),
    createConnection: (_) async => peer,
  );
  late final _Channel old;
  void staleEvents() {
    old.onMessage!(
      RTCDataChannelMessage('{"t":"has","r":1,"k":"obsolete cache read"}'),
    );
    old.onDataChannelState!(RTCDataChannelState.RTCDataChannelClosed);
  }

  old = _Channel(() async {
    if (duringClose) staleEvents();
  });
  final current = _Channel(() async {});
  try {
    await manager.setActiveSwarms({'swarm': 'ticket'});
    manager.handleSignalingMessage('offer', {
      'from': 'peer',
      'media_swarm_id': 'swarm',
      'sdp': 'offer',
      'type': 'offer',
    });
    await answered.future.timeout(const Duration(seconds: 5));
    await Future<void>.delayed(Duration.zero);
    peer.onDataChannel!(old);
    events.clear();
    peer.onDataChannel!(current);
    if (!duringClose) staleEvents();
    current.onMessage!(
      RTCDataChannelMessage('{"t":"has","r":2,"k":"current cache read"}'),
    );
    await Future<void>.delayed(Duration.zero);
    return events.toList();
  } finally {
    await manager.dispose();
  }
}

Future<bool> p2pConcurrentDisposalWaits({bool failClose = false}) async {
  final closing = Completer<void>();
  final release = Completer<void>();
  final answered = Completer<void>();
  final peer = _Peer()
    ..closeOperation = () {
      closing.complete();
      return release.future;
    };
  final manager = P2pMediaManager(
    onSignalingMessage: (type, _) {
      if (type == 'answer') answered.complete();
    },
    loadIceServers: () async => [],
    loadCachedPiece: (_, _) async => null,
    onStateChange: () {},
    createConnection: (_) async => peer,
  );
  await manager.setActiveSwarms({'swarm': 'ticket'});
  manager.handleSignalingMessage('offer', {
    'from': 'peer',
    'media_swarm_id': 'swarm',
    'sdp': 'offer',
    'type': 'offer',
  });
  await answered.future;
  await Future<void>.delayed(Duration.zero);
  Future<Object?> outcome(Future<void> operation) async {
    try {
      await operation;
      return null;
    } catch (error) {
      return error;
    }
  }

  final first = outcome(manager.dispose());
  await closing.future;
  var secondDone = false;
  final second = outcome(manager.dispose()).then((value) {
    secondDone = true;
    return value;
  });
  await Future<void>.delayed(Duration.zero);
  final waited = !secondDone;
  final error = StateError('Controlled peer close failure');
  if (failClose) {
    release.completeError(error);
  } else {
    release.complete();
  }
  final results = await Future.wait([first, second]);
  final later = await outcome(manager.dispose());
  return waited &&
      results.every((value) => identical(value, failClose ? error : null)) &&
      identical(later, failClose ? error : null);
}

Future<List<String>> p2pDisposalAfterPeerFailure() async {
  final events = <String>[];
  final failure = StateError('Controlled close failure');
  var answered = Completer<void>();
  var created = 0;
  final manager = P2pMediaManager(
    onSignalingMessage: (type, _) {
      if (type == 'answer') answered.complete();
    },
    loadIceServers: () async => [],
    loadCachedPiece: (_, _) async => null,
    onStateChange: () {},
    createConnection: (_) async {
      final index = created++;
      return _Peer()
        ..closeOperation = () async {
          events.add('close $index');
          if (index == 0) throw failure;
        };
    },
  );
  await manager.setActiveSwarms({'swarm': 'ticket'});
  for (var i = 0; i < 2; i++) {
    answered = Completer<void>();
    manager.handleSignalingMessage('offer', {
      'from': 'peer$i',
      'media_swarm_id': 'swarm',
      'sdp': 'offer',
      'type': 'offer',
    });
    await answered.future;
    await Future<void>.delayed(Duration.zero);
  }
  try {
    await manager.dispose();
    events.add('unexpected success');
  } catch (error) {
    events.add(
      identical(error, failure) ? 'original failure' : 'wrong failure',
    );
  }
  return events;
}

class _Peer extends RTCPeerConnection {
  Future<void> Function()? closeOperation;
  final candidates = <String?>[];
  @override
  Future<void> close() async => await closeOperation?.call();
  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {}
  @override
  Future<void> setLocalDescription(RTCSessionDescription description) async {}
  @override
  Future<RTCSessionDescription> createAnswer([
    Map<String, dynamic>? constraints,
  ]) async => RTCSessionDescription('answer', 'answer');
  @override
  Future<void> addCandidate(RTCIceCandidate candidate) async =>
      candidates.add(candidate.candidate);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Channel extends RTCDataChannel {
  _Channel(this.closeOperation);
  final Future<void> Function() closeOperation;
  @override
  RTCDataChannelState get state => RTCDataChannelState.RTCDataChannelConnecting;
  @override
  Future<void> close() => closeOperation();
  @override
  Future<void> send(RTCDataChannelMessage message) async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
