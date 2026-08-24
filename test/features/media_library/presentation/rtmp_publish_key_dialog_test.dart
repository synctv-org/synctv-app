import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/features/media_library/presentation/rtmp_publish_key_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

import '../../../test_app.dart';

Widget _app(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: buildThemedTestApp,
    home: Scaffold(body: child),
  );
}

void main() {
  final now = DateTime(2026, 8, 23, 12);

  testWidgets('publish key options default to one-time with an expiration', (
    tester,
  ) async {
    final controller = RtmpPublishKeyOptionsController(now);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _app(RtmpPublishKeyOptionsForm(controller: controller, now: () => now)),
    );

    expect(
      controller.value.keyType,
      client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
    );
    expect(find.text('One-time key'), findsOneWidget);
    expect(
      find.byKey(const Key('rtmp-key-options-expiration')),
      findsOneWidget,
    );
  });

  testWidgets('permanent publish key hides expiration controls', (
    tester,
  ) async {
    final controller = RtmpPublishKeyOptionsController(now);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _app(RtmpPublishKeyOptionsForm(controller: controller, now: () => now)),
    );
    await tester.tap(find.text('One-time key'));
    await tester.pump();
    await tester.tap(find.text('Never expires').last);
    await tester.pump();

    expect(
      controller.value.keyType,
      client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT,
    );
    expect(find.byKey(const Key('rtmp-key-options-expiration')), findsNothing);
  });

  testWidgets('options dialog returns permanent key without expiration', (
    tester,
  ) async {
    RtmpPublishKeyOptions? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () async {
              result = await showRtmpPublishKeyOptionsDialog(
                context,
                now: () => now,
              );
            },
            child: const Text('Open options'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('One-time key'));
    await tester.pump();
    await tester.tap(find.text('Never expires').last);
    await tester.pump();
    await tester.tap(find.text('Generate publish key').last);
    await tester.pumpAndSettle();

    expect(
      result?.keyType,
      client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT,
    );
    expect(result?.expiresAt, isNull);
  });

  testWidgets('credentials dialog shows generated publishing values', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () => showRtmpPublishCredentialsDialog(
              context,
              publish: const RtmpPublishKeyInfo(
                publishKey: 'publish-secret',
                rtmpUrl: 'rtmps://live.example.com/room_123',
                streamKey: 'media_456?token=publish-secret',
                expiresAt: null,
                keyType: client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT,
              ),
              streamInfo: const RoomStreamEntryInfo(
                mediaId: 'media_456',
                active: false,
              ),
            ),
            child: const Text('Open credentials'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open credentials'));
    await tester.pumpAndSettle();

    expect(find.text('rtmps://live.example.com/room_123'), findsOneWidget);
    expect(find.text('media_456?token=publish-secret'), findsOneWidget);
    expect(find.text('publish-secret'), findsOneWidget);
    expect(find.text('Never expires'), findsNWidgets(2));
    expect(find.text('Inactive'), findsOneWidget);
  });

  testWidgets('credentials remain available without stream status', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () => showRtmpPublishCredentialsDialog(
              context,
              publish: const RtmpPublishKeyInfo(
                publishKey: 'one-time-secret',
                rtmpUrl: 'rtmps://live.example.com/room_123',
                streamKey: 'media_456?token=one-time-secret',
                expiresAt: 1900000000,
                keyType: client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
              ),
            ),
            child: const Text('Open credentials'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open credentials'));
    await tester.pumpAndSettle();

    expect(find.text('one-time-secret'), findsOneWidget);
    expect(find.text('media_456?token=one-time-secret'), findsOneWidget);
    expect(find.text('Status'), findsNothing);
  });
}
