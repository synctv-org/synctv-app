import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

Future<MediaStream> acquireVoiceMicrophone({
  Future<MediaStream> Function()? request,
  Duration timeout = const Duration(seconds: 12),
}) {
  final pending = request != null
      ? request()
      : navigator.mediaDevices.getUserMedia({'audio': true, 'video': false});
  var expired = false;
  // A Future timeout does not cancel the browser or native permission request.
  final owned = pending.then((stream) async {
    if (expired) await releaseVoiceMicrophone(stream);
    return stream;
  });
  return owned.timeout(
    timeout,
    onTimeout: () {
      expired = true;
      throw TimeoutException('获取麦克风权限超时，请检查系统麦克风权限', timeout);
    },
  );
}

Future<void> releaseVoiceMicrophone(MediaStream stream) async {
  try {
    await Future.wait(
      stream.getTracks().map((track) async {
        try {
          await track.stop();
        } catch (_) {
          debugPrint('Failed to stop a voice microphone track');
        }
      }),
    );
  } catch (_) {
    debugPrint('Failed to enumerate voice microphone tracks');
  } finally {
    try {
      await stream.dispose();
    } catch (_) {
      debugPrint('Failed to dispose a voice microphone stream');
    }
  }
}
