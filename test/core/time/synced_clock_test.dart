import 'package:flutter_test/flutter_test.dart';

import '../../support/synced_clock_checks.dart';

void main() {
  for (final check in syncedClockChecks.entries) {
    test(check.key, check.value);
  }
}
