import 'dart:async';

import 'p2p_media_runtime.dart';

/// Owns an engine across asynchronous creation and room lifetime changes.
final class P2pMediaEngineOwner {
  P2pMediaPlaybackEngine? _current;
  Future<P2pMediaPlaybackEngine?>? _pending;
  Object _generation = Object();
  bool _closed = false;

  P2pMediaPlaybackEngine? get current => _current;

  Future<P2pMediaPlaybackEngine?> acquire(
    Future<P2pMediaPlaybackEngine> Function() create,
  ) {
    if (_closed) return Future.value();
    final current = _current;
    if (current != null) return Future.value(current);
    final pending = _pending;
    if (pending != null) return pending;
    final completion = Completer<P2pMediaPlaybackEngine?>();
    _pending = completion.future;
    unawaited(
      _create(
        create,
        _generation,
      ).then(completion.complete, onError: completion.completeError),
    );
    return completion.future;
  }

  Future<P2pMediaPlaybackEngine?> _create(
    Future<P2pMediaPlaybackEngine> Function() create,
    Object generation,
  ) async {
    try {
      // Await synchronous failures too, so cleanup follows pending assignment.
      final engine = await Future.sync(create);
      if (_closed || !identical(generation, _generation)) {
        await engine.dispose();
        return null;
      }
      _current = engine;
      return engine;
    } finally {
      if (identical(generation, _generation)) _pending = null;
    }
  }

  /// Transfers the current engine to the caller for ordered disposal.
  /// Any pending creation from this generation will dispose its own result.
  P2pMediaPlaybackEngine? takeCurrent() {
    _generation = Object();
    _pending = null;
    final engine = _current;
    _current = null;
    return engine;
  }

  /// Stops accepting engines immediately; the caller takes the current engine.
  void close() {
    _closed = true;
  }
}
