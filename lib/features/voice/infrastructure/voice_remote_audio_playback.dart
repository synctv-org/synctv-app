import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Plays the audio of received voice tracks.
///
/// Native WebRTC stacks route remote audio through the platform audio
/// device as soon as the track arrives, so playback sinks there are no-ops.
/// Browsers require the opposite: a remote [MediaStream] only becomes
/// audible when it is attached to an HTML audio element, so the web
/// implementation owns one element per remote peer.
abstract interface class VoiceRemoteAudioPlayback {
  /// Begin (or resume) playing the audio carried by a received track.
  ///
  /// Called once per newly received remote audio track; implementations
  /// must never throw — a failed attachment keeps the call running and
  /// surfaces through logs only.
  Future<void> attach(String remoteId, RTCTrackEvent event);

  /// Apply the remote-participant volume to everything playing.
  Future<void> setVolume(double volume);

  /// Stop playing and release the resources of one remote peer.
  Future<void> remove(String remoteId);

  /// Release every remote peer's resources.
  Future<void> dispose();
}
