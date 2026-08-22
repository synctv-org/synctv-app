import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';

import 'src/cancellable_media_kit_video_player.dart';

export 'src/cancellable_media_kit_video_player.dart'
    show
        AdaptiveVideoTrackController,
        BrowserPictureInPictureController,
        CancellableMediaKitVideoPlayer,
        syncTvVideoFormatHeader;
export 'src/video_player_runtime.dart'
    show
        AdaptiveVideoTrackInfo,
        AdaptiveVideoTrackRuntime,
        AdaptiveVideoTrackSnapshot,
        PictureInPictureRuntime,
        VideoPlayerRuntime,
        VideoPlayerRuntimeFactory;

class SyncTvVideoPlayerMediaKit {
  const SyncTvVideoPlayerMediaKit._();

  static void ensureInitialized({
    bool android = false,
    bool iOS = false,
    bool macOS = false,
    bool windows = false,
    bool linux = false,
    bool web = false,
  }) {
    final enabled = kIsWeb
        ? web
        : switch (defaultTargetPlatform) {
            TargetPlatform.android => android,
            TargetPlatform.iOS => iOS,
            TargetPlatform.macOS => macOS,
            TargetPlatform.windows => windows,
            TargetPlatform.linux => linux,
            TargetPlatform.fuchsia => false,
          };
    if (!enabled) return;
    if (!kIsWeb) MediaKit.ensureInitialized();
    CancellableMediaKitVideoPlayer.registerWith();
  }
}
