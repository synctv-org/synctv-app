import 'package:fixnum/fixnum.dart';

import 'decimal_int64.dart';

/// Legacy opaque versions have no numeric replay cursor.
Int64? parseEventSequence(String version) {
  final decimal = normalizeInt64Decimal(version, allowZero: true);
  return decimal == null ? null : Int64.parseInt(decimal);
}
