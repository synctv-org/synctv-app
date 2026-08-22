import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'playback_client_profile_native.dart'
    if (dart.library.js_interop) 'playback_client_profile_web.dart'
    as platform;

client.PlaybackClientProfile defaultPlaybackClientProfile() {
  return platform.buildPlaybackClientProfile();
}

bool supportsP2pMediaLoader() {
  return platform.supportsP2pMediaLoader();
}
