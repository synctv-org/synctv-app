import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets(
    'uses fixed configuration and flexible result columns on wide layouts',
    (tester) async {
      tester.view.physicalSize = const ui.Size(1200, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          builder: buildThemedTestApp,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 1000,
                height: 500,
                child: ProviderWorkspace(
                  controls: const KeyedSubtree(
                    key: Key('workspace-controls'),
                    child: SizedBox(height: 160),
                  ),
                  results: const KeyedSubtree(
                    key: Key('workspace-results'),
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final controls = tester.getRect(
        find.byKey(const Key('workspace-controls')),
      );
      final results = tester.getRect(
        find.byKey(const Key('workspace-results')),
      );
      expect(controls.width, 408);
      expect(results.left, greaterThan(controls.right));
      expect(results.height, 500);
    },
  );

  testWidgets('collapses controls as the compact result list scrolls', (
    tester,
  ) async {
    tester.view.physicalSize = const ui.Size(800, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 600,
              height: 500,
              child: ProviderWorkspace(
                controls: const KeyedSubtree(
                  key: Key('workspace-controls'),
                  child: SizedBox(height: 160),
                ),
                results: ListView.builder(
                  key: Key('workspace-results'),
                  primary: true,
                  itemExtent: 60,
                  itemCount: 20,
                  itemBuilder: (_, index) => Text('Result $index'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final controls = find.byKey(const Key('workspace-controls'));
    expect(controls, findsOneWidget);
    expect(find.byType(NestedScrollView), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('workspace-results')),
      const Offset(0, -240),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('workspace-controls')), findsNothing);
    expect(
      tester.getRect(find.byKey(const Key('workspace-results'))).height,
      500,
    );
  });

  testWidgets('preserves browsing space when compact controls are long', (
    tester,
  ) async {
    tester.view.physicalSize = const ui.Size(430, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 390,
              height: 500,
              child: ProviderWorkspace(
                controls: const KeyedSubtree(
                  key: Key('workspace-controls'),
                  child: SizedBox(height: 640),
                ),
                results: ListView.builder(
                  key: Key('workspace-results'),
                  primary: true,
                  itemExtent: 60,
                  itemCount: 20,
                  itemBuilder: (_, index) => Text('Result $index'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final controls = tester.getRect(
      find.byKey(const Key('workspace-controls')),
    );
    expect(controls.height, 640);
    expect(find.byType(NestedScrollView), findsOneWidget);
  });
}
