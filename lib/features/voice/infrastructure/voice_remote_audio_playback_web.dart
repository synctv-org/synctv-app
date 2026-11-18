import 'dart:js_interop';

import 'package:dart_webrtc/dart_webrtc.dart'
    show MediaStreamTrackWeb, MediaStreamWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web/web.dart' as web;

import 'voice_remote_audio_playback.dart';

/// Browser sink for received voice audio: a hidden `HTMLAudioElement` per
/// remote peer, `srcObject` bound to the peer's remote `MediaStream`.
///
/// Browsers stay silent for remote WebRTC tracks until they are attached to
/// a media element (the WebRTC stack performs no implicit playback), which
/// is exactly the Flutter-Web symptom of synctv-org/synctv-app#138. Native
/// platforms need none of this, so their factory returns a no-op sink.
final class WebVoiceRemoteAudioPlayback implements VoiceRemoteAudioPlayback {
  WebVoiceRemoteAudioPlayback();

  final Map<String, web.HTMLAudioElement> _elements = {};
  double _volume = 1.0;
  bool _unlockArmed = false;

  @override
  Future<void> attach(String remoteId, RTCTrackEvent event) async {
    try {
      final jsStream = _remoteStreamOf(event);
      if (jsStream == null) {
        debugPrint('Voice remote audio: no usable stream from $remoteId');
        return;
      }
      final audio = _elements.putIfAbsent(remoteId, () {
        final element = web.HTMLAudioElement()
          ..id = 'synctv-voice-remote-$remoteId'
          ..autoplay = true;
        web.document.body?.append(element);
        return element;
      });
      // The m-line stream object is stable across renegotiations on the
      // same peer; only rebind when a different stream arrives.
      if (audio.srcObject != jsStream) {
        audio.srcObject = jsStream;
      }
      _applyVolume(audio);
      _startPlayback(audio);
    } catch (error) {
      debugPrint('Voice remote audio attach failed for $remoteId: $error');
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume;
    for (final audio in _elements.values.toList()) {
      try {
        _applyVolume(audio);
      } catch (_) {
        // A dead element is cleaned up by its own lifecycle path.
      }
    }
  }

  @override
  Future<void> remove(String remoteId) async {
    final audio = _elements.remove(remoteId);
    if (audio == null) return;
    _teardownElement(audio);
    if (_elements.isEmpty) _disarmUnlock();
  }

  @override
  Future<void> dispose() async {
    for (final audio in _elements.values.toList()) {
      _teardownElement(audio);
    }
    _elements.clear();
    _disarmUnlock();
  }

  /// The stream the SDP m-line carries (MSID), or a fresh stream wrapping
  /// the received track when signaling omitted the stream id.
  web.MediaStream? _remoteStreamOf(RTCTrackEvent event) {
    if (event.streams.isNotEmpty) {
      final stream = event.streams.first;
      if (stream is MediaStreamWeb) return stream.jsStream;
    }
    final track = event.track;
    if (track is MediaStreamTrackWeb) {
      return web.MediaStream(<web.MediaStreamTrack>[track.jsTrack].toJS);
    }
    return null;
  }

  /// HTMLMediaElement.volume must stay inside 0..1 while the voice slider
  /// allows up to 2.0 (native stacks handle the boost themselves).
  void _applyVolume(web.HTMLAudioElement audio) {
    audio.volume = _volume.clamp(0.0, 1.0).toDouble();
  }

  /// Fire-and-forget playback start: the browser's play promise may stay
  /// pending for a live stream that has not produced audio yet, so the
  /// element's binding must never wait on it.
  void _startPlayback(web.HTMLAudioElement audio) {
    audio.play().toDart.then(
      (_) {},
      // Autoplay policy: start muted (always permitted), then unmute on
      // the first user gesture. Joining voice is itself a click, so this
      // path only guards permission-prompt corner cases.
      onError: (_) {
        audio.muted = true;
        audio.play().toDart.then(
          (_) {},
          onError: (Object error) {
            debugPrint('Voice remote audio cannot start: $error');
          },
        );
        _armUnlock();
      },
    );
  }

  void _armUnlock() {
    if (_unlockArmed) return;
    _unlockArmed = true;
    for (final type in const ['pointerdown', 'keydown', 'touchstart']) {
      web.window.addEventListener(type, _onUnlockGesture.toJS);
    }
  }

  void _disarmUnlock() {
    if (!_unlockArmed) return;
    _unlockArmed = false;
    for (final type in const ['pointerdown', 'keydown', 'touchstart']) {
      web.window.removeEventListener(type, _onUnlockGesture.toJS);
    }
  }

  void _onUnlockGesture(web.Event _) {
    _disarmUnlock();
    for (final audio in _elements.values.toList()) {
      audio.muted = false;
      _startPlayback(audio);
    }
  }

  void _teardownElement(web.HTMLAudioElement audio) {
    try {
      audio.pause();
      audio.srcObject = null;
      audio.remove();
    } catch (_) {
      // The element is out of the map either way; a stale DOM node is
      // collected with the document.
    }
  }
}

/// Entry point picked by
/// [voice_remote_audio_playback_factory](../voice_remote_audio_playback_factory.dart).
VoiceRemoteAudioPlayback createVoiceRemoteAudioPlayback() =>
    WebVoiceRemoteAudioPlayback();
