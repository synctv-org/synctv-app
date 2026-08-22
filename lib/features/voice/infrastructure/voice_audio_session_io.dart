import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

class VoiceAudioSession {
  static Future<void> stopPlaying() async {
    debugPrint('VoiceAudioSession: stopPlaying called');
  }

  static Future<void> setVoiceCallMode(bool enabled) async {
    debugPrint('VoiceAudioSession: setVoiceCallMode $enabled');
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    try {
      final session = await AudioSession.instance;
      if (enabled) {
        await session.configure(
          const AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
            avAudioSessionCategoryOptions:
                AVAudioSessionCategoryOptions.defaultToSpeaker,
            avAudioSessionMode: AVAudioSessionMode.voiceChat,
            androidAudioAttributes: AndroidAudioAttributes(
              contentType: AndroidAudioContentType.speech,
              usage: AndroidAudioUsage.voiceCommunication,
              flags: AndroidAudioFlags.audibilityEnforced,
            ),
            androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
          ),
        );
      } else {
        await session.configure(const AudioSessionConfiguration.music());
      }
    } catch (e) {
      debugPrint('Error configuring AudioSession: $e');
    }
  }
}
