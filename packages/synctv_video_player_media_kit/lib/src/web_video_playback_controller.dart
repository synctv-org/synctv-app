import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

class WebVideoPlaybackController {
  WebVideoPlaybackController(this.video, {required this.onError});

  final web.HTMLVideoElement video;
  final void Function(Object, StackTrace) onError;
  int _command = 0;
  int _mountRevision = 0;
  int? _pendingCommand;
  bool _wantsPlayback = false;
  bool _disposed = false;
  Completer<bool>? _mounting;
  web.ResizeObserver? _mountObserver;
  Timer? _mountTimer;

  bool get _isMounted =>
      video.isConnected && video.parentElement != web.document.body;

  // Flutter first moves this element into a detached platform-view wrapper,
  // then inserts that wrapper. A frame callback can precede the insertion.
  void prepareForMount() {
    if (_disposed) return;
    if (_pendingCommand == null && video.paused) _wantsPlayback = false;
    _finishMount(false);
    _mountRevision++;
    _mounting = Completer<bool>();
    _mountObserver = web.ResizeObserver(
      ((JSArray<web.ResizeObserverEntry> _, web.ResizeObserver observer) {
        if (_isMounted) _finishMount(true);
      }).toJS,
    )..observe(video);
    _mountTimer = Timer(const Duration(seconds: 3), () => _finishMount(false));
  }

  void _finishMount(bool attached) {
    final mounting = _mounting;
    if (mounting == null) return;
    _mounting = null;
    _mountObserver?.disconnect();
    _mountObserver = null;
    _mountTimer?.cancel();
    _mountTimer = null;
    mounting.complete(attached);
    // Reparenting can also pause playback after its original promise resolved.
    if (attached &&
        !_disposed &&
        _wantsPlayback &&
        !video.ended &&
        _pendingCommand == null) {
      unawaited(play().catchError(onError));
    }
  }

  bool _isCurrent(int command) =>
      !_disposed && _wantsPlayback && _command == command;

  Future<void> play() async {
    if (_disposed) return;
    final command = ++_command;
    final mountRevision = _mountRevision;
    final mountingAtStart = _mounting?.future;
    _wantsPlayback = true;
    _pendingCommand = command;
    try {
      try {
        await video.play().toDart;
      } catch (error) {
        if (!_isCurrent(command)) return;
        final interruptedByMount =
            error.isA<web.DOMException>() &&
            (error as web.DOMException).name == 'AbortError' &&
            (mountingAtStart != null || _mountRevision != mountRevision);
        if (!interruptedByMount) rethrow;
        final mounting = _mounting?.future ?? mountingAtStart;
        final attached = mounting == null ? _isMounted : await mounting;
        if (!_isCurrent(command)) return;
        if (!attached || !_isMounted) rethrow;
        await video.play().toDart;
      }
    } catch (error) {
      if (!_isCurrent(command)) return;
      _wantsPlayback = false;
      if (error.isA<web.DOMException>()) {
        final exception = error as web.DOMException;
        throw PlatformException(
          code: exception.name,
          message: exception.message,
        );
      }
      rethrow;
    } finally {
      if (_pendingCommand == command) _pendingCommand = null;
    }
  }

  void pause() {
    _command++;
    _wantsPlayback = false;
    _pendingCommand = null;
    video.pause();
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    pause();
    _finishMount(false);
  }
}
