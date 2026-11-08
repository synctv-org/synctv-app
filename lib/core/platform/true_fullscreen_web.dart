/// True fullscreen via the browser Fullscreen API for the web build.
///
/// Flutter web renders to a single canvas, so fullscreen is requested on the
/// document element: the browser expands the whole app, and the fullscreen
/// player route on top fills it.
library;

import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web targets always support browser fullscreen.
const bool supportsTrueFullscreen = true;

/// The app surface (the browser viewport) always fills as the player's
/// fullscreen container on web.
const bool supportsSurfaceFullScreen = true;

/// Requests fullscreen for the whole document.
///
/// Must be called from a user-gesture handler; browsers reject the request
/// otherwise. Returns whether the browser accepted it.
Future<bool> requestTrueFullscreen() async {
  try {
    final element = web.document.documentElement;
    if (element == null) return false;
    await element.requestFullscreen().toDart;
    return true;
  } catch (_) {
    return false;
  }
}

/// Exits fullscreen; a no-op when it is not active.
Future<void> exitTrueFullscreen() async {
  try {
    if (web.document.fullscreenElement == null) return;
    await web.document.exitFullscreen().toDart;
  } catch (_) {
    // The browser may have exited fullscreen on its own (Esc).
  }
}

/// Whether the document is currently presented in fullscreen.
bool isTrueFullscreenActive() => web.document.fullscreenElement != null;
