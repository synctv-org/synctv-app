/// Shared value formatters for bytes, timestamps, and durations used
/// across presentation surfaces.
library;

/// Formats [bytes] with binary (1024-based) units, keeping one decimal
/// below 100 and dropping it at or above 100 of the active unit.
String formatBytes(num bytes) {
  const units = ['B', 'KiB', 'MiB', 'GiB', 'TiB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(unit == 0 || value >= 100 ? 0 : 1)} ${units[unit]}';
}

/// Formats epoch [seconds] as `yyyy-MM-dd HH:mm` in the local zone;
/// non-positive values render as a dash.
String formatTimestampSeconds(int seconds) {
  if (seconds <= 0) return '-';
  final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
