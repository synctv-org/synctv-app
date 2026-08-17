import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:synctv_app/features/room/application/danmaku_source.dart';

final class HttpDanmakuSource implements DanmakuSource {
  const HttpDanmakuSource();

  @override
  Future<String?> loadDocument(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async {
    final requestHeaders = <String, String>{
      ...headers,
      HttpHeaders.acceptEncodingHeader: 'identity',
    };
    final client = IOClient(HttpClient()..autoUncompress = false);
    try {
      final response = await client.get(uri, headers: requestHeaders);
      if (response.statusCode != 200) return null;
      return utf8.decode(_decodeDocumentBytes(response), allowMalformed: true);
    } finally {
      client.close();
    }
  }

  List<int> _decodeDocumentBytes(http.Response response) {
    final bytes = response.bodyBytes;
    return switch (response.headers[HttpHeaders.contentEncodingHeader]
        ?.trim()
        .toLowerCase()) {
      'deflate' => _decodeDeflate(bytes),
      'gzip' => gzip.decode(bytes),
      _ => _decodeUnlabelledCompressedBytes(bytes),
    };
  }

  List<int> _decodeDeflate(List<int> bytes) {
    try {
      return ZLibDecoder().convert(bytes);
    } on FormatException {
      return ZLibDecoder(raw: true).convert(bytes);
    }
  }

  List<int> _decodeUnlabelledCompressedBytes(List<int> bytes) {
    try {
      utf8.decode(bytes);
      return bytes;
    } on FormatException {
      try {
        return _decodeDeflate(bytes);
      } on FormatException {
        try {
          return gzip.decode(bytes);
        } on FormatException {
          return bytes;
        }
      }
    }
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
