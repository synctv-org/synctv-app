import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_responsive_layout.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/playlist_empty_state.dart';

import '../../../test_app.dart';

Widget _app(Widget child) {
  return MaterialApp(
    locale: const Locale('zh'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: buildThemedTestApp,
    home: Scaffold(body: child),
  );
}

Finder _byTooltip(String message) {
  return find.byWidgetPredicate(
    (widget) => switch (widget) {
      AppTooltip(message: final value) => value == message,
      Tooltip(message: final value) => value == message,
      _ => false,
    },
    description: 'tooltip with message "$message"',
  );
}

void main() {
  testWidgets('scrollable tabs accept mouse drag input', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 240));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _app(
        const DefaultTabController(
          length: 4,
          child: AppTabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              SizedBox(width: 120, child: Tab(text: 'Overview')),
              SizedBox(width: 120, child: Tab(text: 'Users')),
              SizedBox(width: 120, child: Tab(text: 'Providers')),
              SizedBox(width: 120, child: Tab(text: 'Settings')),
            ],
          ),
        ),
      ),
    );

    final scrollable = find.descendant(
      of: find.byType(AppTabBar),
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scrollable).position;
    expect(position.pixels, 0);

    final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    final start = tester.getCenter(find.text('Users'));
    await mouse.addPointer(location: start);
    await mouse.down(start);
    await mouse.moveBy(const Offset(-140, 0));
    await mouse.up();
    await tester.pumpAndSettle();

    expect(position.pixels, greaterThan(0));
  });

  testWidgets('AppDialog keeps actions visible when its body is tall', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(600, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () {
              showAppDialog<void>(
                context: context,
                builder: (dialogContext) => AppDialog(
                  title: const Text('Playback settings'),
                  body: const SizedBox(height: 700, child: Text('Tall body')),
                  actions: [
                    AppActionButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      label: 'Save',
                      style: AppActionButtonStyle.filled,
                    ),
                  ],
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Save'), findsOneWidget);
    expect(tester.getBottomLeft(find.text('Save')).dy, lessThan(500));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Playback settings'), findsNothing);
  });

  testWidgets('AppTooltip uses a plain overlay and keeps tooltip semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const Center(
          child: AppTooltip(
            message: 'Playback settings',
            child: Icon(Icons.settings),
          ),
        ),
      ),
    );

    expect(find.byType(Tooltip), findsNothing);
    final tooltipSemantics = tester
        .getSemantics(find.byType(AppTooltip))
        .getSemanticsData();
    expect(tooltipSemantics.tooltip, 'Playback settings');

    final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
    await mouse.addPointer(
      location: tester.getCenter(find.byIcon(Icons.settings)),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Playback settings'), findsOneWidget);

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(find.text('Playback settings'), findsNothing);
    semantics.dispose();
  });

  testWidgets('AppSlider exposes one formatted adjustable semantics node', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      _app(
        AppSlider(
          value: 25,
          min: 0,
          max: 30,
          onChanged: (_) {},
          semanticFormatterCallback: (_) => '播放进度: 00:25 / 00:30',
        ),
      ),
    );

    final adjustable = find.semantics.byPredicate((node) {
      final data = node.getSemanticsData();
      return data.hasAction(ui.SemanticsAction.increase) &&
          data.hasAction(ui.SemanticsAction.decrease) &&
          data.value == '播放进度: 00:25 / 00:30';
    }, describeMatch: (_) => 'adjustable slider semantics');
    expect(adjustable, findsOneWidget);

    semantics.dispose();
  });

  testWidgets('AppTextField clear keeps controller and onChanged in sync', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'ab');
    final changes = <String>[];

    await tester.pumpWidget(
      _app(
        AppTextField(
          controller: controller,
          label: '测试字段',
          onChanged: changes.add,
        ),
      ),
    );

    expect(_byTooltip('粘贴'), findsNothing);
    expect(_byTooltip('清空'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    await tester.tap(_byTooltip('清空'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(controller.text, isEmpty);
    expect(changes.last, isEmpty);

    controller.dispose();
  });

  testWidgets('AppTextField skips clear action during Tab traversal', (
    tester,
  ) async {
    final firstController = TextEditingController(text: 'room');
    final secondController = TextEditingController();
    final firstFocus = FocusNode();
    final secondFocus = FocusNode();

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppTextField(
              controller: firstController,
              focusNode: firstFocus,
              label: '房间名',
            ),
            AppTextField(
              controller: secondController,
              focusNode: secondFocus,
              label: '描述',
            ),
          ],
        ),
      ),
    );

    firstFocus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(secondFocus.hasFocus, isTrue);

    firstController.dispose();
    secondController.dispose();
    firstFocus.dispose();
    secondFocus.dispose();
  });

  testWidgets('AppSearchField exposes clear control without paste button', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'alist');

    await tester.pumpWidget(
      _app(
        AppSearchField(
          controller: controller,
          hintText: '搜索房间',
          onSubmitted: (_) {},
        ),
      ),
    );

    expect(_byTooltip('粘贴'), findsNothing);
    expect(_byTooltip('清空'), findsOneWidget);

    await tester.tap(_byTooltip('清空'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(controller.text, isEmpty);

    controller.dispose();
  });

  testWidgets('AppSearchField accepts typing and submits query', (
    tester,
  ) async {
    final controller = TextEditingController();
    final submitted = <String>[];

    await tester.pumpWidget(
      _app(
        AppSearchField(
          controller: controller,
          hintText: '搜索房间',
          onSubmitted: submitted.add,
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), 'movie night');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(const Duration(milliseconds: 150));

    expect(controller.text, 'movie night');
    expect(submitted, ['movie night']);
    expect(_byTooltip('粘贴'), findsNothing);

    controller.dispose();
  });

  testWidgets('AppResponsiveWrap keeps children within narrow constraints', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const SizedBox(
          width: 180,
          child: AppResponsiveWrap(
            minItemWidth: 280,
            children: [Text('A'), Text('B')],
          ),
        ),
      ),
    );

    final childWidths = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .where((box) => box.width == 180)
        .length;
    expect(childWidths, greaterThanOrEqualTo(2));
  });

  testWidgets('AppAdaptiveSplitView keeps collapsed secondary usable', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const SizedBox(
          width: 400,
          height: 600,
          child: AppAdaptiveSplitView(
            primary: ColoredBox(key: ValueKey('primary'), color: Colors.black),
            secondary: ColoredBox(
              key: ValueKey('secondary'),
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('primary'))).height,
      closeTo(224, 1),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('secondary'))).height,
      closeTo(364, 1),
    );
  });

  testWidgets('AppTextField keeps the default text editing context menu', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'room name');

    await tester.pumpWidget(
      _app(AppTextField(controller: controller, label: '房间名')),
    );

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.contextMenuBuilder, isNotNull);
    final state = tester.state<EditableTextState>(find.byType(EditableText));
    final menu = editable.contextMenuBuilder!(
      tester.element(find.byType(EditableText)),
      state,
    );
    expect(menu, isA<AdaptiveTextSelectionToolbar>());
    expect(state.contextMenuButtonItems, isNotEmpty);
    expect(
      state.contextMenuButtonItems.map((item) => item.label),
      isNot(contains('清空')),
    );

    controller.dispose();
  });

  testWidgets('AppTextField keeps native editing affordances', (tester) async {
    final controller = TextEditingController(text: 'room ');
    final undoController = UndoHistoryController();

    await tester.pumpWidget(
      _app(
        AppTextField(
          controller: controller,
          label: '房间名',
          undoController: undoController,
        ),
      ),
    );

    await tester.tap(find.byType(EditableText));
    await tester.pump(const Duration(milliseconds: 150));

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.enableInteractiveSelection, isTrue);
    expect(editable.contextMenuBuilder, isNotNull);
    expect(editable.undoController, same(undoController));
    expect(_byTooltip('粘贴'), findsNothing);

    controller.dispose();
    undoController.dispose();
  });

  testWidgets('AppTextField exposes one native editable text field', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = TextEditingController(text: 'old');
    final changes = <String>[];

    await tester.pumpWidget(
      _app(
        AppTextField(
          controller: controller,
          label: '用户名',
          onChanged: changes.add,
        ),
      ),
    );

    expect(find.byType(EditableText), findsOne);
    await tester.enterText(find.byType(EditableText), 'root');
    await tester.pump(const Duration(milliseconds: 150));

    expect(controller.text, 'root');
    expect(changes.last, 'root');

    controller.dispose();
    semantics.dispose();
  });

  testWidgets('AppTextField read-only semantics cannot set text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = TextEditingController(text: 'locked');

    await tester.pumpWidget(
      _app(AppTextField(controller: controller, label: '只读', readOnly: true)),
    );

    expect(
      find.semantics.byPredicate(
        (node) =>
            node.label == '只读' &&
            node.getSemanticsData().hasAction(ui.SemanticsAction.setText),
        describeMatch: (_) => 'read-only setText action',
      ),
      findsNothing,
    );

    controller.dispose();
    semantics.dispose();
  });

  testWidgets('AppTextField form fields submit and keep native edit menu', (
    tester,
  ) async {
    final serverController = TextEditingController();
    final passwordController = TextEditingController();
    final submitted = <String>[];

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppTextField(
              controller: serverController,
              label: '服务器地址',
              hintText: 'https://tv.example.com',
              prefixIcon: Icons.link_rounded,
              textInputAction: TextInputAction.next,
              onSubmitted: submitted.add,
            ),
            AppTextField(
              controller: passwordController,
              label: '密码',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
            ),
          ],
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText).first, 'http://127.0.0.1');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump(const Duration(milliseconds: 150));

    expect(serverController.text, 'http://127.0.0.1');
    expect(submitted, ['http://127.0.0.1']);
    expect(_byTooltip('粘贴'), findsNothing);

    final editables = tester.widgetList<EditableText>(
      find.byType(EditableText),
    );
    expect(
      editables.every((editable) => editable.contextMenuBuilder != null),
      isTrue,
    );

    serverController.dispose();
    passwordController.dispose();
  });

  testWidgets('AppTextField password reveal uses component-library action', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'secret');

    await tester.pumpWidget(
      _app(
        AppTextField(controller: controller, label: '密码', obscureText: true),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(_byTooltip('显示密码'), findsOneWidget);

    await tester.tap(_byTooltip('显示密码'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(_byTooltip('隐藏密码'), findsOneWidget);

    controller.dispose();
  });

  testWidgets(
    'AppTextField reports Caps Lock while a password field is focused',
    (tester) async {
      if (HardwareKeyboard.instance.lockModesEnabled.contains(
        KeyboardLockMode.capsLock,
      )) {
        await tester.sendKeyEvent(LogicalKeyboardKey.capsLock);
      }
      addTearDown(() async {
        if (HardwareKeyboard.instance.lockModesEnabled.contains(
          KeyboardLockMode.capsLock,
        )) {
          await tester.sendKeyEvent(LogicalKeyboardKey.capsLock);
        }
      });
      final controller = TextEditingController();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        _app(
          AppTextField(
            controller: controller,
            focusNode: focusNode,
            label: '密码',
            helperText: '至少 8 个字符',
            obscureText: true,
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      expect(find.text('大写锁定已开启'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.capsLock);
      await tester.pump();
      expect(find.text('至少 8 个字符'), findsOneWidget);
      expect(find.text('大写锁定已开启'), findsOneWidget);

      focusNode.unfocus();
      await tester.pump();
      expect(find.text('大写锁定已开启'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.capsLock);
      controller.dispose();
      focusNode.dispose();
    },
  );

  testWidgets('AppTextField skips password reveal during Tab traversal', (
    tester,
  ) async {
    final passwordController = TextEditingController(text: 'secret');
    final nextController = TextEditingController();
    final passwordFocus = FocusNode();
    final nextFocus = FocusNode();

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppTextField(
              controller: passwordController,
              focusNode: passwordFocus,
              label: '密码',
              obscureText: true,
            ),
            AppTextField(
              controller: nextController,
              focusNode: nextFocus,
              label: '服务器地址',
            ),
          ],
        ),
      ),
    );

    passwordFocus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(nextFocus.hasFocus, isTrue);

    passwordController.dispose();
    nextController.dispose();
    passwordFocus.dispose();
    nextFocus.dispose();
  });

  testWidgets('AppReadOnlyField uses app text field chrome without actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppReadOnlyField(
          label: 'Provider',
          value: 'GitHub',
          prefixIcon: Icons.link,
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
    expect(_byTooltip('清空'), findsNothing);
    expect(_byTooltip('粘贴'), findsNothing);

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.readOnly, isTrue);
  });

  testWidgets('AppSelectableText keeps native selectable text behavior', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppSelectableText(
          '{"type":"room.updated"}',
          monospace: true,
          maxLines: 2,
        ),
      ),
    );

    final selectable = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );
    expect(selectable.data, '{"type":"room.updated"}');
    expect(selectable.maxLines, 2);
    expect(selectable.style?.fontFamily, 'monospace');
  });

  testWidgets('AppSelectableText uses the adaptive platform toolbar', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const AppSelectableText('copy me')));

    final selectable = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );
    final editableState = tester.state<EditableTextState>(
      find.byType(EditableText),
    );
    final toolbar = selectable.contextMenuBuilder!(
      tester.element(find.byType(SelectableText)),
      editableState,
    );

    expect(toolbar, isA<AdaptiveTextSelectionToolbar>());
  });

  testWidgets(
    'AppActionButton uses ForUI button variants and disables loading',
    (tester) async {
      var presses = 0;

      await tester.pumpWidget(
        _app(
          AppActionButton(
            onPressed: () => presses += 1,
            icon: Icons.save_outlined,
            label: '保存',
          ),
        ),
      );

      expect(find.byType(FButton), findsOneWidget);
      await tester.tap(find.text('保存'));
      await tester.pump(const Duration(milliseconds: 150));
      expect(presses, 1);

      await tester.pumpWidget(
        _app(
          AppActionButton(
            onPressed: () => presses += 1,
            icon: Icons.delete_outline,
            label: '删除',
            style: AppActionButtonStyle.destructive,
            size: AppActionButtonSize.sm,
          ),
        ),
      );

      expect(find.byType(FButton), findsOneWidget);
      await tester.tap(find.text('删除'));
      await tester.pump(const Duration(milliseconds: 150));
      expect(presses, 2);

      await tester.pumpWidget(
        _app(
          AppActionButton(
            onPressed: () => presses += 1,
            label: '保存',
            loading: true,
          ),
        ),
      );

      expect(find.byType(FCircularProgress), findsOneWidget);
      await tester.tap(find.text('保存'));
      await tester.pump(const Duration(milliseconds: 150));
      expect(presses, 2);
    },
  );

  testWidgets('AppIconButton uses ForUI icon button and disables loading', (
    tester,
  ) async {
    var presses = 0;

    await tester.pumpWidget(
      _app(
        AppIconButton(
          onPressed: () => presses += 1,
          icon: Icons.refresh_rounded,
          tooltip: '刷新',
          style: AppIconButtonStyle.tonal,
        ),
      ),
    );

    expect(find.byType(FButton), findsOneWidget);
    expect(_byTooltip('刷新'), findsOneWidget);
    await tester.tap(_byTooltip('刷新'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(presses, 1);

    await tester.pumpWidget(
      _app(
        AppIconButton(
          onPressed: () => presses += 1,
          icon: Icons.refresh_rounded,
          tooltip: '刷新',
          loading: true,
        ),
      ),
    );

    expect(find.byType(FCircularProgress), findsOneWidget);
    await tester.tap(_byTooltip('刷新'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(presses, 1);

    await tester.pumpWidget(
      _app(
        AppIconButton(
          onPressed: () => presses += 1,
          icon: Icons.filter_alt_outlined,
          selectedIcon: Icons.filter_alt_rounded,
          tooltip: '筛选',
          selected: true,
          size: AppIconButtonSize.sm,
        ),
      ),
    );

    expect(find.byIcon(Icons.filter_alt_rounded), findsOneWidget);
    await tester.tap(_byTooltip('筛选'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(presses, 2);
  });

  testWidgets('AppIconButton can keep semantics without a hover tooltip', (
    tester,
  ) async {
    var presses = 0;
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      _app(
        AppIconButton(
          onPressed: () => presses += 1,
          icon: Icons.volume_up_rounded,
          tooltip: '音量',
          showTooltip: false,
        ),
      ),
    );

    expect(_byTooltip('音量'), findsNothing);
    expect(find.bySemanticsLabel('音量'), findsWidgets);
    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    await tester.pump(const Duration(milliseconds: 150));
    expect(presses, 1);
    semantics.dispose();
  });

  testWidgets('AppGlassIconButton centralizes glass icon taps', (tester) async {
    var presses = 0;

    await tester.pumpWidget(
      _app(
        AppGlassIconButton(
          tooltip: '选择图片',
          icon: const Icon(Icons.image_outlined),
          isDark: false,
          onPressed: () => presses += 1,
          rotateOnPressed: true,
          hapticFeedback: HapticFeedbackType.none,
        ),
      ),
    );

    expect(_byTooltip('选择图片'), findsOneWidget);
    expect(find.byType(AppBlurSurface), findsOneWidget);

    await tester.tap(_byTooltip('选择图片'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(presses, 1);
  });

  testWidgets('AppOverlayActionButton keeps overlay actions tappable', (
    tester,
  ) async {
    var presses = 0;

    await tester.pumpWidget(
      _app(
        AppOverlayActionButton(
          onPressed: () => presses += 1,
          icon: Icons.sync_rounded,
          label: '同步',
        ),
      ),
    );

    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byIcon(Icons.sync_rounded), findsOneWidget);
    await tester.tap(find.text('同步'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(presses, 1);
  });

  testWidgets('AppSlider reports value changes', (tester) async {
    var value = 0.2;
    var changeStartCount = 0;
    double? committedValue;

    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            return AppSlider(
              value: value,
              min: 0,
              max: 1,
              divisions: 10,
              label: value.toStringAsFixed(1),
              onChangeStart: (_) => changeStartCount += 1,
              onChanged: (next) => setState(() => value = next),
              onChangeEnd: (next) => committedValue = next,
            );
          },
        ),
      ),
    );

    expect(find.byType(Slider), findsOneWidget);
    await tester.drag(find.byType(Slider), const Offset(120, 0));
    await tester.pump(const Duration(milliseconds: 150));
    expect(value, isNot(0.2));
    expect(changeStartCount, 1);
    expect(committedValue, value);
  });

  testWidgets('AppSegmentedControl reports selected value', (tester) async {
    var selected = 'public';

    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            return AppSegmentedControl<String>(
              value: selected,
              segments: const [
                ButtonSegment(value: 'public', label: Text('公开')),
                ButtonSegment(value: 'mine', label: Text('我的')),
              ],
              onChanged: (value) => setState(() => selected = value),
            );
          },
        ),
      ),
    );

    expect(find.byType(SegmentedButton<String>), findsOneWidget);
    await tester.tap(find.text('我的'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(selected, 'mine');
  });

  testWidgets(
    'AppLoadingIndicator and AppLinearProgress wrap progress states',
    (tester) async {
      await tester.pumpWidget(
        _app(
          const Column(
            children: [
              AppLoadingIndicator(),
              AppLoadingIndicator(size: AppLoadingSize.sm, centered: false),
              AppLinearProgress(),
            ],
          ),
        ),
      );

      expect(find.byType(FCircularProgress), findsNWidgets(2));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('App tab wrappers keep controller-based navigation', (
    tester,
  ) async {
    final controller = TabController(length: 2, vsync: const TestVSync());

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppTabBar(
              controller: controller,
              tabs: const [
                Tab(text: '资料'),
                Tab(text: '偏好'),
              ],
            ),
            Expanded(
              child: AppTabBarView(
                controller: controller,
                children: const [Text('资料内容'), Text('偏好内容')],
              ),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.text('资料内容'), findsOneWidget);

    await tester.tap(find.text('偏好'));
    await tester.pumpAndSettle();

    expect(controller.index, 1);
    expect(find.text('偏好内容'), findsOneWidget);

    controller.dispose();
  });

  testWidgets('AppDefaultTabController provides inherited tab state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppDefaultTabController(
          length: 2,
          child: Column(
            children: [
              AppTabBar(
                tabs: [
                  Tab(text: '房间'),
                  Tab(text: '成员'),
                ],
              ),
              Expanded(
                child: AppTabBarView(children: [Text('房间列表'), Text('成员列表')]),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('房间列表'), findsOneWidget);

    await tester.tap(find.text('成员'));
    await tester.pumpAndSettle();

    expect(find.text('成员列表'), findsOneWidget);
  });

  testWidgets('AppPopupMenuButton and AppMenuAnchor expose menu actions', (
    tester,
  ) async {
    var selected = 0;
    var opened = 0;
    var canceled = 0;

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppPopupMenuButton<int>(
              tooltip: '数量',
              onOpened: () => opened++,
              onCanceled: () => canceled++,
              onSelected: (value) => selected = value,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 50, child: Text('50')),
              ],
              child: const Text('打开菜单'),
            ),
            AppMenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => selected = 100,
                  child: const Text('100'),
                ),
              ],
              builder: (context, controller, child) {
                return AppActionButton(
                  onPressed: controller.open,
                  label: '更多',
                  style: AppActionButtonStyle.text,
                );
              },
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('打开菜单'));
    await tester.pumpAndSettle();
    expect(opened, 1);
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(canceled, 1);

    await tester.tap(find.text('打开菜单'));
    await tester.pumpAndSettle();
    expect(opened, 2);
    await tester.tap(find.text('50'));
    await tester.pumpAndSettle();
    expect(selected, 50);

    await tester.tap(find.text('更多'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('100'));
    await tester.pumpAndSettle();
    expect(selected, 100);
  });

  testWidgets('AppDialog and AppConfirmDialog render app actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        AppDialog(
          title: const Text('标题'),
          body: const Text('内容'),
          actions: [AppActionButton(onPressed: () {}, label: '确定')],
        ),
      ),
    );

    expect(find.text('标题'), findsOneWidget);
    expect(find.text('内容'), findsOneWidget);
    expect(find.byType(FDialog), findsOneWidget);

    await tester.pumpWidget(
      _app(
        AppConfirmDialog(
          title: '删除',
          content: const Text('确认删除？'),
          confirmLabel: '删除',
          destructive: true,
          onConfirm: () {},
        ),
      ),
    );

    expect(find.text('删除'), findsWidgets);
    expect(find.text('确认删除？'), findsOneWidget);
  });

  testWidgets('showAppDialog renders AppDialogFrame and returns a value', (
    tester,
  ) async {
    String? result;

    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => AppActionButton(
            onPressed: () async {
              result = await showAppDialog<String>(
                context: context,
                builder: (context) => AppDialogFrame(
                  child: AppActionButton(
                    onPressed: () => Navigator.pop(context, 'done'),
                    label: '完成',
                  ),
                ),
              );
            },
            label: '打开',
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.byType(AppDialogFrame), findsOneWidget);
    expect(find.byType(Dialog), findsOneWidget);

    await tester.tap(find.text('完成'));
    await tester.pumpAndSettle();

    expect(result, 'done');
  });

  testWidgets(
    'showAppBottomSheet renders AppBottomSheetFrame and returns value',
    (tester) async {
      String? result;

      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => AppActionButton(
              onPressed: () async {
                result = await showAppBottomSheet<String>(
                  context: context,
                  builder: (context) => AppBottomSheetFrame(
                    child: AppActionButton(
                      onPressed: () => Navigator.pop(context, 'selected'),
                      label: '选择',
                    ),
                  ),
                );
              },
              label: '打开面板',
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开面板'));
      await tester.pumpAndSettle();

      expect(find.byType(AppBottomSheetFrame), findsOneWidget);
      expect(find.text('选择'), findsOneWidget);

      await tester.tap(find.text('选择'));
      await tester.pumpAndSettle();

      expect(result, 'selected');
    },
  );

  testWidgets('AppCard and AppTile use ForUI structure components', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      _app(
        AppCard(
          child: AppTile(
            prefix: const Icon(Icons.folder_outlined),
            title: const Text('媒体库'),
            subtitle: const Text('3 项'),
            suffix: const Icon(Icons.chevron_right_rounded),
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(FCard), findsOneWidget);
    expect(find.byType(FTile), findsOneWidget);
    await tester.tap(find.text('媒体库'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(tapped, isTrue);
  });

  testWidgets('AppInkSurface centralizes tappable material surfaces', (
    tester,
  ) async {
    var tapped = false;
    var longPressed = false;

    await tester.pumpWidget(
      _app(
        AppInkSurface(
          onTap: () => tapped = true,
          onLongPress: () => longPressed = true,
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
          padding: const EdgeInsets.all(12),
          child: const Text('卡片'),
        ),
      ),
    );

    expect(find.byType(Material), findsWidgets);
    expect(find.byType(InkWell), findsOneWidget);
    expect(find.text('卡片'), findsOneWidget);

    await tester.tap(find.text('卡片'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(tapped, isTrue);

    await tester.longPress(find.text('卡片'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(longPressed, isTrue);
  });

  testWidgets('AppScaffold and AppPageBar wrap page chrome', (tester) async {
    await tester.pumpWidget(
      _app(
        const AppScaffold(
          appBar: AppPageBar(
            title: Text('页面'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Center(child: Text('内容')),
          backgroundColor: Colors.white,
        ),
      ),
    );

    expect(find.byType(AppScaffold), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('页面'), findsOneWidget);
    expect(find.text('内容'), findsOneWidget);
  });

  testWidgets('AppPageBar supports compact page chrome', (tester) async {
    const appBar = AppPageBar(
      title: Text('紧凑页面'),
      toolbarHeight: 44,
      avoidMacOsTitleBar: false,
    );

    await tester.pumpWidget(_app(const AppScaffold(appBar: appBar)));

    expect(appBar.preferredSize.height, 44);
    expect(tester.widget<AppBar>(find.byType(AppBar)).toolbarHeight, 44);
  });

  testWidgets('AppTransparentRouteSurface keeps transparent material route', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const AppTransparentRouteSurface(child: Text('登录'))),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(AppTransparentRouteSurface),
        matching: find.byType(Material),
      ),
    );
    expect(material.type, MaterialType.transparency);
    expect(find.text('登录'), findsOneWidget);
  });

  testWidgets('AppOverlaySurface wraps overlay material settings', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppOverlaySurface(
          type: MaterialType.canvas,
          color: Colors.black,
          child: Text('覆盖层'),
        ),
      ),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(AppOverlaySurface),
        matching: find.byType(Material),
      ),
    );
    expect(material.type, MaterialType.canvas);
    expect(material.color, Colors.black);
    expect(find.text('覆盖层'), findsOneWidget);
  });

  testWidgets('AppBlurSurface wraps blur and decorated content', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppBlurSurface(
          color: Colors.white,
          padding: EdgeInsets.all(12),
          child: Text('模糊面板'),
        ),
      ),
    );

    expect(find.byType(ClipRRect), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('模糊面板'), findsOneWidget);
  });

  testWidgets('AppPanelSurface centralizes panel decoration', (tester) async {
    await tester.pumpWidget(
      _app(
        AppPanelSurface(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
          constraints: const BoxConstraints(maxHeight: 120),
          boxShadow: const [BoxShadow(blurRadius: 12)],
          child: const Text('面板'),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).last);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, Colors.red);
    expect(decoration.borderRadius, BorderRadius.circular(16));
    expect(decoration.boxShadow, isNotEmpty);
    expect(container.constraints, const BoxConstraints(maxHeight: 120));
    expect(container.clipBehavior, Clip.antiAlias);
    expect(find.text('面板'), findsOneWidget);
  });

  testWidgets('AppFloatingInputSurface applies input shell chrome', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const AppFloatingInputSurface(child: Text('输入'))),
    );

    final panel = tester.widget<Container>(find.byType(Container).last);
    final decoration = panel.decoration! as BoxDecoration;
    expect(panel.margin, const EdgeInsets.fromLTRB(16, 0, 16, 16));
    expect(decoration.borderRadius, BorderRadius.circular(24));
    expect(decoration.boxShadow, isNotEmpty);
    expect(find.text('输入'), findsOneWidget);
  });

  testWidgets('AppBadge and AppIconBadge centralize compact indicators', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Column(
          children: [
            AppBadge(icon: Icons.lock, color: Colors.blue, label: Text('密码')),
            AppIconBadge(icon: Icons.meeting_room, color: Colors.green),
          ],
        ),
      ),
    );

    expect(find.text('密码'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.byIcon(Icons.meeting_room), findsOneWidget);

    final panels = tester.widgetList<Container>(find.byType(Container));
    expect(
      panels.where((container) => container.decoration is BoxDecoration),
      isNotEmpty,
    );
  });

  testWidgets('AppInfoBanner renders icon, content, and trailing actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppInfoBanner(
          icon: Icons.info_outline,
          boxedIcon: true,
          title: Text('提示'),
          message: Text('这里是说明'),
          trailing: AppBadge(label: Text('状态')),
        ),
      ),
    );

    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.text('提示'), findsOneWidget);
    expect(find.text('这里是说明'), findsOneWidget);
    expect(find.text('状态'), findsOneWidget);
    expect(find.byType(AppIconBadge), findsOneWidget);
  });

  testWidgets('AppEmptyState and AppImageThumbnail render reusable states', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Column(
          children: [
            AppEmptyState(
              icon: Icons.inbox_outlined,
              title: '暂无数据',
              subtitle: '稍后再试',
            ),
            AppImageThumbnail(
              url: 'https://example.invalid/image.jpg',
              width: 80,
              height: 48,
            ),
            AppImageThumbnail.asset(
              assetName: 'missing-asset.png',
              width: 32,
              height: 32,
              errorChild: Text('图片不可用'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('暂无数据'), findsOneWidget);
    expect(find.text('稍后再试'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
    expect(find.byType(AppPanelSurface), findsWidgets);
  });

  testWidgets('AppSafeArea wraps SafeArea configuration', (tester) async {
    await tester.pumpWidget(
      _app(
        const AppSafeArea(
          top: false,
          minimum: EdgeInsets.all(12),
          child: Text('安全区'),
        ),
      ),
    );

    final safeArea = tester.widget<SafeArea>(find.byType(SafeArea).last);
    expect(safeArea.top, isFalse);
    expect(safeArea.minimum, const EdgeInsets.all(12));
    expect(find.text('安全区'), findsOneWidget);
  });

  testWidgets('AppSliverAppBar wraps SliverAppBar configuration', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        CustomScrollView(
          slivers: [
            const AppSliverAppBar(
              expandedHeight: 80,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(title: Text('标题')),
            ),
            SliverToBoxAdapter(child: Container(height: 120)),
          ],
        ),
      ),
    );

    final appBar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));
    expect(appBar.expandedHeight, 80);
    expect(appBar.pinned, isTrue);
    expect(appBar.automaticallyImplyLeading, isFalse);
  });

  testWidgets('AppAccordionItem uses ForUI accordion and reveals content', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const AppAccordionItem(title: Text('事件分组'), child: Text('分组内容'))),
    );

    expect(find.byType(FAccordion), findsOneWidget);
    expect(find.text('事件分组'), findsOneWidget);

    await tester.tap(find.text('事件分组'));
    await tester.pumpAndSettle();

    expect(find.text('分组内容'), findsOneWidget);
  });

  testWidgets('AppSwitch and AppCheckbox use ForUI controls', (tester) async {
    var switchValue = false;
    var checkboxValue = false;

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppSwitch(
              value: switchValue,
              label: '启用',
              onChanged: (value) => switchValue = value,
            ),
            AppCheckbox(
              value: checkboxValue,
              label: '选择',
              onChanged: (value) => checkboxValue = value,
            ),
          ],
        ),
      ),
    );

    expect(find.byType(FSwitch), findsOneWidget);
    expect(find.byType(FCheckbox), findsOneWidget);

    await tester.tap(find.text('启用'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.text('选择'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(switchValue, isTrue);
    expect(checkboxValue, isTrue);
  });

  testWidgets('AppSwitchTile and AppCheckboxTile toggle from tile presses', (
    tester,
  ) async {
    var switchValue = false;
    var checkboxValue = false;

    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                AppSwitchTile(
                  value: switchValue,
                  title: const Text('通知'),
                  subtitle: const Text('接收账号事件'),
                  onChanged: (value) => setState(() => switchValue = value),
                ),
                AppCheckboxTile(
                  value: checkboxValue,
                  title: const Text('全选'),
                  suffix: const Icon(Icons.filter_list_rounded),
                  onChanged: (value) => setState(() => checkboxValue = value),
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.byType(FTile), findsNWidgets(2));
    expect(find.byType(FSwitch), findsOneWidget);
    expect(find.byType(FCheckbox), findsOneWidget);

    await tester.tap(find.text('通知'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.text('全选'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(switchValue, isTrue);
    expect(checkboxValue, isTrue);
  });

  testWidgets('AppChip supports selection, press, delete, and static states', (
    tester,
  ) async {
    var selected = false;
    var pressed = false;
    var deleted = false;

    await tester.pumpWidget(
      _app(
        Wrap(
          children: [
            AppChip(
              label: const Text('筛选'),
              selected: selected,
              onSelected: (value) => selected = value,
            ),
            AppChip(
              label: const Text('动作'),
              avatar: const Icon(Icons.flash_on_rounded),
              onPressed: () => pressed = true,
            ),
            AppChip(label: const Text('删除'), onDeleted: () => deleted = true),
            const AppChip(label: Text('状态')),
          ],
        ),
      ),
    );

    expect(find.byType(FilterChip), findsOneWidget);
    expect(find.byType(ActionChip), findsOneWidget);
    expect(find.byType(InputChip), findsOneWidget);
    expect(find.byType(Chip), findsWidgets);

    await tester.tap(find.byType(FilterChip));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.byType(ActionChip));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.byType(InputChip));
    await tester.pump(const Duration(milliseconds: 150));

    expect(selected, isTrue);
    expect(pressed, isTrue);
    expect(deleted, isFalse);
  });

  testWidgets('AppFloatingActionButton wraps Material FAB behavior', (
    tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      _app(
        AppFloatingActionButton(
          onPressed: () => pressed = true,
          icon: Icons.add_rounded,
          tooltip: '添加',
          small: true,
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(_byTooltip('添加'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(pressed, isTrue);
  });

  testWidgets('AppSelect uses ForUI select and reports changes', (
    tester,
  ) async {
    var selected = 'created';

    await tester.pumpWidget(
      _app(
        AppSelect<String>(
          value: selected,
          label: '排序',
          options: const {'创建时间': 'created', '更新时间': 'updated'},
          onChanged: (value) {
            if (value != null) selected = value;
          },
        ),
      ),
    );

    expect(find.byType(AppSelect<String>), findsOneWidget);
    expect(find.text('创建时间'), findsOneWidget);

    await tester.tap(find.text('创建时间'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.text('更新时间').last);
    await tester.pump(const Duration(milliseconds: 150));

    expect(selected, 'updated');
  });

  testWidgets('AppSelect supports nullable option values', (tester) async {
    bool? selected = true;
    final changes = <bool?>[];

    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            return AppSelect<bool?>(
              value: selected,
              label: '封禁状态',
              options: const {'全部': null, '已封禁': true, '未封禁': false},
              onChanged: (value) {
                changes.add(value);
                setState(() => selected = value);
              },
            );
          },
        ),
      ),
    );

    expect(find.byType(AppSelect<bool?>), findsOneWidget);
    expect(find.text('已封禁'), findsOneWidget);

    await tester.tap(find.text('已封禁'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.text('全部').last);
    await tester.pump(const Duration(milliseconds: 150));

    expect(selected, isNull);
    expect(changes.last, isNull);
  });

  testWidgets('AppSelect participates in Flutter forms', (tester) async {
    final formKey = GlobalKey<FormState>();
    var selected = 3;
    int? saved;

    await tester.pumpWidget(
      _app(
        Form(
          key: formKey,
          child: StatefulBuilder(
            builder: (context, setState) {
              return AppSelect<int>(
                value: selected,
                label: '角色',
                prefixIcon: Icons.admin_panel_settings_outlined,
                options: const {'管理员': 2, '成员': 3},
                validator: (value) => value == 2 ? null : '请选择管理员',
                onSaved: (value) => saved = value,
                onChanged: (value) {
                  if (value != null) setState(() => selected = value);
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.text('成员'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.text('管理员').last);
    await tester.pump(const Duration(milliseconds: 150));

    expect(formKey.currentState!.validate(), isTrue);
    formKey.currentState!.save();
    expect(saved, 2);
  });

  testWidgets('AppRefreshIndicator wraps pull to refresh behavior', (
    tester,
  ) async {
    var refreshed = false;

    await tester.pumpWidget(
      _app(
        AppRefreshIndicator(
          onRefresh: () async => refreshed = true,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [SizedBox(height: 600, child: Text('列表'))],
          ),
        ),
      ),
    );

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.drag(find.text('列表'), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(refreshed, isTrue);
  });

  testWidgets('AppAvatar renders initials and fallback consistently', (
    tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      _app(
        Row(
          textDirection: TextDirection.ltr,
          children: [
            AppAvatar(
              name: 'alice',
              tooltip: '用户头像',
              onPressed: () => pressed = true,
            ),
            const AppAvatar(
              name: '',
              fallbackIcon: Icons.person_outline_rounded,
            ),
            const AppAvatar(name: 'bob', size: 40, shape: BoxShape.rectangle),
          ],
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    expect(find.text('B'), findsOneWidget);

    await tester.tap(_byTooltip('用户头像'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(pressed, isTrue);
  });

  testWidgets('AppListView supports children, builder, and separators', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const AppListView(shrinkWrap: true, children: [Text('静态列表')])),
    );
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('静态列表'), findsOneWidget);

    await tester.pumpWidget(
      _app(
        AppListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) => Text('条目 $index'),
        ),
      ),
    );
    expect(find.text('条目 0'), findsOneWidget);
    expect(find.text('条目 1'), findsOneWidget);

    await tester.pumpWidget(
      _app(
        AppListView.separated(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) => Text('分隔条目 $index'),
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
    expect(find.text('分隔条目 0'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('AppSingleChildScrollView wraps single child scrolling', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppSingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: SizedBox(height: 600, child: Text('滚动内容')),
        ),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('滚动内容'), findsOneWidget);
  });

  testWidgets('AppGridView supports builder and count layouts', (tester) async {
    await tester.pumpWidget(
      _app(
        AppGridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: 2,
          itemBuilder: (context, index) => Text('网格 $index'),
        ),
      ),
    );
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('网格 0'), findsOneWidget);
    expect(find.text('网格 1'), findsOneWidget);

    await tester.pumpWidget(
      _app(
        const AppGridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [Text('固定网格')],
        ),
      ),
    );
    expect(find.text('固定网格'), findsOneWidget);
  });

  testWidgets('AppDivider wraps themed horizontal and vertical dividers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Row(
          children: [
            Expanded(child: AppDivider(height: 12)),
            AppVerticalDivider(width: 12),
          ],
        ),
      ),
    );

    expect(find.byType(Divider), findsOneWidget);
    expect(find.byType(VerticalDivider), findsOneWidget);
  });

  testWidgets('AppEmptyMessage renders compact empty states', (tester) async {
    await tester.pumpWidget(
      _app(const AppEmptyMessage(message: '暂无内容', icon: Icons.inbox_outlined)),
    );

    expect(find.text('暂无内容'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('AppEmptyState supports constrained branded states', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const AppEmptyState(
          icon: Icons.tv_rounded,
          iconColor: Color(0xFFFB7299),
          iconSize: 58,
          title: '粘贴 Bilibili 链接',
          subtitle: '支持 BV 号、视频链接和直播间链接。',
          maxWidth: 360,
        ),
      ),
    );

    expect(find.byIcon(Icons.tv_rounded), findsOneWidget);
    expect(find.text('粘贴 Bilibili 链接'), findsOneWidget);
    expect(find.byType(ConstrainedBox), findsWidgets);
  });

  testWidgets(
    'PlaylistEmptyState hides add action when mutation is unavailable',
    (tester) async {
      await tester.pumpWidget(_app(const PlaylistEmptyState(compact: true)));

      expect(find.text('播放列表为空'), findsOneWidget);
      expect(find.text('添加媒体'), findsNothing);
      expect(find.byIcon(Icons.add_rounded), findsNothing);
    },
  );

  testWidgets('PlaylistEmptyState shows add action for editable playlists', (
    tester,
  ) async {
    var added = false;

    await tester.pumpWidget(
      _app(PlaylistEmptyState(compact: true, onAdd: () => added = true)),
    );

    expect(find.text('添加媒体'), findsOneWidget);
    await tester.tap(find.text('添加媒体'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(added, isTrue);
  });

  testWidgets('AppPaginationBar renders label and page actions', (
    tester,
  ) async {
    var previous = 0;
    var next = 0;

    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => AppPaginationBar.page(
            context: context,
            page: 2,
            pageSize: 20,
            total: 42,
            onPrevious: () => previous += 1,
            onNext: () => next += 1,
          ),
        ),
      ),
    );

    expect(find.text('第 2 页 · 每页 20 条 · 共 42 条'), findsOneWidget);

    await tester.tap(_byTooltip('上一页'));
    await tester.tap(_byTooltip('下一页'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(previous, 1);
    expect(next, 1);
  });

  testWidgets('AppPaginationBar supports shrink-wrapped horizontal toolbars', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPaginationBar(
              padding: EdgeInsets.zero,
              label: '共 42 个 · 第 2 / 3 页',
              onPrevious: () {},
              onNext: () {},
            ),
            const SizedBox(width: 8),
            AppIconButton(
              onPressed: () {},
              icon: Icons.refresh_rounded,
              tooltip: '刷新',
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('共 42 个 · 第 2 / 3 页'), findsOneWidget);
  });

  testWidgets('AppDataToolbar renders count, actions, and compact layout', (
    tester,
  ) async {
    var refreshes = 0;
    var actions = 0;

    await tester.pumpWidget(
      _app(
        SizedBox(
          width: 320,
          child: AppDataToolbar(
            title: '房间成员',
            count: 12,
            onRefresh: () => refreshes += 1,
            action: AppIconButton(
              tooltip: '添加成员',
              icon: Icons.person_add_alt_1,
              onPressed: () => actions += 1,
            ),
          ),
        ),
      ),
    );

    expect(find.text('房间成员'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.byType(AppSingleChildScrollView), findsOneWidget);

    await tester.tap(_byTooltip('添加成员'));
    await tester.tap(_byTooltip('刷新'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(actions, 1);
    expect(refreshes, 1);

    await tester.pumpWidget(
      _app(
        AppDataToolbar(
          title: '加载中',
          count: 3,
          loading: true,
          onRefresh: () => refreshes += 1,
        ),
      ),
    );

    await tester.tap(_byTooltip('刷新'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(refreshes, 1);
    expect(find.byType(FCircularProgress), findsOneWidget);
  });

  testWidgets('AppLoadMoreFooter switches between action and loading', (
    tester,
  ) async {
    var presses = 0;

    await tester.pumpWidget(
      _app(AppLoadMoreFooter(loading: false, onPressed: () => presses += 1)),
    );

    expect(find.text('加载更多'), findsOneWidget);
    await tester.tap(find.text('加载更多'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(presses, 1);

    await tester.pumpWidget(
      _app(const AppLoadMoreFooter(loading: true, onPressed: null)),
    );

    expect(find.byType(FCircularProgress), findsOneWidget);
    expect(find.text('加载更多'), findsNothing);
  });
}
