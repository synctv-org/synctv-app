import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/content_reports/presentation/report_filters_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  for (final language in ['en', 'zh']) {
    for (final width in [320.0, 1200.0]) {
      testWidgets('report filters remain editable at $language/3x/$width', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, width == 320 ? 568 : 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        ContentReportFilters? result;
        await _open(
          tester,
          locale: Locale(language),
          textScale: 3,
          onResult: (value) => result = value,
        );
        final l10n = AppLocalizations.of(
          tester.element(find.byType(ReportFiltersDialog)),
        );
        expect(find.byType(AppTextField), findsNWidgets(7));
        final reporter = _input(l10n.reportFilterReporterId);
        await tester.ensureVisible(reporter);
        await tester.enterText(reporter, '  usr_reporter  ');
        final message = _input(l10n.reportFilterMessageId);
        await tester.ensureVisible(message);
        await tester.enterText(message, ' 42 ');
        await tester.ensureVisible(find.text(l10n.apply));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text(l10n.apply));
        await tester.pumpAndSettle();
        expect(result?.reporterUserId, 'usr_reporter');
        expect(result?.targetChatMessageId, '42');
        expect(result?.targetUserId, isEmpty);
        expect(find.byType(ReportFiltersDialog), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('room filters expose supported fields and validate message IDs', (
    tester,
  ) async {
    ContentReportFilters? result;
    await _open(tester, roomScoped: true, onResult: (value) => result = value);
    expect(find.byType(AppTextField), findsNWidgets(2));
    final message = _input('Message ID');
    for (final invalid in [
      'abc',
      '-1',
      '0',
      '1.5',
      '0x10',
      '9223372036854775808',
    ]) {
      await tester.enterText(message, invalid);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(
        find.text('Enter a message ID from 1 to 9223372036854775807'),
        findsOneWidget,
      );
      expect(result, isNull);
    }
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(
      find.text('Enter a message ID from 1 to 9223372036854775807'),
      findsNothing,
    );
    await tester.enterText(_input('Reported member user ID'), ' usr_member ');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(result?.targetMemberUserId, 'usr_member');
    expect(result?.targetChatMessageId, '0');
    expect(result?.reporterUserId, isEmpty);
  });

  for (final id in ['9007199254740993', '9223372036854775807']) {
    testWidgets('message filter preserves exact ID $id', (tester) async {
      ContentReportFilters? result;
      await _open(
        tester,
        roomScoped: true,
        onResult: (value) => result = value,
      );
      await tester.enterText(_input('Message ID'), ' 00$id ');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(result?.targetChatMessageId, id);
      expect(find.byType(ReportFiltersDialog), findsNothing);
    });
  }

  testWidgets('retained apply does not pop a covering route', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    var completions = 0;
    await _open(tester, navigator: navigator, onResult: (_) => completions++);
    final apply = tester
        .widgetList<AppActionButton>(find.byType(AppActionButton))
        .singleWhere((button) => button.label == 'Apply')
        .onPressed!;
    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Covering page')),
      ),
    );
    await tester.pumpAndSettle();
    apply();
    await tester.pumpAndSettle();
    expect(find.text('Covering page'), findsOneWidget);
    expect(completions, 0);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(completions, 1);
  });
}

Finder _input(String label) => find.descendant(
  of: find.widgetWithText(AppTextField, label),
  matching: find.byType(TextField),
);

Future<void> _open(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  double textScale = 1,
  bool roomScoped = false,
  GlobalKey<NavigatorState>? navigator,
  ValueChanged<ContentReportFilters?>? onResult,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigator,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => buildThemedTestApp(
        context,
        MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: AppActionButton(
            label: 'Open',
            onPressed: () async {
              final result = await showAppDialog<ContentReportFilters>(
                context: context,
                builder: (_) => ReportFiltersDialog(
                  initialFilters: const ContentReportFilters(),
                  roomScoped: roomScoped,
                ),
              );
              onResult?.call(result);
            },
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
