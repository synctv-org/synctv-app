import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/application/media_library_gateway.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/data/shared_preferences_p2p_media_preferences_store.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/features/room/application/room_chat_gateway.dart';
import 'package:synctv_app/features/room/application/room_management_gateway.dart';
import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/features/room/application/room_realtime_protocol.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_mode_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_realtime_event_log_store.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/features/room/presentation/room_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source;

import '../../../test_app.dart';

void main() {
  testWidgets(
    'password state survives policy snapshots and refreshes after removal',
    (tester) async {
      final gateway = _Gateway()..passwordEnabled = true;
      final messages = StreamController<RoomRealtimeMessage>();
      addTearDown(messages.close);
      await _pumpPage(tester, gateway, messages: messages.stream);
      await _select(tester, 'Information');
      expect(find.text('Configured'), findsOneWidget);
      messages.add(
        RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.roomSettings,
          roomSettings: SyncTvRoomSettings(chatEnabled: false),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Configured'), findsOneWidget);
      final scroll = find
          .byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
          )
          .last;
      await tester.scrollUntilVisible(
        find.text('Remove password'),
        200,
        scrollable: scroll,
      );
      await tester.tap(find.text('Remove password'));
      await tester.pump();
      gateway.passwordEnabled = false;
      gateway.pending[#updateRoomPassword]!.single.complete(null);
      await tester.pump();
      gateway.pending[#getRoomSettings]!.single.complete(SyncTvRoomSettings());
      await tester.pumpAndSettle();
      expect(find.text('No action needed'), findsOneWidget);
      expect(find.text('Remove password'), findsNothing);
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets('empty member results ignore room-wide and late online counts', (
    tester,
  ) async {
    final gateway = _Gateway();
    final messages = StreamController<RoomRealtimeMessage>();
    addTearDown(messages.close);
    await _pumpPage(tester, gateway, messages: messages.stream);
    await _select(tester, 'Members');
    await tester.tap(byAppTooltip('Refresh'));
    await tester.pump();
    gateway.pending[#getRoomMemberDetailsPage]!.single.complete(
      const RoomMembersPage(
        members: [],
        total: 0,
        page: 1,
        pageSize: 50,
        version: '',
        onlineMemberCount: 1,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('0 online / 0 members'), findsOneWidget);
    messages.add(
      const RoomRealtimeMessage(
        kind: RoomRealtimeMessageKind.presenceCount,
        resourceObserveId: 'manage_member_online_count',
        onlineMemberCount: 1,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('0 online / 0 members'), findsOneWidget);
  });

  testWidgets('adding a member validates missing ID before save or Enter', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _pumpPage(tester, gateway);
    await _select(tester, 'Members');
    await tester.tap(byAppTooltip('Add member'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();
    expect(find.text('Enter a user ID'), findsOneWidget);
    final field = find.byWidgetPredicate(
      (widget) => widget is AppTextField && widget.label == 'User ID',
    );
    await tester.enterText(field, '   ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Enter a user ID'), findsOneWidget);
    expect(find.text('Send notification'), findsOneWidget);
    await tester.tap(find.text('Cancel').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('context actions refresh the open sheet and tolerate dismissal', (
    tester,
  ) async {
    final gateway = _Gateway()..contextMessage = _message('Context message');
    await _pumpPage(tester, gateway);
    await _select(tester, 'Chat');
    await tester.tap(byAppTooltip('View context').last);
    await tester.pumpAndSettle();
    await tester.tap(byAppTooltip('Pin').last);
    await tester.pumpAndSettle();
    gateway.pending[#getContext]!.last.complete(
      ChatMessageContextInfo(
        before: const [],
        message: gateway.contextMessage!,
        after: const [],
      ),
    );
    await tester.pumpAndSettle();
    expect(byAppTooltip('Unpin'), findsNWidgets(2));
    expect(byAppTooltip('Pin'), findsNothing);
    await tester.tap(byAppTooltip('Unpin').last);
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.text('Message context'))).pop();
    await tester.pumpAndSettle();
    gateway.pending[#getContext]!.last.complete(
      ChatMessageContextInfo(
        before: const [],
        message: gateway.contextMessage!,
        after: const [],
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets(
    'move dialog renders loaded targets and can close during refresh',
    (tester) async {
      final gateway = _Gateway()..moveDialogMedia = true;
      await _pumpPage(tester, gateway);
      await _select(tester, 'Media');
      await tester.tap(byAppTooltip('Media actions').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move to...'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Move target'), findsOneWidget);
      await tester.tap(find.text('Refresh').last);
      await tester.pump();
      await tester.tap(find.text('Cancel').last);
      await tester.pumpAndSettle();
      gateway.pending[#listPlaylistsPage]!.single.complete(
        const RoomPlaylistsPage(
          playlists: [],
          total: 0,
          page: 1,
          pageSize: 100,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty playlist name preserves the draft on save and Enter', (
    tester,
  ) async {
    final gateway = _Gateway()..immediateMedia = true;
    await _pumpPage(tester, gateway);
    await _select(tester, 'Media');
    await tester.tap(byAppTooltip('New playlist'));
    await tester.pumpAndSettle();
    final name = find.byWidgetPredicate(
      (widget) => widget is AppTextField && widget.label == 'Name',
    );
    final description = find.byWidgetPredicate(
      (widget) => widget is AppTextField && widget.label == 'Description',
    );
    await tester.enterText(description, 'Keep this description');
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();
    expect(find.text('Enter a name'), findsOneWidget);
    expect(find.text('Keep this description'), findsOneWidget);
    await tester.enterText(name, '   ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Enter a name'), findsOneWidget);
    expect(find.text('Keep this description'), findsOneWidget);
    await tester.tap(find.text('Cancel').last);
    await tester.pumpAndSettle();
    expect(find.text('Keep this description'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('media instance label collisions preserve request targets', (
    tester,
  ) async {
    final gateway = _Gateway()..immediateMedia = true;
    await _pumpPage(tester, gateway);
    await _select(tester, 'Media');
    tester
        .widget<AppSelect<source.SourceProvider>>(
          find.byType(AppSelect<source.SourceProvider>),
        )
        .onChanged!(source.SourceProvider.SOURCE_PROVIDER_ALIST);
    await tester.pumpAndSettle();
    final selector = find.byWidgetPredicate(
      (widget) => widget is AppSelect<String> && widget.label == 'Instance',
    );
    final options = tester.widget<AppSelect<String>>(selector).options;
    expect(options.values, ['', 'Local instance', 'Local instance (Default)']);
    for (final target in ['Local instance', '']) {
      final label = options.entries.singleWhere((e) => e.value == target).key;
      await tester.ensureVisible(selector);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: selector,
          matching: find.byType(DropdownButton<String>),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(label).last);
      await tester.pumpAndSettle();
      expect(tester.widget<AppSelect<String>>(selector).value, target);
      expect(
        gateway.mediaRequests.last.namedArguments[#providerInstanceName],
        target,
      );
      expect(tester.takeException(), isNull);
    }
  });

  for (final search in [false, true]) {
    testWidgets('chat refresh preserves pending live updates, search=$search', (
      tester,
    ) async {
      final gateway = _Gateway();
      final messages = StreamController<RoomRealtimeMessage>();
      addTearDown(messages.close);
      await _pumpPage(tester, gateway, messages: messages.stream);
      await _select(tester, 'Chat');
      if (search) {
        await _search(tester, 'match');
      } else {
        await tester.tap(byAppTooltip('Refresh'));
        await tester.pump();
      }
      for (final update in [
        ('match', 'latest edit', 3),
        ('match', 'older live edit', 2),
        ('new', 'new live message', 1),
      ]) {
        messages.add(
          RoomRealtimeMessage(
            kind: RoomRealtimeMessageKind.chat,
            resourceObserveId: 'manage_chat_events',
            chatId: update.$1,
            chatContent: update.$2,
            chatVersion: update.$3,
          ),
        );
      }
      await tester.pump();
      const stale = RoomChatMessageInfo(
        id: 'match',
        roomId: 'room',
        userId: 'user',
        content: 'stale HTTP message',
        timestamp: 1,
        version: 1,
      );
      if (search) {
        gateway.pending[#search]!.single.complete(
          const ChatSearchPage(messages: [stale], nextCursor: ''),
        );
      } else {
        gateway.pending[#getHistory]!.single.complete(
          const ChatHistoryPage(messages: [stale], nextCursor: ''),
        );
      }
      await tester.pumpAndSettle();
      expect(find.text('latest edit'), findsOneWidget);
      expect(find.text('older live edit'), findsNothing);
      expect(find.text('stale HTTP message'), findsNothing);
      expect(
        find.text('new live message'),
        search ? findsNothing : findsOneWidget,
      );
      await tester.tap(byAppTooltip('Refresh'));
      await tester.pump();
      if (search) {
        gateway.pending[#search]!.last.complete(
          const ChatSearchPage(messages: [stale], nextCursor: ''),
        );
      } else {
        gateway.pending[#getHistory]!.last.complete(
          const ChatHistoryPage(messages: [stale], nextCursor: ''),
        );
      }
      await tester.pumpAndSettle();
      expect(find.text('latest edit'), findsOneWidget);
      expect(find.text('stale HTTP message'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  for (final fail in [false, true]) {
    testWidgets(
      'room reset blocks saving and releases controls, failure=$fail',
      (tester) async {
        final gateway = _Gateway();
        await _pumpPage(tester, gateway);
        await _select(tester, 'Settings');
        final guestFinder = find.byWidgetPredicate(
          (w) => w is AppSwitch && w.semanticsLabel == 'Allow guests to join',
        );
        final guest = tester.widget<AppSwitch>(guestFinder);
        final approvalFinder = find.byWidgetPredicate(
          (w) =>
              w is AppSwitch && w.semanticsLabel == 'Require approval to join',
        );
        tester.widget<AppSwitch>(approvalFinder).onChanged!(true);
        await tester.pump();
        final scroll = tester.state<ScrollableState>(
          find
              .ancestor(of: guestFinder, matching: find.byType(Scrollable))
              .first,
        );
        await tester.scrollUntilVisible(
          find.text('Reset room settings'),
          400,
          scrollable: find.byWidget(scroll.widget),
        );
        await tester.tap(find.text('Reset room settings'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Reset').last);
        await tester.pump();
        expect(gateway.pending[#resetRoomSettings], hasLength(1));
        final saveFinder = find.widgetWithText(
          AppActionButton,
          'Save settings',
        );
        expect(tester.widget<AppActionButton>(saveFinder).onPressed, isNull);
        guest.onChanged!(true);
        await tester.pump();
        if (fail) {
          gateway.pending[#resetRoomSettings]!.single.completeError(
            StateError('reset failed'),
          );
        } else {
          gateway.pending[#resetRoomSettings]!.single.complete(null);
          await tester.pump();
          gateway.pending[#getRoomSettings]!.single.complete(
            SyncTvRoomSettings(),
          );
        }
        await tester.pump();
        await tester.pump(const Duration(seconds: 4));
        expect(tester.widget<AppActionButton>(saveFinder).onPressed, isNotNull);
        scroll.position.jumpTo(0);
        await tester.pumpAndSettle();
        expect(tester.widget<AppSwitch>(guestFinder).value, isTrue);
        expect(tester.widget<AppSwitch>(approvalFinder).value, fail);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final oldFirst in [false, true]) {
    for (final editAfterSave in [false, true]) {
      testWidgets(
        'password/settings readback oldFirst=$oldFirst draft=$editAfterSave',
        (tester) async {
          final gateway = _Gateway();
          await _pumpPage(tester, gateway);
          await _select(tester, 'Information');
          final vertical = find
              .byWidgetPredicate(
                (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
              )
              .last;
          await tester.scrollUntilVisible(
            find.text('New password'),
            400,
            scrollable: vertical,
          );
          final password = tester.widget<AppTextField>(
            find.byWidgetPredicate(
              (w) => w is AppTextField && w.label == 'New password',
            ),
          );
          password.controller.text = 'test-password';
          password.onChanged!('test-password');
          await tester.pump();
          await tester.scrollUntilVisible(
            find.text('Save password'),
            200,
            scrollable: vertical,
          );
          await tester.tap(find.text('Save password'));
          await tester.pump();
          gateway.pending[#updateRoomPassword]!.single.complete(null);
          await tester.pump();
          await _select(tester, 'Settings');
          final guestFinder = find.byWidgetPredicate(
            (w) => w is AppSwitch && w.semanticsLabel == 'Allow guests to join',
          );
          final guestControl = tester.widget<AppSwitch>(guestFinder);
          guestControl.onChanged!(true);
          await tester.pump();
          final scroll = tester.state<ScrollableState>(
            find
                .ancestor(of: guestFinder, matching: find.byType(Scrollable))
                .first,
          );
          await tester.scrollUntilVisible(
            find.text('Save settings'),
            400,
            scrollable: find.byWidget(scroll.widget),
          );
          await tester.tap(find.text('Save settings'));
          await tester.pump();
          gateway.pending[#updateRoomSettings]!.single.complete(null);
          await tester.pump();
          final reads = gateway.pending[#getRoomSettings]!;
          expect(reads, hasLength(2));
          if (editAfterSave) {
            guestControl.onChanged!(false);
            await tester.pump();
          }
          if (oldFirst) {
            reads[0].complete(SyncTvRoomSettings(requirePassword: true));
            await tester.pump();
          }
          reads[1].complete(
            SyncTvRoomSettings(allowGuestJoin: true, requirePassword: true),
          );
          await tester.pump();
          if (!oldFirst) {
            reads[0].complete(SyncTvRoomSettings(requirePassword: true));
            await tester.pump();
          }
          scroll.position.jumpTo(0);
          await tester.pumpAndSettle();
          expect(tester.widget<AppSwitch>(guestFinder).value, !editAfterSave);
          await tester.pump(const Duration(seconds: 4));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  for (final failure in ['none', 'write', 'read']) {
    testWidgets('settings save retains edits and retries, failure=$failure', (
      tester,
    ) async {
      final gateway = _Gateway();
      final messages = StreamController<RoomRealtimeMessage>();
      addTearDown(messages.close);
      await _pumpPage(tester, gateway, messages: messages.stream);
      await _select(tester, 'Settings');
      final guestFinder = find.byWidgetPredicate(
        (w) => w is AppSwitch && w.semanticsLabel == 'Allow guests to join',
      );
      final guest = tester.widget<AppSwitch>(guestFinder);
      guest.onChanged!(true);
      await tester.pump();
      final scrollState = tester.state<ScrollableState>(
        find.ancestor(of: guestFinder, matching: find.byType(Scrollable)).first,
      );
      final scrollable = find.byWidget(scrollState.widget);
      await tester.scrollUntilVisible(
        find.text('Save settings'),
        400,
        scrollable: scrollable,
      );
      await tester.tap(find.text('Save settings'));
      await tester.pump();
      expect(gateway.pending[#updateRoomSettings], hasLength(1));
      guest.onChanged!(false);
      await tester.pump();
      messages.add(
        RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.roomSettings,
          resourceObserveId: 'manage_room_settings',
          roomSettings: SyncTvRoomSettings(allowGuestJoin: true),
        ),
      );
      await tester.pump();
      expect(gateway.savedSettings.single.allowGuestJoin, isTrue);
      if (failure != 'none') {
        if (failure == 'write') {
          gateway.pending[#updateRoomSettings]!.single.completeError(
            StateError('save failed'),
          );
        } else {
          gateway.pending[#updateRoomSettings]!.single.complete(null);
          await tester.pump();
          gateway.pending[#getRoomSettings]!.single.completeError(
            StateError('read failed'),
          );
        }
        await tester.pump();
        await tester.pump(const Duration(seconds: 4));
        final retry = tester.widget<AppActionButton>(
          find.widgetWithText(AppActionButton, 'Save settings'),
        );
        expect(retry.onPressed, isNotNull);
        await tester.tap(find.text('Save settings'));
        await tester.pump();
        expect(gateway.savedSettings, hasLength(2));
        expect(gateway.savedSettings.last.allowGuestJoin, isFalse);
      }
      gateway.pending[#updateRoomSettings]!.last.complete(null);
      await tester.pump();
      messages.add(
        RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.roomSettings,
          resourceObserveId: 'manage_room_settings',
          roomSettings: SyncTvRoomSettings(
            allowGuestJoin: failure == 'none',
            requireApproval: true,
          ),
        ),
      );
      await tester.pump();
      gateway.pending[#getRoomSettings]!.last.complete(
        SyncTvRoomSettings(allowGuestJoin: failure == 'none'),
      );
      await tester.pump();
      scrollState.position.jumpTo(0);
      await tester.pumpAndSettle();
      expect(tester.widget<AppSwitch>(guestFinder).value, isFalse);
      final approval = tester.widget<AppSwitch>(
        find.byWidgetPredicate(
          (w) =>
              w is AppSwitch && w.semanticsLabel == 'Require approval to join',
        ),
      );
      expect(approval.value, isTrue);
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'settings snapshot preserves draft and updates untouched fields',
    (tester) async {
      final gateway = _Gateway();
      final messages = StreamController<RoomRealtimeMessage>();
      addTearDown(messages.close);
      await _pumpPage(tester, gateway, messages: messages.stream);
      await _select(tester, 'Settings');
      AppSwitch control(String label) => tester
          .widgetList<AppSwitch>(find.byType(AppSwitch))
          .singleWhere((item) => item.semanticsLabel == label);
      final guest = control('Allow guests to join');
      guest.onChanged!(!guest.value);
      await tester.pump();
      messages.add(
        RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.roomSettings,
          resourceObserveId: 'manage_room_settings',
          resourceVersion: 'new-settings',
          roomSettings: SyncTvRoomSettings(requireApproval: true),
        ),
      );
      await tester.pumpAndSettle();
      expect(control('Allow guests to join').value, !guest.value);
      expect(control('Require approval to join').value, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
  for (final online in [false, true]) {
    testWidgets('member refresh preserves newer presence: online=$online', (
      tester,
    ) async {
      final gateway = _Gateway();
      final messages = StreamController<RoomRealtimeMessage>();
      addTearDown(messages.close);
      await _pumpPage(tester, gateway, messages: messages.stream);
      await _select(tester, 'Members');
      await tester.tap(byAppTooltip('Refresh'));
      await tester.pump();
      messages.add(
        RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.onlineEvent,
          resourceObserveId: 'manage_member_online_count',
          onlineEvent: RoomRealtimeOnlineEvent(
            userId: 'initial',
            username: 'initial',
            role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
            kind: online
                ? client.OnlineEventKind.ONLINE_EVENT_KIND_JOINED
                : client.OnlineEventKind.ONLINE_EVENT_KIND_LEFT,
            occurredAtMillis: 1,
          ),
        ),
      );
      await tester.pump();
      final stale = _members('initial');
      gateway.pending[#getRoomMemberDetailsPage]!.single.complete(
        RoomMembersPage(
          members: [stale.members.single.copyWith(isOnline: !online)],
          total: 1,
          page: 1,
          pageSize: 50,
          version: '',
          onlineMemberCount: online ? 0 : 1,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(online ? 'Online' : 'Offline'), findsOneWidget);
      expect(find.text(online ? 'Offline' : 'Online'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  for (final failOld in [false, true]) {
    testWidgets(
      'realtime media snapshot supersedes HTTP, old failure=$failOld',
      (tester) async {
        final gateway = _Gateway();
        final messages = StreamController<RoomRealtimeMessage>();
        addTearDown(messages.close);
        final protocol = _Protocol();
        await _pumpPage(
          tester,
          gateway,
          messages: messages.stream,
          protocol: protocol,
        );
        await _select(tester, 'Media');
        await tester.tap(byAppTooltip('Refresh'));
        await tester.pump();
        messages.add(
          RoomRealtimeMessage(
            kind: RoomRealtimeMessageKind.mediaLibrary,
            resourceObserveId: protocol.mediaObserveId,
            resourceVersion: 'new-version',
            mediaLibrary: _media('realtime playlist'),
          ),
        );
        await tester.pumpAndSettle();
        if (failOld) {
          gateway.pending[#listMediaLibrary]!.single.completeError(
            StateError('stale media failure'),
          );
        } else {
          gateway.pending[#listMediaLibrary]!.single.complete(
            _media('old playlist'),
          );
        }
        await tester.pumpAndSettle();
        expect(find.text('realtime playlist'), findsOneWidget);
        expect(find.text('old playlist'), findsNothing);
        expect(find.textContaining('stale media failure'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final surface in [
    ('Members', #getRoomMemberDetailsPage, _members),
    ('Streaming', #listRoomStreamsPage, _streams),
    ('Review', #listRoomJoinReviewsPage, _reviews),
  ]) {
    for (final failOld in [false, true]) {
      testWidgets(
        '${surface.$1} preserves the latest query, old failure=$failOld',
        (tester) async {
          final gateway = _Gateway();
          await _pumpPage(tester, gateway);
          await _select(tester, surface.$1);
          await _search(tester, 'old');
          await _search(tester, 'latest');
          final requests = gateway.pending[surface.$2]!;
          expect(requests, hasLength(2));
          requests[1].complete(surface.$3('latest result'));
          await tester.pumpAndSettle();
          if (failOld) {
            requests[0].completeError(StateError('stale failure'));
          } else {
            requests[0].complete(surface.$3('old result'));
          }
          await tester.pumpAndSettle();
          expect(find.text('latest result'), findsWidgets);
          expect(find.text('old result'), findsNothing);
          expect(find.textContaining('stale failure'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('chat search survives an older history refresh', (tester) async {
    final gateway = _Gateway();
    await _pumpPage(tester, gateway);
    await _select(tester, 'Chat');
    await tester.tap(byAppTooltip('Refresh'));
    await tester.pump();
    await _search(tester, 'latest');
    gateway.pending[#search]!.single.complete(
      ChatSearchPage(messages: [_message('latest result')], nextCursor: ''),
    );
    await tester.pumpAndSettle();
    gateway.pending[#getHistory]!.single.complete(
      ChatHistoryPage(messages: [_message('old result')], nextCursor: ''),
    );
    await tester.pumpAndSettle();
    expect(find.text('latest result'), findsOneWidget);
    expect(find.text('old result'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('room settings switches expose their setting names', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _pumpPage(tester, gateway);
    await _select(tester, 'Settings');
    final switches = tester.widgetList<AppSwitch>(find.byType(AppSwitch));
    expect(switches, isNotEmpty);
    expect(
      switches.every((control) => control.semanticsLabel?.isNotEmpty == true),
      isTrue,
    );
  });

  for (final action in ['Load more', 'Refresh']) {
    testWidgets(
      'chat $action retains the submitted query while the input is edited',
      (tester) async {
        final gateway = _Gateway();
        await _pumpPage(tester, gateway);
        await _select(tester, 'Chat');
        await _search(tester, 'submitted');
        gateway.pending[#search]!.single.complete(
          ChatSearchPage(
            messages: [_message('first result')],
            nextCursor: 'next-page',
          ),
        );
        await tester.pumpAndSettle();
        tester
                .widget<AppSearchField>(find.byType(AppSearchField))
                .controller
                .text =
            'draft';
        await tester.tap(byAppTooltip(action));
        await tester.pump();
        expect(gateway.searches.last.namedArguments[#query], 'submitted');
        expect(
          gateway.searches.last.namedArguments[#cursor],
          action == 'Load more' ? 'next-page' : '',
        );
        gateway.pending[#search]!.last.complete(
          const ChatSearchPage(messages: [], nextCursor: ''),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'chat search ignores unrelated realtime messages and older edits',
    (tester) async {
      final gateway = _Gateway();
      final messages = StreamController<RoomRealtimeMessage>();
      addTearDown(messages.close);
      await _pumpPage(tester, gateway, messages: messages.stream);
      await _select(tester, 'Chat');
      await _search(tester, 'submitted');
      gateway.pending[#search]!.single.complete(
        const ChatSearchPage(
          messages: [
            RoomChatMessageInfo(
              id: 'match',
              roomId: 'room',
              userId: 'user',
              content: 'matched result',
              timestamp: 1,
              version: 3,
            ),
          ],
          nextCursor: '',
        ),
      );
      await tester.pumpAndSettle();
      messages.add(
        const RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.chat,
          resourceObserveId: 'manage_chat_events',
          chatId: 'unrelated',
          chatContent: 'unrelated result',
        ),
      );
      messages.add(
        const RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.chat,
          resourceObserveId: 'manage_chat_events',
          chatId: 'match',
          chatContent: 'old edit',
          chatVersion: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('matched result'), findsOneWidget);
      expect(find.text('unrelated result'), findsNothing);
      expect(find.text('old edit'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _select(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).first);
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String value) async {
  final field = tester.widget<AppSearchField>(find.byType(AppSearchField));
  field.controller.text = value;
  field.onSubmitted(value);
  await tester.pump();
}

Future<void> _pumpPage(
  WidgetTester tester,
  _Gateway gateway, {
  Stream<RoomRealtimeMessage> messages = const Stream.empty(),
  _Protocol? protocol,
}) async {
  await tester.binding.setSurfaceSize(const Size(1280, 960));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  SharedPreferences.setMockInitialValues({});
  final playback = PlaybackModePreferencesController(
    store: const SharedPreferencesPlaybackModeStore(),
  );
  final p2p = P2pMediaPreferencesController(
    store: const SharedPreferencesP2pMediaPreferencesStore(),
  );
  addTearDown(playback.dispose);
  addTearDown(p2p.dispose);
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => DependencyRegistryScope(
        values: {
          RoomManagementGateway: gateway,
          RoomChatGateway: gateway,
          RoomPlaybackGateway: gateway,
          MediaLibraryGateway: gateway,
          PlaybackModePreferencesController: playback,
          RealtimeEventLogPreferencesController:
              RealtimeEventLogPreferencesController(
                store: const SharedPreferencesRealtimeEventLogStore(),
              ),
          ResourceUrlResolver: const IdentityResourceUrlResolver(),
          RoomRealtimeProtocol: protocol ?? _Protocol(),
        },
        child: buildThemedTestApp(context, child),
      ),
      home: RoomSettingsPage(
        roomId: 'room',
        roomName: 'Test room',
        creatorId: 'me',
        currentUserId: 'me',
        isPublic: true,
        currentSettings: SyncTvRoomSettings(),
        realtime: RoomRealtimeSession(
          send: (_) {},
          messages: messages,
          events: const Stream.empty(),
          reconnects: const Stream.empty(),
        ),
        p2pMediaPreferences: p2p,
        canUseWebRtc: false,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _Protocol implements RoomRealtimeProtocol {
  String mediaObserveId = '';
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #encodePlaylistObservation) {
      mediaObserveId = invocation.namedArguments[#observeId] as String;
    }
    return const <int>[];
  }
}

class _Gateway
    implements
        RoomManagementGateway,
        RoomChatGateway,
        RoomPlaybackGateway,
        MediaLibraryGateway {
  final calls = <Symbol, int>{};
  final savedSettings = <SyncTvRoomSettings>[];
  final searches = <Invocation>[];
  final pending = <Symbol, List<Completer<Object?>>>{};
  RoomChatMessageInfo? contextMessage;
  bool passwordEnabled = false;
  bool immediateMedia = false;
  bool moveDialogMedia = false;
  final mediaRequests = <Invocation>[];

  Future<T> _reply<T>(
    Invocation invocation,
    T initial, {
    bool firstImmediate = true,
  }) {
    final name = invocation.memberName;
    calls[name] = (calls[name] ?? 0) + 1;
    if (calls[name] == 1 && firstImmediate) return Future.value(initial);
    final request = Completer<T>();
    (pending[name] ??= []).add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (contextMessage != null) {
      if (invocation.memberName == #getHistory) {
        return Future.value(
          ChatHistoryPage(messages: [contextMessage!], nextCursor: ''),
        );
      }
      if (invocation.memberName == #getContext) {
        return _reply(
          invocation,
          ChatMessageContextInfo(
            before: const [],
            message: contextMessage!,
            after: const [],
          ),
        );
      }
      if (invocation.memberName == #pin || invocation.memberName == #unpin) {
        final pinning = invocation.memberName == #pin;
        contextMessage = contextMessage!.copyWith(
          pin: pinning
              ? const ChatPinInfo(
                  pinnedByUserId: 'me',
                  pinnedByUsername: 'Me',
                  note: '',
                  pinnedAt: 1,
                )
              : null,
          clearPin: !pinning,
        );
        return Future.value(
          ChatPinEventInfo(
            eventId: 'pin',
            roomId: 'room',
            kind: pinning
                ? client.ChatPinEventKind.CHAT_PIN_EVENT_KIND_PINNED
                : client.ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED,
            message: contextMessage!,
            pin: contextMessage!.pin,
            occurredAt: 1,
            sequence: 1,
          ),
        );
      }
    }
    if (invocation.memberName == #updateRoomSettings) {
      savedSettings.add(
        invocation.positionalArguments[1] as SyncTvRoomSettings,
      );
    }
    if (invocation.memberName == #search) searches.add(invocation);
    if (invocation.memberName == #listMediaLibrary) {
      mediaRequests.add(invocation);
      if (moveDialogMedia) {
        return Future.value(
          RoomMediaLibraryPage(
            playlists: [],
            media: [
              RoomMediaItem(
                id: 'med_test',
                name: 'Movable media',
                url: 'https://example.com/video.mp4',
              ),
            ],
            dynamicItems: [],
            currentPath: [],
            total: 1,
            playlistCount: 0,
            fileCount: 1,
            version: '',
            usesCursor: false,
            nextCursor: '',
            page: 1,
            supportsSearch: true,
          ),
        );
      }
      if (immediateMedia) return Future.value(_media('initial playlist'));
    }
    return switch (invocation.memberName) {
      #listPlaylistsPage => _reply(
        invocation,
        RoomPlaylistsPage(
          playlists: [RoomPlaylistItem(id: 'pl_target', name: 'Move target')],
          total: 1,
          page: 1,
          pageSize: 100,
        ),
      ),
      #listAvailableProviderInstances => Future.value([
        'Local instance',
        'Local instance (Default)',
      ]),
      #resetRoomSettings || #updateRoomPassword || #updateRoomSettings =>
        _reply<void>(invocation, null, firstImmediate: false),
      #getRoomSettings => _reply(
        invocation,
        SyncTvRoomSettings(),
        firstImmediate: false,
      ),
      #getRoomInfo => Future.value(
        SyncTvRoom(
          roomId: 'room',
          roomName: 'Test room',
          creatorId: 'me',
          needPassword: passwordEnabled,
        ),
      ),
      #getRoomMemberDetailsPage => _reply(invocation, _members('initial')),
      #listRoomStreamsPage => _reply(invocation, _streams('initial')),
      #listRoomJoinReviewsPage => _reply(invocation, _reviews('initial')),
      #getHistory => _reply(
        invocation,
        const ChatHistoryPage(messages: [], nextCursor: ''),
      ),
      #search => _reply(
        invocation,
        const ChatSearchPage(messages: [], nextCursor: ''),
        firstImmediate: false,
      ),
      #listMediaLibrary => _reply(invocation, _media('initial playlist')),
      _ => super.noSuchMethod(invocation),
    };
  }
}

RoomMediaLibraryPage _media(String label) => RoomMediaLibraryPage(
  playlists: [RoomPlaylistItem(id: 'pl_test', name: label)],
  media: [],
  dynamicItems: [],
  currentPath: [],
  total: 1,
  playlistCount: 1,
  fileCount: 0,
  version: label,
  usesCursor: false,
  nextCursor: '',
  page: 1,
  supportsSearch: true,
);

RoomMembersPage _members(String label) => RoomMembersPage(
  members: [
    AdminRoomMember(
      roomId: 'room',
      userId: label,
      username: label,
      role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
      permissions: 0,
      addedPermissions: 0,
      removedPermissions: 0,
      adminAddedPermissions: 0,
      adminRemovedPermissions: 0,
      joinedAt: 0,
      isOnline: false,
    ),
  ],
  total: 1,
  page: 1,
  pageSize: 50,
  version: '',
);

RoomStreamsPage _streams(String label) => RoomStreamsPage(
  streams: [RoomStreamEntryInfo(mediaId: label, active: true)],
  total: 1,
  page: 1,
  pageSize: 50,
);

RoomJoinReviewsPage _reviews(String label) => RoomJoinReviewsPage(
  reviews: [
    RoomJoinReviewInfo(
      id: label,
      roomId: 'room',
      userId: label,
      username: label,
      requestedRole: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
      status: common.ReviewStatus.REVIEW_STATUS_PENDING,
      requestedAt: 0,
      reviewedAt: 0,
      reviewedBy: '',
      rejectionReason: '',
    ),
  ],
  total: 1,
  page: 1,
  pageSize: 50,
);

RoomChatMessageInfo _message(String label) => RoomChatMessageInfo(
  id: label,
  roomId: 'room',
  userId: 'user',
  username: 'Test user',
  content: label,
  timestamp: 1,
);
