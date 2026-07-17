import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/widgets/add_media_dialog.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

void main() {
  testWidgets('desktop direct-link action stays fully visible', (tester) async {
    tester.view.physicalSize = const ui.Size(984, 728);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: FTheme(
          data: FThemes.blue.light.desktop,
          child: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 620,
                child: AddMediaDialog(roomId: 'room_layout_test'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final action = find.text('Add to playlist');
    expect(action, findsOneWidget);
    final actionButton = find.ancestor(
      of: action,
      matching: find.byType(AppActionButton),
    );
    expect(actionButton, findsOneWidget);
    final actionRect = tester.getRect(actionButton);
    expect(actionRect.height, greaterThanOrEqualTo(46));
    expect(actionRect.bottom, lessThanOrEqualTo(728));
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });
}
