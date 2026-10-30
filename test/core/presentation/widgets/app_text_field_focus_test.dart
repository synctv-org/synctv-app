import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

import '../../../test_app.dart';

Widget _app(Widget child) {
  return MaterialApp(
    locale: const Locale('zh'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: buildThemedTestApp,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('AppTextField keeps focus across keyboard inset changes', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _app(
        Center(
          child: AppTextField(
            controller: controller,
            focusNode: focusNode,
            label: 'Username',
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue, reason: 'tap must focus the field');

    tester.view.viewInsets = const FakeViewPadding(bottom: 301);
    await tester.pumpAndSettle();
    expect(
      focusNode.hasFocus,
      isTrue,
      reason: 'keyboard insets must not drop focus',
    );

    await tester.enterText(find.byType(TextFormField), 'hello');
    expect(controller.text, 'hello');

    tester.view.reset();
    await tester.pumpAndSettle();
  });

  testWidgets('AppTextField keeps focus when a rebuild lands right after tap', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _app(
        Center(
          child: AppTextField(
            controller: controller,
            focusNode: focusNode,
            label: 'Chat',
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);
    await tester.pumpAndSettle();
    expect(
      focusNode.hasFocus,
      isTrue,
      reason: 'rebuild after focus must keep focus',
    );
  });

  testWidgets(
    'AppTextField keeps focus and keyboard on touch tap outside (Android)',
    (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _app(
          Center(
            child: SizedBox(
              width: 220,
              child: AppTextField(
                controller: controller,
                focusNode: focusNode,
                label: 'Username',
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);
      expect(tester.testTextInput.isVisible, isTrue);

      final touch = await tester.startGesture(
        const Offset(8, 8),
        kind: PointerDeviceKind.touch,
      );
      await touch.up();
      await tester.pumpAndSettle();

      expect(
        focusNode.hasFocus,
        isTrue,
        reason: 'touch taps outside a field must not drop focus on Android',
      );
      expect(
        tester.testTextInput.isVisible,
        isTrue,
        reason: 'touch taps outside a field must not close the keyboard',
      );
    },
  );

  testWidgets('AppTextField drops focus on mouse click outside (Android)', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _app(
        Center(
          child: SizedBox(
            width: 220,
            child: AppTextField(
              controller: controller,
              focusNode: focusNode,
              label: 'Username',
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(8, 8));
    await mouse.down(const Offset(8, 8));
    await mouse.up();
    await tester.pumpAndSettle();

    expect(
      focusNode.hasFocus,
      isFalse,
      reason: 'mouse clicks outside a field must drop focus',
    );
  });
}
