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
