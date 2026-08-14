import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';
import 'package:synctv_app/core/localization/presentation/language_selector_dialog.dart';

import '../../test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await appLocaleController.setPreference(AppLocalePreference.system);
  });

  testWidgets('selects and persists a display language', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: buildThemedTestApp,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showLanguageSelectorDialog(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Display language'), findsOneWidget);

    await tester.tap(find.text('Simplified Chinese'));
    await tester.pumpAndSettle();

    expect(
      appLocaleController.preference,
      AppLocalePreference.simplifiedChinese,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(AppLocaleController.preferenceKey),
      AppLocalePreference.simplifiedChinese.name,
    );
  });
}
