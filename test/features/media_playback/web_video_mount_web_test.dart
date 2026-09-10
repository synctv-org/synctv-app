@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';

import '../../support/web_video_mount_checks.dart';

void main() {
  for (final scenario in webVideoMountChecks) {
    test(scenario, () => runWebVideoMountCheck(scenario));
  }
}
