import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

void main() {
  for (final checkbox in [false, true]) {
    testWidgets('labeled toggle has one keyboard stop checkbox=$checkbox', (
      tester,
    ) async {
      final toggleFocus = FocusNode();
      final nextFocus = FocusNode();
      addTearDown(toggleFocus.dispose);
      addTearDown(nextFocus.dispose);
      var value = false;
      var changes = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                void update(bool next) => setState(() {
                  value = next;
                  changes++;
                });
                return Column(
                  children: [
                    if (checkbox)
                      AppCheckbox(
                        value: value,
                        onChanged: update,
                        label: 'Notifications',
                        focusNode: toggleFocus,
                      )
                    else
                      AppSwitch(
                        value: value,
                        onChanged: update,
                        label: 'Notifications',
                        focusNode: toggleFocus,
                      ),
                    TextButton(
                      focusNode: nextFocus,
                      onPressed: () {},
                      child: const Text('Next'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(toggleFocus.hasPrimaryFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(value, isTrue);
      expect(changes, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(nextFocus.hasPrimaryFocus, isTrue);
      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();
      expect(value, isFalse);
      expect(changes, 2);
      expect(tester.takeException(), isNull);
    });
  }
}
