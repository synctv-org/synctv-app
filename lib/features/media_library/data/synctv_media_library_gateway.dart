import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/features/media_library/application/media_library_gateway.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

final class SyncTvMediaLibraryGateway implements MediaLibraryGateway {
  const SyncTvMediaLibraryGateway();

  @override
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
  }) => SyncTvService.listMediaLibrary(
    roomId,
    page: page,
    cursor: cursor,
    pageSize: pageSize,
    playlistId: playlistId,
    target: target,
    search: search,
    sourceProvider: sourceProvider,
    previewSourceConfig: previewSourceConfig,
    typedPreviewSourceConfig: typedPreviewSourceConfig,
    providerInstanceName: providerInstanceName,
    sortBy: sortBy,
    sortDirection: sortDirection,
    availability: availability,
    refresh: refresh,
  );
  @override
  Future<PlaylistDetailInfo> getPlaylist(String roomId, String playlistId) =>
      SyncTvService.getPlaylist(roomId, playlistId);
  @override
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
  }) => SyncTvService.listPlaylistsPage(
    roomId,
    parentId: parentId,
    page: page,
    pageSize: pageSize,
    search: search,
    sourceProvider: sourceProvider,
    providerInstanceName: providerInstanceName,
    dynamicOnly: dynamicOnly,
    sortBy: sortBy,
    sortDirection: sortDirection,
    availability: availability,
  );
  @override
  Future<RoomPlaylistItem> createPlaylist(
    String roomId, {
    required String name,
    String parentId = '',
    String description = '',
    client.PlaylistBrowseAccessMode browseAccessMode =
        client.PlaylistBrowseAccessMode.PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
  }) => SyncTvService.createPlaylist(
    roomId,
    name: name,
    parentId: parentId,
    description: description,
    browseAccessMode: browseAccessMode,
  );
  @override
  Future<RoomPlaylistItem> updatePlaylist(
    String roomId,
    String playlistId, {
    required String name,
    String? description,
    source.PlaylistSourceConfig? sourceConfig,
    client.PlaylistBrowseAccessMode? browseAccessMode,
  }) => SyncTvService.updatePlaylist(
    roomId,
    playlistId,
    name: name,
    description: description,
    sourceConfig: sourceConfig,
    browseAccessMode: browseAccessMode,
  );
  @override
  Future<RoomPlaylistItem> updatePlaylistCover(
    String roomId,
    String playlistId,
    LocalImageUpload upload,
  ) => SyncTvService.updatePlaylistCover(roomId, playlistId, upload);
  @override
  Future<RoomPlaylistItem> clearPlaylistCover(
    String roomId,
    String playlistId,
  ) => SyncTvService.clearPlaylistCover(roomId, playlistId);
  @override
  Future<RoomPlaylistItem> movePlaylist(
    String roomId,
    String playlistId, {
    String? beforePlaylistId,
    String? afterPlaylistId,
  }) => SyncTvService.movePlaylist(
    roomId,
    playlistId,
    beforePlaylistId: beforePlaylistId,
    afterPlaylistId: afterPlaylistId,
  );
  @override
  Future<void> deletePlaylist(
    String roomId,
    String playlistId, {
    bool force = false,
  }) => SyncTvService.deletePlaylist(roomId, playlistId, force: force);
  @override
  Future<RoomMediaItem> editMedia(
    String roomId,
    String mediaId, {
    required String name,
    String? description,
    source_enum.PlaybackProxyMode? playbackProxyMode,
  }) => SyncTvService.editMedia(
    roomId,
    mediaId,
    name: name,
    description: description,
    playbackProxyMode: playbackProxyMode,
  );
  @override
  Future<RoomMediaItem> updateVideoCover(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  ) => SyncTvService.updateVideoCover(roomId, mediaId, upload);
  @override
  Future<RoomMediaItem> clearVideoCover(String roomId, String mediaId) =>
      SyncTvService.clearVideoCover(roomId, mediaId);
  @override
  Future<RoomMediaItem> updateVideoThumbnail(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  ) => SyncTvService.updateVideoThumbnail(roomId, mediaId, upload);
  @override
  Future<RoomMediaItem> clearVideoThumbnail(String roomId, String mediaId) =>
      SyncTvService.clearVideoThumbnail(roomId, mediaId);
  @override
  Future<RoomMediaItem> getMedia(String roomId, String mediaId) =>
      SyncTvService.getMedia(roomId, mediaId);
  @override
  Future<int> moveMedia(
    String roomId, {
    List<String> mediaIds = const [],
    String? sourcePlaylistId,
    String? targetPlaylistId,
    bool allFromScope = false,
    String? beforeMediaId,
    String? afterMediaId,
  }) => SyncTvService.moveMedia(
    roomId,
    mediaIds: mediaIds,
    sourcePlaylistId: sourcePlaylistId,
    targetPlaylistId: targetPlaylistId,
    allFromScope: allFromScope,
    beforeMediaId: beforeMediaId,
    afterMediaId: afterMediaId,
  );
  @override
  Future<void> deleteMedia(String roomId, String mediaId) =>
      SyncTvService.deleteMedia(roomId, mediaId);
  @override
  Future<void> deleteMediaLibraryEntries(
    String roomId, {
    List<String> mediaIds = const [],
    List<String> playlistIds = const [],
  }) => SyncTvService.deleteMediaLibraryEntries(
    roomId,
    mediaIds: mediaIds,
    playlistIds: playlistIds,
  );
  @override
  Future<void> clearMediaLibrary(String roomId, {String? parentId}) =>
      SyncTvService.clearMediaLibrary(roomId, parentId: parentId);
  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) =>
      SyncTvService.listAvailableProviderInstances(providerType: providerType);
}
