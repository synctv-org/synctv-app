import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synctv_app/features/room/application/danmaku_source.dart';

final class HttpDanmakuSource implements DanmakuSource {
  const HttpDanmakuSource();

  @override
  Future<String?> loadDocument(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async {
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) return null;
    return utf8.decode(response.bodyBytes, allowMalformed: true);
  }

  @override
  Stream<String> openEventStream(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async* {
    final client = http.Client();
    try {
      final request = http.Request('GET', uri);
      request.headers
        ..addAll(headers)
        ..['Accept'] = 'text/event-stream';
      final response = await client.send(request);
      if (response.statusCode == 401) {
        throw const DanmakuAccessExpiredException();
      }
      if (response.statusCode == 403) {
        throw const DanmakuAccessDeniedException();
      }
      if (response.statusCode != 200) {
        throw HttpException(response.statusCode);
      }
      try {
        await for (final line
            in response.stream
                .transform(utf8.decoder)
                .transform(const LineSplitter())) {
          if (line.startsWith('data: ')) yield line.substring(6);
        }
      } on http.ClientException {
        // The application controller owns reconnection after an SSE response
        // closes, including transport-level response body failures.
      }
    } finally {
      client.close();
    }
  }
}

final class HttpException implements Exception {
  const HttpException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'Danmaku request failed with HTTP $statusCode';
}
