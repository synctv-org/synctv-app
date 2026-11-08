/// Fullscreen API helpers for the web build.
///
/// Flutter web renders to a single canvas, so fullscreen is requested on the
/// document element: the browser expands the whole app, and the fullscreen
/// player route on top fills it.
library;

import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Requests fullscreen for the whole document.
///
/// Must be called from a user-gesture handler; browsers reject the request
/// otherwise. Returns whether the browser accepted it.
Future<bool> requestBrowserFullscreen() async {
  try {
    final element = web.document.documentElement;
    if (element == null) return false;
    await element.requestFullscreen().toDart;
    return true;
  } catch (_) {
    return false;
  }
}

/// Exits browser fullscreen; a no-op when it is not active.
Future<void> exitBrowserFullscreen() async {
  try {
    if (web.document.fullscreenElement == null) return;
    await web.document.exitFullscreen().toDart;
  } catch (_) {
    // The browser may have exited fullscreen on its own (Esc).
  }
}

/// Whether the document is currently presented in browser fullscreen.
bool isBrowserFullscreenActive() => web.document.fullscreenElement != null;
