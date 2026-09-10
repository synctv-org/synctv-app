import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final kind in ['success', 'error', 'warning', 'enabled', 'disabled']) {
    testWidgets('$kind toast text meets normal-text contrast', (tester) async {
      addTearDown(AppNotifications.dismissAll);
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      switch (kind) {
        case 'success':
          AppNotifications.showSuccess(context, 'Status message');
        case 'error':
          AppNotifications.showError(context, 'Status message');
        case 'warning':
          AppNotifications.showWarning(context, 'Status message');
        default:
          AppNotifications.showToggle(
            context,
            'Status message',
            isEnabled: kind == 'enabled',
          );
      }
      await tester.pumpAndSettle();
      final foreground = tester
          .widget<Text>(find.text('Status message'))
          .style!
          .color!;
      final background = tester
          .widget<AppPanelSurface>(find.byType(AppPanelSurface))
          .color!;
      final a = foreground.computeLuminance();
      final b = background.computeLuminance();
      final contrast = ((a > b ? a : b) + 0.05) / ((a > b ? b : a) + 0.05);
      expect(contrast, greaterThanOrEqualTo(4.5));
      AppNotifications.dismissAll();
      await tester.pump();
    });
  }
  for (final details in [false, true]) {
    for (final interaction in ['hover', 'focus', 'both']) {
      testWidgets('toast pauses for $interaction, details=$details', (
        tester,
      ) async {
        addTearDown(AppNotifications.dismissAll);
        late BuildContext context;
        final outsideFocus = FocusNode();
        addTearDown(outsideFocus.dispose);
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return Scaffold(
                  body: TextButton(
                    focusNode: outsideFocus,
                    onPressed: () {},
                    child: const Text('Outside'),
                  ),
                );
              },
            ),
          ),
        );
        final message = details
            ? List.filled(10, 'Preview error').join('\n')
            : 'Preview message';
        AppNotifications.showInfo(
          context,
          message,
          action: details
              ? null
              : SnackBarAction(label: 'Retry', onPressed: () {}),
        );
        await tester.pumpAndSettle();
        final control = details
            ? find.byIcon(Icons.open_in_full_rounded)
            : find.text('Retry');
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        if (interaction != 'focus') {
          await mouse.moveTo(tester.getCenter(control));
        }
        if (interaction != 'hover') {
          Focus.of(tester.element(control)).requestFocus();
        }
        await tester.pump();
        await tester.pump(const Duration(seconds: 10));
        expect(find.text(message), findsOneWidget);
        if (interaction != 'focus') {
          await mouse.moveTo(Offset.zero);
        }
        if (interaction == 'both') {
          await tester.pump();
          await tester.pump(const Duration(seconds: 10));
          expect(find.text(message), findsOneWidget);
        }
        if (interaction != 'hover') {
          outsideFocus.requestFocus();
        }
        await tester.pump();
        await tester.pump(const Duration(seconds: 2));
        expect(find.text(message), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        expect(find.text(message), findsNothing);
        if (interaction == 'both') {
          AppNotifications.showInfo(
            context,
            message,
            action: details
                ? null
                : SnackBarAction(label: 'Retry', onPressed: () {}),
          );
          await tester.pumpAndSettle();
          await mouse.moveTo(tester.getCenter(control));
          Focus.of(tester.element(control)).requestFocus();
          await tester.pump();
          AppNotifications.showSuccess(context, 'Replacement');
          await tester.pump();
          await mouse.moveTo(Offset.zero);
          outsideFocus.requestFocus();
          await tester.pump();
          await tester.pump(const Duration(seconds: 3));
          expect(find.text('Replacement'), findsNothing);
        }
      });
    }
  }
  testWidgets('resizing a focused details toast to passive resumes expiry', (
    tester,
  ) async {
    addTearDown(AppNotifications.dismissAll);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(3)),
          child: child!,
        ),
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold();
          },
        ),
      ),
    );
    const message = 'Read this message now.';
    AppNotifications.showInfo(context, message);
    await tester.pumpAndSettle();
    final details = find.byIcon(Icons.open_in_full_rounded);
    expect(details, findsOneWidget);
    Focus.of(tester.element(details)).requestFocus();
    await tester.pump();
    await tester.pump(const Duration(seconds: 10));
    expect(find.text(message), findsOneWidget);
    tester.view.physicalSize = const Size(1200, 900);
    await tester.pump();
    expect(details, findsNothing);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text(message), findsNothing);
  });
  for (final mode in ['action', 'details', 'passive']) {
    testWidgets('accessible notification timeout policy: $mode', (
      tester,
    ) async {
      final accessible = ValueNotifier(false);
      addTearDown(accessible.dispose);
      addTearDown(AppNotifications.dismissAll);
      late BuildContext context;
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ValueListenableBuilder<bool>(
            valueListenable: accessible,
            builder: (context, value, _) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(accessibleNavigation: value),
              child: child!,
            ),
          ),
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final message = mode == 'details'
          ? List.filled(10, 'Preview error').join('\n')
          : 'Preview message';
      void show() => AppNotifications.showInfo(
        context,
        message,
        action: mode == 'action'
            ? SnackBarAction(label: 'Retry', onPressed: () => calls++)
            : null,
      );
      show();
      await tester.pumpAndSettle();
      accessible.value = true;
      await tester.pump();
      await tester.pump(const Duration(seconds: 10));
      if (mode == 'passive') {
        expect(find.text(message), findsNothing);
      } else {
        expect(find.text(message), findsOneWidget);
        final close = find.byWidgetPredicate(
          (widget) => widget is AppIconButton && widget.tooltip == 'Close',
        );
        final staleClose = tester.widget<AppIconButton>(close).onPressed!;
        await tester.tap(close);
        await tester.pump();
        expect(find.text(message), findsNothing);
        show();
        await tester.pumpAndSettle();
        staleClose();
        await tester.pump();
        expect(find.text(message), findsOneWidget);
        accessible.value = false;
        await tester.pump();
        await tester.pump(const Duration(seconds: 2));
        expect(find.text(message), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        expect(find.text(message), findsNothing);
        accessible.value = true;
        show();
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 10));
        if (mode == 'action') {
          await tester.tap(find.text('Retry'));
          await tester.pump();
          expect(calls, 1);
          expect(find.text(message), findsNothing);
        }
      }
      AppNotifications.dismissAll();
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('replaced toast cannot open stale details', (tester) async {
    addTearDown(AppNotifications.dismissAll);
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold();
          },
        ),
      ),
    );
    AppNotifications.showError(
      context,
      List.filled(10, 'Preview error').join('\n'),
    );
    await tester.pumpAndSettle();
    final open = tester
        .widget<AppIconButton>(find.byType(AppIconButton))
        .onPressed!;
    AppNotifications.showSuccess(context, 'Replacement');
    open();
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsNothing);
    expect(find.text('Replacement'), findsOneWidget);
    AppNotifications.dismissAll();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'zh']) {
    for (final size in [
      const Size(1200, 900),
      const Size(320, 568),
      const Size(740, 320),
    ]) {
      for (final hasAction in [false, true]) {
        testWidgets('long toast details $locale/$size/action=$hasAction', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(size);
          addTearDown(() => tester.binding.setSurfaceSize(null));
          addTearDown(AppNotifications.dismissAll);
          late BuildContext context;
          var calls = 0;
          final message = List.filled(
            8,
            locale == 'en'
                ? 'The preview server could not verify this request.'
                : '预览服务器未能验证此请求，请检查连接后重试。',
          ).join('\n');
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(3),
                  viewInsets: EdgeInsets.only(
                    bottom: size.width == 320 ? 200 : 0,
                  ),
                ),
                child: child!,
              ),
              home: Builder(
                builder: (value) {
                  context = value;
                  return const Scaffold();
                },
              ),
            ),
          );
          AppNotifications.showError(
            context,
            message,
            action: hasAction
                ? SnackBarAction(label: 'Retry', onPressed: () => calls++)
                : null,
          );
          await tester.pumpAndSettle();
          final details = find.byWidgetPredicate(
            (widget) =>
                widget is AppIconButton &&
                widget.tooltip == context.l10n.details,
          );
          await tester.ensureVisible(details);
          await tester.pumpAndSettle();
          expect(details.hitTestable(), findsOneWidget);
          final detailsBounds = tester.getRect(details);
          expect(detailsBounds.top, greaterThanOrEqualTo(16));
          expect(
            detailsBounds.bottom,
            lessThanOrEqualTo(size.height - (size.width == 320 ? 216 : 70)),
          );
          final open = tester.widget<AppIconButton>(details).onPressed!;
          await tester.tap(details);
          await tester.pumpAndSettle();
          open();
          expect(find.byType(AppDialog), findsOneWidget);
          final selectable = find.byType(AppSelectableText);
          expect(tester.widget<AppSelectableText>(selectable).data, message);
          await tester.pump(const Duration(seconds: 4));
          expect(selectable, findsOneWidget);
          if (hasAction) {
            final action = tester
                .widget<AppActionButton>(
                  find.ancestor(
                    of: find.text('Retry'),
                    matching: find.byType(AppActionButton),
                  ),
                )
                .onPressed!;
            action();
            action();
            await tester.pumpAndSettle();
            expect(calls, 1);
          } else {
            await tester.tap(
              find.text(MaterialLocalizations.of(context).closeButtonTooltip),
            );
            await tester.pumpAndSettle();
          }
          expect(find.byType(AppDialog), findsNothing);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  for (final width in [320.0, 740.0]) {
    testWidgets('long toast action fits at $width with large text', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(AppNotifications.dismissAll);
      late BuildContext context;
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      const action = 'Restore the deleted playlist';
      AppNotifications.showInfo(
        context,
        'Playlist removed from this room',
        action: SnackBarAction(label: action, onPressed: () => calls++),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final bounds = tester.getRect(find.byType(AppActionButton));
      expect(bounds.left, greaterThanOrEqualTo(24));
      expect(bounds.right, lessThanOrEqualTo(width - 24));
      expect(
        tester
            .renderObject<RenderParagraph>(find.text(action))
            .didExceedMaxLines,
        isFalse,
      );
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      expect(calls, 1);
    });
  }

  testWidgets(
    'passive toast announces status without intercepting underlying taps',
    (tester) async {
      final semantics = tester.ensureSemantics();
      late BuildContext context;
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return Scaffold(
                body: SizedBox.expand(
                  child: TextButton(
                    onPressed: () => taps++,
                    child: const Text('Underlying action'),
                  ),
                ),
              );
            },
          ),
        ),
      );
      AppNotifications.showSuccess(context, 'Status changed');
      await tester.pumpAndSettle();
      expect(
        tester
            .getSemantics(find.text('Status changed'))
            .getSemanticsData()
            .flagsCollection
            .isLiveRegion,
        isTrue,
      );
      await tester.tapAt(tester.getCenter(find.text('Status changed')));
      expect(taps, 1);
      expect(find.text('Status changed'), findsOneWidget);
      AppNotifications.dismissAll();
      await tester.pump();
      semantics.dispose();
    },
  );

  for (final replaced in [false, true]) {
    testWidgets(
      'toast action runs once and ignores stale callbacks, replaced=$replaced',
      (tester) async {
        late BuildContext context;
        var actions = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold(body: SizedBox.expand());
              },
            ),
          ),
        );
        AppNotifications.showInfo(
          context,
          'Action available',
          action: SnackBarAction(label: 'Retry', onPressed: () => actions++),
        );
        await tester.pumpAndSettle();
        final callback = tester
            .widget<AppActionButton>(find.byType(AppActionButton))
            .onPressed!;
        if (replaced) {
          AppNotifications.showSuccess(context, 'Replacement');
        } else {
          await tester.tap(find.text('Retry'));
        }
        callback();
        callback();
        await tester.pumpAndSettle();
        expect(actions, replaced ? 0 : 1);
        expect(find.text('Action available'), findsNothing);
        if (replaced) expect(find.text('Replacement'), findsOneWidget);
        AppNotifications.dismissAll();
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('toast expiry after overlay disposal is safe', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold();
          },
        ),
      ),
    );
    AppNotifications.showSuccess(context, 'Temporary');
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 4));
    AppNotifications.dismissAll();
    expect(tester.takeException(), isNull);
  });

  testWidgets('toast replaces the previous message and dismisses on time', (
    tester,
  ) async {
    late BuildContext testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );

    AppNotifications.showError(
      testContext,
      'old error',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('old error'), findsOneWidget);

    AppNotifications.showSuccess(
      testContext,
      'new success',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('old error'), findsNothing);
    expect(find.text('new success'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('new success'), findsNothing);
  });

  testWidgets('toast replaces an entry before its first frame', (tester) async {
    late BuildContext testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );

    AppNotifications.showError(testContext, 'same-frame error');
    AppNotifications.showSuccess(testContext, 'same-frame success');
    await tester.pump();

    expect(find.text('same-frame error'), findsNothing);
    expect(find.text('same-frame success'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('same-frame success'), findsNothing);
  });

  testWidgets('toast uses the root overlay across route changes', (
    tester,
  ) async {
    late BuildContext rootContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            rootContext = context;
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const Scaffold(body: Text('next page')),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            );
          },
        ),
      ),
    );

    AppNotifications.showError(
      rootContext,
      'route error',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('route error'), findsOneWidget);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('next page'), findsOneWidget);

    AppNotifications.showInfo(
      rootContext,
      'replacement',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('route error'), findsNothing);
    expect(find.text('replacement'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('replacement'), findsNothing);
  });
}
