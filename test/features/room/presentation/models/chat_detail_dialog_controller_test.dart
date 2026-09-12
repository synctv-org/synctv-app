import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/models/chat_detail_dialog_controller.dart';

Future<BuildContext> _host(WidgetTester tester) async {
  late BuildContext context;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (value) {
          context = value;
          return const Scaffold(body: Text('Home'));
        },
      ),
    ),
  );
  return context;
}

Future<void> _show(
  ChatDetailDialogController controller,
  BuildContext context,
  String message,
  String user,
) => controller.show(
  context: context,
  messageId: message,
  userId: user,
  builder: (_) => AlertDialog(content: Text(message)),
);

void main() {
  testWidgets(
    'message invalidation removes only its dialog under another dialog',
    (tester) async {
      final context = await _host(tester);
      final controller = ChatDetailDialogController();
      final first = _show(controller, context, 'First', 'a');
      await tester.pumpAndSettle();
      final second = _show(controller, context, 'Second', 'b');
      await tester.pumpAndSettle();
      controller.dismissWhere((message, _) => message == 'First');
      await tester.pumpAndSettle();
      await first;
      expect(find.text('First', skipOffstage: false), findsNothing);
      expect(find.text('Second'), findsOneWidget);
      controller.dispose();
      await tester.pumpAndSettle();
      await second;
    },
  );

  testWidgets('author invalidation closes all matching messages', (
    tester,
  ) async {
    final context = await _host(tester);
    final controller = ChatDetailDialogController();
    final first = _show(controller, context, 'First', 'a');
    await tester.pumpAndSettle();
    final second = _show(controller, context, 'Second', 'a');
    await tester.pumpAndSettle();
    controller.dismissWhere((_, user) => user == 'a');
    await tester.pumpAndSettle();
    await Future.wait([first, second]);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('dismiss all preserves an unrelated covering page', (
    tester,
  ) async {
    final context = await _host(tester);
    final controller = ChatDetailDialogController();
    final dialog = _show(controller, context, 'Details', 'a');
    await tester.pumpAndSettle();
    final navigator = Navigator.of(context);
    final page = navigator.push<void>(
      MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Cover'))),
    );
    await tester.pumpAndSettle();
    controller.dismissAll();
    await tester.pumpAndSettle();
    await dialog;
    expect(find.text('Cover'), findsOneWidget);
    expect(find.text('Details', skipOffstage: false), findsNothing);
    navigator.pop();
    await tester.pumpAndSettle();
    await page;
  });

  testWidgets('manual dismissal during scheduled invalidation is harmless', (
    tester,
  ) async {
    final context = await _host(tester);
    final controller = ChatDetailDialogController();
    final dialog = _show(controller, context, 'Details', 'a');
    await tester.pumpAndSettle();
    controller.dismissAll();
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    await dialog;
    expect(tester.takeException(), isNull);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('disposed controller rejects later opens', (tester) async {
    final context = await _host(tester);
    final controller = ChatDetailDialogController()..dispose();
    await _show(controller, context, 'Details', 'a');
    await tester.pumpAndSettle();
    expect(find.text('Details'), findsNothing);
  });

  testWidgets(
    'owner disposal closes its dialog without Navigator lock errors',
    (tester) async {
      final context = await _host(tester);
      final navigator = Navigator.of(context);
      final controller = ChatDetailDialogController();
      final owner = MaterialPageRoute<void>(builder: (_) => _Owner(controller));
      final page = navigator.push(owner);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      navigator.removeRoute(owner);
      await tester.pumpAndSettle();
      await page;
      expect(tester.takeException(), isNull);
      expect(find.text('Details', skipOffstage: false), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    },
  );
}

class _Owner extends StatefulWidget {
  const _Owner(this.controller);
  final ChatDetailDialogController controller;
  @override
  State<_Owner> createState() => _OwnerState();
}

class _OwnerState extends State<_Owner> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => _show(widget.controller, context, 'Details', 'a'),
      child: const Text('Open'),
    ),
  );
}
