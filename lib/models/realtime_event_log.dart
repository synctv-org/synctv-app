import 'dart:convert';

class RealtimeEventLogEntry {
  final DateTime timestamp;
  final String direction;
  final String label;
  final String detail;
  final int byteLength;
  final Object? payload;

  const RealtimeEventLogEntry({
    required this.timestamp,
    required this.direction,
    required this.label,
    this.detail = '',
    this.byteLength = 0,
    this.payload,
  });

  factory RealtimeEventLogEntry.incoming({
    required String label,
    String detail = '',
    int byteLength = 0,
    Object? payload,
  }) {
    return RealtimeEventLogEntry(
      timestamp: DateTime.now(),
      direction: 'in',
      label: label,
      detail: detail,
      byteLength: byteLength,
      payload: payload,
    );
  }

  factory RealtimeEventLogEntry.outgoing({
    required String label,
    String detail = '',
    int byteLength = 0,
    Object? payload,
  }) {
    return RealtimeEventLogEntry(
      timestamp: DateTime.now(),
      direction: 'out',
      label: label,
      detail: detail,
      byteLength: byteLength,
      payload: payload,
    );
  }

  String get timeLabel {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  String get groupKey => '$direction:$label';

  Map<String, Object?> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'direction': direction,
      'label': label,
      'detail': detail,
      'byte_length': byteLength,
      'payload': payload,
    };
  }

  String payloadPreview() {
    final value = payload;
    if (value == null) return detail;
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }
}

String realtimeEnumName(Object value) {
  final raw = value.toString();
  final dot = raw.lastIndexOf('.');
  return dot >= 0 ? raw.substring(dot + 1) : raw;
}
