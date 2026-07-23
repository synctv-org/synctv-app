import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';

import 'test_app.dart';

void main() {
  testWidgets('required server setup cannot close without an active server', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FLocalizations.delegate,
        ],
        builder: buildThemedTestApp,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showServerSettingsDialog(
                context: context,
                requireServer: true,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final doneButton = tester.widget<AppActionButton>(
      find.widgetWithText(AppActionButton, 'Done'),
    );
    expect(doneButton.onPressed, isNull);

    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.text('Server address'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Server address'), findsOneWidget);
  });
}
