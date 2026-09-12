import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

import '../../../test_app.dart';

void main() {
  for (final users in [false, true]) {
    testWidgets(
      'returning to admin records refreshes without losing search: users=$users',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final gateway = _RecordGateway();
        await tester.pumpWidget(_app(users, gateway, wholeAdmin: true));
        await tester.pumpAndSettle();
        final label = users ? 'Users' : 'Rooms';
        await tester.tap(find.text(label).first);
        await tester.pump();
        gateway.complete(users, 'Old record');
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).first, 'matching');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pump();
        gateway.complete(users, 'Matching old record', index: 1);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Overview').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text(label).first);
        await tester.pump();
        final requests = users ? gateway.users : gateway.rooms;
        expect(requests, hasLength(3));
        expect(gateway.recordQueries.last.namedArguments[#search], 'matching');
        gateway.complete(users, 'Matching updated record', index: 2);
        await tester.pumpAndSettle();
        expect(find.text('Matching updated record'), findsOneWidget);
        expect(find.text('Matching old record'), findsNothing);
        expect(find.text('matching'), findsOneWidget);
        await tester.binding.setSurfaceSize(const Size(600, 650));
        await tester.pumpAndSettle();
        expect(requests, hasLength(3));
        expect(find.text('matching'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final users in [false, true]) {
    testWidgets(
      'narrow batch actions stay reachable with enlarged text: users=$users',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final gateway = _RecordGateway();
        await tester.pumpWidget(_app(users, gateway));
        await tester.pump();
        gateway.complete(users, 'Sample record');
        await tester.pumpAndSettle();
        tester
            .widget<AppIconButton>(
              find.byWidgetPredicate(
                (w) => w is AppIconButton && w.tooltip == 'Select current page',
              ),
            )
            .onPressed!();
        await tester.pumpAndSettle();
        final label = users ? '1 user selected' : '1 room selected';
        await tester.scrollUntilVisible(
          find.text(label),
          150,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(label), findsOneWidget);
        for (final action in ['Ban', 'Delete', 'Clear']) {
          final button = find.widgetWithText(AppActionButton, action);
          await tester.ensureVisible(button);
          await tester.pumpAndSettle();
          final rect = tester.getRect(button);
          expect(rect.left, greaterThanOrEqualTo(0));
          expect(rect.right, lessThanOrEqualTo(320));
        }
        await tester.tap(find.widgetWithText(AppActionButton, 'Clear'));
        await tester.pumpAndSettle();
        expect(find.text(label), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final locale in [const Locale('zh'), const Locale('en')]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'mobile admin tabs are readable and preserve drafts: $locale/$scale',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(320, 568));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final gateway = _RecordGateway();
          await tester.pumpWidget(
            _app(false, gateway, wholeAdmin: true, locale: locale),
          );
          await tester.pumpAndSettle();
          expect(gateway.rooms, isEmpty);
          expect(gateway.users, isEmpty);
          expect(find.byType(Tab), findsNWidgets(12));
          expect(tester.getSize(find.byType(AppTabBar)).height, lessThan(90));
          for (var index = 0; index < 12; index++) {
            final text = find.descendant(
              of: find.byType(Tab).at(index),
              matching: find.byType(Text),
            );
            await tester.ensureVisible(text);
            await tester.pumpAndSettle();
            final paragraph = tester.renderObject<RenderParagraph>(
              find.descendant(of: text, matching: find.byType(RichText)),
            );
            expect(paragraph.didExceedMaxLines, isFalse);
            expect(tester.getRect(text).top, greaterThanOrEqualTo(0));
            expect(tester.getRect(text).bottom, lessThan(170));
          }
          Future<void> select(int index) async {
            final tab = find.byType(Tab).at(index);
            await tester.ensureVisible(tab);
            await tester.pumpAndSettle();
            await tester.tap(tab);
            await tester.pump();
          }

          await select(2);
          gateway.complete(false, 'Sample room');
          await tester.pumpAndSettle();
          final search = tester.widget<AppSearchField>(
            find.byType(AppSearchField),
          );
          search.controller.text = 'Unsent draft';
          await select(4);
          gateway.complete(true, 'Sample user');
          await tester.pumpAndSettle();
          await select(2);
          gateway.complete(false, 'Updated room', index: 1);
          await tester.pumpAndSettle();
          expect(gateway.rooms, hasLength(2));
          expect(gateway.users, hasLength(1));
          expect(find.text('Unsent draft'), findsOneWidget);
          await tester.binding.setSurfaceSize(const Size(1200, 900));
          await tester.pumpAndSettle();
          expect(find.text('Unsent draft'), findsOneWidget);
          await tester.binding.setSurfaceSize(const Size(320, 568));
          await tester.pumpAndSettle();
          expect(find.text('Unsent draft'), findsOneWidget);
          expect(
            tester.widget<AppTabBar>(find.byType(AppTabBar)).controller!.index,
            2,
          );
          expect(gateway.rooms, hasLength(2));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final users in [false, true]) {
    for (final width in [320.0, 1200.0]) {
      testWidgets(
        'admin filter labels remain readable: users=$users width=$width',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 1000));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final gateway = _RecordGateway();
          await tester.pumpWidget(
            _app(users, gateway, locale: const Locale('zh')),
          );
          await tester.pump();
          gateway.complete(users, 'Sample record');
          await tester.pumpAndSettle();
          for (final label in ['全部状态', '全部封禁', '20 / 页']) {
            final text = find.text(label);
            expect(text, findsOneWidget);
            final paragraph = tester.renderObject<RenderParagraph>(
              find.descendant(of: text, matching: find.byType(RichText)),
            );
            expect(paragraph.didExceedMaxLines, isFalse, reason: label);
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final action in ['Add member', 'Permission overrides']) {
    testWidgets('member list opens once and dispatches $action once', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _RecordGateway();
      await tester.pumpWidget(_app(false, gateway));
      await tester.pump();
      gateway.complete(false, 'Sample record');
      await tester.pumpAndSettle();
      final open = tester
          .widget<AppIconButton>(
            find.byWidgetPredicate(
              (w) => w is AppIconButton && w.tooltip == 'Members',
            ),
          )
          .onPressed!;
      open();
      open();
      await tester.pumpAndSettle();
      expect(gateway.memberReads, 1);
      final controller = tester
          .widget<AppSearchField>(find.byType(AppSearchField).last)
          .controller;
      final VoidCallback submit = action == 'Add member'
          ? tester
                .widget<AppActionButton>(
                  find.widgetWithText(AppActionButton, action),
                )
                .onPressed!
          : tester
                .widget<AppIconButton>(
                  find.byWidgetPredicate(
                    (w) => w is AppIconButton && w.tooltip == action,
                  ),
                )
                .onPressed!;
      submit();
      submit();
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
      expect(() => controller.addListener(() {}), throwsFlutterError);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Room members'), findsOneWidget);
      expect(gateway.memberReads, 2);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Sample record'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final fail in [false, true]) {
    testWidgets('closed member list ignores pending refresh, failure=$fail', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _RecordGateway(deferMemberRefresh: true);
      await tester.pumpWidget(_app(false, gateway));
      await tester.pump();
      gateway.complete(false, 'Sample record');
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Members'));
      await tester.pumpAndSettle();
      final search = tester.widget<AppSearchField>(
        find.byType(AppSearchField).last,
      );
      search.controller.text = 'pending';
      search.onSubmitted('pending');
      await tester.pump();
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(() => search.controller.addListener(() {}), throwsFlutterError);
      if (fail) {
        gateway.memberRefreshes.single.completeError(
          StateError('late refresh'),
        );
      } else {
        gateway.memberRefreshes.single.complete(gateway.initialMembers);
      }
      await tester.pumpAndSettle();
      expect(find.text('Sample record'), findsOneWidget);
      expect(find.textContaining('late refresh'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final duringRead in [false, true]) {
    testWidgets('member return respects covering route, read=$duringRead', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _RecordGateway(deferMemberRefresh: duringRead);
      await tester.pumpWidget(_app(false, gateway));
      await tester.pump();
      gateway.complete(false, 'Sample record');
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Members'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add member'));
      await tester.pumpAndSettle();
      if (duringRead) {
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(gateway.memberRefreshes, hasLength(1));
      } else {
        await tester.enterText(find.byType(TextField).last, 'usr_added');
        await tester.tap(find.text('Add'));
        await tester.pump();
      }
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      unawaited(
        showDialog<void>(
          context: navigator.context,
          builder: (_) => AlertDialog(
            title: const Text('Independent page'),
            actions: [
              TextButton(
                onPressed: () => navigator.pop(),
                child: const Text('Close overlay'),
              ),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      if (duringRead) {
        gateway.memberRefreshes.single.complete(gateway.initialMembers);
      } else {
        gateway.memberMutations[#adminAddRoomMember]!.single.complete();
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Close overlay').hitTestable(), findsOneWidget);
      expect(find.text('Room members'), findsNothing);
      expect(gateway.memberReads, duringRead ? 2 : 1);
      await tester.pump(const Duration(seconds: 4));
      await tester.tap(find.text('Close overlay'));
      await tester.pumpAndSettle();
      expect(find.text('Sample record'), findsOneWidget);
      await tester.tap(byAppTooltip('Members'));
      await tester.pump();
      if (duringRead) {
        gateway.memberRefreshes.last.complete(gateway.initialMembers);
      }
      await tester.pumpAndSettle();
      expect(find.text('Room members'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final cancel in [false, true]) {
    testWidgets('add member returns to member list, cancel=$cancel', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _RecordGateway();
      await tester.pumpWidget(_app(false, gateway));
      await tester.pump();
      gateway.complete(false, 'Sample record');
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Members'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add member'));
      await tester.pumpAndSettle();
      if (cancel) {
        await tester.tap(find.text('Cancel'));
      } else {
        await tester.enterText(find.byType(TextField).last, 'usr_added');
        await tester.tap(find.text('Add'));
        await tester.pump();
        expect(gateway.memberMutations[#adminAddRoomMember], hasLength(1));
        expect(gateway.memberMutationCalls.single.positionalArguments, [
          'room-1',
          'usr_added',
        ]);
        gateway.memberMutations[#adminAddRoomMember]!.single.complete();
      }
      await tester.pumpAndSettle();
      expect(find.text('Room members'), findsOneWidget);
      expect(gateway.memberReads, 2);
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    });
  }
  for (final action in [
    ('Toggle administrator role', #adminSetRoomMemberRole),
    ('Remove', #adminKickRoomMember),
    ('Remark name', #adminUpdateRoomMemberRemarkName),
    ('Display label', #adminUpdateRoomMemberDisplayTag),
  ]) {
    for (final outcome in ['retry', 'closed success', 'closed failure']) {
      testWidgets('member ${action.$1} guards pending mutation: $outcome', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final gateway = _RecordGateway();
        await tester.pumpWidget(_app(false, gateway));
        await tester.pump();
        gateway.complete(false, 'Sample record');
        await tester.pumpAndSettle();
        await tester.tap(byAppTooltip('Members'));
        await tester.pumpAndSettle();
        Finder button(String label) => find.byWidgetPredicate(
          (w) => w is AppIconButton && w.tooltip == label,
        );
        Future<void> start() async {
          final submit = tester
              .widget<AppIconButton>(button(action.$1))
              .onPressed!;
          submit();
          submit();
          await tester.pumpAndSettle();
          if (action.$1 == 'Remove') {
            await tester.tap(find.widgetWithText(AppActionButton, 'Remove'));
          } else if (action.$1 == 'Remark name' ||
              action.$1 == 'Display label') {
            await tester.enterText(
              find.byType(TextField).last,
              'Updated label',
            );
            await tester.tap(find.widgetWithText(AppActionButton, 'Save'));
          }
          await tester.pumpAndSettle();
        }

        await start();
        expect(gateway.memberMutations[action.$2], hasLength(1));
        final submitted = gateway.memberMutationCalls.single;
        expect(submitted.positionalArguments.take(2), ['room-1', 'member-1']);
        if (action.$1 == 'Toggle administrator role') {
          expect(
            submitted.positionalArguments[2],
            common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          );
        } else if (action.$1 == 'Remove') {
          expect(submitted.namedArguments[#kickCooldownSeconds], 60);
        } else {
          expect(submitted.positionalArguments[2], 'Updated label');
        }
        for (final label in [
          action.$1,
          'Permission overrides',
          'Remark name',
          'Display label',
          'Toggle administrator role',
          'Remove',
        ]) {
          expect(tester.widget<AppIconButton>(button(label)).onPressed, isNull);
        }
        if (outcome.startsWith('closed')) {
          await tester.tap(find.text('Close'));
          await tester.pump();
        }
        if (outcome == 'closed success') {
          gateway.memberMutations[action.$2]!.single.complete();
        } else {
          gateway.memberMutations[action.$2]!.single.completeError(
            StateError('member write failed'),
          );
        }
        await tester.pumpAndSettle();
        if (outcome == 'retry') {
          expect(find.textContaining('member write failed'), findsWidgets);
          await tester.pump(const Duration(seconds: 4));
          await start();
          expect(gateway.memberMutations[action.$2], hasLength(2));
          gateway.memberMutations[action.$2]!.last.complete();
          await tester.pumpAndSettle();
          expect(
            tester.widget<AppIconButton>(button(action.$1)).onPressed,
            isNotNull,
          );
          expect(gateway.memberReads, 2);
        } else {
          expect(find.text('Sample record'), findsOneWidget);
          expect(find.textContaining('member write failed'), findsNothing);
          expect(gateway.memberReads, 1);
        }
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets(
    'admin layout changes preserve page drafts and permission return route',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _RecordGateway();
      await tester.pumpWidget(_app(false, gateway, wholeAdmin: true));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rooms').first);
      await tester.pump();
      gateway.complete(false, 'Sample record');
      await tester.pumpAndSettle();
      tester
              .widget<AppSearchField>(find.byType(AppSearchField))
              .controller
              .text =
          'unsent draft';
      await tester.tap(byAppTooltip('Members'));
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Permission overrides'));
      await tester.pumpAndSettle();
      await tester.binding.setSurfaceSize(const Size(320, 568));
      await tester.pumpAndSettle();
      expect(gateway.rooms, hasLength(1));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Room members'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _app(false, gateway, wholeAdmin: true, locale: const Locale('zh')),
      );
      await tester.pumpAndSettle();
      expect(gateway.rooms, hasLength(1));
      expect(
        tester
            .widget<AppSearchField>(find.byType(AppSearchField))
            .controller
            .text,
        'unsent draft',
      );
      expect(tester.takeException(), isNull);
    },
  );
  for (final fail in [false, true]) {
    testWidgets('member search ignores superseded result, failure=$fail', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _RecordGateway(deferMemberRefresh: true);
      await tester.pumpWidget(_app(false, gateway));
      await tester.pump();
      gateway.complete(false, 'Sample record');
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Members'));
      await tester.pumpAndSettle();
      final search = tester.widget<AppSearchField>(
        find.byType(AppSearchField).last,
      );
      search.controller.text = 'old';
      search.onSubmitted('old');
      search.controller.text = 'latest';
      search.onSubmitted('latest');
      await tester.pump();
      expect(gateway.memberRefreshes, hasLength(2));
      gateway.memberRefreshes.last.complete(gateway.initialMembers);
      await tester.pumpAndSettle();
      if (fail) {
        gateway.memberRefreshes.first.completeError(
          StateError('stale member error'),
        );
      } else {
        gateway.memberRefreshes.first.complete(
          const AdminRoomMembersPage(members: [], total: 0),
        );
      }
      await tester.pumpAndSettle();
      expect(find.text('Sample member'), findsOneWidget);
      expect(find.textContaining('stale member error'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  for (final admin in [false, true]) {
    for (final cancel in [false, true]) {
      testWidgets(
        'admin permission editor submits correct role, admin=$admin cancel=$cancel',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1200, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final gateway = _RecordGateway(memberIsAdmin: admin);
          await tester.pumpWidget(_app(false, gateway));
          await tester.pump();
          gateway.complete(false, 'Sample record');
          await tester.pumpAndSettle();
          await tester.ensureVisible(byAppTooltip('Members'));
          await tester.pumpAndSettle();
          await tester.tap(byAppTooltip('Members'));
          await tester.pumpAndSettle();
          await tester.binding.setSurfaceSize(const Size(320, 568));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(
            tester.getSize(find.text('Sample member')).width,
            greaterThan(120),
          );
          expect(
            tester.getSize(find.text('Sample member')).height,
            lessThan(60),
          );
          await tester.ensureVisible(byAppTooltip('Permission overrides'));
          await tester.pumpAndSettle();
          await tester.tap(byAppTooltip('Permission overrides'));
          await tester.pumpAndSettle();
          await tester.binding.setSurfaceSize(const Size(320, 568));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tap(find.text('Clear overrides'));
          await tester.pump();
          expect(gateway.permissionWrites, isEmpty);
          await tester.tap(find.text('Deny').first);
          await tester.pump();
          await tester.tap(find.text(cancel ? 'Cancel' : 'Save'));
          await tester.pumpAndSettle();
          expect(find.text('Room members'), findsOneWidget);
          expect(gateway.permissionWrites, hasLength(cancel ? 0 : 1));
          if (!cancel) {
            final args = gateway.permissionWrites.single.namedArguments;
            expect(args[#addedPermissions], 0);
            expect(args[#adminAddedPermissions], 0);
            expect(
              args[#removedPermissions],
              admin ? 0 : RoomMemberPermissions.sendChatMessages,
            );
            expect(
              args[#adminRemovedPermissions],
              admin ? RoomAdminPermissions.sendChatMessages : 0,
            );
          }
          await tester.pump(const Duration(seconds: 4));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  for (final fail in [false, true]) {
    testWidgets(
      'room settings ignores reset after cancellation, failure=$fail',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final gateway = _RecordGateway();
        await tester.pumpWidget(_app(false, gateway));
        await tester.pump();
        gateway.complete(false, 'Sample record');
        await tester.pumpAndSettle();
        await tester.tap(byAppTooltip('Settings'));
        await tester.pumpAndSettle();
        final reset = find.widgetWithText(AppActionButton, 'Reset');
        final submit = tester.widget<AppActionButton>(reset).onPressed!;
        final save = tester
            .widget<AppActionButton>(
              find.widgetWithText(AppActionButton, 'Save'),
            )
            .onPressed!;
        submit();
        submit();
        save();
        await tester.pump();
        expect(gateway.resets, hasLength(1));
        expect(
          tester
              .widget<AppActionButton>(
                find.widgetWithText(AppActionButton, 'Save'),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(find.text('Cancel'));
        await tester.pump();
        if (fail) {
          gateway.resets.single.completeError(StateError('late reset failure'));
        } else {
          gateway.resets.single.complete();
        }
        await tester.pumpAndSettle();
        expect(find.text('Sample record'), findsOneWidget);
        expect(find.textContaining('late reset failure'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('room settings reset failure permits retry', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 843));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final gateway = _RecordGateway();
    await tester.pumpWidget(_app(false, gateway));
    await tester.pump();
    gateway.complete(false, 'Sample record');
    await tester.pumpAndSettle();
    await tester.tap(byAppTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pump();
    gateway.resets.single.completeError(StateError('reset failed'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Room settings'), findsOneWidget);
    expect(find.text('Requires password'), findsNothing);
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(gateway.resets, hasLength(2));
    gateway.resets.last.complete();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Sample record'), findsOneWidget);
    expect(find.text('Room settings'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final users in [true, false]) {
    final kind = users ? 'users' : 'rooms';
    testWidgets('$kind keep readable content and actions at narrow widths', (
      tester,
    ) async {
      for (final width in [320.0, 390.0, 834.0, 1440.0]) {
        await tester.binding.setSurfaceSize(Size(width, 1000));
        await tester.pumpWidget(const SizedBox.shrink());
        final gateway = _RecordGateway();
        await tester.pumpWidget(_app(users, gateway));
        await tester.pump();
        gateway.complete(users, 'Sample record');
        await tester.pumpAndSettle();
        final title = find.text('Sample record');
        expect(title, findsOneWidget);
        expect(tester.getSize(title).width, greaterThan(130));
        expect(tester.getSize(title).height, lessThan(65));
        expect(tester.takeException(), isNull, reason: '$kind width $width');
      }
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('$kind ignore a stale search response', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _RecordGateway();
      await tester.pumpWidget(_app(users, gateway));
      await tester.pump();
      await tester.enterText(find.byType(TextField).first, 'new');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      gateway.complete(users, 'Latest result', index: 1);
      await tester.pumpAndSettle();
      gateway.complete(users, 'Stale result');
      await tester.pumpAndSettle();
      expect(find.text('Latest result'), findsOneWidget);
      expect(find.text('Stale result'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}

Widget _app(
  bool users,
  AdminGateway gateway, {
  bool wholeAdmin = false,
  Locale locale = const Locale('en'),
}) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  builder: (context, child) => DependencyScope<AdminGateway>(
    value: gateway,
    child: buildThemedTestApp(context, child),
  ),
  home: Scaffold(
    body: wholeAdmin
        ? const AdminSettingsPage()
        : users
        ? const UserManagementTab()
        : const RoomManagementTab(),
  ),
);

class _RecordGateway implements AdminGateway {
  _RecordGateway({this.memberIsAdmin = false, this.deferMemberRefresh = false});

  final bool memberIsAdmin;
  final bool deferMemberRefresh;
  final memberRefreshes = <Completer<AdminRoomMembersPage>>[];
  final memberMutations = <Symbol, List<Completer<void>>>{};
  final memberMutationCalls = <Invocation>[];
  late AdminRoomMembersPage initialMembers;
  var memberReads = 0;
  final permissionWrites = <Invocation>[];
  final resets = <Completer<void>>[];
  final users = <Completer<AdminUsersPage>>[];
  final rooms = <Completer<AdminRoomsPage>>[];
  final recordQueries = <Invocation>[];

  void complete(bool user, String name, {int index = 0}) {
    if (user) {
      users[index].complete(
        AdminUsersPage(
          users: [
            SyncTvUser(
              id: 'user-1',
              username: name,
              role: const AccountUserRole(common_enum.UserRole.USER_ROLE_USER),
            ),
          ],
          total: 1,
        ),
      );
    } else {
      rooms[index].complete(
        AdminRoomsPage(
          rooms: [
            SyncTvRoom(roomId: 'room-1', roomName: name, creatorId: 'user-1'),
          ],
          total: 1,
        ),
      );
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    switch (invocation.memberName) {
      case #adminSetRoomMemberRole ||
          #adminAddRoomMember ||
          #adminKickRoomMember ||
          #adminUpdateRoomMemberRemarkName ||
          #adminUpdateRoomMemberDisplayTag:
        memberMutationCalls.add(invocation);
        final request = Completer<void>();
        (memberMutations[invocation.memberName] ??= []).add(request);
        return request.future;
      case #adminGetServiceState:
        return Future.value(
          const AdminServiceState(
            totalUsers: 1,
            activeUsers: 1,
            bannedUsers: 0,
            totalRooms: 1,
            activeRooms: 1,
            bannedRooms: 0,
            totalMedia: 0,
            providerInstances: 0,
            activeStreams: 0,
            openReports: 0,
          ),
        );
      case #adminUpdateRoomMemberPermissionOverrides:
        permissionWrites.add(invocation);
        return Future<void>.value();
      case #adminListRoomMembersPage:
        if (memberReads++ > 0 && deferMemberRefresh) {
          final request = Completer<AdminRoomMembersPage>();
          memberRefreshes.add(request);
          return request.future;
        }
        return Future.value(
          initialMembers = AdminRoomMembersPage(
            members: [
              AdminRoomMember(
                roomId: 'room-1',
                userId: 'member-1',
                username: 'Sample member',
                role: memberIsAdmin
                    ? common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN
                    : common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                permissions: 0,
                addedPermissions: RoomMemberPermissions.sendChatMessages,
                removedPermissions: 0,
                adminAddedPermissions: RoomAdminPermissions.sendChatMessages,
                adminRemovedPermissions: 0,
                joinedAt: 0,
                isOnline: false,
              ),
            ],
            total: 1,
          ),
        );
      case #adminGetRoomSettings:
        return Future.value(SyncTvRoomSettings());
      case #adminResetRoomSettings:
        final request = Completer<void>();
        resets.add(request);
        return request.future;
      case #adminListUsersPage:
        recordQueries.add(invocation);
        final request = Completer<AdminUsersPage>();
        users.add(request);
        return request.future;
      case #adminListRoomsPage:
        recordQueries.add(invocation);
        final request = Completer<AdminRoomsPage>();
        rooms.add(request);
        return request.future;
      case #adminListRoomCategories:
        return Future.value(<RoomCategoryInfo>[]);
      case #adminListRoomLabels:
        return Future.value(<RoomLabelInfo>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
