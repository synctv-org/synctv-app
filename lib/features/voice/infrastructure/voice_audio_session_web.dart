import 'package:flutter/foundation.dart';

class VoiceAudioSession {
  static Future<void> stopPlaying() async {
    debugPrint('VoiceAudioSession: stopPlaying called');
  }

  static Future<void> setVoiceCallMode(bool enabled) async {
    // Browser WebRTC owns audio routing and exposes no AudioSession API.
    debugPrint('VoiceAudioSession: browser mode $enabled');
  }
}
