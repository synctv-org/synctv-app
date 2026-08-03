import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/media_library/presentation/add_media_dialog.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import '../../../test_app.dart';

void main() {
  testWidgets('desktop direct-link action stays fully visible', (tester) async {
    tester.view.physicalSize = const ui.Size(984, 728);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 620,
              child: AddMediaDialog(roomId: 'room_layout_test'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final action = find.text('Add to playlist');
    expect(action, findsOneWidget);
    final actionButton = find.ancestor(
      of: action,
      matching: find.byType(AppActionButton),
    );
    expect(actionButton, findsOneWidget);
    final actionRect = tester.getRect(actionButton);
    expect(actionRect.height, greaterThanOrEqualTo(46));
    expect(actionRect.bottom, lessThanOrEqualTo(728));
    expect(find.text('On demand'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
    await tester.tap(find.text('Live'));
    await tester.pump();
    final playbackKindControl = tester
        .widget<SegmentedButton<source_enum.PlaybackKind>>(
          find.byWidgetPredicate(
            (widget) => widget is SegmentedButton<source_enum.PlaybackKind>,
          ),
        );
    expect(playbackKindControl.selected, {
      source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
    });
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('compact source selector keeps provider form usable', (
    tester,
  ) async {
    tester.view.physicalSize = const ui.Size(430, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: const Scaffold(body: AddMediaDialog(roomId: 'room_layout_test')),
      ),
    );
    await tester.pump();

    final selector = find.byKey(const ValueKey('add-media-source-selector-0'));
    expect(selector, findsOneWidget);
    expect(find.text('Add to playlist'), findsOneWidget);
    expect(tester.getRect(selector).bottom, lessThan(120));

    final selectorRect = tester.getRect(selector);
    await tester.tapAt(Offset(selectorRect.right - 24, selectorRect.center.dy));
    await tester.pumpAndSettle();
    for (var index = 0; index < 10; index += 1) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.byKey(const Key('acfun-resource')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('add-media-source-selector-10')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('live pull exposes RTSP transport and track controls', (
    tester,
  ) async {
    tester.view.physicalSize = const ui.Size(430, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: const Scaffold(body: AddMediaDialog(roomId: 'room_layout_test')),
      ),
    );
    await tester.pump();

    final selector = find.byKey(const ValueKey('add-media-source-selector-0'));
    final selectorRect = tester.getRect(selector);
    await tester.tapAt(Offset(selectorRect.right - 24, selectorRect.center.dy));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text('HTTP-FLV'), findsOneWidget);
    await tester.tap(find.text('RTSP'));
    await tester.pump();

    expect(find.text('RTSP transport'), findsOneWidget);
    expect(find.text('Video track'), findsOneWidget);
    expect(find.text('Audio track'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('compact store selector uses stable source identifiers', (
    tester,
  ) async {
    tester.view.physicalSize = const ui.Size(430, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: const Scaffold(
          body: AddMediaDialog(
            roomId: 'room_layout_test',
            distributionPolicy: ProviderDistributionPolicy(
              includesThirdPartyProviders: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final selector = find.byKey(const ValueKey('add-media-source-selector-0'));
    final selectorRect = tester.getRect(selector);
    await tester.tapAt(Offset(selectorRect.right - 24, selectorRect.center.dy));
    await tester.pumpAndSettle();
    for (var index = 0; index < 11; index += 1) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('add-media-source-selector-17')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });
}
