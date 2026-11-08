/// Browser Fullscreen API access for the web build.
///
/// Non-web targets compile against the stub in `browser_fullscreen_io.dart`;
/// the real implementation lives in `browser_fullscreen_web.dart`.
library;

export 'browser_fullscreen_io.dart'
    if (dart.library.js_interop) 'browser_fullscreen_web.dart';
