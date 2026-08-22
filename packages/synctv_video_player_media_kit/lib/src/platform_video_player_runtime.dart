import 'video_player_runtime.dart';

const bool usesPlatformWebVideoPlayerRuntime = false;
const bool browserPictureInPictureAvailable = false;

VideoPlayerRuntime createPlatformWebVideoPlayerRuntime(int textureId) {
  throw UnsupportedError('The Web video runtime is unavailable');
}
