import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

class RtmpPublishKeyInfo {
  final String publishKey;
  final String rtmpUrl;
  final String streamKey;
  final String whipUrl;
  final int? expiresAt;
  final client_enum.PublishKeyType keyType;

  const RtmpPublishKeyInfo({
    required this.publishKey,
    required this.rtmpUrl,
    required this.streamKey,
    this.whipUrl = '',
    required this.expiresAt,
    required this.keyType,
  });
}

class RoomMediaLibraryPage {
  final List<RoomPlaylistItem> playlists;
  final List<RoomMediaItem> media;
  final List<RoomDynamicMediaEntry> dynamicItems;
  final List<PlaylistBrowsePathInfo> currentPath;
  final int? total;
  final int playlistCount;
  final int fileCount;
  final String version;
  final bool usesCursor;
  final String nextCursor;
  final int page;
  final bool supportsSearch;

  const RoomMediaLibraryPage({
    required this.playlists,
    required this.media,
    required this.dynamicItems,
    required this.currentPath,
    required this.total,
    required this.playlistCount,
    required this.fileCount,
    required this.version,
    required this.usesCursor,
    required this.nextCursor,
    required this.page,
    required this.supportsSearch,
  });

  List<RoomMediaEntry> get entries => [...playlists, ...media, ...dynamicItems];

  bool hasNextPage(int pageSize) {
    if (usesCursor) return nextCursor.isNotEmpty;
    if (total case final total?) return page * pageSize < total;
    return entries.length >= pageSize;
  }

  int get effectivePlaylistCount =>
      playlistCount + dynamicItems.where((item) => item.isPlaylist).length;

  int get effectiveFileCount =>
      fileCount + dynamicItems.where((item) => !item.isPlaylist).length;
}

class RoomPlaylistsPage {
  final List<RoomPlaylistItem> playlists;
  final int total;
  final int page;
  final int pageSize;

  const RoomPlaylistsPage({
    required this.playlists,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class PlaylistBrowsePathInfo {
  final String playlistId;
  final String name;
  final String target;

  const PlaylistBrowsePathInfo({
    required this.playlistId,
    required this.name,
    required this.target,
  });
}

class PlaylistDetailInfo {
  final RoomPlaylistItem playlist;
  final int childPlaylistCount;
  final int mediaCount;

  const PlaylistDetailInfo({
    required this.playlist,
    required this.childPlaylistCount,
    required this.mediaCount,
  });
}

class StoredImageInfo {
  final String id;
  final bool uploadReference;
  final String storageBackend;
  final String objectKey;
  final String url;
  final String mimeType;
  final int sizeBytes;
  final int width;
  final int height;
  final List<int> metadata;

  const StoredImageInfo({
    required this.id,
    this.uploadReference = false,
    required this.storageBackend,
    required this.objectKey,
    required this.url,
    required this.mimeType,
    required this.sizeBytes,
    required this.width,
    required this.height,
    this.metadata = const [],
  });
}

class ChatHistoryPage {
  final List<RoomChatMessageInfo> messages;
  final String nextCursor;
  final String eventCursor;

  const ChatHistoryPage({
    required this.messages,
    required this.nextCursor,
    this.eventCursor = '',
  });
}

class ChatSearchPage {
  final List<RoomChatMessageInfo> messages;
  final String nextCursor;
  final String eventCursor;

  const ChatSearchPage({
    required this.messages,
    required this.nextCursor,
    this.eventCursor = '',
  });
}

class ChatMessageContextInfo {
  const ChatMessageContextInfo({
    required this.before,
    required this.message,
    required this.after,
  });

  final List<RoomChatMessageInfo> before;
  final RoomChatMessageInfo message;
  final List<RoomChatMessageInfo> after;
}

class ChatReadStateInfo {
  const ChatReadStateInfo({
    required this.roomId,
    required this.userId,
    required this.lastReadMessageId,
    required this.lastReadEventId,
    required this.lastReadEventSequence,
    required this.updatedAt,
    required this.unreadCount,
  });

  final String roomId;
  final String userId;
  final String lastReadMessageId;
  final String lastReadEventId;
  final int lastReadEventSequence;
  final int updatedAt;
  final int unreadCount;
}

class ChatReactionSummaryInfo {
  const ChatReactionSummaryInfo({
    required this.key,
    required this.count,
    required this.reactedByMe,
  });

  final String key;
  final int count;
  final bool reactedByMe;
}

class ChatReactionUserInfo {
  const ChatReactionUserInfo({
    required this.userId,
    required this.username,
    required this.reactedAt,
  });

  final String userId;
  final String username;
  final int reactedAt;
}

class ChatReactionUsersPage {
  const ChatReactionUsersPage({
    required this.users,
    required this.nextCursor,
    required this.total,
  });

  final List<ChatReactionUserInfo> users;
  final String nextCursor;
  final int total;
}

class ChatReadReceiptUserInfo {
  const ChatReadReceiptUserInfo({required this.user, required this.readAt});

  final SyncTvUser user;
  final int readAt;
}

class ChatMessageReadReceiptsInfo {
  const ChatMessageReadReceiptsInfo({
    required this.readers,
    required this.unreadMembers,
    required this.readerTotal,
    required this.unreadTotal,
  });

  final List<ChatReadReceiptUserInfo> readers;
  final List<SyncTvUser> unreadMembers;
  final int readerTotal;
  final int unreadTotal;
}

class ChatPinInfo {
  const ChatPinInfo({
    required this.pinnedByUserId,
    required this.pinnedByUsername,
    required this.note,
    required this.pinnedAt,
  });

  final String pinnedByUserId;
  final String pinnedByUsername;
  final String note;
  final int pinnedAt;
}

class ChatPinnedMessageInfo {
  const ChatPinnedMessageInfo({required this.message, required this.pin});

  final RoomChatMessageInfo message;
  final ChatPinInfo pin;
}

class ChatPinEventInfo {
  const ChatPinEventInfo({
    required this.eventId,
    required this.roomId,
    required this.kind,
    required this.message,
    this.pin,
    required this.occurredAt,
    required this.sequence,
  });

  final String eventId;
  final String roomId;
  final client_enum.ChatPinEventKind kind;
  final RoomChatMessageInfo message;
  final ChatPinInfo? pin;
  final int occurredAt;
  final int sequence;
}

class RoomChatMessageInfo {
  final String id;
  final String roomId;
  final String userId;
  final String? username;
  final String content;
  final int timestamp;
  final client_enum.ChatMessageType messageType;
  final String displayPosition;
  final String displayColor;
  final int version;
  final int editedAt;
  final int deletedAt;
  final client_enum.ChatMessageStatus status;
  final String replyToMessageId;
  final List<StoredImageInfo> images;
  final List<ChatReactionSummaryInfo> reactions;
  final int reactionCount;
  final List<ChatMentionInfo> mentions;
  final ChatPinInfo? pin;

  const RoomChatMessageInfo({
    required this.id,
    required this.roomId,
    required this.userId,
    this.username,
    required this.content,
    required this.timestamp,
    this.messageType = client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
    this.displayPosition = '',
    this.displayColor = '',
    this.version = 0,
    this.editedAt = 0,
    this.deletedAt = 0,
    this.status = client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_UNSPECIFIED,
    this.replyToMessageId = '',
    this.images = const [],
    this.reactions = const [],
    this.reactionCount = 0,
    this.mentions = const [],
    this.pin,
  });

  double? get position => double.tryParse(displayPosition);
  String? get color => displayColor.isEmpty ? null : displayColor;
  bool get isDeleted =>
      deletedAt > 0 ||
      status == client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_DELETED;
  bool get isEdited =>
      editedAt > 0 ||
      status == client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_EDITED;
  bool get isPinned => pin != null;
  bool get isUserMessage =>
      messageType == client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER;
  bool get isSystemMessage => !isUserMessage;
  bool canEditBy(String currentUserId) =>
      currentUserId.isNotEmpty &&
      userId == currentUserId &&
      isUserMessage &&
      !isDeleted;

  RoomChatMessageInfo copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? username,
    String? content,
    int? timestamp,
    client_enum.ChatMessageType? messageType,
    String? displayPosition,
    String? displayColor,
    int? version,
    int? editedAt,
    int? deletedAt,
    client_enum.ChatMessageStatus? status,
    String? replyToMessageId,
    List<StoredImageInfo>? images,
    List<ChatReactionSummaryInfo>? reactions,
    int? reactionCount,
    List<ChatMentionInfo>? mentions,
    ChatPinInfo? pin,
    bool clearPin = false,
  }) {
    return RoomChatMessageInfo(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      displayPosition: displayPosition ?? this.displayPosition,
      displayColor: displayColor ?? this.displayColor,
      version: version ?? this.version,
      editedAt: editedAt ?? this.editedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      status: status ?? this.status,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      images: images ?? this.images,
      reactions: reactions ?? this.reactions,
      reactionCount: reactionCount ?? this.reactionCount,
      mentions: mentions ?? this.mentions,
      pin: clearPin ? null : pin ?? this.pin,
    );
  }
}

class ChatMentionInfo {
  final String userId;
  final String username;
  final int start;
  final int length;

  const ChatMentionInfo({
    required this.userId,
    required this.username,
    required this.start,
    required this.length,
  });
}
