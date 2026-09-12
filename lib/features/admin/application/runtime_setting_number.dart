enum _IntegerFormat { uint32, int64, uint64 }

// Matches the numeric fields in the runtime settings protobuf patches.
const _integerFormats = {
  'roomDefaults.defaultMaxMembers': _IntegerFormat.int64,
  'roomDefaults.defaultMaxChatMessages': _IntegerFormat.uint64,
  'roomCreation.maxRoomsPerUser': _IntegerFormat.int64,
  'email.smtpPort': _IntegerFormat.uint32,
  'webrtc.maxVoiceParticipantsPerRoom': _IntegerFormat.uint32,
  'chat.maxMessagesPerRoom': _IntegerFormat.uint64,
  'chat.maxPinnedMessagesPerRoom': _IntegerFormat.uint64,
  'chat.messageRetentionDays': _IntegerFormat.int64,
  'playbackHistory.retentionDays': _IntegerFormat.uint32,
  'playbackHistory.maxEntriesPerRoom': _IntegerFormat.int64,
};

bool isIntegerRuntimeSetting(String section, String key) =>
    _integerFormats.containsKey('$section.$key');

Object? parseRuntimeSettingNumber(String section, String key, String text) {
  final raw = text.trim();
  final format = _integerFormats['$section.$key'];
  if (format == null) {
    final value = num.tryParse(raw);
    return value != null && value.isFinite ? value : null;
  }
  final value = BigInt.tryParse(raw, radix: 10);
  if (value == null) return null;
  final (minimum, maximum) = switch (format) {
    _IntegerFormat.uint32 => (BigInt.zero, (BigInt.one << 32) - BigInt.one),
    _IntegerFormat.int64 => (
      -(BigInt.one << 63),
      (BigInt.one << 63) - BigInt.one,
    ),
    _IntegerFormat.uint64 => (BigInt.zero, (BigInt.one << 64) - BigInt.one),
  };
  if (value < minimum || value > maximum) return null;
  return format == _IntegerFormat.uint32 ? value.toInt() : value.toString();
}
