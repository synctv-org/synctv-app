import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:synctv_app/features/media_library/presentation/add_media_dialog.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import '../../../test_app.dart';

void main() {
  testWidgets('proxy-only playback locks proxy preference on', (tester) async {
    tester.view.physicalSize = const ui.Size(800, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: const Scaffold(body: AddMediaDialog(roomId: 'room_proxy_test')),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Proxy only'));
    await tester.pump();

    final control = tester.widget<PlaybackProxyModeControl>(
      find.byType(PlaybackProxyModeControl),
    );
    expect(
      control.value,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('unbound Emby only shows the binding guide', (tester) async {
    tester.view.physicalSize = const ui.Size(800, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: const Scaffold(body: AddMediaDialog(roomId: 'room_emby_test')),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('add-media-source-tile-5')));
    await tester.pump();

    expect(find.text('Manage connections'), findsOneWidget);
    expect(find.text('Account binding'), findsNothing);
    expect(find.text('Bind Emby now'), findsOneWidget);
    expect(find.text('Library'), findsNothing);
    expect(find.text('Favorites & people'), findsNothing);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('desktop direct-link action stays fully visible', (tester) async {
    tester.view.physicalSize = const ui.Size(800, 600);
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

    final actionButton = find.byKey(const Key('direct-url-preview'));
    expect(actionButton, findsOneWidget);
    final actionRect = tester.getRect(actionButton);
    expect(actionRect.height, greaterThanOrEqualTo(46));
    expect(actionRect.bottom, lessThanOrEqualTo(600));
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

  testWidgets('desktop workspace filters media sources', (tester) async {
    tester.view.physicalSize = const ui.Size(1300, 800);
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

    expect(find.text('Bilibili'), findsWidgets);
    await tester.enterText(find.byType(TextField).first, 'FNOS');
    await tester.pump();

    expect(
      find.byKey(const ValueKey('add-media-source-tile-12')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('add-media-source-tile-3')), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('source rail uses stable icon and detail widths', (tester) async {
    tester.view.physicalSize = const ui.Size(1300, 800);
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

    final railItem = find.byKey(const ValueKey('add-media-source-tile-3'));
    expect(tester.getSize(railItem).width, greaterThan(180));
    expect(find.text('Bilibili'), findsWidgets);

    tester.view.physicalSize = const ui.Size(980, 800);
    await tester.pump();

    expect(tester.getSize(railItem).width, lessThan(60));
    expect(find.text('Bilibili'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('keeps a direct-link draft while switching sources', (
    tester,
  ) async {
    tester.view.physicalSize = const ui.Size(1200, 800);
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

    await tester.enterText(
      find.byType(TextField).at(1),
      'https://media.test/a',
    );
    await tester.tap(find.byKey(const ValueKey('add-media-source-tile-1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('add-media-source-tile-0')));
    await tester.pump();

    expect(find.text('https://media.test/a'), findsOneWidget);
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
    expect(
      find.byKey(const ValueKey('selected-provider-icon-0')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('direct-url-preview')), findsOneWidget);
    expect(tester.getSize(find.text('On demand')).height, lessThan(24));
    expect(tester.getRect(selector).bottom, lessThan(120));

    final selectorRect = tester.getRect(selector);
    await tester.tapAt(Offset(selectorRect.right - 24, selectorRect.center.dy));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('add-media-provider-icon-3')),
      findsOneWidget,
    );
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
    expect(
      find.byKey(const ValueKey('selected-provider-icon-10')),
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
