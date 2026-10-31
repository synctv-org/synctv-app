abstract interface class DanmakuSource {
  Future<String?> loadDocument(
    Uri uri, {
    Map<String, String> headers = const {},
  });

  Stream<String> openEventStream(
    Uri uri, {
    Map<String, String> headers = const {},
  });
}

final class DanmakuAccessExpiredException implements Exception {
  const DanmakuAccessExpiredException();
}

final class DanmakuAccessDeniedException implements Exception {
  const DanmakuAccessDeniedException();
}

/// A danmaku document exceeded the post-decompression size cap.
final class DanmakuDocumentTooLargeException implements Exception {
  const DanmakuDocumentTooLargeException();

  @override
  String toString() => 'Danmaku document exceeds the size cap';
}
