import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

void main() {
  for (final direction in TextDirection.values) {
    for (final scrollable in [false, true]) {
      testWidgets('tab arrows navigate $direction scrollable=$scrollable', (
        tester,
      ) async {
        final controller = TabController(length: 3, vsync: const TestVSync());
        final input = TextEditingController(text: 'abc');
        final inputFocus = FocusNode();
        addTearDown(controller.dispose);
        addTearDown(input.dispose);
        addTearDown(inputFocus.dispose);
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: direction,
              child: Scaffold(
                body: Column(
                  children: [
                    AppTabBar(
                      controller: controller,
                      isScrollable: scrollable,
                      tabs: const [
                        Tab(text: 'One'),
                        Tab(text: 'Two'),
                        Tab(text: 'Three'),
                      ],
                    ),
                    TextField(controller: input, focusNode: inputFocus),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final firstFocus = FocusManager.instance.primaryFocus;
        final forward = direction == TextDirection.ltr
            ? LogicalKeyboardKey.arrowRight
            : LogicalKeyboardKey.arrowLeft;
        final backward = direction == TextDirection.ltr
            ? LogicalKeyboardKey.arrowLeft
            : LogicalKeyboardKey.arrowRight;
        await tester.sendKeyEvent(forward);
        await tester.pumpAndSettle();
        expect(FocusManager.instance.primaryFocus, isNot(firstFocus));
        expect(controller.index, 0);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(controller.index, 1);
        await tester.sendKeyEvent(backward);
        await tester.pumpAndSettle();
        expect(FocusManager.instance.primaryFocus, firstFocus);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(controller.index, 0);

        inputFocus.requestFocus();
        await tester.pumpAndSettle();
        input.selection = const TextSelection.collapsed(offset: 2);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(inputFocus.hasFocus, isTrue);
        // Web cursor editing is handled by the browser's native text input.
        if (!kIsWeb) expect(input.selection.baseOffset, 1);
        expect(input.text, 'abc');
        expect(controller.index, 0);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
