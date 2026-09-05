import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/contracts/chat_message_selection.dart';
import 'package:synctv_app/contracts/playback_client_profile.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/core/identifiers/client_operation_id.dart';

class SyncTvRoomMediaDomainService {
  SyncTvRoomMediaDomainService(this._api);

  final SyncTvApiClient _api;

  Future<SyncTvPlaybackStatus> playPrevious(String roomId) async {
    final state = await _api.room.playPrevious(
      roomId,
      client.PlayPreviousRequest(clientOperationId: newClientOperationId()),
    );
    return _playbackStatusFromState(state);
  }

  Future<SyncTvPlaybackStatus> playNext(String roomId) async {
    final state = await _api.room.playNext(
      roomId,
      client.PlayNextRequest(clientOperationId: newClientOperationId()),
    );
    return _playbackStatusFromState(state);
  }

  Future<client.ListPlaybackHistoryResponse> listPlaybackHistory(
    String roomId, {
    String cursorEntryId = '',
    int limit = 50,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) {
    return _api.room.listPlaybackHistory(
      roomId,
      client.ListPlaybackHistoryRequest(
        cursorEntryId: cursorEntryId.isEmpty ? null : cursorEntryId,
        limit: limit,
        sortDirection: sortDirection,
      ),
    );
  }

  Future<SyncTvPlaybackStatus> playHistoryEntry(
    String roomId,
    String entryId,
  ) async {
    final state = await _api.room.playHistoryEntry(
      roomId,
      client.PlayHistoryEntryRequest(
        entryId: entryId,
        clientOperationId: newClientOperationId(),
      ),
    );
    return _playbackStatusFromState(state);
  }

  Future<bool> deletePlaybackHistoryEntry(String roomId, String entryId) async {
    final response = await _api.room.deletePlaybackHistoryEntry(
      roomId,
      client.DeletePlaybackHistoryEntryRequest(entryId: entryId),
    );
    return response.deleted;
  }

  Future<int> clearPlaybackHistory(String roomId) async {
    final response = await _api.room.clearPlaybackHistory(roomId);
    return response.deletedCount.toInt();
  }

  Stream<RoomResourceWatchEvent<SyncTvPlaybackStatus>> watchPlaybackState(
    String roomId, {
    String version = '',
  }) {
    return _api.room
        .watchPlaybackState(
          roomId,
          client.WatchPlaybackStateRequest(
            deliveryMode: _watchDeliveryMode,
            playbackState: client.ObservePlaybackState(
              eventSequence: _watchSequence(version),
            ),
          ),
        )
        .map((event) {
          if (event.hasObserved()) {
            return RoomResourceWatchEvent<SyncTvPlaybackStatus>.observed(
              version: _cursorVersion(event.observed.eventCursor),
              changed: event.observed.changed,
            );
          }
          if (event.hasError()) {
            return RoomResourceWatchEvent<SyncTvPlaybackStatus>.error(
              message: event.error.hasError() ? event.error.error.message : '',
              code: event.error.hasError() ? event.error.error.code : 0,
            );
          }
          return RoomResourceWatchEvent<SyncTvPlaybackStatus>.changed(
            version: _cursorVersion(event.resourceEvent.eventCursor),
            snapshot: _playbackStatusFromState(
              event.resourceEvent.playbackState,
            ),
          );
        });
  }

  Stream<RoomResourceWatchEvent<SyncTvPlaybackStatus>> watchPlaybackSnapshot(
    String roomId,
  ) {
    return _api.room
        .watchPlayback(
          roomId,
          client.WatchPlaybackRequest(
            deliveryMode: _watchDeliveryMode,
            playback: client.ObservePlayback(
              playbackClientProfile: defaultPlaybackClientProfile(),
            ),
          ),
        )
        .map((event) {
          if (event.hasObserved()) {
            return RoomResourceWatchEvent<SyncTvPlaybackStatus>.observed(
              version: _cursorVersion(event.observed.eventCursor),
              changed: event.observed.changed,
            );
          }
          if (event.hasError()) {
            return RoomResourceWatchEvent<SyncTvPlaybackStatus>.error(
              message: event.error.hasError() ? event.error.error.message : '',
              code: event.error.hasError() ? event.error.error.code : 0,
            );
          }
          return RoomResourceWatchEvent<SyncTvPlaybackStatus>.changed(
            version: _cursorVersion(event.resourceEvent.eventCursor),
            snapshot: _playbackStatusFromPlayback(event.resourceEvent.playback),
          );
        });
  }

  Stream<RoomResourceWatchEvent<RoomMediaLibraryPage>> watchPlaylistItems(
    String roomId, {
    String version = '',
    String playlistId = '',
    String? target,
    int? page,
    int pageSize = 100,
    String search = '',
    source_enum.SourceProvider sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
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
            deliveryMode: _watchDeliveryMode,
            playlistItems: client.ObservePlaylistItems(
              afterEventSequence: _watchSequence(version),
              request: client.ListPlaylistItemsRequest(
                playlistId: playlistId,
                target: providerTargetFromBase64(target),
                page: page == null ? null : client.PagePagination(page: page),
                pageSize: pageSize,
                search: search,
                sourceProvider: sourceProvider,
                providerInstanceName: providerInstanceName,
                sortBy: sortBy,
                sortDirection: sortDirection,
                availability: availability,
              ),
            ),
          ),
        )
        .map((event) {
          if (event.hasObserved()) {
            return RoomResourceWatchEvent<RoomMediaLibraryPage>.observed(
              version: _cursorVersion(event.observed.eventCursor),
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
            version: _cursorVersion(event.resourceEvent.eventCursor),
            snapshot: _mediaLibraryPageFromProto(
              event.resourceEvent.playlistItems,
              parentId: playlistId,
              requestedPage: page,
            ),
          );
        });
  }

  Future<RoomMediaLibraryPage> listMediaLibrary(
    String roomId, {
    int? page,
    String? cursor,
    int pageSize = 50,
    String playlistId = '',
    String? target,
    String search = '',
    source_enum.SourceProvider sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    Map<String, dynamic>? previewSourceConfig,
    source_config.PlaylistSourceConfig? typedPreviewSourceConfig,
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
        target: providerTargetFromBase64(target),
        page: cursor?.isNotEmpty != true && page != null
            ? client.PagePagination(page: page)
            : null,
        cursor: cursor?.isNotEmpty == true
            ? client.CursorPagination(cursor: cursor)
            : null,
        pageSize: pageSize,
        search: search,
        sourceProvider: sourceProvider,
        providerInstanceName: providerInstanceName,
        sortBy: sortBy,
        sortDirection: sortDirection,
        availability: availability,
        refresh: refresh,
        previewSourceConfig:
            typedPreviewSourceConfig ??
            (previewSourceConfig == null
                ? null
                : SourceConfigCodec.playlistSourceConfigFromMap(
                    sourceProvider: sourceProvider,
                    sourceConfig: previewSourceConfig,
                  )),
      ),
    );
    return _mediaLibraryPageFromProto(
      response,
      parentId: playlistId,
      requestedPage: page,
    );
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
      childPlaylistCount: response.childPlaylistCount,
      mediaCount: response.mediaCount,
    );
  }

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

  Future<RoomPlaylistItem> createPlaylist(
    String roomId, {
    required String name,
    String parentId = '',
    String description = '',
    client_enum.PlaylistBrowseAccessMode browseAccessMode = client_enum
        .PlaylistBrowseAccessMode
        .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
  }) async {
    final response = await _api.room.createPlaylist(
      roomId,
      client.CreatePlaylistRequest(
        name: name,
        parentId: parentId,
        description: description,
        browseAccessMode: browseAccessMode,
      ),
    );
    return _api.mapPlaylist(response);
  }

  Future<RoomPlaylistItem> createPlaylistFromSourceConfig(
    String roomId, {
    required String name,
    required source_config.PlaylistSourceConfig sourceConfig,
    String parentId = '',
    String providerInstanceName = '',
    String description = '',
    client_enum.PlaylistBrowseAccessMode browseAccessMode = client_enum
        .PlaylistBrowseAccessMode
        .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
  }) async {
    final provider = SourceConfigCodec.providerForPlaylistSourceConfig(
      sourceConfig,
    );
    final response = await _api.room.createPlaylist(
      roomId,
      client.CreatePlaylistRequest(
        name: name,
        parentId: parentId,
        sourceProvider: provider,
        sourceConfig: sourceConfig,
        providerInstanceName: providerInstanceName,
        description: description,
        browseAccessMode: browseAccessMode,
      ),
    );
    return _api.mapPlaylist(response);
  }

  Future<RoomPlaylistItem> updatePlaylist(
    String roomId,
    String playlistId, {
    required String name,
    String? description,
    source_config.PlaylistSourceConfig? sourceConfig,
    client_enum.PlaylistBrowseAccessMode? browseAccessMode,
  }) async {
    final response = await _api.room.updatePlaylist(
      roomId,
      client.UpdatePlaylistRequest(
        playlistId: playlistId,
        name: name,
        description: description ?? '',
        sourceConfig: sourceConfig,
        browseAccessMode: browseAccessMode,
      ),
    );
    return _api.mapPlaylist(response);
  }

  Future<RoomPlaylistItem> movePlaylist(
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
    return _api.mapPlaylist(response);
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

  Future<RoomMediaItem> editMedia(
    String roomId,
    String mediaId, {
    required String name,
    String? description,
    source_enum.PlaybackProxyMode? playbackProxyMode,
  }) async {
    final response = await _api.room.editMedia(
      roomId,
      client.EditMediaRequest(
        mediaId: mediaId,
        name: name,
        description: description ?? '',
        playbackProxyMode: playbackProxyMode,
      ),
    );
    return _api.mapMedia(response);
  }

  Future<RoomMediaItem> getMedia(String roomId, String mediaId) async {
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
        sourcePlaylistId: allFromScope ? sourcePlaylistId : null,
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
    List<client_enum.ChatMessageType> includeMessageTypes =
        chatTimelineMessageTypes,
  }) async {
    final response = await _api.room.getChatHistory(
      roomId,
      client.GetChatHistoryRequest(
        limit: limit,
        cursor: cursor,
        includeMessageTypes: includeMessageTypes,
      ),
    );
    return chatHistoryPageFromProto(response);
  }

  ChatHistoryPage chatHistoryPageFromProto(
    client.GetChatHistoryResponse response,
  ) {
    return ChatHistoryPage(
      messages: response.messages.map(_chatMessageFromProto).toList(),
      nextCursor: response.nextCursor,
      eventCursor: response.hasEventCursor()
          ? response.eventCursor.sequence.toInt().toString()
          : '',
    );
  }

  Future<ChatSearchPage> searchChatMessages(
    String roomId, {
    required String query,
    int limit = 50,
    String cursor = '',
    bool includeDeleted = false,
    String userId = '',
  }) async {
    final response = await _api.room.searchChatMessages(
      roomId,
      client.SearchChatMessagesRequest(
        query: query,
        limit: limit,
        cursor: cursor,
        includeDeleted: includeDeleted,
        userId: userId,
      ),
    );
    return ChatSearchPage(
      messages: response.messages.map(_chatMessageFromProto).toList(),
      nextCursor: response.nextCursor,
      eventCursor: response.hasEventCursor()
          ? response.eventCursor.sequence.toInt().toString()
          : '',
    );
  }

  Future<RoomChatMessageInfo> sendChatMessage(
    String roomId, {
    String content = '',
    List<StoredImageInfo> images = const [],
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    List<ChatMentionInfo> mentions = const [],
  }) async {
    final response = await _api.room.sendChatMessage(
      roomId,
      client.SendChatMessageRequest(
        content: content,
        clientMessageId: newClientOperationId(),
        attachments: images.map(chatAttachmentReferenceFromStoredImage),
        displayPosition: displayPosition,
        displayColor: displayColor,
        replyToMessageId: replyToMessageId,
        mentions: mentions.map(
          (mention) => client.ChatMentionInput(
            userId: mention.userId,
            start: mention.start,
            length: mention.length,
          ),
        ),
      ),
    );
    return _chatMessageFromProto(response.event.message);
  }

  Future<List<ChatPinnedMessageInfo>> listPinnedChatMessages(
    String roomId, {
    int limit = 50,
  }) async {
    final response = await _api.room.listPinnedChatMessages(
      roomId,
      client.ListPinnedChatMessagesRequest(limit: limit),
    );
    return response.messages.map(_chatPinnedMessageFromProto).toList();
  }

  Future<ChatPinEventInfo> pinChatMessage(
    String roomId,
    String messageId, {
    String note = '',
  }) async {
    final response = await _api.room.pinChatMessage(
      roomId,
      client.PinChatMessageRequest(
        messageId: messageId,
        note: note,
        clientOperationId: newClientOperationId(),
      ),
    );
    return _chatPinEventFromProto(response.event);
  }

  Future<ChatPinEventInfo> unpinChatMessage(
    String roomId,
    String messageId,
  ) async {
    final response = await _api.room.unpinChatMessage(
      roomId,
      client.UnpinChatMessageRequest(
        messageId: messageId,
        clientOperationId: newClientOperationId(),
      ),
    );
    return _chatPinEventFromProto(response.event);
  }

  Stream<RoomResourceWatchEvent<ChatPinEventInfo>> watchChatPinEvents(
    String roomId, {
    String version = '',
  }) {
    return _api.room
        .watchChatPinEvents(
          roomId,
          client.WatchChatPinEventsRequest(
            deliveryMode: _watchDeliveryMode,
            chatPinEvents: client.ObserveChatPinEvents(
              afterEventSequence: _watchSequence(version),
            ),
          ),
        )
        .map((event) {
          if (event.hasObserved()) {
            return RoomResourceWatchEvent<ChatPinEventInfo>.observed(
              version: _cursorVersion(event.observed.eventCursor),
              changed: event.observed.changed,
            );
          }
          if (event.hasError()) {
            return RoomResourceWatchEvent<ChatPinEventInfo>.error(
              message: event.error.hasError() ? event.error.error.message : '',
              code: event.error.hasError() ? event.error.error.code : 0,
            );
          }
          return RoomResourceWatchEvent<ChatPinEventInfo>.changed(
            version: _cursorVersion(event.resourceEvent.eventCursor),
            snapshot: _chatPinEventFromProto(event.resourceEvent.chatPinEvent),
          );
        });
  }

  Future<RoomChatMessageInfo> editChatMessage(
    String roomId,
    String messageId, {
    required String content,
    required int expectedVersion,
  }) async {
    final response = await _api.room.editChatMessage(
      roomId,
      client.EditChatMessageRequest(
        messageId: messageId,
        content: content,
        expectedVersion: Int64(expectedVersion),
        clientOperationId: newClientOperationId(),
      ),
    );
    return _chatMessageFromProto(response.event.message);
  }

  Future<RoomChatMessageInfo> deleteChatMessage(
    String roomId,
    String messageId, {
    required int expectedVersion,
    String reason = '',
  }) async {
    final response = await _api.room.deleteChatMessage(
      roomId,
      client.DeleteChatMessageRequest(
        messageId: messageId,
        expectedVersion: Int64(expectedVersion),
        reason: reason,
        clientOperationId: newClientOperationId(),
      ),
    );
    return _chatMessageFromProto(response.event.message);
  }

  Future<RoomChatMessageInfo> setChatReaction(
    String roomId,
    String messageId,
    String reactionKey, {
    required bool enabled,
  }) async {
    final response = await _api.room.setChatReaction(
      roomId,
      client.SetChatReactionRequest(
        messageId: messageId,
        reactionKey: reactionKey,
        enabled: enabled,
      ),
    );
    return _chatMessageFromProto(response.message);
  }

  Future<String> reportChatMessage(
    String roomId,
    String messageId, {
    required String reasonCode,
    String reason = '',
  }) async {
    final response = await _api.room.reportContent(
      roomId,
      client.ReportContentRequest(
        chatMessage: client.ReportChatMessageTarget(
          roomId: roomId,
          messageId: messageId,
        ),
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
    return response.reportId;
  }

  Future<String> reportRoom(
    String roomId, {
    required String reasonCode,
    String reason = '',
  }) async {
    final response = await _api.room.reportContent(
      roomId,
      client.ReportContentRequest(
        room: client.ReportRoomTarget(roomId: roomId),
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
    return response.reportId;
  }

  Future<String> reportUser(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  }) async {
    final response = await _api.room.reportContent(
      roomId,
      client.ReportContentRequest(
        user: client.ReportUserTarget(userId: userId),
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
    return response.reportId;
  }

  Future<String> reportRoomMember(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  }) async {
    final response = await _api.room.reportContent(
      roomId,
      client.ReportContentRequest(
        roomMember: client.ReportRoomMemberTarget(
          roomId: roomId,
          userId: userId,
        ),
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
    return response.reportId;
  }

  Future<RoomChatMessageInfo> getChatMessage(
    String roomId,
    String messageId, {
    bool includeDeleted = false,
  }) async {
    final response = await _api.room.getChatMessage(
      roomId,
      client.GetChatMessageRequest(
        messageId: messageId,
        includeDeleted: includeDeleted,
      ),
    );
    return _chatMessageFromProto(response);
  }

  Future<ChatReactionUsersPage> listChatReactionUsers(
    String roomId,
    String messageId,
    String reactionKey, {
    int limit = 50,
    String cursor = '',
  }) async {
    final response = await _api.room.listChatReactionUsers(
      roomId,
      client.ListChatReactionUsersRequest(
        messageId: messageId,
        reactionKey: reactionKey,
        limit: limit,
        cursor: cursor,
      ),
    );
    return ChatReactionUsersPage(
      users: response.users.map(_chatReactionUserFromProto).toList(),
      nextCursor: response.nextCursor,
      total: response.total.toInt(),
    );
  }

  Future<ChatMessageContextInfo> getChatMessageContext(
    String roomId,
    String messageId, {
    int beforeLimit = 20,
    int afterLimit = 20,
    bool includeDeleted = false,
  }) async {
    final response = await _api.room.getChatMessageContext(
      roomId,
      client.GetChatMessageContextRequest(
        messageId: messageId,
        beforeLimit: beforeLimit,
        afterLimit: afterLimit,
        includeDeleted: includeDeleted,
      ),
    );
    return _chatMessageContextFromProto(response);
  }

  ChatMessageContextInfo _chatMessageContextFromProto(
    client.GetChatMessageContextResponse response,
  ) {
    return ChatMessageContextInfo(
      before: response.before.map(_chatMessageFromProto).toList(),
      message: _chatMessageFromProto(response.message),
      after: response.after.map(_chatMessageFromProto).toList(),
    );
  }

  Future<List<RoomChatMessageInfo>> getChatPlaybackMessages(
    String roomId, {
    String playbackMediaId = '',
    String playbackPlaylistId = '',
    List<int> playbackTarget = const [],
    double positionSeconds = 0,
    double beforeSeconds = 30,
    double afterSeconds = 30,
    int limit = 50,
    bool includeDeleted = false,
    List<client_enum.ChatMessageType> includeMessageTypes = const [],
  }) async {
    final response = await _api.room.getChatPlaybackMessages(
      roomId,
      client.GetChatPlaybackMessagesRequest(
        playbackMediaId: playbackMediaId,
        playbackPlaylistId: playbackPlaylistId,
        playbackTarget: playbackTarget.isEmpty
            ? client.ProviderTarget()
            : providerTargetFromJson(
                Map<String, dynamic>.from(
                  jsonDecode(utf8.decode(playbackTarget)),
                ),
              ),
        positionSeconds: positionSeconds,
        beforeSeconds: beforeSeconds,
        afterSeconds: afterSeconds,
        limit: limit,
        includeDeleted: includeDeleted,
        includeMessageTypes: includeMessageTypes,
      ),
    );
    final allowedTypes = includeMessageTypes.toSet();
    return response.messages
        .map(_chatMessageFromProto)
        .where(
          (message) =>
              allowedTypes.isEmpty ||
              allowedTypes.contains(message.messageType),
        )
        .toList();
  }

  Future<ChatReadStateInfo> markChatRead(
    String roomId,
    String messageId,
  ) async {
    final response = await _api.room.markChatRead(
      roomId,
      client.MarkChatReadRequest(messageId: messageId),
    );
    return _chatReadStateFromProto(response);
  }

  Future<ChatReadStateInfo> getChatReadState(String roomId) async {
    final response = await _api.room.getChatReadState(
      roomId,
      client.GetChatReadStateRequest(),
    );
    return _chatReadStateFromProto(response);
  }

  Future<ChatMessageReadReceiptsInfo> getChatMessageReadReceipts(
    String roomId,
    String messageId, {
    int page = 1,
    int pageSize = 50,
  }) async {
    final response = await _api.room.getChatMessageReadReceipts(
      roomId,
      client.GetChatMessageReadReceiptsRequest(
        messageId: messageId,
        page: page,
        pageSize: pageSize,
      ),
    );
    return _chatMessageReadReceiptsFromProto(response);
  }

  StoredImageInfo storedImageFromChatAttachment(client.ChatAttachment image) {
    return StoredImageInfo.fromChatAttachment(
      image,
      resolveUrl: _api.resolveResourceUrl,
    );
  }

  client.ChatAttachmentReference chatAttachmentReferenceFromStoredImage(
    StoredImageInfo image,
  ) {
    return client.ChatAttachmentReference(
      id: image.id,
      kind: image.uploadReference
          ? client_enum
                .ChatAttachmentReferenceKind
                .CHAT_ATTACHMENT_REFERENCE_KIND_UPLOAD
          : client_enum
                .ChatAttachmentReferenceKind
                .CHAT_ATTACHMENT_REFERENCE_KIND_REUSE,
    );
  }

  Future<String> addMediaFromSourceConfig(
    String roomId, {
    String playlistId = '',
    String providerInstanceName = '',
    required source_config.MediaSourceConfig sourceConfig,
    String name = '',
  }) async {
    final response = await _api.room.addMedia(
      roomId,
      client.AddMediaRequest(
        playlistId: playlistId.isEmpty ? null : playlistId,
        providerInstanceName: providerInstanceName,
        sourceConfig: sourceConfig,
        name: name,
      ),
    );
    return response.id;
  }

  Future<RtmpPublishKeyInfo> createRtmpPublishKeyInfo(
    String roomId,
    String mediaId, {
    required client_enum.PublishKeyType keyType,
    int? expiresAt,
  }) async {
    final response = await _api.room.createRoomPublishKey(
      roomId,
      client.CreateRoomPublishKeyRequest(
        mediaId: mediaId,
        type: keyType,
        expiresAt: expiresAt == null ? null : Int64(expiresAt),
      ),
    );
    return RtmpPublishKeyInfo(
      publishKey: response.publishKey,
      rtmpUrl: response.rtmpUrl,
      streamKey: response.streamKey,
      whipUrl: response.whipUrl,
      expiresAt: response.hasExpiresAt() ? response.expiresAt.toInt() : null,
      keyType: response.type,
    );
  }

  Future<RoomStreamEntryInfo> getRtmpStreamInfo({
    required String roomId,
    required String mediaId,
  }) async {
    final response = await _api.room.getRoomStreamInfo(
      roomId,
      client.GetRoomStreamInfoRequest(mediaId: mediaId),
    );
    return RoomStreamEntryInfo(
      mediaId: mediaId,
      active: response.active,
      publisherUserId: response.hasPublisher() ? response.publisher.userId : '',
      startedAt: response.hasPublisher()
          ? response.publisher.startedAt.toInt()
          : 0,
    );
  }

  Future<void> deleteMedia(String roomId, String mediaId) async {
    await _api.room.deleteMedia(
      roomId,
      client.DeleteMediaRequest(mediaId: mediaId, force: true),
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

  Future<void> clearMediaLibrary(String roomId, {String? parentId}) async {
    await _api.room.clearPlaylist(
      roomId,
      client.ClearPlaylistRequest(playlistId: parentId ?? ''),
    );
  }

  Future<SyncTvPlaybackStatus> switchMedia(
    String roomId,
    String entryId, {
    String? subPath,
    String? playlistId,
  }) async {
    final clientOperationId = newClientOperationId();
    if (entryId.isEmpty) {
      final state = await _api.room.stopPlayback(
        roomId,
        client.StopPlaybackRequest(clientOperationId: clientOperationId),
      );
      return _playbackStatusFromState(state);
    }
    final target = providerTargetFromBase64(subPath);
    final hasTarget = !providerTargetIsEmpty(target);
    final dynamicPlaylistId = playlistId ?? '';
    final isStaticMedia = entryId.startsWith('med_');
    final isDynamicPlaylist = entryId.startsWith('pl_');
    if (!hasTarget && !isStaticMedia && !isDynamicPlaylist) {
      throw ArgumentError.value(
        entryId,
        'entryId',
        'Expected a med_ media ID or pl_ playlist ID',
      );
    }
    if (hasTarget && dynamicPlaylistId.isEmpty) {
      throw ArgumentError.value(
        playlistId,
        'playlistId',
        'A dynamic provider target requires a pl_ playlist ID',
      );
    }
    final state = await _api.room.startPlayback(
      roomId,
      client.StartPlaybackRequest(
        mediaId: !hasTarget && isStaticMedia ? entryId : '',
        playlistId: hasTarget
            ? dynamicPlaylistId
            : isStaticMedia
            ? dynamicPlaylistId
            : isDynamicPlaylist
            ? entryId
            : '',
        target: target,
        clientOperationId: clientOperationId,
      ),
    );
    return _playbackStatusFromState(state);
  }

  Future<SyncTvPlaybackStatus> updatePlaybackState(
    String roomId, {
    PlaybackControlAction? action,
    required bool isPlaying,
    double? position,
    double speed = 1.0,
    int? version,
  }) async {
    final response = await _api.room.updatePlaybackState(
      roomId,
      client.UpdatePlaybackStateRequest(
        type: _playbackStateUpdateType(action, isPlaying, position),
        playing: isPlaying,
        position: position,
        speed: speed,
        version: version == null ? null : Int64(version),
      ),
    );
    return _api.mapPlaybackState(response);
  }

  client_enum.ResourceDeliveryMode get _watchDeliveryMode =>
      client_enum.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT;

  Int64? _watchSequence(String version) {
    if (version.isEmpty) return null;
    final parsed = int.tryParse(version);
    return parsed == null ? null : Int64(parsed);
  }

  String _cursorVersion(client.EventCursor cursor) {
    final sequence = cursor.sequence.toInt();
    return sequence == 0 ? cursor.eventId : sequence.toString();
  }

  client_enum.PlaybackUpdateType _playbackStateUpdateType(
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
      null =>
        position != null
            ? client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK
            : isPlaying
            ? client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PLAY
            : client_enum.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PAUSE,
    };
  }

  RoomMediaLibraryPage _mediaLibraryPageFromProto(
    client.ListPlaylistItemsResponse response, {
    String parentId = '',
    int? requestedPage,
  }) {
    return RoomMediaLibraryPage(
      playlists: response.playlists.map(_api.mapPlaylist).toList(),
      media: response.media.map(_api.mapMedia).toList(),
      dynamicItems: response.dynamicItems
          .map((item) => _api.mapDynamicItem(item, playlistId: parentId))
          .toList(),
      currentPath: response.currentPath.map(_browsePathFromProto).toList(),
      total: response.hasTotal() ? response.total.toInt() : null,
      playlistCount: response.playlistCount.toInt(),
      fileCount: response.fileCount.toInt(),
      version: response.version,
      usesCursor:
          response.whichPagination() ==
          client.ListPlaylistItemsResponse_Pagination.cursor,
      nextCursor: response.hasCursor() ? response.cursor.cursor : '',
      page: response.hasPage() ? response.page.page : requestedPage ?? 1,
      supportsSearch: response.supportsSearch,
    );
  }

  PlaylistBrowsePathInfo _browsePathFromProto(
    client.PlaylistBrowsePathNode node,
  ) {
    return PlaylistBrowsePathInfo(
      playlistId: node.playlistId,
      name: node.name,
      target: providerTargetToBase64(node.target),
    );
  }

  RoomChatMessageInfo _chatMessageFromProto(client.ChatMessageReceive message) {
    return RoomChatMessageInfo.fromProto(
      message,
      resolveUrl: _api.resolveResourceUrl,
    );
  }

  ChatPinnedMessageInfo _chatPinnedMessageFromProto(
    client.ChatPinnedMessage message,
  ) {
    return ChatPinnedMessageInfo(
      message: _chatMessageFromProto(message.message),
      pin: ChatPinInfo(
        pinnedByUserId: message.pinnedByUserId,
        pinnedByUsername: message.pinnedByUsername,
        note: message.note,
        pinnedAt: message.pinnedAt.toInt(),
      ),
    );
  }

  ChatPinEventInfo _chatPinEventFromProto(client.ChatPinEvent event) {
    return ChatPinEventInfo.fromProto(
      event,
      resolveUrl: _api.resolveResourceUrl,
    );
  }

  ChatReactionUserInfo _chatReactionUserFromProto(
    client.ChatReactionUser user,
  ) {
    return ChatReactionUserInfo(
      userId: user.userId,
      username: user.username,
      reactedAt: user.reactedAt.toInt(),
    );
  }

  ChatReadStateInfo _chatReadStateFromProto(
    client.ChatReadStateResponse response,
  ) {
    final state = response.state;
    return ChatReadStateInfo(
      roomId: state.roomId,
      userId: state.userId,
      lastReadMessageId: state.lastReadMessageId,
      lastReadEventId: state.lastReadEventId,
      lastReadEventSequence: state.lastReadEventSequence.toInt(),
      updatedAt: state.updatedAt.toInt(),
      unreadCount: response.unreadCount.toInt(),
    );
  }

  ChatMessageReadReceiptsInfo _chatMessageReadReceiptsFromProto(
    client.GetChatMessageReadReceiptsResponse response,
  ) {
    return ChatMessageReadReceiptsInfo(
      readers: response.readers
          .where((reader) => reader.hasUser())
          .map(
            (reader) => ChatReadReceiptUserInfo(
              user: _api.mapPublicUser(reader.user),
              readAt: reader.readAt.toInt(),
            ),
          )
          .toList(),
      unreadMembers: response.unreadMembers
          .where((member) => member.hasUser())
          .map((member) => _api.mapPublicUser(member.user))
          .toList(),
      readerTotal: response.readerTotal.toInt(),
      unreadTotal: response.unreadTotal.toInt(),
    );
  }

  SyncTvPlaybackStatus _playbackStatusFromState(client.PlaybackState state) {
    final encodedTarget = providerTargetToBase64(state.target);
    final entry =
        state.playingMediaId.isEmpty && state.playingPlaylistId.isEmpty
        ? null
        : RoomPlaybackEntry(
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
    return SyncTvPlaybackStatus(
      entry: entry,
      isPlaying: state.isPlaying,
      currentTime: state.position,
      playbackRate: state.speed == 0 ? 1.0 : state.speed,
      generatedAtMillis: state.generatedAtMillis.toInt(),
      version: state.version.toInt(),
      playingMediaId: state.playingMediaId,
      playingPlaylistId: state.playingPlaylistId,
      targetHash: state.targetHash,
      historyCursorId: state.historyCursorId,
    );
  }

  SyncTvPlaybackStatus _playbackStatusFromPlayback(client.Playback playback) {
    final entry = playback.mediaId.isEmpty && playback.playlistId.isEmpty
        ? null
        : RoomMediaEntry.fromPlaybackProto(
            playback,
            resolveUrl: _api.resolveResourceUrl,
          );
    return SyncTvPlaybackStatus(
      entry: entry,
      generatedAtMillis: SyncedClock.nowMillis(),
    );
  }
}
