import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/features/room/application/room_chat_gateway.dart';
import 'package:synctv_app/contracts/chat_message_selection.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

final class SyncTvRoomChatGateway implements RoomChatGateway {
  const SyncTvRoomChatGateway();

  @override
  Future<ChatHistoryPage> getHistory(
    String roomId, {
    int limit = 50,
    String cursor = '',
    List<client.ChatMessageType> includeMessageTypes = chatTimelineMessageTypes,
  }) => SyncTvService.getChatHistory(
    roomId,
    limit: limit,
    cursor: cursor,
    includeMessageTypes: includeMessageTypes,
  );

  @override
  Future<ChatSearchPage> search(
    String roomId, {
    required String query,
    int limit = 50,
    String cursor = '',
    bool includeDeleted = false,
    String userId = '',
  }) => SyncTvService.searchChatMessages(
    roomId,
    query: query,
    limit: limit,
    cursor: cursor,
    includeDeleted: includeDeleted,
    userId: userId,
  );

  @override
  Future<StoredImageInfo> uploadImage(String roomId, LocalImageUpload upload) =>
      SyncTvService.uploadChatImage(roomId, upload);

  @override
  Future<RoomChatMessageInfo> send(
    String roomId, {
    String content = '',
    List<StoredImageInfo> images = const [],
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    List<ChatMentionInfo> mentions = const [],
  }) => SyncTvService.sendChatMessage(
    roomId,
    content: content,
    images: images,
    displayPosition: displayPosition,
    displayColor: displayColor,
    replyToMessageId: replyToMessageId,
    mentions: mentions,
  );

  @override
  Future<List<ChatPinnedMessageInfo>> listPinned(
    String roomId, {
    int limit = 50,
  }) => SyncTvService.listPinnedChatMessages(roomId, limit: limit);

  @override
  Future<ChatPinEventInfo> pin(
    String roomId,
    String messageId, {
    String note = '',
  }) => SyncTvService.pinChatMessage(roomId, messageId, note: note);

  @override
  Future<ChatPinEventInfo> unpin(String roomId, String messageId) =>
      SyncTvService.unpinChatMessage(roomId, messageId);

  @override
  Future<RoomChatMessageInfo> edit(
    String roomId,
    String messageId, {
    required String content,
    required int expectedVersion,
  }) => SyncTvService.editChatMessage(
    roomId,
    messageId,
    content: content,
    expectedVersion: expectedVersion,
  );

  @override
  Future<RoomChatMessageInfo> delete(
    String roomId,
    String messageId, {
    required int expectedVersion,
    String reason = '',
  }) => SyncTvService.deleteChatMessage(
    roomId,
    messageId,
    expectedVersion: expectedVersion,
    reason: reason,
  );

  @override
  Future<RoomChatMessageInfo> setReaction(
    String roomId,
    String messageId,
    String reactionKey, {
    required bool enabled,
  }) => SyncTvService.setChatReaction(
    roomId,
    messageId,
    reactionKey,
    enabled: enabled,
  );

  @override
  Future<String> reportMessage(
    String roomId,
    String messageId, {
    required String reasonCode,
    String reason = '',
  }) => SyncTvService.reportChatMessage(
    roomId,
    messageId,
    reasonCode: reasonCode,
    reason: reason,
  );

  @override
  Future<String> reportRoom(
    String roomId, {
    required String reasonCode,
    String reason = '',
  }) =>
      SyncTvService.reportRoom(roomId, reasonCode: reasonCode, reason: reason);

  @override
  Future<String> reportUser(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  }) => SyncTvService.reportUser(
    roomId,
    userId,
    reasonCode: reasonCode,
    reason: reason,
  );

  @override
  Future<String> reportMember(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  }) => SyncTvService.reportRoomMember(
    roomId,
    userId,
    reasonCode: reasonCode,
    reason: reason,
  );

  @override
  Future<RoomChatMessageInfo> getMessage(
    String roomId,
    String messageId, {
    bool includeDeleted = false,
  }) => SyncTvService.getChatMessage(
    roomId,
    messageId,
    includeDeleted: includeDeleted,
  );

  @override
  Future<ChatReactionUsersPage> listReactionUsers(
    String roomId,
    String messageId,
    String reactionKey, {
    int limit = 50,
    String cursor = '',
  }) => SyncTvService.listChatReactionUsers(
    roomId,
    messageId,
    reactionKey,
    limit: limit,
    cursor: cursor,
  );

  @override
  Future<ChatMessageContextInfo> getContext(
    String roomId,
    String messageId, {
    int beforeLimit = 20,
    int afterLimit = 20,
    bool includeDeleted = false,
  }) => SyncTvService.getChatMessageContext(
    roomId,
    messageId,
    beforeLimit: beforeLimit,
    afterLimit: afterLimit,
    includeDeleted: includeDeleted,
  );

  @override
  Future<List<RoomChatMessageInfo>> getPlaybackMessages(
    String roomId, {
    String playbackMediaId = '',
    String playbackPlaylistId = '',
    List<int> playbackTarget = const [],
    double positionSeconds = 0,
    double beforeSeconds = 30,
    double afterSeconds = 30,
    int limit = 50,
    bool includeDeleted = false,
    List<client.ChatMessageType> includeMessageTypes = const [],
  }) => SyncTvService.getChatPlaybackMessages(
    roomId,
    playbackMediaId: playbackMediaId,
    playbackPlaylistId: playbackPlaylistId,
    playbackTarget: playbackTarget,
    positionSeconds: positionSeconds,
    beforeSeconds: beforeSeconds,
    afterSeconds: afterSeconds,
    limit: limit,
    includeDeleted: includeDeleted,
    includeMessageTypes: includeMessageTypes,
  );

  @override
  Future<ChatReadStateInfo> markRead(String roomId, String messageId) =>
      SyncTvService.markChatRead(roomId, messageId);

  @override
  Future<ChatReadStateInfo> getReadState(String roomId) =>
      SyncTvService.getChatReadState(roomId);

  @override
  Future<ChatMessageReadReceiptsInfo> getReadReceipts(
    String roomId,
    String messageId, {
    int page = 1,
    int pageSize = 50,
  }) => SyncTvService.getChatMessageReadReceipts(
    roomId,
    messageId,
    page: page,
    pageSize: pageSize,
  );
}
