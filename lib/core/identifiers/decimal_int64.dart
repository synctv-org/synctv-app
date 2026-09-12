const _maximumInt64 = '9223372036854775807';

/// Normalizes a decimal identifier without passing through a JavaScript number.
String? normalizeInt64Decimal(String value, {bool allowZero = false}) {
  final text = value.trim();
  if (text.isEmpty) return null;
  var firstDigit = 0;
  while (firstDigit < text.length && text.codeUnitAt(firstDigit) == 48) {
    firstDigit++;
  }
  if (firstDigit == text.length) return allowZero ? '0' : null;
  // Bound significant digits before parsing or allocating an arbitrary integer.
  if (text.length - firstDigit > _maximumInt64.length) return null;
  for (var i = firstDigit; i < text.length; i++) {
    final digit = text.codeUnitAt(i);
    if (digit < 48 || digit > 57) return null;
  }
  final decimal = text.substring(firstDigit);
  if (decimal.length == _maximumInt64.length &&
      decimal.compareTo(_maximumInt64) > 0) {
    return null;
  }
  return decimal;
}
