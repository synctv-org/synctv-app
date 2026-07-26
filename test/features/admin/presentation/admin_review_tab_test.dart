import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';

import '../../../test_app.dart';

void main() {
  for (final testCase in <(String, Widget)>[
    ('user management', const UserManagementTab()),
    ('review', const AdminReviewTab()),
    ('provider', const AdminProviderTab()),
    ('runtime settings', const RuntimeSettingsSectionsTab()),
  ]) {
    testWidgets('${testCase.$1} initializes after localization is available', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: buildThemedTestApp,
          home: Scaffold(body: testCase.$2),
        ),
      );

      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byWidget(testCase.$2), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    });
  }
}
