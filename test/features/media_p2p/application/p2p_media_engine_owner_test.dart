import 'package:flutter_test/flutter_test.dart';

import '../../../support/p2p_engine_owner_checks.dart';

void main() {
  for (final scenario in p2pEngineOwnerChecks) {
    test(scenario, () => runP2pEngineOwnerCheck(scenario));
  }
}
