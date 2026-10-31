import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:synctv_app/features/room/application/subtitle_source.dart';
import 'package:synctv_app/features/room/domain/media_document_parsing.dart';

final class HttpSubtitleSource implements SubtitleSource {
  const HttpSubtitleSource();

  @override
  Future<Uint8List?> load(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async {
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) return null;
    // Subtitle documents are untrusted; reject oversized bodies at fetch.
    if (response.bodyBytes.length > maxSubtitleDocumentBytes) {
      throw const SubtitleDocumentTooLargeException();
    }
    return response.bodyBytes;
  }
}
