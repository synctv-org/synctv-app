import 'dart:typed_data';

abstract interface class SubtitleSource {
  Future<Uint8List?> load(Uri uri, {Map<String, String> headers = const {}});
}

/// A subtitle document exceeded the size cap.
final class SubtitleDocumentTooLargeException implements Exception {
  const SubtitleDocumentTooLargeException();

  @override
  String toString() => 'Subtitle document exceeds the size cap';
}
