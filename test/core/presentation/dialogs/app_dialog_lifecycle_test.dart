import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

Widget _app(Widget home) => MaterialApp(
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  builder: buildThemedTestApp,
  home: home,
);

Widget _page({ValueChanged<BuildContext>? onContext}) => Scaffold(
  body: Builder(
    builder: (context) {
      onContext?.call(context);
      return TextButton(
        onPressed: () => AppDialogs.showStyledDialog<void>(
          context: context,
          title: 'Settings',
          icon: const Icon(Icons.settings_outlined),
          content: const Text('Original dialog'),
          actions: [AppDialogs.createCancelButton(context)],
        ),
        child: const Text('Open dialog'),
      );
    },
  ),
);

void main() {
  for (final confirmFirst in [false, true]) {
    for (final replacement in [false, true]) {
      testWidgets(
        'Confirm rejects stale action after ${confirmFirst ? "confirm" : "cancel"}, replacement=$replacement',
        (tester) async {
          late BuildContext pageContext;
          var confirmations = 0;
          await tester.pumpWidget(
            _app(
              Builder(
                builder: (context) {
                  pageContext = context;
                  return Scaffold(
                    body: TextButton(
                      onPressed: () => AppDialogs.showStyledDialog<void>(
                        context: context,
                        title: 'Settings',
                        icon: const Icon(Icons.settings_outlined),
                        content: const Text('Original dialog'),
                        actions: [
                          AppDialogs.createCancelButton(context),
                          AppDialogs.createConfirmButton(context, () {
                            confirmations++;
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                      child: const Text('Open'),
                    ),
                  );
                },
              ),
            ),
          );
          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();
          final callback = tester
              .widget<AppActionButton>(
                find.widgetWithText(AppActionButton, 'Confirm'),
              )
              .onPressed!;
          if (confirmFirst) {
            callback();
          } else {
            await tester.tap(find.text('Cancel'));
          }
          if (replacement) {
            showAppDialog<void>(
              context: pageContext,
              builder: (_) =>
                  const AppDialog(title: Text('Replacement'), actions: []),
            );
          }
          callback();
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(confirmations, confirmFirst ? 1 : 0);
          callback();
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(confirmations, confirmFirst ? 1 : 0);
          expect(
            find.text(replacement ? 'Replacement' : 'Open'),
            findsOneWidget,
          );
        },
      );
    }
  }

  testWidgets('Confirm permits retry while its dialog remains current', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => AppDialogs.showStyledDialog<void>(
                context: context,
                title: 'Settings',
                icon: const Icon(Icons.settings_outlined),
                content: const Text('Required field'),
                actions: [
                  AppDialogs.createConfirmButton(context, () => attempts++),
                ],
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.text('Required field'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final cancel in [false, true]) {
    for (final replacement in [false, true]) {
      testWidgets(
        '${cancel ? "Cancel" : "Close"} ignores retained callback after ${replacement ? "replacement" : "dismissal"}',
        (tester) async {
          late BuildContext pageContext;
          await tester.pumpWidget(
            _app(
              Builder(
                builder: (context) => Scaffold(
                  body: TextButton(
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) =>
                            _page(onContext: (value) => pageContext = value),
                      ),
                    ),
                    child: const Text('Open page'),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.text('Open page'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Open dialog'));
          await tester.pumpAndSettle();
          final callback = cancel
              ? tester
                    .widget<AppActionButton>(
                      find.widgetWithText(AppActionButton, 'Cancel'),
                    )
                    .onPressed!
              : tester
                    .widget<AppIconButton>(
                      find.widgetWithIcon(AppIconButton, Icons.close_rounded),
                    )
                    .onPressed!;
          callback();
          if (replacement) {
            showAppDialog<void>(
              context: pageContext,
              builder: (_) => const AppDialog(
                title: Text('Replacement'),
                body: Text('Keep this dialog open'),
                actions: [],
              ),
            );
          }
          callback();
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (replacement) {
            expect(find.text('Keep this dialog open'), findsOneWidget);
          } else {
            expect(find.text('Open dialog'), findsOneWidget);
            expect(find.text('Original dialog'), findsNothing);
          }
          callback();
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(
            find.text(replacement ? 'Keep this dialog open' : 'Open dialog'),
            findsOneWidget,
          );
        },
      );
    }
  }

  testWidgets('Cancel uses the dialog navigator with a nested caller', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Navigator(
          onGenerateRoute: (_) =>
              MaterialPageRoute<void>(builder: (_) => _page()),
        ),
      ),
    );
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Original dialog'), findsNothing);
    expect(find.text('Open dialog'), findsOneWidget);
  });
}
