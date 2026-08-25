import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/contracts/chat_message_selection.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

import '../../../test_app.dart';

void main() {
  testWidgets('failed moderation submission restores optimistic messages', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final gateway = _ChatModerationAdminGateway();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => DependencyScope<AdminGateway>(
          value: gateway,
          child: buildThemedTestApp(context, child),
        ),
        home: const Scaffold(body: RoomManagementTab()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(byAppTooltip('Chat history'));
    await tester.pumpAndSettle();
    expect(find.text('message body'), findsOneWidget);

    await tester.tap(find.widgetWithText(AppActionButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppActionButton, 'Delete').last);
    await tester.pumpAndSettle();

    expect(find.text('This message was deleted'), findsOneWidget);
    expect(find.text('message body'), findsNothing);

    gateway.submission.completeError(StateError('queue unavailable'));
    await tester.pumpAndSettle();

    expect(find.text('message body'), findsOneWidget);
    expect(find.text('This message was deleted'), findsNothing);
    expect(gateway.moderationCalls, 1);
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });
}

final class _ChatModerationAdminGateway implements AdminGateway {
  final Completer<void> submission = Completer<void>();
  int moderationCalls = 0;

  @override
  Future<List<RoomCategoryInfo>> adminListRoomCategories({
    bool includeDisabled = false,
    bool refresh = false,
  }) async => const [];

  @override
  Future<List<RoomLabelInfo>> adminListRoomLabels({
    bool includeDisabled = false,
    String categoryId = '',
    bool refresh = false,
  }) async => const [];

  @override
  Future<AdminRoomsPage> adminListRoomsPage({
    int page = 1,
    int pageSize = 20,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
    common_enum.RoomStatus status =
        common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
    bool? isBanned,
    admin_enum.RoomListSortBy sortBy =
        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    return AdminRoomsPage(
      rooms: [
        SyncTvRoom(
          roomId: 'room_test',
          roomName: 'Test room',
          creatorId: 'usr_owner',
        ),
      ],
      total: 1,
    );
  }

  @override
  Future<ChatHistoryPage> getChatHistory(
    String roomId, {
    int limit = 50,
    String cursor = '',
    List<client_enum.ChatMessageType> includeMessageTypes =
        chatTimelineMessageTypes,
  }) async {
    return const ChatHistoryPage(
      messages: [
        RoomChatMessageInfo(
          id: '10',
          roomId: 'room_test',
          userId: 'usr_target',
          username: 'target',
          content: 'message body',
          timestamp: 1,
          version: 4,
        ),
      ],
      nextCursor: '',
    );
  }

  @override
  Future<void> adminModerateRoomChatUser(
    String roomId,
    String userId, {
    required bool deleteAllMessages,
    required bool deleteAllReactions,
    required bool ban,
    String messageId = '',
    String reason = '',
  }) {
    moderationCalls++;
    return submission.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
