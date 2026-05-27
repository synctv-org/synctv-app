import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/room_media_models.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/providers/rtmp.pb.dart' as rtmp;

class SyncTvRoomMediaDomainService {
  SyncTvRoomMediaDomainService(this._api);

  final SyncTvApiClient _api;

  Future<WPlaybackStatus> getCurrentMovie(String roomId) async {
    final response = await _api.room.getPlayback(
      roomId,
      client.GetPlaybackRequest(),
    );
    return _api.mapPlayback(response);
  }

  Stream<RoomResourceWatchEvent<WPlaybackStatus>> watchPlaybackState(
    String roomId, {
    String version = '',
  }) {
    return _api.room
        .watchPlaybackState(
      roomId,
      client.WatchPlaybackStateRequest(
        options: _watchOptions(version),
      ),
    )
        .map((event) {
      if (event.hasObserved()) {
        return RoomResourceWatchEvent<WPlaybackStatus>.observed(
          version: event.observed.version,
          changed: event.observed.changed,
        );
      }
      if (event.hasError()) {
        return RoomResourceWatchEvent<WPlaybackStatus>.error(
          message: event.error.hasError() ? event.error.error.message : '',
          code: event.error.hasError() ? event.error.error.code : 0,
        );
      }
      return RoomResourceWatchEvent<WPlaybackStatus>.changed(
        version: event.changed.version,
        snapshot: _playbackStatusFromState(event.changed.playbackState),
      );
    });
  }

  Stream<RoomResourceWatchEvent<WPlaybackStatus>> watchPlaybackSnapshot(
    String roomId, {
    String version = '',
    String mediaId = '',
    String playlistId = '',
    String? target,
  }) {
    return _api.room
        .watchPlaybackSnapshot(
      roomId,
      client.WatchPlaybackSnapshotRequest(
        options: _watchOptions(version),
        playbackSnapshot: client.ObservePlaybackSnapshot(
          mediaId: mediaId,
          playlistId: playlistId,
          target: _decodeTarget(target) ?? const [],
        ),
      ),
    )
        .map((event) {
      if (event.hasObserved()) {
        return RoomResourceWatchEvent<WPlaybackStatus>.observed(
          version: event.observed.version,
          changed: event.observed.changed,
        );
      }
      if (event.hasError()) {
        return RoomResourceWatchEvent<WPlaybackStatus>.error(
          message: event.error.hasError() ? event.error.error.message : '',
          code: event.error.hasError() ? event.error.error.code : 0,
        );
      }
      return RoomResourceWatchEvent<WPlaybackStatus>.changed(
        version: event.changed.version,
        snapshot: _playbackStatusFromSnapshot(event.changed.playbackSnapshot),
      );
    });
  }

  Stream<RoomResourceWatchEvent<RoomMediaLibraryPage>> watchPlaylistItems(
    String roomId, {
    String version = '',
    String playlistId = '',
    String? target,
    int page = 1,
    int pageSize = 100,
    String search = '',
    String sourceProvider = '',
    String providerInstanceName = '',
    client_enum.MediaListSortBy sortBy =
        client_enum.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
    client_enum.ResourceAvailabilityFilter availability =
        client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
  }) {
    return _api.room
        .watchPlaylistItems(
      roomId,
      client.WatchPlaylistItemsRequest(
        options: _watchOptions(version),
        request: client.ListPlaylistItemsRequest(
          playlistId: playlistId,
          target: _decodeTarget(target) ?? const [],
          page: page,
          pageSize: pageSize,
          search: search,
          sourceProvider: sourceProvider,
          providerInstanceName: providerInstanceName,
          sortBy: sortBy,
          sortDirection: sortDirection,
          availability: availability,
        ),
      ),
    )
        .map((event) {
      if (event.hasObserved()) {
        return RoomResourceWatchEvent<RoomMediaLibraryPage>.observed(
          version: event.observed.version,
          changed: event.observed.changed,
        );
      }
      if (event.hasError()) {
        return RoomResourceWatchEvent<RoomMediaLibraryPage>.error(
          message: event.error.hasError() ? event.error.error.message : '',
          code: event.error.hasError() ? event.error.error.code : 0,
        );
      }
      return RoomResourceWatchEvent<RoomMediaLibraryPage>.changed(
        version: event.changed.version,
        snapshot: _mediaLibraryPageFromProto(
          event.changed.playlistItems,
          parentId: playlistId,
        ),
      );
    });
  }

  Future<RoomMediaLibraryPage> listMediaLibrary(
    String roomId, {
    int page = 1,
    int pageSize = 50,
    String playlistId = '',
    String? target,
    String search = '',
    String sourceProvider = '',
    String providerInstanceName = '',
    client_enum.MediaListSortBy sortBy =
        client_enum.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
    client_enum.ResourceAvailabilityFilter availability =
        client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
    bool refresh = false,
  }) async {
    final response = await _api.room.listPlaylistItems(
      roomId,
      client.ListPlaylistItemsRequest(
        playlistId: playlistId,
        target: _decodeTarget(target) ?? const [],
        page: page,
        pageSize: pageSize,
        search: search,
        sourceProvider: sourceProvider,
        providerInstanceName: providerInstanceName,
        sortBy: sortBy,
        sortDirection: sortDirection,
        availability: availability,
        refresh: refresh,
      ),
    );
    return _mediaLibraryPageFromProto(response, parentId: playlistId);
  }

  Future<PlaylistDetailInfo> getPlaylist(
    String roomId,
    String playlistId,
  ) async {
    final response = await _api.room.getPlaylist(
      roomId,
      client.GetPlaylistRequest(playlistId: playlistId),
    );
    return PlaylistDetailInfo(
      playlist: _api.mapPlaylist(response.playlist),
      childFolderCount: response.childFolderCount,
      mediaCount: response.mediaCount,
    );
  }

  Future<RoomPlaylistsPage> listPlaylistsPage(
    String roomId, {
    String parentId = '',
    int page = 1,
    int pageSize = 100,
    String? search,
    String sourceProvider = '',
    String providerInstanceName = '',
    bool? dynamicOnly,
    client_enum.PlaylistListSortBy sortBy =
        client_enum.PlaylistListSortBy.PLAYLIST_LIST_SORT_BY_POSITION,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
    client_enum.ResourceAvailabilityFilter availability =
        client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
  }) async {
    final response = await _api.room.listPlaylists(
      roomId,
      client.ListPlaylistsRequest(
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
      ),
    );
    return RoomPlaylistsPage(
      playlists: response.playlists.map(_api.mapPlaylist).toList(),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<WMovie> createPlaylist(
    String roomId, {
    required String name,
    String parentId = '',
    String sourceProvider = '',
    Map<String, dynamic> sourceConfig = const {},
    String providerInstanceName = '',
  }) async {
    final response = await _api.room.createPlaylist(
      roomId,
      client.CreatePlaylistRequest(
        name: name,
        parentId: parentId,
        sourceProvider: sourceProvider,
        sourceConfig: _playlistSourceConfigBytes(
          sourceProvider: sourceProvider,
          providerInstanceName: providerInstanceName,
          sourceConfig: sourceConfig,
        ),
        providerInstanceName: providerInstanceName,
      ),
    );
    return _api.mapPlaylist(response.playlist);
  }

  Future<WMovie> updatePlaylist(
    String roomId,
    String playlistId, {
    required String name,
  }) async {
    final response = await _api.room.updatePlaylist(
      roomId,
      client.UpdatePlaylistRequest(playlistId: playlistId, name: name),
    );
    return _api.mapPlaylist(response.playlist);
  }

  Future<WMovie> movePlaylist(
    String roomId,
    String playlistId, {
    String? beforePlaylistId,
    String? afterPlaylistId,
  }) async {
    final response = await _api.room.movePlaylist(
      roomId,
      client.MovePlaylistRequest(
        playlistId: playlistId,
        beforePlaylistId: beforePlaylistId,
        afterPlaylistId: afterPlaylistId,
      ),
    );
    return _api.mapPlaylist(response.playlist);
  }

  Future<void> deletePlaylist(
    String roomId,
    String playlistId, {
    bool force = false,
  }) async {
    await _api.room.deletePlaylist(
      roomId,
      client.DeletePlaylistRequest(playlistId: playlistId, force: force),
    );
  }

  Future<WMovie> editMedia(
    String roomId,
    String mediaId, {
    required String name,
  }) async {
    final response = await _api.room.editMedia(
      roomId,
      client.EditMediaRequest(mediaId: mediaId, name: name),
    );
    return _api.mapMedia(response.media);
  }

  Future<WMovie> getMedia(String roomId, String mediaId) async {
    final media = await _api.room.getMedia(
      roomId,
      client.GetMediaRequest(mediaId: mediaId),
    );
    return _api.mapMedia(media);
  }

  Future<int> moveMedia(
    String roomId, {
    List<String> mediaIds = const [],
    String? sourcePlaylistId,
    String? targetPlaylistId,
    bool allFromScope = false,
    String? beforeMediaId,
    String? afterMediaId,
  }) async {
    final response = await _api.room.moveMedia(
      roomId,
      client.MoveMediaRequest(
        mediaIds: mediaIds,
        sourcePlaylistId: sourcePlaylistId,
        targetPlaylistId: targetPlaylistId,
        allFromScope: allFromScope,
        beforeMediaId: beforeMediaId,
        afterMediaId: afterMediaId,
      ),
    );
    return response.movedCount;
  }

  Future<ChatHistoryPage> getChatHistory(
    String roomId, {
    int limit = 50,
    String cursor = '',
  }) async {
    final response = await _api.room.getChatHistory(
      roomId,
      client.GetChatHistoryRequest(limit: limit, cursor: cursor),
    );
    return ChatHistoryPage(
      messages: response.messages.map(_chatMessageFromProto).toList(),
      nextCursor: response.nextCursor,
    );
  }

  Future<String> addDirectUrlMedia(
    String roomId, {
    String playlistId = '',
    required String url,
    Map<String, String> headers = const {},
    String name = '',
  }) async {
    final sourceConfig = DirectUrlSourceConfig.fromUserInput(
      url: url,
      headers: headers,
    );
    return _addMedia(
      roomId,
      playlistId: playlistId,
      sourceProvider: DirectUrlSourceConfig.sourceProvider,
      sourceConfig: sourceConfig.toJson(),
      name: name,
    );
  }

  Future<String> addBilibiliMedia(
    String roomId, {
    String playlistId = '',
    String providerInstanceName = '',
    required Map<String, dynamic> sourceConfig,
    String name = '',
  }) {
    return _addMedia(
      roomId,
      playlistId: playlistId,
      sourceProvider: 'bilibili',
      providerInstanceName: providerInstanceName,
      sourceConfig: sourceConfig,
      name: name,
    );
  }

  Future<String> addAlistMedia(
    String roomId, {
    String playlistId = '',
    required String serverId,
    required String path,
    String password = '',
    String name = '',
    String providerInstanceName = '',
  }) {
    final sourceConfig = <String, dynamic>{
      'server_id': serverId,
      'path': path,
    };
    if (password.isNotEmpty) sourceConfig['password'] = password;
    return _addMedia(
      roomId,
      playlistId: playlistId,
      sourceProvider: 'alist',
      providerInstanceName: providerInstanceName,
      sourceConfig: sourceConfig,
      name: name,
    );
  }

  Future<String> addEmbyMedia(
    String roomId, {
    String playlistId = '',
    required String serverId,
    required String itemId,
    String name = '',
    String providerInstanceName = '',
  }) {
    return _addMedia(
      roomId,
      playlistId: playlistId,
      sourceProvider: 'emby',
      providerInstanceName: providerInstanceName,
      sourceConfig: {
        'server_id': serverId,
        'item_id': itemId,
      },
      name: name,
    );
  }

  Future<String> addRtmpMedia(
    String roomId, {
    String playlistId = '',
    String name = '',
  }) {
    return _addMedia(
      roomId,
      playlistId: playlistId,
      sourceProvider: 'rtmp',
      sourceConfig: const {},
      name: name,
    );
  }

  Future<RtmpPublishKeyInfo> createRtmpPublishKeyInfo(
    String roomId,
    String mediaId,
  ) async {
    final response = await _api.rtmpProvider.createPublishKey(
      rtmp.CreatePublishKeyRequest(roomId: roomId, mediaId: mediaId),
    );
    return RtmpPublishKeyInfo(
      publishKey: response.publishKey,
      rtmpUrl: response.rtmpUrl,
      streamKey: response.streamKey,
      expiresAt: response.expiresAt.toInt(),
    );
  }

  Future<RoomStreamEntryInfo> getRtmpStreamInfo({
    required String roomId,
    required String mediaId,
  }) async {
    final response = await _api.rtmpProvider.getStreamInfo(
      rtmp.GetStreamInfoRequest(roomId: roomId, mediaId: mediaId),
    );
    return RoomStreamEntryInfo(
      mediaId: mediaId,
      active: response.active,
      publisherUserId: response.hasPublisher() ? response.publisher.userId : '',
      startedAt:
          response.hasPublisher() ? response.publisher.startedAt.toInt() : 0,
    );
  }

  Future<void> addMediaBatch(
    String roomId,
    List<Map<String, dynamic>> items,
  ) {
    return _api.room.addMediaBatch(
      roomId,
      client.AddMediaBatchRequest(
        items: items.map(
          (item) => client.AddMediaRequest(
            playlistId: item['playlist_id']?.toString().isEmpty ?? true
                ? null
                : item['playlist_id']?.toString(),
            sourceProvider: item['source_provider']?.toString() ?? '',
            providerInstanceName:
                item['provider_instance_name']?.toString() ?? '',
            sourceConfig: _api.encodeJsonBytes(
              item['source_config'] ?? const {},
            ),
            name: item['name']?.toString() ?? '',
          ),
        ),
      ),
    );
  }

  Future<void> deleteMovie(String roomId, String movieId) async {
    await _api.room.deleteMedia(
      roomId,
      client.DeleteMediaRequest(mediaId: movieId, force: true),
    );
  }

  Future<void> deleteMediaLibraryEntries(
    String roomId, {
    List<String> mediaIds = const [],
    List<String> playlistIds = const [],
  }) async {
    await _api.room.deleteEntries(
      roomId,
      client.DeleteEntriesRequest(
        mediaIds: mediaIds,
        playlistIds: playlistIds,
        force: true,
      ),
    );
  }

  Future<void> clearMovies(String roomId, {String? parentId}) async {
    await _api.room.clearPlaylist(
      roomId,
      client.ClearPlaylistRequest(playlistId: parentId ?? ''),
    );
  }

  Future<void> switchMovie(
    String roomId,
    String movieId, {
    String? subPath,
    String? playlistId,
  }) async {
    if (movieId.isEmpty) {
      await _api.room.stopPlayback(roomId, client.StopPlaybackRequest());
      return;
    }
    final target = _decodeTarget(subPath);
    final dynamicPlaylistId = playlistId ?? '';
    await _api.room.startPlayback(
      roomId,
      client.StartPlaybackRequest(
        mediaId: target == null && movieId.startsWith('med_') ? movieId : '',
        playlistId: target != null
            ? dynamicPlaylistId
            : movieId.startsWith('pl_')
                ? movieId
                : '',
        target: target ?? const [],
      ),
    );
  }

  Future<void> updatePlayback(
    String roomId, {
    PlaybackControlAction? action,
    required bool isPlaying,
    double? position,
    double speed = 1.0,
    int? version,
  }) async {
    await _api.room.updatePlayback(
      roomId,
      client.UpdatePlaybackRequest(
        type: _playbackUpdateType(action, isPlaying, position),
        playing: isPlaying,
        position: position,
        speed: speed,
        version: version == null ? null : Int64(version),
      ),
    );
  }

  Future<String> _addMedia(
    String roomId, {
    String playlistId = '',
    required String sourceProvider,
    String providerInstanceName = '',
    required Map<String, dynamic> sourceConfig,
    String name = '',
  }) async {
    final response = await _api.room.addMedia(
      roomId,
      client.AddMediaRequest(
        playlistId: playlistId.isEmpty ? null : playlistId,
        sourceProvider: sourceProvider,
        providerInstanceName: providerInstanceName,
        sourceConfig: _api.encodeJsonBytes(sourceConfig),
        name: name,
      ),
    );
    return response.media.id;
  }

  client.WatchOptions _watchOptions(String version) {
    return client.WatchOptions(
      version: version,
      deliveryMode:
          client_enum.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
    );
  }

  List<int> _playlistSourceConfigBytes({
    required String sourceProvider,
    required String providerInstanceName,
    required Object? sourceConfig,
  }) {
    if (sourceProvider.isNotEmpty || providerInstanceName.isNotEmpty) {
      return _api.encodeJsonBytes(sourceConfig);
    }
    if (sourceConfig == null) return const [];
    if (sourceConfig is List<int>) return sourceConfig;
    if (sourceConfig is Map && sourceConfig.isEmpty) return const [];
    if (sourceConfig is Iterable && sourceConfig.isEmpty) return const [];
    return _api.encodeJsonBytes(sourceConfig);
  }

  client_enum.PlaybackUpdateType _playbackUpdateType(
    PlaybackControlAction? action,
    bool isPlaying,
    double? position,
  ) {
    return switch (action) {
      PlaybackControlAction.play =>
        client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PLAY,
      PlaybackControlAction.pause =>
        client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PAUSE,
      PlaybackControlAction.seek =>
        client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK,
      PlaybackControlAction.speed =>
        client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED,
      null => position != null
          ? client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK
          : isPlaying
              ? client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PLAY
              : client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PAUSE,
    };
  }

  List<int>? _decodeTarget(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return base64Url.decode(value);
    } catch (_) {
      return utf8.encode(value);
    }
  }

  RoomMediaLibraryPage _mediaLibraryPageFromProto(
    client.ListPlaylistItemsResponse response, {
    String parentId = '',
  }) {
    return RoomMediaLibraryPage(
      playlists: response.playlists.map(_api.mapPlaylist).toList(),
      media: response.media.map(_api.mapMedia).toList(),
      dynamicItems: response.dynamicItems
          .map((item) => _api.mapDynamicItem(item, playlistId: parentId))
          .toList(),
      currentPath: response.currentPath.map(_browsePathFromProto).toList(),
      total: response.total,
      folderCount: response.folderCount,
      fileCount: response.fileCount,
      version: response.version,
    );
  }

  PlaylistBrowsePathInfo _browsePathFromProto(
    client.PlaylistBrowsePathNode node,
  ) {
    return PlaylistBrowsePathInfo(
      playlistId: node.playlistId,
      name: node.name,
      target: base64Url.encode(node.target),
    );
  }

  RoomChatMessageInfo _chatMessageFromProto(
    client.ChatMessageReceive message,
  ) {
    return RoomChatMessageInfo(
      id: message.id,
      roomId: message.roomId,
      userId: message.userId,
      username: message.username,
      content: message.content,
      timestamp: message.timestamp.toInt(),
      position: message.hasPosition() ? message.position : null,
      color: message.hasColor() ? message.color : null,
    );
  }

  WPlaybackStatus _playbackStatusFromState(
    client.PlaybackState state,
  ) {
    final encodedTarget =
        state.target.isEmpty ? '' : base64Url.encode(state.target);
    final movie = state.playingMediaId.isEmpty &&
            state.playingPlaylistId.isEmpty
        ? null
        : WMovie(
            id: encodedTarget.isNotEmpty
                ? encodedTarget
                : state.playingMediaId.isNotEmpty
                    ? state.playingMediaId
                    : state.playingPlaylistId,
            name: '',
            url: '',
            subPath: encodedTarget.isEmpty ? null : encodedTarget,
            parentId: encodedTarget.isEmpty ? null : state.playingPlaylistId,
          );
    return WPlaybackStatus(
      movie: movie,
      isPlaying: state.isPlaying,
      currentTime: state.position,
      playbackRate: state.speed == 0 ? 1.0 : state.speed,
    );
  }

  WPlaybackStatus _playbackStatusFromSnapshot(
    client.PlaybackSnapshot snapshot,
  ) {
    client.PlaybackInfo? info;
    if (snapshot.playbackInfos.containsKey(snapshot.defaultMode)) {
      info = snapshot.playbackInfos[snapshot.defaultMode];
    } else if (snapshot.playbackInfos.isNotEmpty) {
      info = snapshot.playbackInfos.values.first;
    }
    final playbackUrl = info != null && info.urls.isNotEmpty
        ? info.urls[
            info.defaultUrlIndex >= 0 && info.defaultUrlIndex < info.urls.length
                ? info.defaultUrlIndex
                : 0]
        : null;
    final movie = snapshot.mediaId.isEmpty && snapshot.playlistId.isEmpty
        ? null
        : WMovie(
            id: snapshot.mediaId.isNotEmpty
                ? snapshot.mediaId
                : snapshot.playlistId,
            name: snapshot.name,
            url: _api.resolveResourceUrl(playbackUrl?.url ?? ''),
            headers: playbackUrl == null
                ? const {}
                : Map<String, String>.from(playbackUrl.headers),
            type: info?.format ?? '',
            metadata: {
              'snapshot_version': snapshot.version,
              'default_mode': snapshot.defaultMode,
              'playback_metadata': Map<String, String>.from(
                snapshot.metadata,
              ),
            },
          );
    return WPlaybackStatus(movie: movie);
  }
}
