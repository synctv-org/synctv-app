import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_message_edit_form.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  testWidgets('message edits validate before closing and submit trimmed text', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: buildThemedTestApp,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await AppDialogs.showStyledDialog<String>(
                  context: context,
                  title: 'Edit message',
                  icon: const Icon(Icons.edit_outlined),
                  content: const ChatMessageEditForm(
                    initialContent: 'Original',
                  ),
                  actions: const [],
                );
              },
              child: const Text('Edit'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Original'), findsOneWidget);
    await tester.enterText(find.byType(AppTextField), '   ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter message content'), findsOneWidget);
    expect(result, isNull);
    await tester.enterText(find.byType(AppTextField), '  Revised message  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(result, 'Revised message');
    expect(find.byType(ChatMessageEditForm), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('failed save retains draft and successful retry closes', (
    tester,
  ) async {
    var calls = 0;
    final pending = Completer<void>();
    await openEditor(tester, (content) async {
      calls++;
      expect(content, 'Revised');
      if (calls == 1) await pending.future;
    });
    await tester.enterText(find.byType(AppTextField), '  Revised  ');
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(calls, 1);
    expect(find.byType(ChatMessageEditForm), findsOneWidget);
    pending.completeError(StateError('version conflict'));
    await tester.pumpAndSettle();
    expect(find.byType(ChatMessageEditForm), findsOneWidget);
    expect(find.text('  Revised  '), findsOneWidget);
    expect(find.textContaining('version conflict'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.byType(ChatMessageEditForm), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'late save completion after cancel does not pop underlying route',
    (tester) async {
      final pending = Completer<void>();
      await openEditor(tester, (_) => pending.future);
      await tester.enterText(find.byType(AppTextField), 'Revised');
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsOneWidget);
      expect(find.byType(ChatMessageEditForm), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> openEditor(
  WidgetTester tester,
  Future<void> Function(String) save,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: buildThemedTestApp,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => AppDialogs.showStyledDialog<String>(
              context: context,
              title: 'Edit message',
              icon: const Icon(Icons.edit_outlined),
              content: ChatMessageEditForm(
                initialContent: 'Original',
                onSave: save,
              ),
              actions: const [],
            ),
            child: const Text('Edit'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Edit'));
  await tester.pumpAndSettle();
}
