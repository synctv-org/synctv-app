/// True fullscreen access for the platform the app runs on.
///
/// On web this drives the browser Fullscreen API on the document element;
/// on desktop builds it toggles the OS window's fullscreen state; on mobile
/// platforms it is a no-op, where the fullscreen player route alone covers
/// the screen. Non-web targets compile against `true_fullscreen_io.dart`.
library;

export 'true_fullscreen_io.dart'
    if (dart.library.js_interop) 'true_fullscreen_web.dart';
