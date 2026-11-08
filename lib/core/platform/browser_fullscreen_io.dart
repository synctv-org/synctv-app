/// Stub Fullscreen API helpers for non-web targets.
///
/// The web implementation replaces these through the conditional export in
/// `browser_fullscreen.dart`.
library;

/// Requests fullscreen for the whole document. Never succeeds off the web;
/// the player route still opens as ordinary web fullscreen.
Future<bool> requestBrowserFullscreen() async => false;

/// Exits browser fullscreen; a no-op off the web.
Future<void> exitBrowserFullscreen() async {}

/// Whether the document is currently presented in browser fullscreen.
bool isBrowserFullscreenActive() => false;
