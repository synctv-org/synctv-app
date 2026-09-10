import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/room_member_text_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final width in [320.0, 1200.0]) {
    for (final value in ['  Updated label  ', '   ']) {
      testWidgets('member text trims "$value" and closes once at $width', (
        tester,
      ) async {
        final results = <String?>[];
        await _open(tester, width, results.add);
        expect(find.text('Initial label'), findsOneWidget);
        await tester.enterText(find.byType(TextField), value);
        final submit = tester
            .widget<AppActionButton>(
              find.widgetWithText(AppActionButton, 'Save'),
            )
            .onPressed!;
        final keyboardSubmit = tester
            .widget<AppTextField>(find.byType(AppTextField))
            .onSubmitted!;
        submit();
        keyboardSubmit(value);
        submit();
        await tester.pumpAndSettle();
        expect(results, [value.trim()]);
        expect(find.text('Editor page'), findsOneWidget);
        submit();
        keyboardSubmit(value);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('dismissed member text ignores callbacks during route exit', (
    tester,
  ) async {
    final results = <String?>[];
    await _open(tester, 320, results.add);
    final submit = tester
        .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Save'))
        .onPressed!;
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    submit();
    await tester.pumpAndSettle();
    expect(results, [null]);
    expect(find.text('Editor page'), findsOneWidget);
    submit();
    expect(tester.takeException(), isNull);
  });

  testWidgets('covered member text preserves covering route and draft', (
    tester,
  ) async {
    final results = <String?>[];
    await _open(tester, 320, results.add);
    await tester.enterText(find.byType(TextField), 'Draft');
    final submit = tester
        .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Save'))
        .onPressed!;
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    final covering = navigator.push<void>(
      MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Cover'))),
    );
    await tester.pumpAndSettle();
    submit();
    await tester.pumpAndSettle();
    expect(find.text('Cover'), findsOneWidget);
    expect(results, isEmpty);
    navigator.pop();
    await covering;
    await tester.pumpAndSettle();
    expect(find.text('Draft'), findsOneWidget);
    submit();
    await tester.pumpAndSettle();
    expect(results, ['Draft']);
    expect(find.text('Editor page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(
  WidgetTester tester,
  double width,
  ValueChanged<String?> onResult,
) async {
  await tester.binding.setSurfaceSize(Size(width, 568));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.5)),
        child: child!,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Column(
                    children: [
                      const Text('Editor page'),
                      TextButton(
                        onPressed: () async => onResult(
                          await showAppDialog<String>(
                            context: context,
                            builder: (_) => const RoomMemberTextDialog(
                              title: 'Remark name',
                              label: 'Remark name',
                              initialValue: 'Initial label',
                              icon: Icons.edit_outlined,
                            ),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Edit'));
  await tester.pumpAndSettle();
}
