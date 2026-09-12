import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_reaction_users_dialog.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_read_receipts_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as enums;

const _user = ChatReactionUserInfo(
  userId: 'one',
  username: 'Alex',
  reactedAt: 1,
);
const _page = ChatReactionUsersPage(users: [_user], nextCursor: '', total: 1);

Future<void> _pump(
  WidgetTester tester,
  Widget dialog, {
  double width = 800,
  double scale = 1,
}) async {
  tester.view.physicalSize = Size(width, 700);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Scaffold(body: dialog),
    ),
  );
  await tester.pumpAndSettle();
}

ChatReactionUsersDialog _reactions(
  Future<ChatReactionUsersPage> Function({String cursor}) load,
) => ChatReactionUsersDialog(
  roomId: 'room',
  messageId: 'message',
  reactionKey: 'Like',
  loadUsers: load,
);

void main() {
  testWidgets('reaction member survives an out-of-range timestamp', (
    tester,
  ) async {
    await _pump(
      tester,
      _reactions(
        ({String cursor = ''}) async => const ChatReactionUsersPage(
          users: [
            ChatReactionUserInfo(
              userId: 'one',
              username: 'Alex',
              reactedAt: 9007199254740991,
            ),
          ],
          nextCursor: '',
          total: 1,
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Alex'), findsOneWidget);
  });

  testWidgets('read receipt member survives an out-of-range timestamp', (
    tester,
  ) async {
    final user = SyncTvUser(
      id: 'one',
      username: 'Alex',
      role: const AccountUserRole(enums.UserRole.USER_ROLE_USER),
    );
    await _pump(
      tester,
      ChatReadReceiptsDialog(
        receipts: ChatMessageReadReceiptsInfo(
          readers: [
            ChatReadReceiptUserInfo(user: user, readAt: 9007199254740991),
          ],
          unreadMembers: [],
          readerTotal: 1,
          unreadTotal: 0,
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Alex'), findsOneWidget);
  });

  testWidgets('duplicate reaction members update once across pages', (
    tester,
  ) async {
    var calls = 0;
    await _pump(
      tester,
      _reactions(({String cursor = ''}) async {
        calls++;
        return ChatReactionUsersPage(
          users: calls == 1
              ? [_user, _user]
              : const [
                  ChatReactionUserInfo(
                    userId: 'one',
                    username: 'Renamed',
                    reactedAt: 2,
                  ),
                ],
          nextCursor: calls == 1 ? 'next' : '',
          total: 1,
        );
      }),
    );
    expect(find.text('Alex'), findsOneWidget);
    await tester.tap(find.text('Load more'));
    await tester.pumpAndSettle();
    expect(find.text('Alex'), findsNothing);
    expect(find.text('Renamed'), findsOneWidget);
  });

  for (final cycle in [false, true]) {
    testWidgets('reaction pagination stops repeated cursor, cycle=$cycle', (
      tester,
    ) async {
      final cursors = <String>[];
      await _pump(
        tester,
        _reactions(({String cursor = ''}) async {
          cursors.add(cursor);
          return ChatReactionUsersPage(
            users: [_user],
            nextCursor: cursor == 'a' && cycle ? 'b' : 'a',
            total: 1,
          );
        }),
      );
      await tester.tap(find.text('Load more'));
      await tester.pumpAndSettle();
      if (cycle) {
        await tester.tap(find.text('Load more'));
        await tester.pumpAndSettle();
      }
      expect(cursors, cycle ? ['', 'a', 'b'] : ['', 'a']);
      expect(find.text('Load more'), findsNothing);
      expect(find.text('Alex'), findsOneWidget);
    });
  }

  for (final identity in ['room', 'message', 'reaction']) {
    for (final failure in [false, true]) {
      testWidgets(
        'changing $identity ignores old completion, failure=$failure',
        (tester) async {
          final old = Completer<ChatReactionUsersPage>();
          final fresh = Completer<ChatReactionUsersPage>();
          Future<void> render(bool updated) => tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: ChatReactionUsersDialog(
                  roomId: updated && identity == 'room' ? 'new-room' : 'room',
                  messageId: updated && identity == 'message'
                      ? 'new-message'
                      : 'message',
                  reactionKey: updated && identity == 'reaction'
                      ? 'Love'
                      : 'Like',
                  loadUsers: ({String cursor = ''}) =>
                      updated ? fresh.future : old.future,
                ),
              ),
            ),
          );
          await render(false);
          await render(true);
          if (failure) {
            old.completeError(StateError('Obsolete'));
          } else {
            old.complete(_page);
          }
          await tester.pump();
          expect(tester.takeException(), isNull);
          expect(find.text('Alex'), findsNothing);
          expect(find.textContaining('Obsolete'), findsNothing);
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          fresh.complete(
            const ChatReactionUsersPage(
              users: [
                ChatReactionUserInfo(
                  userId: 'fresh',
                  username: 'Sam',
                  reactedAt: 1,
                ),
              ],
              nextCursor: '',
              total: 1,
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('Sam'), findsOneWidget);
          expect(find.text('Alex'), findsNothing);
        },
      );
    }
  }

  testWidgets('initial reaction failure can retry without uncaught errors', (
    tester,
  ) async {
    var attempts = 0;
    await _pump(
      tester,
      _reactions(({String cursor = ''}) async {
        if (++attempts == 1) throw StateError('Unavailable');
        return _page;
      }),
      width: 320,
    );
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Unavailable'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
    expect(attempts, 2);
  });

  testWidgets(
    'pagination failure preserves users and retries the same cursor',
    (tester) async {
      final cursors = <String>[];
      await _pump(
        tester,
        _reactions(({String cursor = ''}) async {
          cursors.add(cursor);
          if (cursors.length == 1) {
            return const ChatReactionUsersPage(
              users: [_user],
              nextCursor: 'next',
              total: 2,
            );
          }
          if (cursors.length == 2) throw StateError('Unavailable');
          return const ChatReactionUsersPage(
            users: [
              _user,
              ChatReactionUserInfo(
                userId: 'two',
                username: 'Sam',
                reactedAt: 1,
              ),
            ],
            nextCursor: '',
            total: 2,
          );
        }),
      );
      await tester.tap(find.text('Load more'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Alex'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(cursors, ['', 'next', 'next']);
      expect(find.text('Alex'), findsOneWidget);
      expect(find.text('Sam'), findsOneWidget);
    },
  );

  testWidgets('reaction request failure after disposal is contained', (
    tester,
  ) async {
    final pending = Completer<ChatReactionUsersPage>();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: _reactions(({String cursor = ''}) => pending.future),
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox());
    pending.completeError(StateError('Unavailable'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  for (final (width, scale, stacked) in [
    (320.0, 1.0, true),
    (800.0, 2.0, true),
    (800.0, 1.0, false),
  ]) {
    testWidgets('read receipts fit $width at scale $scale', (tester) async {
      final reader = SyncTvUser(
        id: 'reader',
        username: 'Alex',
        role: const AccountUserRole(enums.UserRole.USER_ROLE_USER),
      );
      final unread = SyncTvUser(
        id: 'unread',
        username: 'Sam',
        role: const AccountUserRole(enums.UserRole.USER_ROLE_USER),
      );
      await _pump(
        tester,
        ChatReadReceiptsDialog(
          receipts: ChatMessageReadReceiptsInfo(
            readers: [ChatReadReceiptUserInfo(user: reader, readAt: 1)],
            unreadMembers: [unread],
            readerTotal: 1,
            unreadTotal: 1,
          ),
        ),
        width: width,
        scale: scale,
      );
      expect(tester.takeException(), isNull);
      final readRect = tester.getRect(find.text('1 read'));
      final unreadRect = tester.getRect(find.text('1 unread'));
      if (stacked) {
        expect(unreadRect.top, greaterThan(readRect.bottom));
      } else {
        expect(unreadRect.left, greaterThan(readRect.right));
      }
      expect(find.text('Alex'), findsOneWidget);
      expect(find.text('Sam'), findsOneWidget);
    });
  }
}
