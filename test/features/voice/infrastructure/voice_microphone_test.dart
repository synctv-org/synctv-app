import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_microphone.dart';

void main() {
  test('successful acquisition transfers stream ownership to caller', () async {
    final stream = _Stream([_Track()]);
    expect(
      await acquireVoiceMicrophone(request: () async => stream),
      same(stream),
    );
    expect(stream.disposeCount, 0);
    expect(stream.tracks.single.stopCount, 0);
  });

  test('acquisition failure preserves the original error', () async {
    final error = StateError('permission denied');
    await expectLater(
      acquireVoiceMicrophone(request: () => Future.error(error)),
      throwsA(same(error)),
    );
  });

  for (final stopFails in [false, true]) {
    test(
      'timeout releases late stream despite track failure=$stopFails',
      () async {
        final pending = Completer<MediaStream>();
        final stream = _Stream([_Track(fail: stopFails), _Track()]);
        await expectLater(
          acquireVoiceMicrophone(
            request: () => pending.future,
            timeout: Duration.zero,
          ),
          throwsA(isA<TimeoutException>()),
        );
        pending.complete(stream);
        for (var i = 0; i < 4; i++) {
          await Future<void>.delayed(Duration.zero);
        }
        expect(stream.tracks.map((track) => track.stopCount), [1, 1]);
        expect(stream.disposeCount, 1);
      },
    );
  }

  test('late acquisition error does not escape after timeout', () async {
    final pending = Completer<MediaStream>();
    await expectLater(
      acquireVoiceMicrophone(
        request: () => pending.future,
        timeout: Duration.zero,
      ),
      throwsA(isA<TimeoutException>()),
    );
    pending.completeError(StateError('late denial'));
    await Future<void>.delayed(Duration.zero);
  });

  test('late stream disposal failure does not escape', () async {
    final pending = Completer<MediaStream>();
    final stream = _Stream([_Track()], failDispose: true);
    await expectLater(
      acquireVoiceMicrophone(
        request: () => pending.future,
        timeout: Duration.zero,
      ),
      throwsA(isA<TimeoutException>()),
    );
    pending.complete(stream);
    for (var i = 0; i < 4; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(stream.disposeCount, 1);
  });
}

class _Stream extends MediaStream {
  _Stream(this.tracks, {this.failDispose = false})
    : super('test-stream', 'test');
  final List<_Track> tracks;
  final bool failDispose;
  int disposeCount = 0;
  @override
  List<MediaStreamTrack> getTracks() => tracks;
  @override
  Future<void> dispose() async {
    disposeCount++;
    if (failDispose) throw StateError('dispose failure');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Track implements MediaStreamTrack {
  _Track({this.fail = false});
  final bool fail;
  int stopCount = 0;
  @override
  Future<void> stop() async {
    stopCount++;
    if (fail) throw StateError('stop failure');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
