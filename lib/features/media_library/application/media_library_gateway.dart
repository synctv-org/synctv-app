import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

abstract interface class MediaLibraryGateway {
  Future<RoomMediaLibraryPage> listMediaLibrary(
    String roomId, {
    int page = 1,
    String? cursor,
    int pageSize = 50,
    String playlistId = '',
    String? target,
    String search = '',
    source_enum.SourceProvider sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    Map<String, dynamic>? previewSourceConfig,
    source.PlaylistSourceConfig? typedPreviewSourceConfig,
    String providerInstanceName = '',
    client.MediaListSortBy sortBy =
        client.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
    client.SortDirection sortDirection =
        client.SortDirection.SORT_DIRECTION_ASC,
    client.ResourceAvailabilityFilter availability =
        client.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
    bool refresh = false,
  });
  Future<PlaylistDetailInfo> getPlaylist(String roomId, String playlistId);
  Future<RoomPlaylistsPage> listPlaylistsPage(
    String roomId, {
    String parentId = '',
    int page = 1,
    int pageSize = 100,
    String? search,
    source_enum.SourceProvider sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    String providerInstanceName = '',
    bool? dynamicOnly,
    client.PlaylistListSortBy sortBy =
        client.PlaylistListSortBy.PLAYLIST_LIST_SORT_BY_POSITION,
    client.SortDirection sortDirection =
        client.SortDirection.SORT_DIRECTION_ASC,
    client.ResourceAvailabilityFilter availability =
        client.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
  });
  Future<RoomPlaylistItem> createPlaylist(
    String roomId, {
    required String name,
    String parentId = '',
    String description = '',
    client.PlaylistBrowseAccessMode browseAccessMode =
        client.PlaylistBrowseAccessMode.PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
  });
  Future<RoomPlaylistItem> updatePlaylist(
    String roomId,
    String playlistId, {
    required String name,
    String? description,
    source.PlaylistSourceConfig? sourceConfig,
    client.PlaylistBrowseAccessMode? browseAccessMode,
  });
  Future<RoomPlaylistItem> updatePlaylistCover(
    String roomId,
    String playlistId,
    LocalImageUpload upload,
  );
  Future<RoomPlaylistItem> clearPlaylistCover(String roomId, String playlistId);
  Future<RoomPlaylistItem> movePlaylist(
    String roomId,
    String playlistId, {
    String? beforePlaylistId,
    String? afterPlaylistId,
  });
  Future<void> deletePlaylist(
    String roomId,
    String playlistId, {
    bool force = false,
  });
  Future<RoomMediaItem> editMedia(
    String roomId,
    String mediaId, {
    required String name,
    String? description,
    source_enum.PlaybackProxyMode? playbackProxyMode,
  });
  Future<RoomMediaItem> updateVideoCover(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  );
  Future<RoomMediaItem> clearVideoCover(String roomId, String mediaId);
  Future<RoomMediaItem> updateVideoThumbnail(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  );
  Future<RoomMediaItem> clearVideoThumbnail(String roomId, String mediaId);
  Future<RoomMediaItem> getMedia(String roomId, String mediaId);
  Future<int> moveMedia(
    String roomId, {
    List<String> mediaIds = const [],
    String? sourcePlaylistId,
    String? targetPlaylistId,
    bool allFromScope = false,
    String? beforeMediaId,
    String? afterMediaId,
  });
  Future<void> deleteMedia(String roomId, String mediaId);
  Future<void> deleteMediaLibraryEntries(
    String roomId, {
    List<String> mediaIds = const [],
    List<String> playlistIds = const [],
  });
  Future<void> clearMediaLibrary(String roomId, {String? parentId});
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  });
}
