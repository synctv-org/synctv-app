import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/widgets/app_tab_activity.dart';

void main() {
  testWidgets('nonadjacent animation deactivates old tab before settling', (
    tester,
  ) async {
    final controller = TabController(length: 3, vsync: tester);
    addTearDown(controller.dispose);
    final first = GlobalKey<_CounterState>();
    final last = GlobalKey<_CounterState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTabBarView(
            controller: controller,
            children: [
              _Counter(key: first),
              const Text('Middle'),
              _Counter(key: last),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    controller.animateTo(2, duration: const Duration(seconds: 1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.indexIsChanging, isTrue);
    expect(first.currentState!.active, isFalse);
    await tester.pumpAndSettle();
    expect(last.currentState!.active, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dragging between tabs updates activity and preserves state', (
    tester,
  ) async {
    final controller = TabController(length: 2, vsync: tester);
    addTearDown(controller.dispose);
    final first = GlobalKey<_CounterState>();
    final second = GlobalKey<_CounterState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTabBarView(
            controller: controller,
            children: [
              _Counter(key: first),
              _Counter(key: second),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final initial = first.currentState;
    await tester.drag(find.byType(AppTabBarView), const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(controller.index, 1);
    expect(first.currentState!.active, isFalse);
    expect(second.currentState!.active, isTrue);
    await tester.drag(find.byType(AppTabBarView), const Offset(700, 0));
    await tester.pumpAndSettle();
    expect(controller.index, 0);
    expect(first.currentState!.active, isTrue);
    expect(identical(first.currentState, initial), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('controller replacement drops old activity notifications', (
    tester,
  ) async {
    final original = TabController(length: 2, vsync: tester);
    final replacement = TabController(
      length: 2,
      initialIndex: 1,
      vsync: tester,
    );
    addTearDown(original.dispose);
    addTearDown(replacement.dispose);
    final first = GlobalKey<_CounterState>();
    final second = GlobalKey<_CounterState>();
    Widget host(TabController controller) => MaterialApp(
      home: Scaffold(
        body: AppTabBarView(
          controller: controller,
          children: [
            _Counter(key: first),
            _Counter(key: second),
          ],
        ),
      ),
    );
    await tester.pumpWidget(host(original));
    await tester.pumpAndSettle();
    await tester.pumpWidget(host(replacement));
    await tester.pumpAndSettle();
    expect(first.currentState!.active, isFalse);
    expect(second.currentState!.active, isTrue);
    original.index = 1;
    original.index = 0;
    await tester.pumpAndSettle();
    expect(second.currentState!.active, isTrue);
    replacement.index = 0;
    await tester.pumpAndSettle();
    expect(first.currentState!.active, isTrue);
    expect(second.currentState!.active, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reordering keyed tabs retains their state and selected activity',
    (tester) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);
      final first = GlobalKey<_CounterState>();
      final second = GlobalKey<_CounterState>();
      Widget host(bool reverse) => MaterialApp(
        home: Scaffold(
          body: AppTabBarView(
            controller: controller,
            children: reverse
                ? [_Counter(key: second), _Counter(key: first)]
                : [_Counter(key: first), _Counter(key: second)],
          ),
        ),
      );
      await tester.pumpWidget(host(false));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Count 0 active true'));
      await tester.pump();
      final initial = first.currentState;
      controller.index = 1;
      await tester.pumpAndSettle();
      await tester.pumpWidget(host(true));
      await tester.pumpAndSettle();
      expect(identical(first.currentState, initial), isTrue);
      expect(first.currentState!.count, 1);
      expect(first.currentState!.active, isTrue);
      expect(second.currentState!.active, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('default tabs preserve keyed state and report selection', (
    tester,
  ) async {
    final key = GlobalKey<_CounterState>();
    await tester.pumpWidget(
      MaterialApp(
        home: AppDefaultTabController(
          length: 2,
          child: Scaffold(
            body: Column(
              children: [
                const AppTabBar(
                  tabs: [
                    Tab(text: 'First'),
                    Tab(text: 'Second'),
                  ],
                ),
                Expanded(
                  child: AppTabBarView(
                    children: [
                      _Counter(key: key),
                      const Text('Second content'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final state = key.currentState;
    await tester.tap(find.text('Count 0 active true'));
    await tester.pump();
    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();
    expect(identical(key.currentState, state), isTrue);
    expect(key.currentState!.active, isFalse);
    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    expect(find.text('Count 1 active true'), findsOneWidget);
    expect(identical(key.currentState, state), isTrue);
    expect(tester.takeException(), isNull);
  });
}

class _Counter extends StatefulWidget {
  const _Counter({super.key});
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> with AutomaticKeepAliveClientMixin {
  var count = 0;
  var active = true;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    active = AppTabActivity.of(context);
    return TextButton(
      onPressed: () => setState(() => count++),
      child: Text('Count $count active $active'),
    );
  }
}
