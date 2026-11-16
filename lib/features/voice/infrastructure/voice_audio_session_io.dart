import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceAudioSession {
  static Future<void> stopPlaying() async {
    debugPrint('VoiceAudioSession: stopPlaying called');
  }

  static Future<void> setVoiceCallMode(bool enabled) async {
    debugPrint('VoiceAudioSession: setVoiceCallMode $enabled');
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    try {
      if (Platform.isAndroid) {
        // Keep the WebRTC audio manager in media mode. Communication mode
        // (the plugin default once a peer connection opens) excludes
        // Bluetooth playback and reroutes the whole app to the loudspeaker,
        // which cut off headphone users as soon as voice chat started
        // (synctv-org/synctv#547). Media mode preserves the user's playback
        // route; echo cancellation falls back to the software pipeline.
        if (enabled) {
          await Helper.setAndroidAudioConfiguration(
            AndroidAudioConfiguration(
              manageAudioFocus: false,
              androidAudioMode: AndroidAudioMode.normal,
              androidAudioAttributesUsageType:
                  AndroidAudioAttributesUsageType.media,
              androidAudioAttributesContentType:
                  AndroidAudioAttributesContentType.speech,
              androidAudioStreamType: AndroidAudioStreamType.music,
            ),
          );
        }
        return;
      }

      final session = await AudioSession.instance;
      if (enabled) {
        // iOS: defaultToSpeaker keeps the loudspeaker as the fallback while
        // Bluetooth and wired outputs stay eligible for the voice session.
        await session.configure(
          const AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
            avAudioSessionCategoryOptions:
                AVAudioSessionCategoryOptions.defaultToSpeaker,
            avAudioSessionMode: AVAudioSessionMode.voiceChat,
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
