/// True fullscreen via the OS window for desktop targets.
///
/// Mobile targets are a no-op: there is no window to expand and the
/// fullscreen player route alone covers the screen. The web build replaces
/// this through the conditional export in `true_fullscreen.dart`.
library;

import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

bool get _isDesktopPlatform =>
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.linux;

/// Whether the running platform has a window that can enter true fullscreen.
bool get supportsTrueFullscreen => _isDesktopPlatform;

/// Whether the app surface (the app window on desktop) can fill as the
/// player's fullscreen container.
bool get supportsSurfaceFullScreen => _isDesktopPlatform;

/// Expands the OS window to cover the display; a no-op on mobile.
///
/// Returns whether the window is fullscreen afterwards.
Future<bool> requestTrueFullscreen() async {
  if (!_isDesktopPlatform) return false;
  final window = WindowManager.instance.getCurrent();
  if (window == null) return false;
  if (window.isFullScreen) return true;
  window.isFullScreen = true;
  return true;
}

/// Restores the OS window; a no-op when it is not fullscreen or on mobile.
Future<void> exitTrueFullscreen() async {
  if (!_isDesktopPlatform) return;
  final window = WindowManager.instance.getCurrent();
  if (window == null) return;
  if (window.isFullScreen) window.isFullScreen = false;
}

/// Whether the OS window is currently fullscreen.
bool isTrueFullscreenActive() {
  if (!_isDesktopPlatform) return false;
  final window = WindowManager.instance.getCurrent();
  return window?.isFullScreen ?? false;
}
