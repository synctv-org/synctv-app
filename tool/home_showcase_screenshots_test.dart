import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/home/showcase/home_showcase.dart';

void main() {
  const boundaryKey = Key('showcase_boundary');

  Future<void> capture(
    WidgetTester tester, {
    required Size physicalSize,
    required double devicePixelRatio,
    required String output,
  }) async {
    tester.view
      ..devicePixelRatio = devicePixelRatio
      ..physicalSize = physicalSize;
    await tester.pumpWidget(
      const RepaintBoundary(key: boundaryKey, child: HomeShowcaseApp()),
    );
    await tester.pumpAndSettle();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(boundaryKey),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: devicePixelRatio);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null) throw StateError('Could not encode showcase image');
      await File(output).writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    });
  }

  testWidgets('iPhone 6.9-inch home', (tester) async {
    await capture(
      tester,
      physicalSize: const Size(1320, 2868),
      devicePixelRatio: 3,
      output: 'build/showcase/01-home-iphone-6.9.png',
    );
  });

  testWidgets('iPad 13-inch home', (tester) async {
    await capture(
      tester,
      physicalSize: const Size(2064, 2752),
      devicePixelRatio: 2,
      output: 'build/showcase/01-home-ipad-13.png',
    );
  });

  testWidgets('macOS home', (tester) async {
    await capture(
      tester,
      physicalSize: const Size(1280, 800),
      devicePixelRatio: 1,
      output: 'build/showcase/01-home-macos.png',
    );
  });
}
