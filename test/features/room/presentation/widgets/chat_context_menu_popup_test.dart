import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_context_menu_popup.dart';

void main() {
  testWidgets(
    'bordered panel keeps six buttons on each row without scrolling',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChatContextMenuPopup(
            anchor: const Offset(400, 300),
            reactionCount: 6,
            actionCount: 6,
            child: AppPanelSurface(
              border: Border.all(),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: [
                      for (var i = 0; i < 6; i++)
                        SizedBox(
                          key: Key('reaction_$i'),
                          width: 28,
                          height: 28,
                        ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: [
                      for (var i = 0; i < 6; i++)
                        SizedBox(key: Key('action_$i'), width: 28, height: 28),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(
        tester.getTopLeft(find.byKey(const Key('reaction_5'))).dy,
        tester.getTopLeft(find.byKey(const Key('reaction_0'))).dy,
      );
      expect(
        tester.getTopLeft(find.byKey(const Key('action_5'))).dy,
        tester.getTopLeft(find.byKey(const Key('action_0'))).dy,
      );
      expect(
        tester
            .state<ScrollableState>(find.byType(Scrollable))
            .position
            .maxScrollExtent,
        0,
      );
      expect(tester.takeException(), isNull);
    },
  );

  Widget popup({
    EdgeInsets safe = EdgeInsets.zero,
    EdgeInsets keyboard = EdgeInsets.zero,
  }) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(viewPadding: safe, viewInsets: keyboard),
      child: const ChatContextMenuPopup(
        anchor: Offset(790, 590),
        reactionCount: 6,
        actionCount: 6,
        child: SizedBox(
          height: 200,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text('Last action'),
          ),
        ),
      ),
    ),
  );

  testWidgets('open popup follows a resized viewport', (tester) async {
    await tester.pumpWidget(popup());
    final initial = tester.getRect(find.byType(SingleChildScrollView));
    expect(initial.right, lessThanOrEqualTo(788));
    tester.view.physicalSize = const Size(320, 180);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pump();
    final resized = tester.getRect(find.byType(SingleChildScrollView));
    expect(resized.right, lessThanOrEqualTo(308));
    expect(resized.bottom, lessThanOrEqualTo(168));
    expect(tester.takeException(), isNull);
  });

  testWidgets('popup avoids safe area and changing keyboard insets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 180);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      popup(safe: const EdgeInsets.fromLTRB(20, 24, 10, 16)),
    );
    var rect = tester.getRect(find.byType(SingleChildScrollView));
    expect(rect.left, greaterThanOrEqualTo(32));
    expect(rect.top, greaterThanOrEqualTo(36));
    expect(rect.right, lessThanOrEqualTo(298));
    expect(rect.bottom, lessThanOrEqualTo(152));
    await tester.pumpWidget(
      popup(
        safe: const EdgeInsets.only(top: 24, bottom: 16),
        keyboard: const EdgeInsets.only(bottom: 100),
      ),
    );
    rect = tester.getRect(find.byType(SingleChildScrollView));
    expect(rect.top, greaterThanOrEqualTo(36));
    expect(rect.bottom, lessThanOrEqualTo(68));
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();
    final last = tester.getRect(find.text('Last action'));
    expect(last.bottom, lessThanOrEqualTo(rect.bottom + 0.1));
    expect(find.text('Last action').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
