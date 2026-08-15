import 'dart:async';

/// Coalesces visible-message read cursor updates while preserving the newest
/// cursor received during an in-flight request.
final class ChatReadStateUpdater {
  ChatReadStateUpdater({required this.markRead});

  final Future<void> Function(String messageId) markRead;

  String? _pendingMessageId;
  bool _inFlight = false;
  bool _disposed = false;

  void markVisible(String messageId) {
    if (_disposed || messageId.isEmpty) return;
    _pendingMessageId = messageId;
    if (!_inFlight) unawaited(_flush());
  }

  void dispose() {
    _disposed = true;
    _pendingMessageId = null;
  }

  Future<void> _flush() async {
    if (_inFlight || _disposed) return;
    _inFlight = true;
    try {
      while (!_disposed) {
        final messageId = _pendingMessageId;
        _pendingMessageId = null;
        if (messageId == null) return;
        try {
          await markRead(messageId);
        } catch (_) {
          // The next visible message retries the cursor update.
        }
      }
    } finally {
      _inFlight = false;
      if (!_disposed && _pendingMessageId != null) {
        unawaited(_flush());
      }
    }
  }
}
