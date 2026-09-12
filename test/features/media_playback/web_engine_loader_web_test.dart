@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';

import '../../support/web_engine_loader_checks.dart';

void main() {
  for (final scenario in webEngineLoaderChecks) {
    test(scenario, () => runWebEngineLoaderCheck(scenario));
  }
}
