import 'package:flutter_test/flutter_test.dart';

import '../../support/room_watch_cursor_checks.dart';

void main() {
  for (final check in roomWatchCursorChecks.entries) {
    test(check.key, check.value);
  }
}
