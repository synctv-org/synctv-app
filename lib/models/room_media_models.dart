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

class ChatHistoryPage {
  final List<RoomChatMessageInfo> messages;
  final String nextCursor;

  const ChatHistoryPage({
    required this.messages,
    required this.nextCursor,
  });
}

class RoomChatMessageInfo {
  final String id;
  final String roomId;
  final String userId;
  final String username;
  final String content;
  final int timestamp;
  final double? position;
  final String? color;

  const RoomChatMessageInfo({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.username,
    required this.content,
    required this.timestamp,
    this.position,
    this.color,
  });
}
