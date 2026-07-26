import 'package:flutter/foundation.dart';

abstract interface class PictureInPictureController {
  ValueListenable<bool> get active;

  bool get available;

  bool get supportsWindowDragging;

  Future<bool> initialize();

  Future<bool> enter({required double aspectRatio});

  Future<void> exit({bool restoreDesktopBounds = true});

  void startDragging();
}
