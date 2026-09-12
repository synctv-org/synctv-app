import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
  Finder progressSemantics(Key key) => find.descendant(
    of: find.byKey(key),
    matching: find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          (widget.properties.role == ui.SemanticsRole.loadingSpinner ||
              widget.properties.role == ui.SemanticsRole.progressBar),
    ),
  );

  for (final scale in [1.0, 3.0]) {
    for (final target in ['prefix', 'padding']) {
      testWidgets('AppSelect activates from $target at ${scale}x', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 568);
        addTearDown(tester.view.reset);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final focusNode = scale == 3 ? FocusNode() : null;
        addTearDown(() => focusNode?.dispose());
        late StateSetter update;
        var enabled = false;
        String? selected = 'music';
        final changes = <String?>[];
        await tester.pumpWidget(
          _app(
            Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return AppSelect<String>(
                    value: selected,
                    options: const {'Music': 'music', 'Film': 'film'},
                    enabled: enabled,
                    prefixIcon: Icons.music_note,
                    focusNode: focusNode,
                    clearable: true,
                    onChanged: (value) {
                      changes.add(value);
                      setState(() => selected = value);
                    },
                  );
                },
              ),
            ),
          ),
        );
        Future<void> tapTarget() => tester.tapAt(
          target == 'prefix'
              ? tester.getCenter(find.byIcon(Icons.music_note))
              : tester.getTopLeft(find.byType(InputDecorator)) +
                    const Offset(12, 2),
        );
        await tapTarget();
        await tester.pumpAndSettle();
        expect(find.text('Film').hitTestable(), findsNothing);
        update(() => enabled = true);
        await tester.pumpAndSettle();
        await tapTarget();
        await tester.pumpAndSettle();
        expect(find.text('Film').hitTestable(), findsOneWidget);
        await tester.tap(find.text('Film').hitTestable());
        await tester.pumpAndSettle();
        expect(changes, ['film']);
        await tester.tap(find.byType(AppIconButton));
        await tester.pumpAndSettle();
        expect(changes, ['film', null]);
        expect(find.text('Film').hitTestable(), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final action in ['clear', 'select']) {
    for (final invalidation in [
      'disabled',
      'callback',
      'disposed',
      'options',
    ]) {
      testWidgets('AppSelect ignores stale $action after $invalidation', (
        tester,
      ) async {
        late StateSetter update;
        var enabled = true;
        var callbackAvailable = true;
        var show = true;
        var options = <String, String>{'Music': 'music', 'Film': 'film'};
        var clearable = true;
        final changes = <String?>[];
        await tester.pumpWidget(
          _app(
            StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return show
                    ? AppSelect<String>(
                        value: 'music',
                        options: options,
                        enabled: enabled,
                        clearable: clearable,
                        onChanged: callbackAvailable ? changes.add : null,
                      )
                    : const SizedBox();
              },
            ),
          ),
        );
        final dropdown = tester.widget<DropdownButton<String>>(
          find.byType(DropdownButton<String>),
        );
        final clear = tester
            .widget<AppIconButton>(find.byType(AppIconButton))
            .onPressed!;
        update(() {
          switch (invalidation) {
            case 'disabled':
              enabled = false;
            case 'callback':
              callbackAvailable = false;
            case 'disposed':
              show = false;
            case 'options':
              options = {'Music': 'music'};
              clearable = false;
          }
        });
        await tester.pumpAndSettle();
        if (action == 'clear') {
          clear();
        } else {
          dropdown.onChanged!('film');
        }
        await tester.pumpAndSettle();
        expect(changes, isEmpty);
        if (show) {
          expect(
            tester
                .widget<DropdownButton<String>>(
                  find.byType(DropdownButton<String>),
                )
                .value,
            'music',
          );
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'AppSelect does not submit an option removed while menu is open',
    (tester) async {
      late StateSetter update;
      var options = <String, String>{'Music': 'music', 'Film': 'film'};
      final changes = <String?>[];
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return AppSelect<String>(
                value: 'music',
                options: options,
                onChanged: changes.add,
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      update(() => options = {'Music': 'music'});
      await tester.pumpAndSettle();
      final obsolete = find.widgetWithText(DropdownMenuItem<String>, 'Film');
      if (obsolete.evaluate().isNotEmpty) {
        await tester.tap(obsolete.last);
        await tester.pumpAndSettle();
      }
      expect(changes, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('AppSelect reconciles removed and returning option values', (
    tester,
  ) async {
    final form = GlobalKey<FormState>();
    late StateSetter update;
    var options = <String, String>{'Music': 'music', 'Film': 'film'};
    String? saved = 'unset';
    var changes = 0;
    await tester.pumpWidget(
      _app(
        Form(
          key: form,
          child: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return AppSelect<String>(
                value: 'music',
                options: options,
                hintText: 'Choose a category',
                label: 'Category',
                onChanged: (_) => changes++,
                onSaved: (value) => saved = value,
                validator: (value) => value == null ? 'Required' : null,
              );
            },
          ),
        ),
      ),
    );
    for (final next in [
      <String, String>{'Film': 'film'},
      <String, String>{},
      <String, String>{'Music': 'music'},
    ]) {
      update(() => options = next);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      form.currentState!.save();
      expect(saved, next.containsValue('music') ? 'music' : null);
      expect(form.currentState!.validate(), next.containsValue('music'));
      await tester.pumpAndSettle();
      expect(changes, 0);
    }
  });

  testWidgets(
    'AppSelect menu allows long options to grow at large text scale',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.reset);
      const label = 'International cinema screenings';
      tester.platformDispatcher.textScaleFactorTestValue = 3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      String? selected;
      await tester.pumpWidget(
        _app(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 568),
              textScaler: TextScaler.linear(3),
            ),
            child: Center(
              child: SizedBox(
                width: 280,
                child: AppSelect<String>(
                  value: 'short',
                  options: const {'Music': 'short', label: 'long'},
                  onChanged: (value) => selected = value,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      final item = find.widgetWithText(DropdownMenuItem<String>, label).last;
      expect(
        tester.getSize(item).height,
        greaterThan(kMinInteractiveDimension),
      );
      await tester.ensureVisible(item);
      await tester.pumpAndSettle();
      await tester.tap(item);
      await tester.pumpAndSettle();
      expect(selected, 'long');
      expect(tester.takeException(), isNull);
    },
  );

  for (final axis in Axis.values) {
    for (final showTooltip in [true, false]) {
      testWidgets(
        'AppIconButton reveals direct focus $axis tooltip=$showTooltip',
        (tester) async {
          final controller = ScrollController();
          final first = FocusNode();
          final last = FocusNode();
          addTearDown(controller.dispose);
          addTearDown(first.dispose);
          addTearDown(last.dispose);
          const viewportKey = ValueKey('focus-viewport');
          const firstKey = ValueKey('first-focus-button');
          const lastKey = ValueKey('last-focus-button');
          final children = [
            AppIconButton(
              key: firstKey,
              focusNode: first,
              showTooltip: showTooltip,
              tooltip: 'First',
              icon: Icons.settings,
              onPressed: () {},
            ),
            SizedBox(
              width: axis == Axis.horizontal ? 600 : 0,
              height: axis == Axis.vertical ? 600 : 0,
            ),
            AppIconButton(
              key: lastKey,
              focusNode: last,
              showTooltip: showTooltip,
              tooltip: 'Last',
              icon: Icons.copy,
              onPressed: () {},
            ),
          ];
          await tester.pumpWidget(
            _app(
              Center(
                child: SizedBox(
                  key: viewportKey,
                  width: 220,
                  height: 220,
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: axis,
                    child: axis == Axis.vertical
                        ? Column(children: children)
                        : Row(children: children),
                  ),
                ),
              ),
            ),
          );
          final viewport = tester.getRect(find.byKey(viewportKey));
          first.requestFocus();
          await tester.pumpAndSettle();
          expect(controller.offset, 0);
          last.requestFocus();
          await tester.pumpAndSettle();
          final lastBounds = tester.getRect(find.byKey(lastKey));
          expect(viewport.contains(lastBounds.center), isTrue);
          expect(
            axis == Axis.vertical ? lastBounds.bottom : lastBounds.right,
            lessThanOrEqualTo(
              axis == Axis.vertical ? viewport.bottom : viewport.right,
            ),
          );
          final offset = controller.offset;
          last.requestFocus();
          await tester.pumpAndSettle();
          expect(controller.offset, offset);
          first.requestFocus();
          await tester.pumpAndSettle();
          expect(
            viewport.contains(tester.getRect(find.byKey(firstKey)).center),
            isTrue,
          );
          expect(controller.offset, 0);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  for (final enabled in [true, false]) {
    for (final invalid in [true, false]) {
      for (final selected in [null, 'music']) {
        testWidgets(
          'AppSelect selected value retains button semantics enabled=$enabled invalid=$invalid value=$selected',
          (tester) async {
            final semantics = tester.ensureSemantics();
            await tester.pumpWidget(
              _app(
                AppSelect<String?>(
                  value: selected,
                  options: const {'Music': 'music', 'None': null},
                  label: 'Category',
                  labelAbove: true,
                  enabled: enabled,
                  errorText: invalid ? 'Required' : null,
                  onChanged: (_) {},
                ),
              ),
            );
            await tester.pumpAndSettle();
            final node = tester.getSemantics(
              find.text(selected == null ? 'None' : 'Music'),
            );
            expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
            expect(
              node.getSemanticsData().flagsCollection.isEnabled,
              enabled ? ui.Tristate.isTrue : ui.Tristate.isFalse,
            );
            expect(
              node.getSemanticsData().hasAction(ui.SemanticsAction.tap),
              enabled,
            );
            semantics.dispose();
          },
        );
      }
    }
  }
  testWidgets('External field label wraps and names the password input', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = TextEditingController(text: ' untouched password ');
    addTearDown(controller.dispose);
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const label = 'Confirm new password';
    await tester.pumpWidget(
      _app(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AppTextField(
              controller: controller,
              label: label,
              labelAbove: true,
              obscureText: true,
            ),
          ),
        ),
      ),
    );
    final text = tester.renderObject<RenderParagraph>(find.text(label));
    expect(text.didExceedMaxLines, isFalse);
    expect(text.size.height, greaterThan(50));
    final named = find.bySemanticsLabel(label);
    expect(named, findsOneWidget);
    expect(
      tester.getSemantics(named).getSemanticsData().flagsCollection.isTextField,
      isTrue,
    );
    await tester.tap(_byTooltip('显示密码'));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isFalse,
    );
    expect(controller.text, ' untouched password ');
    expect(find.bySemanticsLabel(label), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('Multiline read-only fields reveal the full value and update', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final value in [
      'preview.account@example.test',
      'second.account@example.test',
    ]) {
      await tester.pumpWidget(
        _app(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(3)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AppReadOnlyField(
                label: 'Recipient email',
                value: value,
                labelAbove: true,
                maxLines: null,
              ),
            ),
          ),
        ),
      );
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.readOnly, isTrue);
      expect(editable.enableInteractiveSelection, isTrue);
      expect(editable.controller.text, value);
      final render = tester
          .state<EditableTextState>(find.byType(EditableText))
          .renderEditable;
      expect(render.maxScrollExtent, 0);
      expect(render.size.height, greaterThan(80));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('AppTile stacked actions wrap and preserve independent taps', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var rowTaps = 0;
    var actionTaps = 0;
    await tester.pumpWidget(
      _app(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: ListView(
            children: [
              AppTile(
                title: const Text('Account'),
                subtitle: const Text('Security settings'),
                prefix: const Icon(Icons.security),
                stackedSuffix: true,
                onPressed: () => rowTaps++,
                suffix: AppActionButton(
                  label: 'Manage recovery codes',
                  wrapLabel: true,
                  onPressed: () => actionTaps++,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final action = find.text('Manage recovery codes');
    expect(
      tester.renderObject<RenderParagraph>(action).didExceedMaxLines,
      isFalse,
    );
    await tester.tap(action);
    expect(actionTaps, 1);
    expect(rowTaps, 0);
    await tester.tap(find.text('Account'));
    expect(rowTaps, 1);
    expect(actionTaps, 1);
  });

  for (final validated in [false, true]) {
    for (final width in [320.0, 740.0]) {
      testWidgets(
        'AppTextField wraps complete errors at $width, validator=$validated',
        (tester) async {
          const message =
              'Enter a SOCKS5 host and optional port (0-65535), without credentials, path, query, or fragment.';
          final controller = TextEditingController();
          final form = GlobalKey<FormState>();
          addTearDown(controller.dispose);
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            _app(
              MediaQuery(
                data: MediaQueryData(
                  size: Size(width, 900),
                  textScaler: const TextScaler.linear(2),
                ),
                child: Form(
                  key: form,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AppTextField(
                      controller: controller,
                      label: 'Proxy',
                      errorText: validated ? null : message,
                      validator: validated ? (_) => message : null,
                    ),
                  ),
                ),
              ),
            ),
          );
          if (validated) form.currentState!.validate();
          await tester.pumpAndSettle();
          final error = tester.renderObject<RenderParagraph>(
            find.text(message),
          );
          expect(error.didExceedMaxLines, isFalse);
          expect(error.size.height, greaterThan(40));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('checkbox tiles expose one toggle and keep links actionable', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var toggles = 0;
    var links = 0;
    await tester.pumpWidget(
      _app(
        AppCheckboxTile(
          value: false,
          semanticsLabel: 'Accept terms',
          prefix: const Icon(Icons.policy),
          title: Wrap(
            children: [
              const Text('I agree to'),
              AppActionButton(
                onPressed: () => links++,
                label: 'Terms',
                style: AppActionButtonStyle.text,
              ),
            ],
          ),
          onChanged: (_) => toggles++,
        ),
      ),
    );
    final togglesFinder = find.semantics.byPredicate(
      (node) =>
          node.getSemanticsData().flagsCollection.isChecked !=
          ui.CheckedState.none,
      describeMatch: (_) => 'checkbox semantics',
    );
    expect(togglesFinder, findsOneWidget);
    expect(find.byIcon(Icons.policy), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(
      find.semantics.byPredicate((node) {
        final data = node.getSemanticsData();
        return data.flagsCollection.isChecked == ui.CheckedState.isFalse &&
            data.flagsCollection.isFocused == ui.Tristate.isTrue &&
            data.label.contains('Accept terms');
      }),
      findsOneWidget,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(toggles, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(links, 1);
    expect(toggles, 1);
    await tester.tap(find.text('Terms'));
    expect(links, 2);
    expect(toggles, 1);
    await tester.tap(find.text('I agree to'));
    expect(toggles, 2);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('disabled checkbox tile keeps its link independently focusable', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var toggles = 0;
    var links = 0;
    await tester.pumpWidget(
      _app(
        AppCheckboxTile(
          value: true,
          enabled: false,
          semanticsLabel: 'Accept terms',
          onChanged: (_) => toggles++,
          title: AppActionButton(label: 'Terms', onPressed: () => links++),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(
      find.semantics.byPredicate((node) {
        final data = node.getSemanticsData();
        return data.flagsCollection.isChecked == ui.CheckedState.isTrue &&
            data.flagsCollection.isEnabled == ui.Tristate.isFalse &&
            data.flagsCollection.isFocused != ui.Tristate.isTrue &&
            !data.hasAction(ui.SemanticsAction.tap);
      }),
      findsOneWidget,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(links, 1);
    expect(toggles, 0);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('buttons expose one named semantic action', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppActionButton(onPressed: () {}, label: 'Create room'),
            AppIconButton(
              onPressed: () {},
              icon: Icons.refresh,
              tooltip: 'Refresh rooms',
            ),
          ],
        ),
      ),
    );
    final buttons = find.semantics.byPredicate(
      (node) => node.getSemanticsData().flagsCollection.isButton,
      describeMatch: (_) => 'button semantics',
    );
    expect(buttons, findsNWidgets(2));
    expect(find.bySemanticsLabel('Create room'), findsOneWidget);
    expect(find.bySemanticsLabel('Refresh rooms'), findsOneWidget);
    semantics.dispose();
  });

  for (final direction in TextDirection.values) {
    for (final change in ['viewport', 'text scale']) {
      for (final explicitController in [false, true]) {
        testWidgets(
          'scrollable tabs reveal selection after $change $direction explicit=$explicitController',
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(1200, 400));
            addTearDown(() => tester.binding.setSurfaceSize(null));
            var scale = 1.0;
            late StateSetter rebuild;
            await tester.pumpWidget(
              _app(
                Directionality(
                  textDirection: direction,
                  child: DefaultTabController(
                    length: 5,
                    initialIndex: 3,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        rebuild = setState;
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaler: TextScaler.linear(scale)),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: AppTabBar(
                              controller: explicitController
                                  ? DefaultTabController.of(context)
                                  : null,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              tabs: const [
                                Tab(text: 'Overview'),
                                Tab(text: 'Library'),
                                Tab(text: 'Providers'),
                                Tab(text: 'Selected account'),
                                Tab(text: 'Settings'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            if (change == 'viewport') {
              await tester.binding.setSurfaceSize(const Size(320, 400));
            } else {
              rebuild(() => scale = 3);
            }
            await tester.pumpAndSettle();

            final bounds = tester.getRect(find.byType(AppTabBar));
            final selected = tester.getRect(find.text('Selected account'));
            expect(selected.left, greaterThanOrEqualTo(bounds.left));
            expect(selected.right, lessThanOrEqualTo(bounds.right));
            final position = tester
                .state<ScrollableState>(
                  find.descendant(
                    of: find.byType(AppTabBar),
                    matching: find.byType(Scrollable),
                  ),
                )
                .position;
            position.jumpTo(position.minScrollExtent);
            await tester.pumpAndSettle();
            rebuild(() {});
            await tester.pumpAndSettle();
            expect(position.pixels, position.minScrollExtent);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  for (final direction in TextDirection.values) {
    testWidgets('scrollable tabs accept mouse drag input $direction', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 240));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _app(
          Directionality(
            textDirection: direction,
            child: const DefaultTabController(
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
        ),
      );

      final scrollable = find.descendant(
        of: find.byType(AppTabBar),
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(scrollable).position;
      expect(position.pixels, 0);

      final mouse = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      addTearDown(mouse.removePointer);
      final start = tester.getCenter(find.text('Users'));
      await mouse.addPointer(location: start);
      await mouse.down(start);
      final delta = direction == TextDirection.ltr ? -140.0 : 140.0;
      await mouse.moveBy(Offset(delta, 0));
      await mouse.up();
      await tester.pumpAndSettle();

      expect(position.pixels, closeTo(140, 0.01));
      final controller = DefaultTabController.of(
        tester.element(find.byType(AppTabBar)),
      );
      expect(controller.index, 0);
      final returnStart = tester.getCenter(find.byType(AppTabBar));
      await mouse.down(returnStart);
      await mouse.moveBy(Offset(-delta, 0));
      await mouse.up();
      await tester.pumpAndSettle();
      expect(position.pixels, 0);
      expect(controller.index, 0);
    });
    for (final axis in Axis.values) {
      testWidgets('scrollable tabs map $axis wheel input in $direction', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 240));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          _app(
            Directionality(
              textDirection: direction,
              child: const DefaultTabController(
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
          ),
        );
        await tester.pumpAndSettle();
        final position = tester
            .state<ScrollableState>(
              find.descendant(
                of: find.byType(AppTabBar),
                matching: find.byType(Scrollable),
              ),
            )
            .position;
        final start = position.maxScrollExtent / 2;
        position.jumpTo(start);
        await tester.pumpAndSettle();
        await tester.sendEventToBinding(
          PointerScrollEvent(
            position: tester.getCenter(find.byType(AppTabBar)),
            scrollDelta: axis == Axis.horizontal
                ? const Offset(40, 0)
                : const Offset(0, 40),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          position.pixels,
          closeTo(start + (direction == TextDirection.ltr ? 40 : -40), 0.01),
        );
        expect(
          DefaultTabController.of(tester.element(find.byType(AppTabBar))).index,
          0,
        );
      });
    }
  }

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

  for (final release in ['hover', 'focus']) {
    testWidgets(
      'AppTooltip retains the other interaction after $release exits',
      (tester) async {
        final focus = FocusNode();
        addTearDown(focus.dispose);
        await tester.pumpWidget(
          _app(
            Center(
              child: AppTooltip(
                message: 'Playback settings',
                child: IconButton(
                  focusNode: focus,
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                ),
              ),
            ),
          ),
        );
        final mouse = await tester.createGesture(
          kind: ui.PointerDeviceKind.mouse,
        );
        await mouse.addPointer(
          location: tester.getCenter(find.byIcon(Icons.settings)),
        );
        addTearDown(mouse.removePointer);
        focus.requestFocus();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Playback settings'), findsOneWidget);
        if (release == 'hover') {
          await mouse.moveTo(Offset.zero);
        } else {
          focus.unfocus();
        }
        await tester.pump();
        expect(find.text('Playback settings'), findsOneWidget);
        await mouse.moveTo(Offset.zero);
        focus.unfocus();
        await tester.pump();
        expect(find.text('Playback settings'), findsNothing);
      },
    );
  }

  testWidgets('AppTooltip bounds long text within a narrow overlay', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(240, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const message = 'View all playback settings and available quality options';
    await tester.pumpWidget(
      _app(
        const Center(
          child: AppTooltip(message: message, child: Icon(Icons.settings)),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
    await mouse.addPointer(
      location: tester.getCenter(find.byIcon(Icons.settings)),
    );
    addTearDown(mouse.removePointer);
    await tester.pump(const Duration(milliseconds: 500));
    final bounds = tester.getRect(find.text(message));
    expect(bounds.left, greaterThanOrEqualTo(8));
    expect(bounds.right, lessThanOrEqualTo(232));
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(740, 200), const Size(320, 568)]) {
    testWidgets('AppTooltip fits safe bounds and keyboard at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final keyboard = size.width == 320 ? 300.0 : 0.0;
      final keyboardInset = ValueNotifier(0.0);
      addTearDown(keyboardInset.dispose);
      const padding = EdgeInsets.fromLTRB(24, 20, 32, 16);
      const message =
          'View all playback settings and available quality options for this video';
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ValueListenableBuilder<double>(
            valueListenable: keyboardInset,
            builder: (context, inset, _) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(3),
                padding: padding,
                viewInsets: EdgeInsets.only(bottom: inset),
              ),
              child: child!,
            ),
          ),
          home: Scaffold(
            body: SafeArea(
              child: Center(
                child: AppTooltip(
                  message: message,
                  child: IconButton(
                    focusNode: focus,
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      focus.requestFocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text(message), findsOneWidget);
      keyboardInset.value = keyboard;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      final bounds = tester.getRect(find.text(message));
      expect(bounds.left, greaterThanOrEqualTo(padding.left + 8));
      expect(bounds.right, lessThanOrEqualTo(size.width - padding.right - 8));
      expect(bounds.top, greaterThanOrEqualTo(padding.top + 8));
      expect(
        bounds.bottom,
        lessThanOrEqualTo(
          size.height - (keyboard > 0 ? keyboard : padding.bottom) - 8,
        ),
      );
      expect(tester.widget<Text>(find.text(message)).maxLines, lessThan(8));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('AppTooltip refreshes focused content and resized bounds', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final message = ValueNotifier('Playback settings');
    final focus = FocusNode();
    addTearDown(message.dispose);
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      _app(
        Center(
          child: ValueListenableBuilder<String>(
            valueListenable: message,
            builder: (context, value, _) => AppTooltip(
              message: value,
              child: IconButton(
                focusNode: focus,
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
            ),
          ),
        ),
      ),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Playback settings'), findsOneWidget);
    message.value = 'View all playback settings and available quality options';
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Playback settings'), findsNothing);
    expect(find.text(message.value), findsOneWidget);
    tester.view.physicalSize = const Size(240, 568);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      tester.getRect(find.text(message.value)).right,
      lessThanOrEqualTo(232),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(message.value), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final interaction in ['hover', 'focus', 'both']) {
    testWidgets('Escape dismisses $interaction tooltips before the dialog', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      late BuildContext context;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (value) {
              context = value;
              return const SizedBox();
            },
          ),
        ),
      );
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTooltip(
                message: 'Playback settings',
                child: IconButton(
                  focusNode: focus,
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                ),
              ),
              AppTooltip(
                message: 'Refresh',
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final mouse = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      if (interaction != 'focus') {
        await mouse.moveTo(tester.getCenter(find.byIcon(Icons.refresh)));
      }
      if (interaction != 'hover') focus.requestFocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      if (interaction != 'focus') expect(find.text('Refresh'), findsOneWidget);
      if (interaction != 'hover') {
        expect(find.text('Playback settings'), findsOneWidget);
      }
      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Refresh'), findsNothing);
      expect(find.text('Playback settings'), findsNothing);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      if (interaction != 'hover') expect(focus.hasFocus, isTrue);
      await mouse.moveTo(Offset.zero);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Playback settings'), findsNothing);
      await mouse.moveTo(tester.getCenter(find.byIcon(Icons.refresh)));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Refresh'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Refresh'), findsNothing);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

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

  testWidgets('AppSearchField trims submitted query boundaries', (
    tester,
  ) async {
    final controller = TextEditingController();
    final submitted = <String>[];
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(
        AppSearchField(
          controller: controller,
          hintText: 'Search',
          onSubmitted: submitted.add,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), '  movie night  ');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(submitted, ['movie night']);
    expect(controller.text, '  movie night  ');
    expect(tester.takeException(), isNull);
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

  testWidgets(
    'AppReadOnlyField updates dynamic values without becoming editable',
    (tester) async {
      var value = 'old-server.example.test';
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                AppReadOnlyField(label: 'Server', value: value, maxLines: null),
                TextButton(
                  onPressed: () =>
                      setState(() => value = 'new-server.example.test/path'),
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.text('old-server.example.test'), findsOneWidget);
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      expect(find.text('new-server.example.test/path'), findsOneWidget);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).readOnly,
        isTrue,
      );
      expect(_byTooltip('清空'), findsNothing);
      expect(_byTooltip('粘贴'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

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

      expect(find.byType(FilledButton), findsOneWidget);
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

      expect(find.byType(FilledButton), findsOneWidget);
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

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
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

    expect(find.byType(IconButton), findsOneWidget);
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

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
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
    final semantics = tester.ensureSemantics();
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
    expect(find.bySemanticsLabel('选择图片'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(presses, 2);
    semantics.dispose();
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

  for (final locale in ['en', 'zh']) {
    for (final kind in ['circular', 'linear', 'determinate']) {
      testWidgets('$kind loading semantics in $locale', (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          const progressKey = ValueKey('progress');
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: kind == 'circular'
                    ? const AppLoadingIndicator(key: progressKey)
                    : AppLinearProgress(
                        key: progressKey,
                        value: kind == 'determinate' ? 0.42 : null,
                      ),
              ),
            ),
          );
          final data = tester
              .getSemantics(progressSemantics(progressKey))
              .getSemanticsData();
          final label = tester.element(find.byKey(progressKey)).l10n.loading;
          expect(data.label, label);
          expect(
            data.role,
            kind == 'determinate'
                ? ui.SemanticsRole.progressBar
                : ui.SemanticsRole.loadingSpinner,
          );
          expect(data.value, kind == 'determinate' ? '42' : '');
          expect(find.text(label), findsNothing);
        } finally {
          semantics.dispose();
        }
      });
    }
  }

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

      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    },
  );

  for (final linear in [false, true]) {
    testWidgets(
      'loading semantics support fallback and custom labels linear=$linear',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          const key = ValueKey('progress');
          String? label;
          late StateSetter update;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) {
                    update = setState;
                    return linear
                        ? AppLinearProgress(
                            key: key,
                            value: 0.5,
                            semanticLabel: label,
                          )
                        : AppLoadingIndicator(
                            key: key,
                            centered: false,
                            semanticLabel: label,
                          );
                  },
                ),
              ),
            ),
          );
          final bounds = tester.getRect(find.byKey(key));
          expect(tester.getSemantics(progressSemantics(key)).label, 'Loading');
          update(() => label = 'Uploading media');
          await tester.pump();
          final data = tester
              .getSemantics(progressSemantics(key))
              .getSemanticsData();
          expect(data.label, 'Uploading media');
          expect(data.value, linear ? '50' : '');
          expect(tester.getRect(find.byKey(key)), bounds);
          expect(find.text('Uploading media'), findsNothing);
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets('loading semantics update with locale and disappear on removal', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      const key = ValueKey('progress');
      Widget app(String locale) => MaterialApp(
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: AppLoadingIndicator(key: key)),
      );
      await tester.pumpWidget(app('en'));
      final english = tester.getSemantics(progressSemantics(key)).label;
      await tester.pumpWidget(app('zh'));
      await tester.pump();
      final chinese = tester.element(find.byKey(key)).l10n.loading;
      expect(chinese, isNot(english));
      expect(tester.getSemantics(progressSemantics(key)).label, chinese);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(find.bySemanticsLabel(chinese), findsNothing);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

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
    expect(find.byType(AlertDialog), findsOneWidget);

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

    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    await tester.tap(find.text('媒体库'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(tapped, isTrue);
  });

  testWidgets('AppTile owns a Material surface inside decorated parents', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black),
          child: AppTile(
            title: const Text('Selected item'),
            selected: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.ancestor(of: find.byType(ListTile), matching: find.byType(Material)),
      findsWidgets,
    );
  });

  testWidgets('AppTile exposes enabled semantics and focus behavior', (
    tester,
  ) async {
    final enabledNode = FocusNode();
    final disabledNode = FocusNode();
    addTearDown(enabledNode.dispose);
    addTearDown(disabledNode.dispose);

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppTile(
              title: const Text('可用项目'),
              focusNode: enabledNode,
              onPressed: () {},
            ),
            AppTile(
              title: const Text('禁用项目'),
              enabled: false,
              focusNode: disabledNode,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

    final enabledSemantics = tester.getSemantics(find.text('可用项目'));
    expect(
      enabledSemantics.getSemanticsData().actions & SemanticsAction.tap.index,
      isNonZero,
    );
    expect(
      enabledSemantics
          .getSemanticsData()
          .flagsCollection
          .isEnabled
          .toBoolOrNull(),
      true,
    );

    final disabledSemantics = tester.getSemantics(find.text('禁用项目'));
    expect(
      disabledSemantics.getSemanticsData().actions & SemanticsAction.tap.index,
      isZero,
    );
    expect(
      disabledSemantics
          .getSemanticsData()
          .flagsCollection
          .isEnabled
          .toBoolOrNull(),
      false,
    );

    enabledNode.requestFocus();
    await tester.pump();
    expect(enabledNode.hasFocus, isTrue);
    disabledNode.requestFocus();
    await tester.pump();
    expect(disabledNode.hasFocus, isFalse);
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

    expect(find.byType(ExpansionTile), findsOneWidget);
    expect(find.text('事件分组'), findsOneWidget);

    await tester.tap(find.text('事件分组'));
    await tester.pumpAndSettle();

    expect(find.text('分组内容'), findsOneWidget);
  });

  testWidgets('switches expose one named and actionable semantic node', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final changes = <bool>[];
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            AppSwitch(
              value: false,
              label: 'Standalone',
              onChanged: changes.add,
            ),
            AppSwitchTile(
              value: true,
              title: const Text('Notifications'),
              onChanged: changes.add,
            ),
          ],
        ),
      ),
    );
    final switches = find.semantics.byPredicate(
      (node) =>
          !node.isMergedIntoParent &&
          node.getSemanticsData().flagsCollection.isToggled != ui.Tristate.none,
      describeMatch: (_) => 'switch semantics',
    );
    expect(switches, findsNWidgets(2));
    expect(find.bySemanticsLabel('Standalone'), findsOneWidget);
    expect(find.bySemanticsLabel('Notifications'), findsOneWidget);
    await tester.tap(find.text('Standalone'));
    await tester.tap(find.text('Notifications'));
    expect(changes, [true, false]);
    semantics.dispose();
  });

  testWidgets('AppSwitch and AppCheckbox use Material controls', (
    tester,
  ) async {
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

    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.byType(Checkbox));
    await tester.pump(const Duration(milliseconds: 150));

    expect(switchValue, isTrue);
    expect(checkboxValue, isTrue);
  });

  testWidgets('checkbox has one named state for screen readers', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        AppCheckbox(
          value: true,
          semanticsLabel: 'Select room',
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.bySemanticsLabel('Select room'), findsOneWidget);
    final checked = find.semantics.byPredicate(
      (node) =>
          !node.isMergedIntoParent &&
          node.getSemanticsData().flagsCollection.isChecked !=
              ui.CheckedState.none,
      describeMatch: (_) => 'checkbox semantic state',
    );
    expect(checked, findsOneWidget);
    semantics.dispose();
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

    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);

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

  for (final width in [320.0, 1200.0]) {
    for (final scale in [1.0, 1.5, 2.0]) {
      for (final prefix in [false, true]) {
        testWidgets(
          'compact selects fit translated labels: $width/$scale/$prefix',
          (tester) async {
            await tester.binding.setSurfaceSize(Size(width, 900));
            addTearDown(() => tester.binding.setSurfaceSize(null));
            for (final labels in [
              ['全部角色', '加入时间'],
              ['All roles', 'Joined at'],
            ]) {
              await tester.pumpWidget(
                _app(
                  MediaQuery(
                    data: MediaQueryData(
                      size: Size(width, 900),
                      textScaler: TextScaler.linear(scale),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: AppSelect<int>(
                        value: 1,
                        prefixIcon: prefix ? Icons.sort : null,
                        options: {labels.first: 1, labels.last: 2},
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ),
              );
              await tester.pumpAndSettle();
              final text = find.text(labels.first);
              final paragraph = tester.renderObject<RenderParagraph>(
                find.descendant(of: text, matching: find.byType(RichText)),
              );
              // Long scaled text may truncate only when the viewport is exhausted.
              if (width == 1200 || scale == 1 || labels.first == '全部角色') {
                expect(paragraph.didExceedMaxLines, isFalse);
              }
              expect(
                tester.getSize(find.byType(AppSelect<int>)).width,
                lessThanOrEqualTo(width - 32),
              );
              expect(tester.takeException(), isNull);
            }
          },
        );
      }
    }
  }

  testWidgets(
    'compact select preserves width across selection in a narrow parent',
    (tester) async {
      var value = 1;
      await tester.pumpWidget(
        _app(
          Center(
            child: SizedBox(
              width: 180,
              child: StatefulBuilder(
                builder: (context, setState) => AppSelect<int>(
                  value: value,
                  options: const {
                    'Short': 1,
                    'A much longer selected label': 2,
                  },
                  onChanged: (next) => setState(() => value = next!),
                ),
              ),
            ),
          ),
        ),
      );
      final before = tester.getSize(find.byType(AppSelect<int>));
      await tester.tap(find.text('Short'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A much longer selected label').last);
      await tester.pumpAndSettle();
      expect(value, 2);
      expect(tester.getSize(find.byType(AppSelect<int>)), before);
      expect(before.width, 180);
      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [220.0, 440.0]) {
    for (final language in ['en', 'zh']) {
      testWidgets('multiline select $language/$width at 3x', (tester) async {
        await tester.binding.setSurfaceSize(const Size(600, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final label = language == 'en' ? 'Media source instance' : '媒体源实例';
        final first = language == 'en' ? 'Local instance' : '本地实例';
        final second = language == 'en' ? 'Remote media server' : '远程媒体服务器';
        var selected = 1;
        await tester.pumpWidget(
          _app(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(3)),
              child: SizedBox(
                width: width,
                child: StatefulBuilder(
                  builder: (context, setState) => AppSelect<int>(
                    value: selected,
                    label: label,
                    labelAbove: true,
                    wrapText: true,
                    prefixIcon: Icons.account_tree_outlined,
                    options: {first: 1, second: 2},
                    onChanged: (value) => setState(() => selected = value!),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        for (final text in [label, first]) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.text(text),
          );
          expect(paragraph.didExceedMaxLines, isFalse, reason: text);
          expect(paragraph.size.width, lessThanOrEqualTo(width));
        }
        final initialSize = tester.getSize(find.byType(AppSelect<int>));
        await tester.tap(find.text(first));
        await tester.pumpAndSettle();
        final option = find.text(second).last;
        await tester.ensureVisible(option);
        await tester.pumpAndSettle();
        expect(
          tester.renderObject<RenderParagraph>(option).didExceedMaxLines,
          isFalse,
        );
        await tester.tap(option);
        await tester.pumpAndSettle();
        expect(selected, 2);
        expect(tester.getSize(find.byType(AppSelect<int>)), initialSize);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('AppSelect reports changes', (tester) async {
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

  testWidgets('AppSelect renders an icon for every option', (tester) async {
    await tester.pumpWidget(
      _app(
        AppSelect<String>(
          value: 'bilibili',
          options: const {'Bilibili': 'bilibili', 'YouTube': 'youtube'},
          optionPrefixBuilder: (context, value) => Icon(
            value == 'bilibili' ? Icons.tv_rounded : Icons.smart_display,
            key: ValueKey('provider-option-$value'),
          ),
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Bilibili'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(
      find.byKey(const ValueKey('provider-option-bilibili')),
      findsAtLeastNWidgets(1),
    );
    expect(
      find.byKey(const ValueKey('provider-option-youtube')),
      findsAtLeastNWidgets(1),
    );
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

  for (final enabled in [true, false]) {
    for (final nullableOption in [true, false]) {
      testWidgets('AppSelect clear enabled=$enabled nullable=$nullableOption', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        String? selected = 'music';
        String? saved = 'unchanged';
        final changes = <String?>[];
        var formChanges = 0;
        await tester.pumpWidget(
          _app(
            Form(
              key: formKey,
              onChanged: () => formChanges++,
              child: StatefulBuilder(
                builder: (context, setState) => AppSelect<String?>(
                  value: selected,
                  label: 'Category',
                  clearable: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value == null ? 'Choose a category' : null,
                  enabled: enabled,
                  options: {if (nullableOption) 'None': null, 'Music': 'music'},
                  onSaved: (value) => saved = value,
                  onChanged: (value) {
                    changes.add(value);
                    setState(() => selected = value);
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final clear = _byTooltip('清空');
        if (!enabled) {
          expect(clear, findsNothing);
          formKey.currentState!.save();
          expect(saved, 'music');
          expect(changes, isEmpty);
          return;
        }
        expect(clear, findsOneWidget);
        await tester.tap(clear);
        await tester.pumpAndSettle();
        expect(changes, [null]);
        expect(selected, isNull);
        expect(formChanges, 1);
        expect(find.text('Choose a category'), findsOneWidget);
        formKey.currentState!.save();
        expect(saved, isNull);
        expect(clear, findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

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

  for (final shape in BoxShape.values) {
    for (final size in [24.0, 60.0]) {
      for (final scale in [1.0, 3.0]) {
        testWidgets('Avatar initial fits $shape/$size/$scale', (tester) async {
          await tester.pumpWidget(
            _app(
              MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Center(
                  child: AppAvatar(
                    name: 'wide',
                    size: size,
                    shape: shape,
                    textStyle: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
            ),
          );
          final avatar = tester.getRect(find.byType(AppAvatar));
          final glyph = tester.renderObject<RenderBox>(find.text('W'));
          final glyphBounds = MatrixUtils.transformRect(
            glyph.getTransformTo(null),
            Offset.zero & glyph.size,
          );
          expect(avatar.size, Size.square(size));
          expect(glyphBounds.left, greaterThanOrEqualTo(avatar.left));
          expect(glyphBounds.top, greaterThanOrEqualTo(avatar.top));
          expect(glyphBounds.right, lessThanOrEqualTo(avatar.right));
          expect(glyphBounds.bottom, lessThanOrEqualTo(avatar.bottom));
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

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
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
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

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('加载更多'), findsNothing);
  });
}
