@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';

import '../../../support/oauth2_web_session_checks.dart';
import '../../../support/oauth2_dispatcher_checks.dart';

void main() {
  for (final scenario in oauth2DispatcherChecks) {
    test(scenario, () => runOAuth2DispatcherCheck(scenario));
  }
  for (final scenario in oauth2WebSessionChecks) {
    test(scenario, () => runOAuth2WebSessionCheck(scenario));
  }
}
