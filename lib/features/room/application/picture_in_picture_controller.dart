import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

abstract interface class PictureInPictureController {
  ValueListenable<bool> get active;

  bool get available;

  bool get supportsWindowDragging;

  bool get usesCompactApplicationSurface;

  Future<bool> initialize();

  Future<bool> enter({
    required double aspectRatio,
    VideoPlayerController? videoController,
  });

  Future<void> exit({bool restoreDesktopBounds = true});

  void startDragging();
}
