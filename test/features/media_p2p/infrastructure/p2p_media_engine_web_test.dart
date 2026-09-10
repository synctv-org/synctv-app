@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';

import '../../../support/p2p_web_lifecycle_checks.dart';
import '../../../support/p2p_web_request_checks.dart';
import '../../../support/p2p_web_pending_request_checks.dart';

void main() {
  for (final scenario in p2pWebLifecycleChecks) {
    test(scenario, () => runP2pWebLifecycleCheck(scenario));
  }
  for (final scenario in p2pWebRequestChecks) {
    test(scenario, () => runP2pWebRequestCheck(scenario));
  }
  for (final scenario in p2pWebPendingRequestChecks) {
    test(scenario, () => runP2pWebPendingRequestCheck(scenario));
  }
}
