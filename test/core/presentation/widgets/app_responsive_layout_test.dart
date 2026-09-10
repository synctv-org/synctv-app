import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_responsive_layout.dart';

void main() {
  testWidgets('split reserves the configured primary width at its breakpoint', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    for (final width in [1014.0, 1020.0, 1200.0, 1600.0]) {
      tester.view.physicalSize = Size(width, 700);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppAdaptiveSplitView(
              minPrimaryWidth: 680,
              minSecondaryWidth: 320,
              maxSecondaryWidth: 420,
              spacing: 14,
              primary: ColoredBox(key: Key('primary'), color: Colors.black),
              secondary: ColoredBox(key: Key('secondary'), color: Colors.blue),
            ),
          ),
        ),
      );
      await tester.pump();
      final primary = tester.getRect(find.byKey(const Key('primary')));
      final secondary = tester.getRect(find.byKey(const Key('secondary')));
      expect(primary.width, greaterThanOrEqualTo(680), reason: 'width $width');
      expect(secondary.width, inInclusiveRange(320, 420));
      expect(secondary.left - primary.right, 14);
      expect(secondary.right, width);
      expect(tester.takeException(), isNull);
    }
  });
}
