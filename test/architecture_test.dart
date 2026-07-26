import 'package:flutter_test/flutter_test.dart';

import '../tool/check_architecture.dart' as architecture;
import '../tool/generate_feature_gateways.dart' as gateways;

void main() {
  test('source dependencies follow the application architecture', () {
    expect(architecture.checkArchitecture(), 0);
  });

  test('generated feature gateways match their checked-in manifest', () {
    expect(
      () => gateways.generateFeatureGateways(check: true),
      returnsNormally,
    );
  });
}
