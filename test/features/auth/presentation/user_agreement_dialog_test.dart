import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/auth/presentation/user_agreement_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  for (final covered in [true, false]) {
    testWidgets('agreement completion preserves other routes: $covered', (
      tester,
    ) async {
      bool? accepted;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: buildThemedTestApp,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  accepted = await showAppDialog<bool>(
                    context: context,
                    builder: (_) => const UserAgreementDialog(
                      agreementContent: 'A short agreement.',
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final finish = _agreeButton(tester).onPressed!;
      if (covered) {
        final context = tester.element(find.byType(UserAgreementDialog));
        unawaited(
          showAppDialog<void>(
            context: context,
            builder: (_) => const AlertDialog(title: Text('Cover')),
          ),
        );
        await tester.pumpAndSettle();
        finish();
        await tester.pumpAndSettle();
        expect(find.text('Cover'), findsOneWidget);
        expect(accepted, isNull);
        Navigator.of(tester.element(find.text('Cover'))).pop();
        await tester.pumpAndSettle();
      }
      finish();
      finish();
      await tester.pumpAndSettle();
      expect(accepted, isTrue);
      expect(find.text('Open'), findsOneWidget);
      expect(find.byType(UserAgreementDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'agreement actions remain reachable at large text and low height',
    (tester) async {
      tester.view
        ..physicalSize = const Size(320, 300)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(_app('A short agreement.'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(_agreeButton(tester).onPressed, isNotNull);
      final button = find.widgetWithText(AppActionButton, 'Agree');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      expect(button.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('short agreements allow explicit acceptance without scrolling', (
    tester,
  ) async {
    await tester.pumpWidget(_app('A short agreement.'));
    await tester.pumpAndSettle();
    expect(_agreeButton(tester).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('long agreements require reaching the end', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _app(
        List.generate(40, (i) => 'Paragraph $i. Read this term.').join('\n\n'),
      ),
    );
    await tester.pumpAndSettle();
    expect(_agreeButton(tester).onPressed, isNull);
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(_agreeButton(tester).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('replacement agreement resets reading progress', (tester) async {
    await tester.pumpWidget(_app('A short agreement.'));
    await tester.pumpAndSettle();
    expect(_agreeButton(tester).onPressed, isNotNull);
    final longContent = List.generate(40, (i) => 'New term $i.').join('\n\n');
    await tester.pumpWidget(_app(longContent));
    await tester.pumpAndSettle();
    expect(_agreeButton(tester).onPressed, isNull);
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(_agreeButton(tester).onPressed, isNotNull);
    await tester.pumpWidget(_app(longContent.replaceAll('New', 'Updated')));
    await tester.pumpAndSettle();
    expect(scrollable.position.pixels, 0);
    expect(_agreeButton(tester).onPressed, isNull);
    await tester.pumpWidget(_app('Another short agreement.'));
    await tester.pumpAndSettle();
    expect(_agreeButton(tester).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });
}

AppActionButton _agreeButton(WidgetTester tester) => tester.widget(
  find.byWidgetPredicate(
    (widget) => widget is AppActionButton && widget.label == 'Agree',
  ),
);

Widget _app(String content) => MaterialApp(
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  builder: buildThemedTestApp,
  home: Scaffold(body: UserAgreementDialog(agreementContent: content)),
);
