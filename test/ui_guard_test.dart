import 'package:flutter_test/flutter_test.dart';

import '../tool/check_ui_guard.dart' as ui_guard;

void main() {
  test('business UI uses app component wrappers', () {
    expect(ui_guard.checkUiGuard(), 0);
  });
}
