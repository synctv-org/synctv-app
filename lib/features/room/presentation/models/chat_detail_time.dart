String? formatChatDetailTime(int seconds) {
  // Check seconds before multiplying to stay within DateTime's range on Web/VM.
  const maxSeconds = 8640000000000;
  if (seconds <= 0 || seconds > maxSeconds) return null;
  final time = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  return '${time.month.toString().padLeft(2, '0')}-'
      '${time.day.toString().padLeft(2, '0')} '
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}
