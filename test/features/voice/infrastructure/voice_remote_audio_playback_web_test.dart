@TestOn('browser')
library;

import 'package:dart_webrtc/dart_webrtc.dart' show MediaStreamWeb;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_remote_audio_playback_factory.dart';
import 'package:web/web.dart' as web;

class _StubTrack implements MediaStreamTrack {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// The exact shape the manager hands the sink: the m-line stream from the
/// SDP, wrapped in flutter_webrtc's web adapter.
RTCTrackEvent _eventFor(web.MediaStream jsStream) => RTCTrackEvent(
  track: _StubTrack(),
  streams: [MediaStreamWeb(jsStream, 'voice-test')],
);

web.HTMLAudioElement? _elementOf(String remoteId) =>
    web.document.querySelector('#synctv-voice-remote-$remoteId')
        as web.HTMLAudioElement?;

void main() {
  test(
    'attach binds the remote stream to an autoplaying audio element',
    () async {
      final sink = createVoiceRemoteAudioPlayback();
      addTearDown(sink.dispose);

      final jsStream = web.MediaStream();
      await sink.attach('peer1', _eventFor(jsStream));

      final audio = _elementOf('peer1');
      expect(
        audio,
        isNotNull,
        reason: 'the audio element must live in the DOM',
      );
      expect(audio!.autoplay, isTrue);
      expect(
        audio.srcObject,
        jsStream,
        reason: 'srcObject is the remote stream',
      );
    },
  );

  test(
    'volume follows the session level but never exceeds the element cap',
    () async {
      final sink = createVoiceRemoteAudioPlayback();
      addTearDown(sink.dispose);

      await sink.attach('peer1', _eventFor(web.MediaStream()));
      final audio = _elementOf('peer1')!;

      // The session slider allows up to 2.0 (native boost); HTMLMediaElement
      // throws above 1.0, so the sink must clamp.
      await sink.setVolume(1.5);
      expect(audio.volume, 1.0);
      await sink.setVolume(0.25);
      expect(audio.volume, 0.25);
      await sink.setVolume(2.0);
      expect(audio.volume, 1.0);
    },
  );

  test('remove releases one peer while dispose clears everything', () async {
    final sink = createVoiceRemoteAudioPlayback();

    await sink.attach('peer1', _eventFor(web.MediaStream()));
    await sink.attach('peer2', _eventFor(web.MediaStream()));
    final peer1 = _elementOf('peer1')!;
    expect(_elementOf('peer2'), isNotNull);

    await sink.remove('peer1');
    expect(_elementOf('peer1'), isNull, reason: 'element leaves the DOM');
    expect(peer1.srcObject, isNull);
    expect(_elementOf('peer2'), isNotNull);

    await sink.dispose();
    expect(_elementOf('peer2'), isNull);
  });
}
