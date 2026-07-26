import 'dart:typed_data';

abstract interface class SubtitleSource {
  Future<Uint8List?> load(Uri uri, {Map<String, String> headers = const {}});
}
