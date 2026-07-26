import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/contracts/chat_message_selection.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

abstract interface class RoomChatGateway {
  Future<ChatHistoryPage> getHistory(
    String roomId, {
    int limit = 50,
    String cursor = '',
    List<client.ChatMessageType> includeMessageTypes = chatTimelineMessageTypes,
  });

  Future<ChatSearchPage> search(
    String roomId, {
    required String query,
    int limit = 50,
    String cursor = '',
    bool includeDeleted = false,
    String userId = '',
  });

  Future<StoredImageInfo> uploadImage(String roomId, LocalImageUpload upload);

  Future<RoomChatMessageInfo> send(
    String roomId, {
    String content = '',
    List<StoredImageInfo> images = const [],
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    List<ChatMentionInfo> mentions = const [],
  });

  Future<List<ChatPinnedMessageInfo>> listPinned(
    String roomId, {
    int limit = 50,
  });

  Future<ChatPinEventInfo> pin(
    String roomId,
    String messageId, {
    String note = '',
  });

  Future<ChatPinEventInfo> unpin(String roomId, String messageId);

  Future<RoomChatMessageInfo> edit(
    String roomId,
    String messageId, {
    required String content,
    required int expectedVersion,
  });

  Future<RoomChatMessageInfo> delete(
    String roomId,
    String messageId, {
    required int expectedVersion,
    String reason = '',
  });

  Future<RoomChatMessageInfo> setReaction(
    String roomId,
    String messageId,
    String reactionKey, {
    required bool enabled,
  });

  Future<String> reportMessage(
    String roomId,
    String messageId, {
    required String reasonCode,
    String reason = '',
  });

  Future<String> reportRoom(
    String roomId, {
    required String reasonCode,
    String reason = '',
  });

  Future<String> reportUser(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  });

  Future<String> reportMember(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  });

  Future<RoomChatMessageInfo> getMessage(
    String roomId,
    String messageId, {
    bool includeDeleted = false,
  });

  Future<ChatReactionUsersPage> listReactionUsers(
    String roomId,
    String messageId,
    String reactionKey, {
    int limit = 50,
    String cursor = '',
  });

  Future<ChatMessageContextInfo> getContext(
    String roomId,
    String messageId, {
    int beforeLimit = 20,
    int afterLimit = 20,
    bool includeDeleted = false,
  });

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
  });

  Future<ChatReadStateInfo> markRead(String roomId, String messageId);

  Future<ChatReadStateInfo> getReadState(String roomId);

  Future<ChatMessageReadReceiptsInfo> getReadReceipts(
    String roomId,
    String messageId, {
    int page = 1,
    int pageSize = 50,
  });
}
