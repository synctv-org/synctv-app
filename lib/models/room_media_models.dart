import 'package:synctv_app/models/watch_together_models.dart';

class RtmpPublishKeyInfo {
  final String publishKey;
  final String rtmpUrl;
  final String streamKey;
  final int expiresAt;

  const RtmpPublishKeyInfo({
    required this.publishKey,
    required this.rtmpUrl,
    required this.streamKey,
    required this.expiresAt,
  });
}

class RoomMediaLibraryPage {
  final List<WMovie> playlists;
  final List<WMovie> media;
  final List<WMovie> dynamicItems;
  final List<PlaylistBrowsePathInfo> currentPath;
  final int total;
  final int folderCount;
  final int fileCount;
  final String version;

  const RoomMediaLibraryPage({
    required this.playlists,
    required this.media,
    required this.dynamicItems,
    required this.currentPath,
    required this.total,
    required this.folderCount,
    required this.fileCount,
    required this.version,
  });

  List<WMovie> get entries => [...playlists, ...media, ...dynamicItems];
}

class RoomPlaylistsPage {
  final List<WMovie> playlists;
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
  final WMovie playlist;
  final int childFolderCount;
  final int mediaCount;

  const PlaylistDetailInfo({
    required this.playlist,
    required this.childFolderCount,
    required this.mediaCount,
  });
}

class StoredImageInfo {
  final String id;
  final String storageBackend;
  final String objectKey;
  final String url;
  final String mimeType;
  final int sizeBytes;
  final int width;
  final int height;

  const StoredImageInfo({
    required this.id,
    required this.storageBackend,
    required this.objectKey,
    required this.url,
    required this.mimeType,
    required this.sizeBytes,
    required this.width,
    required this.height,
  });
}

class ChatHistoryPage {
  final List<RoomChatMessageInfo> messages;
  final String nextCursor;

  const ChatHistoryPage({
    required this.messages,
    required this.nextCursor,
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

class RoomChatMessageInfo {
  final String id;
  final String roomId;
  final String userId;
  final String username;
  final String content;
  final int timestamp;
  final String displayPosition;
  final String displayColor;
  final int version;
  final int editedAt;
  final int deletedAt;
  final int status;
  final List<StoredImageInfo> images;

  const RoomChatMessageInfo({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.username,
    required this.content,
    required this.timestamp,
    this.displayPosition = '',
    this.displayColor = '',
    this.version = 0,
    this.editedAt = 0,
    this.deletedAt = 0,
    this.status = 0,
    this.images = const [],
  });

  double? get position => double.tryParse(displayPosition);
  String? get color => displayColor.isEmpty ? null : displayColor;
  bool get isDeleted => deletedAt > 0 || status == 3;
  bool get isEdited => editedAt > 0 || status == 2;
}
