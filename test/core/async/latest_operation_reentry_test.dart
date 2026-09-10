import 'package:flutter_test/flutter_test.dart';

import '../../support/latest_operation_checks.dart';

void main() {
  for (final check in latestOperationChecks.entries) {
    test(check.key, check.value);
  }
}
