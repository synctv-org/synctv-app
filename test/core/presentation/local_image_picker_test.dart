import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/image/local_image_picker.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../tool/fixtures/image_picker_fixture.dart';

void main() {
  for (final bytes in [
    Uint8List.fromList([1, 2, 3]),
    Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10]),
  ]) {
    testWidgets(
      'invalid image shows recoverable editor feedback: ${bytes.length}',
      (tester) async {
        await _openEditor(tester, providedBytes: bytes, waitUntilReady: false);
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            'This image cannot be edited. Try another image or upload the original.',
          ),
          findsOneWidget,
        );
        expect(find.byType(Crop), findsNothing);
        expect(
          tester
              .widget<AppActionButton>(
                find.widgetWithText(AppActionButton, 'Use edited image'),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.text('Open'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final tiny in [true, false]) {
    testWidgets('ready images produce square crops: tiny=$tiny', (
      tester,
    ) async {
      PickedLocalImage? result;
      await _openEditor(
        tester,
        onPicked: (image) => result = image,
        providedBytes: tiny
            ? base64Decode(
                'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
              )
            : null,
      );
      expect(find.byType(Crop), findsOneWidget);
      await tester.tap(find.text('Square crop'));
      await tester.pump();
      await tester.tap(find.text('Use edited image'));
      for (var attempt = 0; attempt < 20 && result == null; attempt++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      expect(
        result?.upload.width,
        tiny ? 1 : result?.upload.height,
        reason: tester
            .widgetList<Text>(find.byType(Text))
            .map((text) => text.data)
            .join(' | '),
      );
      expect(
        result?.upload.height,
        tiny ? equals(1) : inInclusiveRange(1, 360),
      );
      expect(result?.upload.mimeType, 'image/png');
      expect(find.text('Edit image'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('purpose ratio survives a square crop round trip', (
    tester,
  ) async {
    PickedLocalImage? result;
    await _openEditor(tester, onPicked: (value) => result = value);
    await tester.tap(find.text('Square crop'));
    await tester.pump();
    await tester.tap(find.byType(FilterChip).first);
    await tester.pump();
    final viewport = tester.getRect(find.byType(Crop));
    final handles = find.descendant(
      of: find.byType(Crop),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      ),
    );
    expect(handles, findsNWidgets(4));
    for (final handle in handles.evaluate()) {
      final bounds = tester.getRect(find.byWidget(handle.widget));
      expect(viewport.contains(bounds.topLeft), isTrue);
      expect(viewport.contains(bounds.bottomRight), isTrue);
    }
    await tester.tap(find.text('Use edited image'));
    for (var attempt = 0; attempt < 20 && result == null; attempt++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(result, isNotNull);
    expect(result!.upload.width / result!.upload.height, closeTo(16 / 9, 0.01));
  });

  testWidgets('pan and zoom retain exported pixels across viewport changes', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Future<PickedLocalImage> export({required bool resize}) async {
      tester.view.physicalSize = const Size(600, 800);
      PickedLocalImage? result;
      await _openEditor(tester, onPicked: (value) => result = value);
      await tester.tap(find.text('Square crop'));
      await tester.pump();
      final center = tester.getCenter(find.byType(Crop));
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: center,
          scrollDelta: const Offset(0, -100),
        ),
      );
      await tester.dragFrom(center, const Offset(-65, 0));
      await tester.pumpAndSettle();
      if (resize) {
        for (final size in [
          const Size(1169, 768),
          const Size(320, 568),
          const Size(600, 800),
        ]) {
          tester.view.physicalSize = size;
          await tester.pump();
          for (var attempt = 0; attempt < 10; attempt++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 50)),
            );
            await tester.pump();
          }
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
      await tester.tap(find.text('Use edited image'));
      for (var attempt = 0; attempt < 20 && result == null; attempt++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      return result!;
    }

    final original = await export(resize: false);
    final resized = await export(resize: true);
    expect(resized.upload.width, original.upload.width);
    expect(resized.upload.height, original.upload.height);
    expect(resized.previewBytes, original.previewBytes);
  });

  for (final reading in [false, true]) {
    testWidgets(
      'current picker still reports file failures: reading=$reading',
      (tester) async {
        final gate = Completer<void>();
        Object? failure;
        await _openEditor(
          tester,
          selectionGate: reading ? null : gate.future,
          readGate: reading ? gate.future : null,
          onFailure: (error) => failure = error,
        );
        final error = StateError('current file failure');
        gate.completeError(error);
        await tester.pumpAndSettle();
        expect(failure, same(error));
        expect(find.text('Edit image'), findsNothing);
      },
    );
  }

  for (final reading in [false, true]) {
    for (final fail in [false, true]) {
      testWidgets(
        'covered picker ignores pending result: reading=$reading failure=$fail',
        (tester) async {
          final gate = Completer<void>();
          var completed = false;
          final navigator = await _openEditor(
            tester,
            selectionGate: reading ? null : gate.future,
            readGate: reading ? gate.future : null,
            onPicked: (image) {
              completed = true;
              expect(image, isNull);
            },
          );
          unawaited(
            navigator.currentState!.push<void>(
              MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Next page')),
              ),
            ),
          );
          if (fail) {
            gate.completeError(StateError('late file failure'));
          } else {
            gate.complete();
          }
          await tester.pumpAndSettle();
          expect(completed, isTrue);
          expect(find.text('Next page'), findsOneWidget);
          expect(find.text('Edit image'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('crop waits for image readiness and blocks stale actions', (
    tester,
  ) async {
    await _openEditor(tester, waitUntilReady: false);
    expect(
      tester
          .widget<AppActionButton>(
            find.widgetWithText(AppActionButton, 'Use edited image'),
          )
          .onPressed,
      isNull,
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    final crop = tester.widget<Crop>(find.byType(Crop));
    var requests = 0;
    crop.controller!.delegate = CropControllerDelegate()
      ..onCrop = (_) {
        requests++;
      };
    AppActionButton cropButton() => tester.widget<AppActionButton>(
      find.widgetWithText(AppActionButton, 'Use edited image'),
    );
    expect(cropButton().onPressed, isNull);
    for (final chip in tester.widgetList<FilterChip>(find.byType(FilterChip))) {
      expect(chip.onSelected, isNull);
    }
    crop.onStatusChanged!(CropStatus.ready);
    await tester.pump();
    final readyButton = cropButton();
    expect(readyButton.onPressed, isNotNull);
    crop.onStatusChanged!(CropStatus.loading);
    readyButton.onPressed!();
    await tester.pump();
    expect(requests, 0);
    expect(cropButton().onPressed, isNull);
    crop.onStatusChanged!(CropStatus.ready);
    await tester.pump();
    cropButton().onPressed!();
    await tester.pump();
    expect(requests, 1);
    final pointer = tester.widget<IgnorePointer>(
      find
          .ancestor(of: find.byType(Crop), matching: find.byType(IgnorePointer))
          .first,
    );
    expect(pointer.ignoring, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    crop.onStatusChanged!(CropStatus.ready);
    expect(tester.takeException(), isNull);
  });

  for (final edited in [false, true]) {
    testWidgets('returns encoded image dimensions: edited=$edited', (
      tester,
    ) async {
      PickedLocalImage? result;
      await _openEditor(tester, onPicked: (value) => result = value);
      if (edited) {
        final crop = tester.widget<Crop>(find.byType(Crop));
        crop.onCropped(CropSuccess(crop.image));
      } else {
        await tester.tap(find.text('Upload original'));
      }
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      expect(result?.upload.width, 640);
      expect(result?.upload.height, 360);
      expect(result?.upload.mimeType, 'image/png');
      expect(find.text('Edit image'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'crop blocks duplicate requests and aspect changes and can retry',
    (tester) async {
      await _openEditor(tester);
      final crop = tester.widget<Crop>(find.byType(Crop));
      var requests = 0;
      crop.controller!.delegate = CropControllerDelegate()
        ..onCrop = (_) {
          requests++;
        };
      final button = tester.widget<AppActionButton>(
        find.widgetWithText(AppActionButton, 'Use edited image'),
      );
      button.onPressed!();
      button.onPressed!();
      await tester.pump();
      expect(requests, 1);
      for (final chip in tester.widgetList<FilterChip>(
        find.byType(FilterChip),
      )) {
        expect(chip.onSelected, isNull);
      }
      crop.onCropped(CropFailure(StateError('retry crop'), StackTrace.current));
      await tester.pump();
      expect(find.textContaining('retry crop'), findsWidgets);
      await tester.tap(find.text('Use edited image'));
      await tester.pump();
      expect(requests, 2);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    },
  );

  for (final size in [const Size(1000, 800), const Size(320, 568)]) {
    testWidgets('image editor lays out and cancels at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _openEditor(tester);
      expect(find.text('Edit image'), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(
        find.text('Square crop').hitTestable(),
        findsOneWidget,
        reason:
            'chip ${tester.getRect(find.text("Square crop"))}; '
            'cancel ${tester.getRect(find.text("Cancel"))}; '
            'crop ${tester.getRect(find.byType(Crop))}',
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Edit image'), findsNothing);
    });
  }

  for (final dismiss in [false, true]) {
    for (final fail in [false, true]) {
      testWidgets(
        'late crop preserves newer route: dismissed=$dismiss failure=$fail',
        (tester) async {
          final navigator = await _openEditor(tester);
          final crop = tester.widget<Crop>(find.byType(Crop));
          crop.controller!.delegate = CropControllerDelegate()..onCrop = (_) {};
          await tester.tap(find.text('Use edited image'));
          await tester.pump();
          if (dismiss) navigator.currentState!.pop();
          unawaited(
            navigator.currentState!.push<void>(
              MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Next page')),
              ),
            ),
          );
          crop.onCropped(
            fail
                ? CropFailure(
                    StateError('late crop failure'),
                    StackTrace.current,
                  )
                : CropSuccess(Uint8List.fromList([1, 2, 3])),
          );
          await tester.pumpAndSettle();
          expect(find.text('Next page'), findsOneWidget);
          expect(find.textContaining('late crop failure'), findsNothing);
          expect(tester.takeException(), isNull);
          if (!dismiss) {
            navigator.currentState!.pop();
            await tester.pumpAndSettle();
            expect(find.text('Use edited image'), findsOneWidget);
          }
        },
      );
    }
  }
}

Future<GlobalKey<NavigatorState>> _openEditor(
  WidgetTester tester, {
  ValueChanged<PickedLocalImage?>? onPicked,
  bool waitUntilReady = true,
  Future<void>? selectionGate,
  Future<void>? readGate,
  ValueChanged<Object>? onFailure,
  Uint8List? providedBytes,
}) async {
  final previous = FilePickerPlatform.instance;
  final bytes =
      providedBytes ?? await tester.runAsync(createImagePickerFixture);
  FilePickerPlatform.instance = FixtureImagePicker(
    bytes!,
    selectionGate: selectionGate,
    readGate: readGate,
  );
  addTearDown(() => FilePickerPlatform.instance = previous);
  final navigator = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigator,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              try {
                final result = await pickLocalImageUpload(
                  context,
                  aspectRatio: 16 / 9,
                );
                onPicked?.call(result);
              } catch (error) {
                if (onFailure == null) rethrow;
                onFailure(error);
              }
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pump();
  if (!waitUntilReady) return navigator;
  for (var attempt = 0; attempt < 20; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
    final button = find.widgetWithText(AppActionButton, 'Use edited image');
    if (button.evaluate().isEmpty ||
        tester.widget<AppActionButton>(button).onPressed != null) {
      break;
    }
  }
  await tester.pumpAndSettle();
  return navigator;
}
