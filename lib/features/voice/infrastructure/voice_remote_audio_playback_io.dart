import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'voice_remote_audio_playback.dart';

/// Native stacks play received audio through the platform audio device by
/// themselves; nothing to attach, so every operation is a no-op.
final class NativeVoiceRemoteAudioPlayback implements VoiceRemoteAudioPlayback {
  const NativeVoiceRemoteAudioPlayback();

  @override
  Future<void> attach(String remoteId, RTCTrackEvent event) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> remove(String remoteId) async {}
  @override
  Future<void> dispose() async {}
}

/// Entry point picked by
/// [voice_remote_audio_playback_factory](../voice_remote_audio_playback_factory.dart).
VoiceRemoteAudioPlayback createVoiceRemoteAudioPlayback() =>
    const NativeVoiceRemoteAudioPlayback();
