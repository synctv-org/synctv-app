import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/join_room_dialog.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../test_app.dart';

void main() {
  for (final password in [false, true]) {
    testWidgets(
      'join lifecycle password=$password handles late duplicate and failed submission',
      (tester) async {
        final calls = <String>[];
        var pending = Completer<JoinRoomResult>();
        late BuildContext page;
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Builder(
              builder: (context) {
                page = context;
                return const Scaffold(body: Text('Room page'));
              },
            ),
          ),
        );
        Future<JoinRoomResult> submit(String value) {
          calls.add(value);
          return pending.future;
        }

        Future<void> open() async {
          if (password) {
            unawaited(
              showRoomPasswordDialog(
                context: page,
                roomName: 'Room',
                onSubmitted: submit,
              ),
            );
          } else {
            unawaited(
              showJoinRoomDialog(
                context: page,
                onSubmitted: (_, value) async {
                  await submit(value);
                },
              ),
            );
          }
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), ' value ');
          await tester.pump();
        }

        await open();
        final lateSubmit = tester
            .widget<AppTextField>(find.byType(AppTextField))
            .onSubmitted!;
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        lateSubmit('ignored');
        await tester.pump();
        expect(calls, isEmpty);
        expect(tester.takeException(), isNull);

        await open();
        final activeSubmit = tester
            .widget<AppTextField>(find.byType(AppTextField))
            .onSubmitted!;
        activeSubmit('ignored');
        activeSubmit('ignored');
        await tester.pump();
        expect(calls, [password ? ' value ' : 'value']);
        pending.completeError(StateError('offline'));
        await tester.pumpAndSettle();
        expect(find.textContaining('offline'), findsOneWidget);
        expect(
          tester.widget<AppTextField>(find.byType(AppTextField)).enabled,
          isTrue,
        );
        pending = Completer<JoinRoomResult>();
        activeSubmit('ignored');
        await tester.pump();
        expect(calls, hasLength(2));
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('Room page'), findsOneWidget);
        pending.complete(const RoomJoined());
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsNothing);
        expect(find.text('Room page'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final password in [false, true]) {
    for (final locale in ['en', 'zh']) {
      for (final size in [const Size(320, 568), const Size(1200, 360)]) {
        testWidgets('join layout password=$password $locale $size at 3x', (
          tester,
        ) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = size;
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetPhysicalSize);
          late BuildContext page;
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(3),
                  viewInsets: EdgeInsets.only(
                    bottom: size.width < 400 ? 220 : 0,
                  ),
                ),
                child: child!,
              ),
              home: Builder(
                builder: (context) {
                  page = context;
                  return const Scaffold(body: Text('Room page'));
                },
              ),
            ),
          );
          const roomName = 'Friday Film Club with a longer room name';
          if (password) {
            showRoomPasswordDialog(
              context: page,
              roomName: roomName,
              onSubmitted: (_) async => const RoomJoined(),
            );
          } else {
            showJoinRoomDialog(context: page, onSubmitted: (_, _) async {});
          }
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (password) {
            expect(tester.widget<Text>(find.text(roomName)).maxLines, isNull);
          }
          final field = find.byType(TextField);
          await tester.ensureVisible(field);
          await tester.enterText(field, password ? ' password ' : 'room_1');
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final cancel = find.text(AppLocalizations.of(page).cancel);
          await tester.ensureVisible(cancel);
          await tester.tap(cancel);
          await tester.pumpAndSettle();
          expect(find.text('Room page'), findsOneWidget);
          expect(find.byType(TextField), findsNothing);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
  testWidgets('room password dialog keeps the form open and allows retry', (
    tester,
  ) async {
    var attempts = 0;
    JoinRoomResult? completed;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                completed = await showRoomPasswordDialog(
                  context: context,
                  roomName: 'Friday Film Club',
                  onSubmitted: (password) async {
                    attempts++;
                    if (password == 'wrong') {
                      throw RoomPasswordRejectedException(
                        StateError('credential validation failed'),
                      );
                    }
                    return const RoomJoined();
                  },
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'wrong');
    await tester.tap(find.text('Join room').last);
    await tester.pumpAndSettle();

    expect(find.text('Incorrect room password'), findsOneWidget);
    expect(find.text('Enter room password'), findsOneWidget);
    expect(attempts, 1);
    expect(completed, isNull);

    await tester.enterText(find.byType(TextField), 'correct');
    await tester.tap(find.text('Join room').last);
    await tester.pumpAndSettle();

    expect(find.text('Enter room password'), findsNothing);
    expect(attempts, 2);
    expect(completed, isA<RoomJoined>());
  });
}
