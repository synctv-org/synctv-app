import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:synctv_app/features/room/application/subtitle_source.dart';

final class HttpSubtitleSource implements SubtitleSource {
  const HttpSubtitleSource();

  @override
  Future<Uint8List?> load(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async {
    final response = await http.get(uri, headers: headers);
    return response.statusCode == 200 ? response.bodyBytes : null;
  }
}
