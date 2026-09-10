import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/image/app_image_preview.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../tool/fixtures/image_picker_fixture.dart';
import '../../test_app.dart';

void main() {
  testWidgets(
    'image preview contains the whole image, zooms and closes across widths',
    (tester) async {
      final bytes = await tester.runAsync(createImagePickerFixture);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_app(MemoryImage(bytes!)));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.contain);
      final controller = tester
          .widget<InteractiveViewer>(find.byType(InteractiveViewer))
          .transformationController!;
      await tester.tap(byAppTooltip('Zoom in'));
      await tester.pump();
      expect(controller.value.getMaxScaleOnAxis(), 1.5);
      await tester.binding.setSurfaceSize(const Size(1169, 768));
      await tester.pumpAndSettle();
      expect(controller.value.getMaxScaleOnAxis(), 1.5);
      await tester.tap(byAppTooltip('Zoom out'));
      await tester.pump();
      expect(controller.value.getMaxScaleOnAxis(), 1);
      await tester.tap(byAppTooltip('Zoom in'));
      await tester.tap(byAppTooltip('Reset'));
      await tester.pump();
      expect(controller.value, Matrix4.identity());
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(AppImageViewer), findsNothing);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(AppImageViewer), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('broken image keeps an accessible close action', (tester) async {
    await tester.pumpWidget(_app(MemoryImage(Uint8List.fromList([1, 2, 3]))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Could not load the image.'), findsOneWidget);
    await tester.tap(byAppTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(AppImageViewer), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Widget _app(ImageProvider image) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Builder(
    builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () => showAppDialog<void>(
          context: context,
          builder: (_) => AppImageViewer(image: image),
        ),
        child: const Text('Open'),
      ),
    ),
  ),
);
