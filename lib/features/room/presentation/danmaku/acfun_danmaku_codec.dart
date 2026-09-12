import 'dart:convert';
import 'dart:ui';

import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';

// Duration stores microseconds. Reserve eight seconds for the comment lifetime
// while keeping the result within JavaScript's exact integer range.
const _maxPositionMs = 9007199254740 - 8000;

List<DanmakuItem>? decodeAcFunDanmakuDocument(String content) {
  final Object? decoded;
  try {
    decoded = jsonDecode(content);
  } on FormatException {
    return null;
  }
  if (decoded is! Map<String, dynamic> || decoded['comments'] is! List) {
    return null;
  }
  final comments = decoded['comments']! as List;
  return comments
      .whereType<Map>()
      .map((value) => _decodeComment(Map<String, dynamic>.from(value)))
      .whereType<DanmakuItem>()
      .toList();
}

DanmakuItem? _decodeComment(Map<String, dynamic> value) {
  final text = value['text']?.toString().trim() ?? '';
  final positionMs = _integer(value['positionMs']);
  if (text.isEmpty ||
      positionMs == null ||
      positionMs < 0 ||
      positionMs > _maxPositionMs) {
    return null;
  }
  final mode = _integer(value['mode']) ?? 1;
  final type = switch (mode) {
    4 => DanmakuType.bottom,
    5 => DanmakuType.top,
    _ => DanmakuType.floating,
  };
  final startTime = Duration(milliseconds: positionMs);
  return DanmakuItem(
    text: text,
    startTime: startTime,
    endTime:
        startTime +
        (type == DanmakuType.floating
            ? const Duration(seconds: 8)
            : const Duration(seconds: 4)),
    color: _color(value['color']),
    fontSize: (_integer(value['size']) ?? 25).clamp(12, 64).toDouble(),
    type: type,
  );
}

int? _integer(Object? value) {
  return switch (value) {
    num number when number.isFinite => number.toInt(),
    String text => int.tryParse(text),
    _ => null,
  };
}

Color _color(Object? value) {
  final raw = value?.toString().trim().replaceFirst('#', '') ?? '';
  final rgb = int.tryParse(raw, radix: 16);
  return Color(0xFF000000 | ((rgb ?? 0xFFFFFF) & 0xFFFFFF));
}
