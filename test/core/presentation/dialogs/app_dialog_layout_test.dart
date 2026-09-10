import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  for (final locale in ['en', 'zh']) {
    for (final width in [320.0, 1200.0]) {
      testWidgets('styled header uses readable width at 3x $locale $width', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final title = locale == 'en'
            ? 'Confirm this room configuration change'
            : '确认修改房间配置';
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(3)),
              child: buildThemedTestApp(context, child),
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => AppDialogs.showStyledDialog<void>(
                    context: context,
                    title: title,
                    icon: const Icon(Icons.settings_outlined),
                    content: const Text('Changes'),
                    actions: [AppDialogs.createCancelButton(context)],
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final frameWidth = tester
            .getSize(find.byType(AppSingleChildScrollView))
            .width;
        expect(
          tester.getSize(find.text(title)).width,
          greaterThan(frameWidth - 80),
        );
        final close = find.widgetWithIcon(AppIconButton, Icons.close_rounded);
        expect(close.hitTestable(), findsOneWidget);
        expect(
          tester.getBottomLeft(close).dy,
          lessThan(tester.getTopLeft(find.text(title)).dy),
        );
        await tester.tap(close);
        await tester.pumpAndSettle();
        expect(find.byType(AppDialogFrame), findsNothing);
      });
    }
  }

  testWidgets('styled dialog remains usable in a short large-text viewport', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 240));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(3)),
          child: buildThemedTestApp(context, child),
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => AppDialogs.showStyledDialog<void>(
                context: context,
                title: 'Confirm this room configuration change',
                icon: const Icon(Icons.settings_outlined),
                content: const Text('Changes'),
                actions: [AppDialogs.createCancelButton(context)],
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester
          .renderObject<RenderParagraph>(
            find.text('Confirm this room configuration change'),
          )
          .didExceedMaxLines,
      isFalse,
    );
    await tester.ensureVisible(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AppDialogFrame), findsNothing);
  });

  for (final label in ['Open browser', 'Save changes and continue']) {
    for (final scale in [1.0, 3.0]) {
      testWidgets('dialog action shows full $label at ${scale}x', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var confirmed = 0;
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: buildThemedTestApp(context, child),
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => AppDialogs.showStyledDialog<void>(
                    context: context,
                    title: 'Save',
                    icon: const Icon(Icons.save_outlined),
                    content: const Text('Changes'),
                    actions: [
                      AppDialogs.createCancelButton(context),
                      AppDialogs.createConfirmButton(context, () {
                        confirmed++;
                        Navigator.of(context).pop();
                      }, text: label),
                    ],
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        for (final confirm in [false, true]) {
          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          for (final text in [label, 'Cancel']) {
            await tester.ensureVisible(find.text(text));
            await tester.pumpAndSettle();
            final paragraph = tester.renderObject<RenderParagraph>(
              find.text(text),
            );
            expect(paragraph.didExceedMaxLines, isFalse, reason: text);
            final button = find.ancestor(
              of: find.text(text),
              matching: find.byType(AppActionButton),
            );
            expect(
              tester
                  .getRect(button)
                  .contains(tester.getCenter(find.text(text))),
              isTrue,
            );
            expect(find.text(text).hitTestable(), findsOneWidget);
          }
          await tester.ensureVisible(find.text(confirm ? label : 'Cancel'));
          await tester.pumpAndSettle();
          await tester.tap(find.text(confirm ? label : 'Cancel'));
          await tester.pumpAndSettle();
          expect(find.text('Changes'), findsNothing);
          expect(confirmed, confirm ? 1 : 0);
        }
      });
    }
  }

  for (final confirm in [false, true]) {
    testWidgets(
      '${confirm ? "confirm" : "form"} dialog fits a phone keyboard',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                viewInsets: const EdgeInsets.only(bottom: 250),
                textScaler: TextScaler.linear(1.5),
              ),
              child: buildThemedTestApp(context, child),
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showAppDialog<void>(
                    context: context,
                    builder: (context) => confirm
                        ? AppConfirmDialog(
                            title: 'Confirm this room configuration change',
                            content: Text('A detailed explanation. ' * 30),
                            onConfirm: () => Navigator.pop(context),
                          )
                        : AppDialog(
                            title: const Text('Change this room configuration'),
                            body: SizedBox(
                              width: 480,
                              child: Text('A detailed explanation. ' * 30),
                            ),
                            actions: [
                              AppActionButton(
                                onPressed: () => Navigator.pop(context),
                                label: 'Save',
                              ),
                            ],
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
        expect(tester.takeException(), isNull);
        expect(find.byType(Scrollable), findsOneWidget);
        final action = find.text(confirm ? 'Confirm' : 'Save');
        expect(action.hitTestable(), findsOneWidget);
        expect(tester.getBottomRight(action).dy, lessThan(318));
        await tester.tap(action);
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      },
    );
  }
}
