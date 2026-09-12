import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_scroll_controller.dart';

void main() {
  testWidgets(
    'chat follows bottom through resize and delayed image layout, preserving older reading position',
    (tester) async {
      final controller = ChatScrollController();
      addTearDown(controller.dispose);
      final key = GlobalKey();
      Future<void> render(
        double height,
        double imageHeight, {
        bool narrow = false,
      }) async {
        final chat = SizedBox(
          key: key,
          height: height,
          width: 300,
          child: ListView(
            controller: controller,
            children: [
              for (var i = 0; i < 20; i++)
                SizedBox(height: 50, child: Text('Message $i')),
              SizedBox(height: imageHeight, child: const Text('Image')),
            ],
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: narrow ? Column(children: [chat]) : Row(children: [chat]),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      await render(400, 100);
      await tester.scrollUntilVisible(find.text('Image'), 300);
      await tester.pumpAndSettle();
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(controller.position.extentAfter, 0);
      await render(240, 100, narrow: true);
      expect(controller.position.extentAfter, 0);
      await render(240, 240, narrow: true);
      expect(controller.position.extentAfter, 0);
      await render(400, 240);
      expect(controller.position.extentAfter, 0);
      controller.jumpTo(300);
      await tester.pumpAndSettle();
      await render(240, 240, narrow: true);
      expect(controller.offset, 300);
      expect(tester.takeException(), isNull);
    },
  );
}
