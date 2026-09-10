import 'dart:convert';

/// Emits complete SSE payloads intended for the danmaku consumer.
Stream<String> decodeDanmakuEvents(Stream<List<int>> bytes) async* {
  var eventType = '';
  final data = <String>[];
  await for (final line
      in bytes.transform(utf8.decoder).transform(const LineSplitter())) {
    if (line.isEmpty) {
      // Provider error messages are diagnostics, not viewer chat.
      if (data.isNotEmpty && eventType != 'error') {
        yield data.join('\n');
      }
      data.clear();
      eventType = '';
      continue;
    }
    if (line.startsWith(':')) continue;
    final colon = line.indexOf(':');
    final field = colon < 0 ? line : line.substring(0, colon);
    var value = colon < 0 ? '' : line.substring(colon + 1);
    if (value.startsWith(' ')) value = value.substring(1);
    switch (field) {
      case 'data':
        data.add(value);
      case 'event':
        eventType = value;
    }
  }
  // An unfinished event is discarded when the connection ends.
}
