import 'package:flutter_test/flutter_test.dart';

import '../../../../support/playback_expiry_checks.dart';

void main() {
  for (final check in playbackExpiryChecks.entries) {
    test(check.key, check.value);
  }
}
