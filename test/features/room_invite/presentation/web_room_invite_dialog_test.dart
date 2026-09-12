import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/features/room_invite/presentation/web_room_invite_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

const _invite = RoomInvite(
  roomId: 'room-with-a-long-identifier',
  serverEndpoint: 'https://invite.example.test/sync',
);
const _launchChannel = MethodChannel('plugins.flutter.io/url_launcher');

Future<BuildContext> _show(
  WidgetTester tester, {
  String locale = 'en',
  double scale = 1,
}) async {
  late BuildContext page;
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Builder(
        builder: (context) {
          page = context;
          return const Scaffold(body: Text('Invite page'));
        },
      ),
    ),
  );
  unawaited(showWebRoomInviteDialog(context: page, invite: _invite));
  await tester.pumpAndSettle();
  return page;
}

VoidCallback _open(WidgetTester tester) => tester
    .widget<AppActionButton>(
      find.ancestor(
        of: find.text('Open server'),
        matching: find.byType(AppActionButton),
      ),
    )
    .onPressed!;

VoidCallback _copy(WidgetTester tester) => tester
    .widget<AppIconButton>(
      find.ancestor(
        of: byAppTooltip('Copy room ID'),
        matching: find.byType(AppIconButton),
      ),
    )
    .onPressed!;

void main() {
  tearDown(AppNotifications.dismissAll);

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 360)]) {
      testWidgets('web invite fields and actions $locale $size at 3x', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final page = await _show(tester, locale: locale, scale: 3);
        expect(find.text(page.l10n.addServer), findsNothing);
        expect(find.byType(BottomSheet), findsNothing);
        final fields = tester.widgetList<EditableText>(
          find.byType(EditableText),
        );
        expect(fields.map((field) => field.controller.text), [
          _invite.serverEndpoint,
          _invite.roomId,
        ]);
        expect(
          fields.every(
            (field) => field.readOnly && field.enableInteractiveSelection,
          ),
          isTrue,
        );
        final copy = byAppTooltip(page.l10n.copyRoomId);
        await tester.ensureVisible(copy);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text(page.l10n.close));
        await tester.pumpAndSettle();
        expect(find.text('Invite page'), findsOneWidget);
      });
    }
  }

  for (final operation in ['open', 'copy']) {
    for (final outcome in ['success', 'failure', 'disposed']) {
      testWidgets(
        'web invite $operation handles $outcome and duplicate callbacks',
        (tester) async {
          final calls = <MethodCall>[];
          final completion = Completer<Object?>();
          final channel = operation == 'open'
              ? _launchChannel
              : SystemChannels.platform;
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            channel,
            (call) {
              if (call.method != 'launch' &&
                  call.method != 'Clipboard.setData') {
                return Future<Object?>.value();
              }
              calls.add(call);
              return completion.future;
            },
          );
          addTearDown(
            () => tester.binding.defaultBinaryMessenger
                .setMockMethodCallHandler(channel, null),
          );
          final page = await _show(tester);
          final action = operation == 'open' ? _open(tester) : _copy(tester);
          action();
          action();
          await tester.pump();
          expect(calls, hasLength(1));
          expect(
            calls.single.arguments[operation == 'open' ? 'url' : 'text'],
            operation == 'open' ? _invite.serverEndpoint : _invite.roomId,
          );
          if (outcome == 'disposed') {
            await tester.tap(find.text('Close'));
            await tester.pumpAndSettle();
          }
          if (outcome == 'failure' || outcome == 'disposed') {
            completion.completeError(PlatformException(code: 'unavailable'));
          } else {
            completion.complete(operation == 'open' ? true : null);
          }
          await tester.pumpAndSettle();
          if (outcome == 'failure') {
            expect(
              find.text(
                operation == 'open'
                    ? page.l10n.openInviteServerFailed
                    : page.l10n.copyRoomIdFailed,
              ),
              findsOneWidget,
            );
            final retry = operation == 'open' ? _open(tester) : _copy(tester);
            retry();
            await tester.pumpAndSettle();
            expect(calls, hasLength(2));
          }
          if (outcome != 'disposed') {
            await tester.tap(find.text('Close'));
            await tester.pumpAndSettle();
          }
          final count = calls.length;
          action();
          await tester.pump();
          expect(calls, hasLength(count));
          expect(find.text('Invite page'), findsOneWidget);
          expect(tester.takeException(), isNull);
          AppNotifications.dismissAll();
        },
      );
    }
  }

  testWidgets('web invite reports rejected launch without closing', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      _launchChannel,
      (_) async => false,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        _launchChannel,
        null,
      ),
    );
    final page = await _show(tester);
    _open(tester)();
    await tester.pumpAndSettle();
    expect(find.text(page.l10n.openInviteServerFailed), findsOneWidget);
    expect(find.text('Open server'), findsOneWidget);
    AppNotifications.dismissAll();
  });
}
