import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_message_hover_layout.dart';

void main() {
  Widget subject({required double width, required bool alignEnd}) {
    return MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: ChatMessageHoverLayout(
            alignEnd: alignEnd,
            message: const SizedBox(
              key: Key('message'),
              width: 220,
              height: 60,
            ),
            actions: const SizedBox(
              key: Key('actions'),
              width: 100,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('places actions below without shrinking a wide message', (
    tester,
  ) async {
    await tester.pumpWidget(subject(width: 300, alignEnd: false));

    final messageRect = tester.getRect(find.byKey(const Key('message')));
    final actionsRect = tester.getRect(find.byKey(const Key('actions')));
    expect(messageRect.width, 220);
    expect(actionsRect.top, greaterThan(messageRect.bottom));
  });

  testWidgets('keeps actions beside the message when space is available', (
    tester,
  ) async {
    await tester.pumpWidget(subject(width: 340, alignEnd: true));

    final messageRect = tester.getRect(find.byKey(const Key('message')));
    final actionsRect = tester.getRect(find.byKey(const Key('actions')));
    expect(messageRect.width, 220);
    expect(actionsRect.top, messageRect.top);
    expect(actionsRect.left, greaterThan(messageRect.right));
  });
}
