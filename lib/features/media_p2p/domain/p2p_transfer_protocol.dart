import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

class P2pPermitPool {
  P2pPermitPool(this.capacity) : assert(capacity > 0);

  final int capacity;
  final Queue<Completer<void>> _waiters = Queue();
  int _active = 0;
  bool _closed = false;

  int get active => _active;
  int get queued => _waiters.length;

  Future<bool> acquire({Future<void>? cancelled}) async {
    if (_closed) throw StateError('P2P permit pool is closed');
    if (_active < capacity) {
      _active++;
      return true;
    }
    final waiter = Completer<void>();
    _waiters.add(waiter);
    if (cancelled == null) {
      await waiter.future;
      return true;
    }
    final acquired = await Future.any<bool>([
      waiter.future.then((_) => true),
      cancelled.then((_) => false),
    ]);
    if (acquired) return true;
    if (_waiters.remove(waiter)) return false;
    if (waiter.isCompleted) release();
    return false;
  }

  void release() {
    if (_active <= 0) throw StateError('P2P permit pool is already empty');
    if (_waiters.isNotEmpty) {
      _waiters.removeFirst().complete();
    } else {
      _active--;
    }
  }

  void close() {
    if (_closed) return;
    _closed = true;
    while (_waiters.isNotEmpty) {
      _waiters.removeFirst().completeError(
        StateError('P2P permit pool is closed'),
      );
    }
  }
}

class P2pIncomingTransfer {
  final Completer<Uint8List?> _completer = Completer<Uint8List?>();
  final List<Uint8List> _chunks = [];
  int? _expectedLength;
  int _receivedBytes = 0;
  Completer<void> _activity = Completer<void>();

  bool get isCompleted => _completer.isCompleted;

  void _notifyActivity() {
    if (!_activity.isCompleted) _activity.complete();
  }

  void begin(int length) {
    _expectedLength = length;
    _notifyActivity();
  }

  void add(Uint8List chunk, int maxBytes) {
    if (_completer.isCompleted) return;
    _receivedBytes += chunk.length;
    if (_receivedBytes > maxBytes) {
      completeInvalid();
      return;
    }
    _chunks.add(chunk);
    _notifyActivity();
  }

  void complete() {
    if (_completer.isCompleted) return;
    final builder = BytesBuilder(copy: false);
    for (final chunk in _chunks) {
      builder.add(chunk);
    }
    final bytes = builder.takeBytes();
    if (bytes.length != _expectedLength) {
      _completer.completeError(const FormatException('Invalid P2P piece'));
      _notifyActivity();
      return;
    }
    _completer.complete(bytes);
    _notifyActivity();
  }

  void completeMissing() {
    if (!_completer.isCompleted) _completer.complete(null);
    _notifyActivity();
  }

  void completeInvalid() {
    if (!_completer.isCompleted) {
      _completer.completeError(const FormatException('Invalid P2P piece'));
      _notifyActivity();
    }
  }

  Future<Uint8List?> wait({
    required Duration idleTimeout,
    required Duration completionBudget,
  }) async {
    final deadline = DateTime.now().add(completionBudget);
    while (!_completer.isCompleted) {
      final remaining = deadline.difference(DateTime.now());
      if (remaining <= Duration.zero) {
        throw TimeoutException('P2P transfer budget exceeded');
      }
      final activity = _activity;
      final wait = remaining < idleTimeout ? remaining : idleTimeout;
      await activity.future.timeout(wait);
      if (identical(activity, _activity)) _activity = Completer<void>();
    }
    return _completer.future;
  }
}
