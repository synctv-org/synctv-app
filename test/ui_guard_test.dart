import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/check_ui_guard.dart' as ui_guard;

void main() {
  test('business UI uses app component wrappers', () {
    expect(ui_guard.checkUiGuard(), 0);
  });

  for (final constructor in [
    'CircularProgressIndicator()',
    'CircularProgressIndicator.adaptive()',
  ]) {
    test('UI guard catches $constructor', () {
      final directory = Directory.systemTemp.createTempSync('ui-guard-');
      addTearDown(() => directory.deleteSync(recursive: true));
      File('${directory.path}/loading.dart')
          .writeAsStringSync('final loading = $constructor;');
      expect(ui_guard.checkUiGuard([directory.path]), 1);
    });
  }

  test('loading guard permits wrappers and ignores comments and strings', () {
    final directory = Directory.systemTemp.createTempSync('ui-guard-');
    addTearDown(() => directory.deleteSync(recursive: true));
    File('${directory.path}/loading.dart').writeAsStringSync('''
final loading = AppLoadingIndicator();
// CircularProgressIndicator.adaptive()
/* CircularProgressIndicator.adaptive() */
final label = 'CircularProgressIndicator.adaptive()';
''');
    expect(ui_guard.checkUiGuard([directory.path]), 0);
  });
}
