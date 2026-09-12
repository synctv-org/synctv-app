import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final anchored in [false, true]) {
    for (final reason in ['disabled', 'callback', 'empty']) {
      for (final labelAbove in [false, true]) {
        testWidgets(
          'disabled select anchored=$anchored reason=$reason labelAbove=$labelAbove',
          (tester) async {
            final semantics = tester.ensureSemantics();
            try {
              var active = false;
              var changes = 0;
              String? selected = reason == 'empty' ? null : 'music';
              late StateSetter update;
              await tester.pumpWidget(
                MaterialApp(
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: Scaffold(
                    body: StatefulBuilder(
                      builder: (context, setState) {
                        update = setState;
                        return AppSelect<String>(
                          value: selected,
                          label: 'Category',
                          labelAbove: labelAbove,
                          description: 'Help',
                          errorText: 'Required',
                          hintText: 'Choose category',
                          options: reason == 'empty' && !active
                              ? const {}
                              : const {'Music': 'music', 'Books': 'books'},
                          enabled: active || reason != 'disabled',
                          useAnchoredMenu: anchored,
                          onChanged: reason == 'callback' && !active
                              ? null
                              : (value) {
                                  changes++;
                                  setState(() => selected = value);
                                },
                        );
                      },
                    ),
                  ),
                ),
              );
              await tester.pumpAndSettle();
              final valueText = reason == 'empty' ? 'Choose category' : 'Music';
              final data = tester
                  .getSemantics(find.text(valueText))
                  .getSemanticsData();
              expect(data.flagsCollection.isButton, isTrue);
              expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
              expect(data.flagsCollection.isExpanded, ui.Tristate.none);
              expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
              expect(data.hasAction(ui.SemanticsAction.expand), isFalse);
              expect(find.bySemanticsLabel(RegExp('Category')), findsWidgets);
              expect(find.bySemanticsLabel(RegExp('Required')), findsWidgets);
              await tester.tap(find.text(valueText));
              await tester.pumpAndSettle();
              expect(find.text('Books'), findsNothing);
              expect(changes, 0);
              update(() => active = true);
              await tester.pumpAndSettle();
              await tester.tap(find.text(valueText));
              await tester.pumpAndSettle();
              await tester.tap(find.text('Books').last);
              await tester.pumpAndSettle();
              expect(changes, 1);
              expect(selected, 'books');
              expect(tester.takeException(), isNull);
            } finally {
              semantics.dispose();
            }
          },
        );
      }
    }
  }
}
