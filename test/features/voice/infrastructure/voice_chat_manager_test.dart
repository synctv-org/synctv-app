import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_chat_manager.dart';

void main() {
  test('failed audio routing still allows cleanup and a later join', () async {
    final failure = StateError('audio mode failed');
    var failNext = true;
    final modes = <bool>[];
    final manager = VoiceChatManager(
      onSignalingMessage: (_, _) {},
      onStateChange: () {},
      loadIceServers: () async => _iceServers,
      acquireMicrophone: () async => _Stream(),
      configureVoiceCallMode: (enabled) async {
        modes.add(enabled);
        if (enabled && failNext) {
          failNext = false;
          throw failure;
        }
      },
      configureSpeakerphone: (_) async {},
    );
    await expectLater(
      manager.join(clientOperationId: 'failed'),
      throwsA(same(failure)),
    );
    expect(manager.isConnected, isFalse);
    await manager.join(clientOperationId: 'retry');
    expect(manager.isConnected, isTrue);
    await manager.dispose();
    expect(modes, [true, false, true, false]);
  });

  for (final stage in ['voice mode', 'speakerphone']) {
    test('leaving serializes pending $stage configuration', () async {
      final started = Completer<void>();
      final pending = Completer<void>();
      final calls = <String>[];
      var enabledState = false;
      final stream = _Stream();
      Future<void> configure(bool enabled) async {
        calls.add('start:$enabled');
        if (enabled) {
          started.complete();
          await pending.future;
        }
        enabledState = enabled;
        calls.add('end:$enabled');
      }

      final manager = VoiceChatManager(
        onSignalingMessage: (_, _) {},
        onStateChange: () {},
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => stream,
        configureVoiceCallMode: stage == 'voice mode'
            ? configure
            : (_) async {},
        configureSpeakerphone: stage == 'speakerphone'
            ? configure
            : (_) async {},
      );
      final joining = manager.join(clientOperationId: 'pending');
      await started.future;
      final leaving = manager.leave();
      await Future<void>.delayed(Duration.zero);
      final callsWhilePending = List<String>.of(calls);
      final stopsWhilePending = stream.track.stops;
      pending.complete();
      await Future.wait([joining, leaving]);
      expect(callsWhilePending, ['start:true']);
      expect(enabledState, isFalse);
      expect(calls, ['start:true', 'end:true', 'start:false', 'end:false']);
      expect(manager.isConnected, isFalse);
      if (stage == 'speakerphone') {
        expect(stopsWhilePending, 1);
        expect(stream.disposals, 1);
      }
      await manager.dispose();
    });
  }

  test('microphone stops while speakerphone shutdown is pending', () async {
    final pending = Completer<void>();
    final shutdown = Completer<void>();
    final stream = _Stream();
    var block = true;
    final manager = VoiceChatManager(
      onSignalingMessage: (_, _) {},
      onStateChange: () {},
      loadIceServers: () async => _iceServers,
      acquireMicrophone: () async => stream,
      configureVoiceCallMode: (_) async {},
      configureSpeakerphone: (enabled) async {
        if (!enabled && block) {
          shutdown.complete();
          await pending.future;
        }
      },
    );
    await manager.join(clientOperationId: 'joined');
    final leaving = manager.leave();
    await shutdown.future;
    final stoppedBeforeShutdown = stream.track.stops;
    pending.complete();
    await leaving;
    expect(stoppedBeforeShutdown, 1);
    expect(stream.disposals, 1);
    block = false;
    await manager.dispose();
  });

  test(
    'replacement retains ICE candidates before during and after close',
    () async {
      final closing = Completer<void>();
      final closed = Completer<void>();
      final old = _Peer()
        ..closeOperation = () {
          closed.complete();
          return closing.future;
        };
      final next = _Peer();
      var creations = 0;
      final manager = VoiceChatManager(
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => _Stream(),
        createConnection: (_) async => creations++ == 0 ? old : next,
        onSignalingMessage: (_, _) {},
        onStateChange: () {},
      );
      await manager.join(clientOperationId: 'first');
      await manager.handleJoin('peer');
      await manager.handleCandidate('peer', {
        'candidate': 'before',
        'sdpMid': '0',
        'sdpMLineIndex': 0,
      });
      final replacing = manager.handleJoin('peer');
      await closed.future;
      await manager.handleCandidate('peer', {
        'candidate': 'during',
        'sdpMid': '0',
        'sdpMLineIndex': 0,
      });
      closing.complete();
      await replacing;
      await manager.handleCandidate('peer', {
        'candidate': 'after',
        'sdpMid': '0',
        'sdpMLineIndex': 0,
      });
      await manager.handleAnswer('peer', {'sdp': 'answer', 'type': 'answer'});
      expect(next.candidates, ['before', 'during', 'after']);
      await manager.dispose();
    },
  );

  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('FlutterWebRTC.Method'),
          (_) async => null,
        );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('FlutterWebRTC.Method'),
          null,
        );
  });

  for (final dispose in [false, true]) {
    test(
      'late microphone cannot join after ${dispose ? 'dispose' : 'leave'}',
      () async {
        final pending = Completer<MediaStream>();
        final requested = Completer<void>();
        final signals = <String>[];
        var changes = 0;
        final manager = _manager(signals, () {
          requested.complete();
          return pending.future;
        }, onStateChange: () => changes++);
        final joining = manager.join(clientOperationId: 'first');
        await requested.future;
        await (dispose ? manager.dispose() : manager.leave());
        final changesAfterExit = changes;
        final stream = _Stream();
        pending.complete(stream);
        await joining;
        expect(signals, isEmpty);
        expect(manager.isConnected, isFalse);
        expect(stream.track.stops, 1);
        expect(stream.disposals, 1);
        expect(changes, changesAfterExit);
        if (dispose) {
          await expectLater(
            manager.join(clientOperationId: 'next'),
            throwsStateError,
          );
        }
      },
    );
  }

  test(
    'duplicate join shares one acquisition and signaling operation',
    () async {
      final pending = Completer<MediaStream>();
      final requested = Completer<void>();
      var requests = 0;
      final signals = <String>[];
      final manager = _manager(signals, () {
        requests++;
        if (!requested.isCompleted) requested.complete();
        return pending.future;
      });
      final first = manager.join(clientOperationId: 'first');
      final second = manager.join(clientOperationId: 'second');
      await requested.future;
      final stream = _Stream();
      pending.complete(stream);
      await Future.wait([first, second]);
      expect(requests, 1);
      expect(signals, ['join:first']);
      expect(manager.participantCount, 1);
      await manager.leave();
      expect(stream.disposals, 1);
      expect(signals, ['join:first', 'leave:null']);
    },
  );

  for (final fails in [false, true]) {
    test(
      'old microphone completion preserves a new join, fails=$fails',
      () async {
        final old = Completer<MediaStream>();
        final requested = Completer<void>();
        final current = _Stream();
        var calls = 0;
        final signals = <String>[];
        final manager = _manager(signals, () {
          if (calls++ == 0) {
            requested.complete();
            return old.future;
          }
          return Future.value(current);
        });
        final first = manager.join(clientOperationId: 'old');
        await requested.future;
        await manager.leave();
        await manager.join(clientOperationId: 'new');
        final late = _Stream();
        if (fails) {
          old.completeError(StateError('late permission failure'));
        } else {
          old.complete(late);
        }
        await first;
        expect(manager.isConnected, isTrue);
        expect(current.disposals, 0);
        expect(signals, ['join:new']);
        if (!fails) expect(late.disposals, 1);
        await manager.dispose();
      },
    );
  }

  test('leave during ICE loading prevents microphone acquisition', () async {
    final ice = Completer<List<IceServerInfo>>();
    final started = Completer<void>();
    var acquisitions = 0;
    final manager = VoiceChatManager(
      onSignalingMessage: (_, _) => fail('Stale join signaled'),
      loadIceServers: () {
        started.complete();
        return ice.future;
      },
      onStateChange: () {},
      acquireMicrophone: () async {
        acquisitions++;
        return _Stream();
      },
    );
    final joining = manager.join(clientOperationId: 'old');
    await started.future;
    await manager.leave();
    ice.complete(_iceServers);
    await joining;
    expect(acquisitions, 0);
  });

  test(
    'new join waits for prior stream cleanup and repeated leave shares it',
    () async {
      final release = Completer<void>();
      final stopped = Completer<void>();
      final old = _Stream()
        ..onDispose = () {
          stopped.complete();
          return release.future;
        };
      final next = _Stream();
      var acquisitions = 0;
      final manager = _manager(
        [],
        () async => acquisitions++ == 0 ? old : next,
      );
      await manager.join(clientOperationId: 'old');
      final leaving = manager.leave();
      await stopped.future;
      final leavingAgain = manager.leave();
      final joining = manager.join(clientOperationId: 'new');
      await Future<void>.delayed(Duration.zero);
      expect(acquisitions, 1);
      expect(manager.isConnected, isFalse);
      release.complete();
      await Future.wait([leaving, leavingAgain, joining]);
      expect(acquisitions, 2);
      expect(old.disposals, 1);
      expect(manager.isConnected, isTrue);
      await manager.dispose();
    },
  );

  test(
    'failed acquisition can retry and synchronous rejection cannot reconnect',
    () async {
      var calls = 0;
      final stream = _Stream();
      late VoiceChatManager manager;
      Future<bool>? rejection;
      manager = VoiceChatManager(
        loadIceServers: () async => _iceServers,
        onStateChange: () {},
        acquireMicrophone: () async {
          if (calls++ == 0) throw StateError('permission denied');
          return stream;
        },
        onSignalingMessage: (type, data) {
          if (type == 'join') {
            rejection = manager.rejectJoin(
              data['client_operation_id'] as String,
            );
          }
        },
      );
      await expectLater(
        manager.join(clientOperationId: 'first'),
        throwsStateError,
      );
      await manager.join(clientOperationId: 'second');
      expect(await rejection, isTrue);
      expect(manager.isConnected, isFalse);
      expect(stream.disposals, 1);
    },
  );

  test(
    'leave signal failure still releases microphone and permits retry',
    () async {
      final stream = _Stream();
      final failure = StateError('signaling unavailable');
      var changes = 0;
      final manager = VoiceChatManager(
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => stream,
        onStateChange: () => changes++,
        onSignalingMessage: (type, _) {
          if (type == 'leave') throw failure;
        },
      );
      await manager.join(clientOperationId: 'first');
      await expectLater(manager.leave(), throwsA(same(failure)));
      expect(stream.track.stops, 1);
      expect(stream.disposals, 1);
      expect(manager.isConnected, isFalse);
      expect(changes, 2);
      await manager.join(clientOperationId: 'second');
      expect(manager.isConnected, isTrue);
      await manager.dispose();
    },
  );

  test('join failure survives cleanup notification failure', () async {
    final original = StateError('microphone denied');
    final manager = VoiceChatManager(
      loadIceServers: () async => _iceServers,
      acquireMicrophone: () async => throw original,
      onSignalingMessage: (_, _) {},
      onStateChange: () => throw StateError('listener failure'),
    );
    await expectLater(
      manager.join(clientOperationId: 'first'),
      throwsA(same(original)),
    );
    expect(manager.isConnected, isFalse);
    await manager.dispose();
  });

  test('first cleanup error survives later notification error', () async {
    final original = StateError('leave failed');
    final stream = _Stream();
    var failNotification = false;
    final manager = VoiceChatManager(
      loadIceServers: () async => _iceServers,
      acquireMicrophone: () async => stream,
      onSignalingMessage: (type, _) {
        if (type == 'leave') throw original;
      },
      onStateChange: () {
        if (failNotification) throw StateError('listener failed');
      },
    );
    await manager.join(clientOperationId: 'first');
    failNotification = true;
    await expectLater(manager.leave(), throwsA(same(original)));
    expect(stream.disposals, 1);
    await manager.dispose();
  });

  test('inactive and disposed sessions ignore incoming signals', () async {
    final manager = _SignalingSpy();
    for (final type in ['join', 'offer', 'answer', 'candidate', 'leave']) {
      manager.handleSignalingMessage(type, {'from': 'peer'});
    }
    expect(manager.received, isEmpty);
    await manager.join(clientOperationId: 'first');
    manager.handleSignalingMessage('join', {'from': 'peer'});
    expect(manager.received, ['join:peer']);
    manager.received.clear();
    await manager.leave();
    manager.handleSignalingMessage('join', {'from': 'peer'});
    expect(manager.received, isEmpty);
    await manager.dispose();
    manager.handleSignalingMessage('offer', {'from': 'peer'});
    expect(manager.received, isEmpty);
  });

  test(
    'active signaling rejects invalid sender IDs and preserves valid routing',
    () async {
      final manager = _SignalingSpy();
      await manager.join(clientOperationId: 'first');
      for (final sender in [null, 42, true, <String>[], '', '   ']) {
        for (final type in ['join', 'offer', 'answer', 'candidate', 'leave']) {
          expect(
            () => manager.handleSignalingMessage(type, {'from': sender}),
            returnsNormally,
          );
        }
      }
      expect(manager.received, isEmpty);
      for (final type in ['join', 'offer', 'answer', 'candidate', 'leave']) {
        manager.handleSignalingMessage(type, {'from': 'peer'});
      }
      expect(manager.received, [
        'join:peer',
        'offer:peer',
        'answer:peer',
        'candidate:peer',
        'leave:peer',
      ]);
      await manager.dispose();
    },
  );

  test('malformed offer tie breakers do not escape asynchronously', () async {
    final manager = _manager([], () async => _Stream());
    await manager.join(clientOperationId: 'first');
    for (final value in [
      'invalid',
      true,
      <String>[],
      double.nan,
      double.infinity,
    ]) {
      await expectLater(
        manager.handleOffer('peer', {'tie_breaker': value}),
        completes,
      );
    }
    await manager.dispose();
  });

  test(
    'synchronous join response is accepted before connected notification',
    () async {
      late _SignalingSpy manager;
      manager = _SignalingSpy(
        onSignal: (type, _) {
          if (type == 'join') {
            expect(manager.isConnected, isFalse);
            manager.handleSignalingMessage('join', {'from': 'peer'});
          }
        },
      );
      await manager.join(clientOperationId: 'first');
      expect(manager.received, ['join:peer']);
      await manager.dispose();
    },
  );

  for (final exit in ['leave', 'peer leave', 'dispose']) {
    test('late peer creation closes after $exit', () async {
      final pending = Completer<RTCPeerConnection>();
      final started = Completer<void>();
      final signals = <String>[];
      final manager = VoiceChatManager(
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => _Stream(),
        createConnection: (_) {
          started.complete();
          return pending.future;
        },
        onSignalingMessage: (type, _) => signals.add(type),
        onStateChange: () {},
      );
      await manager.join(clientOperationId: 'first');
      final creating = manager.handleJoin('peer');
      await started.future;
      if (exit == 'peer leave') {
        await manager.handleLeave('peer');
      } else if (exit == 'dispose') {
        await manager.dispose();
      } else {
        await manager.leave();
      }
      final peer = _Peer();
      pending.complete(peer);
      await creating;
      expect(peer.closes, 1);
      expect(peer.offers, 0);
      expect(signals.where((type) => type == 'offer'), isEmpty);
      await manager.dispose();
      expect(peer.closes, 1);
    });
  }

  test(
    'late offer and retained callbacks cannot revive a closed peer',
    () async {
      final pending = Completer<RTCSessionDescription>();
      final started = Completer<void>();
      final peer = _Peer()
        ..offer = () {
          started.complete();
          return pending.future;
        };
      final signals = <String>[];
      var changes = 0;
      final manager = VoiceChatManager(
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => _Stream(),
        createConnection: (_) async => peer,
        onSignalingMessage: (type, _) => signals.add(type),
        onStateChange: () => changes++,
      );
      await manager.join(clientOperationId: 'first');
      final creating = manager.handleJoin('peer');
      await started.future;
      final candidate = peer.onIceCandidate!;
      final state = peer.onConnectionState!;
      await manager.leave();
      final changesAfterLeave = changes;
      pending.complete(RTCSessionDescription('sdp', 'offer'));
      await creating;
      candidate(RTCIceCandidate('candidate', '0', 0));
      state(RTCPeerConnectionState.RTCPeerConnectionStateConnected);
      expect(peer.localDescriptions, 0);
      expect(peer.closes, 1);
      expect(manager.hasPeersConnected, isFalse);
      expect(changes, changesAfterLeave);
      expect(signals, ['join', 'leave']);
    },
  );

  test('newest peer replacement wins out-of-order creation', () async {
    final pending = <Completer<RTCPeerConnection>>[];
    final signals = <String>[];
    final manager = VoiceChatManager(
      loadIceServers: () async => _iceServers,
      acquireMicrophone: () async => _Stream(),
      createConnection: (_) {
        final c = Completer<RTCPeerConnection>();
        pending.add(c);
        return c.future;
      },
      onSignalingMessage: (type, _) => signals.add(type),
      onStateChange: () {},
    );
    await manager.join(clientOperationId: 'first');
    final first = manager.handleJoin('peer');
    await Future<void>.delayed(Duration.zero);
    final second = manager.handleJoin('peer');
    await Future<void>.delayed(Duration.zero);
    expect(pending.length, 2);
    final newest = _Peer();
    pending[1].complete(newest);
    await second;
    final old = _Peer();
    pending[0].complete(old);
    await first;
    expect(old.closes, 1);
    expect(old.offers, 0);
    expect(newest.closes, 0);
    expect(newest.offers, 1);
    expect(signals, ['join', 'offer']);
    await manager.dispose();
    expect(newest.closes, 1);
  });

  for (final stage in ['track', 'offer', 'local', 'remote', 'answer']) {
    test(
      'failed $stage negotiation releases its peer and allows replacement',
      () async {
        final failed = _Peer()..failureStage = stage;
        final replacement = _Peer();
        var creations = 0;
        final manager = VoiceChatManager(
          loadIceServers: () async => _iceServers,
          acquireMicrophone: () async => _Stream(),
          createConnection: (_) async =>
              creations++ == 0 ? failed : replacement,
          onSignalingMessage: (_, _) {},
          onStateChange: () {},
        );
        await manager.join(clientOperationId: 'first');
        if (stage == 'remote' || stage == 'answer') {
          await manager.handleOffer('peer', {'sdp': 'sdp', 'type': 'offer'});
        } else {
          await manager.handleJoin('peer');
        }
        expect(failed.closes, 1);
        await manager.handleJoin('peer');
        expect(replacement.offers, 1);
        expect(replacement.closes, 0);
        await manager.dispose();
        expect(failed.closes, 1);
      },
    );
  }

  test(
    'remote answer failure closes the established local offer peer',
    () async {
      final peer = _Peer();
      final manager = VoiceChatManager(
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => _Stream(),
        createConnection: (_) async => peer,
        onSignalingMessage: (_, _) {},
        onStateChange: () {},
      );
      await manager.join(clientOperationId: 'first');
      await manager.handleJoin('peer');
      peer.failureStage = 'remote';
      await manager.handleAnswer('peer', {'sdp': 'sdp', 'type': 'answer'});
      expect(peer.closes, 1);
      await manager.dispose();
      expect(peer.closes, 1);
    },
  );

  test('late old offer failure cannot close its replacement', () async {
    final pending = Completer<RTCSessionDescription>();
    final started = Completer<void>();
    final old = _Peer()
      ..offer = () {
        started.complete();
        return pending.future;
      };
    final current = _Peer();
    var calls = 0;
    final manager = VoiceChatManager(
      loadIceServers: () async => _iceServers,
      acquireMicrophone: () async => _Stream(),
      createConnection: (_) async => calls++ == 0 ? old : current,
      onSignalingMessage: (_, _) {},
      onStateChange: () {},
    );
    await manager.join(clientOperationId: 'first');
    final first = manager.handleJoin('peer');
    await started.future;
    await manager.handleJoin('peer');
    pending.completeError(StateError('old offer failed'));
    await first;
    expect(old.closes, 1);
    expect(current.closes, 0);
    await manager.dispose();
  });

  for (final failClose in [false, true]) {
    test(
      'peer departure refreshes participant count despite close failure=$failClose',
      () async {
        final peer = _Peer()..failClose = failClose;
        final counts = <int>[];
        late VoiceChatManager manager;
        manager = VoiceChatManager(
          loadIceServers: () async => _iceServers,
          acquireMicrophone: () async => _Stream(),
          createConnection: (_) async => peer,
          onSignalingMessage: (_, _) {},
          onStateChange: () => counts.add(manager.participantCount),
        );
        await manager.join(clientOperationId: 'first');
        await manager.handleJoin('peer');
        final retained = peer.onConnectionState!;
        retained(RTCPeerConnectionState.RTCPeerConnectionStateConnected);
        expect(counts, [1, 2]);
        if (failClose) {
          await expectLater(manager.handleLeave('peer'), throwsStateError);
        } else {
          await manager.handleLeave('peer');
        }
        expect(counts, [1, 2, 1]);
        retained(RTCPeerConnectionState.RTCPeerConnectionStateClosed);
        await manager.handleLeave('peer');
        expect(counts, [1, 2, 1]);
        expect(peer.closes, 1);
        await manager.dispose();
      },
    );
  }

  test(
    'participant removal is visible while peer close remains pending',
    () async {
      final pending = Completer<void>();
      final started = Completer<void>();
      final peer = _Peer()
        ..closeOperation = () {
          started.complete();
          return pending.future;
        };
      final counts = <int>[];
      late VoiceChatManager manager;
      manager = VoiceChatManager(
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => _Stream(),
        createConnection: (_) async => peer,
        onSignalingMessage: (_, _) {},
        onStateChange: () => counts.add(manager.participantCount),
      );
      await manager.join(clientOperationId: 'first');
      await manager.handleJoin('peer');
      peer.onConnectionState!(
        RTCPeerConnectionState.RTCPeerConnectionStateConnected,
      );
      final leaving = manager.handleLeave('peer');
      await started.future;
      try {
        expect(counts, [1, 2, 1]);
      } finally {
        pending.complete();
        await leaving;
        await manager.dispose();
      }
    },
  );

  for (final closeFails in [false, true]) {
    test(
      'notification failure cannot prevent peer close, closeFails=$closeFails',
      () async {
        final closeError = StateError('close failure');
        final notificationError = StateError('notification failure');
        final peer = _Peer()
          ..closeOperation = () async {
            if (closeFails) throw closeError;
          };
        var failNotification = false;
        final manager = VoiceChatManager(
          loadIceServers: () async => _iceServers,
          acquireMicrophone: () async => _Stream(),
          createConnection: (_) async => peer,
          onSignalingMessage: (_, _) {},
          onStateChange: () {
            if (failNotification) throw notificationError;
          },
        );
        await manager.join(clientOperationId: 'first');
        await manager.handleJoin('peer');
        peer.onConnectionState!(
          RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        );
        failNotification = true;
        await expectLater(
          manager.handleLeave('peer'),
          throwsA(same(closeFails ? closeError : notificationError)),
        );
        expect(peer.closes, 1);
        expect(manager.participantCount, 1);
        await manager.dispose();
      },
    );
  }

  test('join validates ICE servers before announcing voice presence', () async {
    final signals = <String>[];
    var stateChanges = 0;
    final manager = VoiceChatManager(
      onSignalingMessage: (type, _) => signals.add(type),
      loadIceServers: () async => const [],
      onStateChange: () => stateChanges += 1,
    );

    await expectLater(
      manager.join(clientOperationId: 'voice-join-1'),
      throwsA(isA<StateError>()),
    );

    expect(manager.isConnected, isFalse);
    expect(manager.participantCount, 0);
    expect(signals, isEmpty);
    expect(stateChanges, 0);
  });
}

const _iceServers = [
  IceServerInfo(urls: ['stun:example.test'], username: '', credential: ''),
];

VoiceChatManager _manager(
  List<String> signals,
  Future<MediaStream> Function() acquire, {
  void Function()? onStateChange,
}) => VoiceChatManager(
  onSignalingMessage: (type, data) =>
      signals.add('$type:${data['client_operation_id']}'),
  loadIceServers: () async => _iceServers,
  onStateChange: onStateChange ?? () {},
  acquireMicrophone: acquire,
);

class _Stream extends MediaStream {
  _Stream() : super('test-stream', 'test');
  final track = _Track();
  int disposals = 0;
  Future<void> Function()? onDispose;
  @override
  List<MediaStreamTrack> getTracks() => [track];
  @override
  Future<void> dispose() async {
    disposals++;
    await onDispose?.call();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Track implements MediaStreamTrack {
  int stops = 0;
  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SignalingSpy extends VoiceChatManager {
  _SignalingSpy({void Function(String, Map<String, dynamic>)? onSignal})
    : super(
        loadIceServers: () async => _iceServers,
        acquireMicrophone: () async => _Stream(),
        onSignalingMessage: onSignal ?? (_, _) {},
        onStateChange: () {},
      );
  final received = <String>[];
  @override
  Future<void> handleJoin(String fromId) async {
    received.add('join:$fromId');
  }

  @override
  Future<void> handleOffer(String fromId, Map<String, dynamic> data) async {
    received.add('offer:$fromId');
  }

  @override
  Future<void> handleAnswer(String fromId, Map<String, dynamic> data) async {
    received.add('answer:$fromId');
  }

  @override
  Future<void> handleCandidate(String fromId, Map<String, dynamic> data) async {
    received.add('candidate:$fromId');
  }

  @override
  Future<void> handleLeave(String fromId) async {
    received.add('leave:$fromId');
  }
}

class _Peer extends RTCPeerConnection {
  final candidates = <String?>[];
  @override
  Future<void> addCandidate(RTCIceCandidate candidate) async {
    candidates.add(candidate.candidate);
  }

  bool failClose = false;
  Future<void> Function()? closeOperation;
  String? failureStage;
  int closes = 0;
  int offers = 0;
  int localDescriptions = 0;
  Future<RTCSessionDescription> Function()? offer;
  @override
  Future<void> close() async {
    closes++;
    await closeOperation?.call();
    if (failClose) throw StateError('close failed');
  }

  @override
  Future<RTCSessionDescription> createOffer([
    Map<String, dynamic>? constraints,
  ]) async {
    offers++;
    if (failureStage == 'offer') throw StateError('offer failed');
    return offer != null
        ? await offer!()
        : RTCSessionDescription('sdp', 'offer');
  }

  @override
  Future<void> setLocalDescription(RTCSessionDescription description) async {
    localDescriptions++;
    if (failureStage == 'local') throw StateError('local description failed');
  }

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    if (failureStage == 'remote') throw StateError('remote description failed');
  }

  @override
  Future<RTCSessionDescription> createAnswer([
    Map<String, dynamic>? constraints,
  ]) async {
    if (failureStage == 'answer') throw StateError('answer failed');
    return RTCSessionDescription('sdp', 'answer');
  }

  @override
  Future<RTCRtpSender> addTrack(
    MediaStreamTrack track, [
    MediaStream? stream,
  ]) async {
    if (failureStage == 'track') throw StateError('track failed');
    return _Sender();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Sender implements RTCRtpSender {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
