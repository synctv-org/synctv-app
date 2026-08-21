import 'dart:typed_data';

import 'package:synctv_app/features/room/application/room_realtime_protocol.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/features/room/domain/realtime_event_log.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

final class ProtobufRoomRealtimeProtocol implements RoomRealtimeProtocol {
  const ProtobufRoomRealtimeProtocol();

  @override
  RoomRealtimeMessage decode(Uint8List data) => RoomRealtimeCodec.decode(data);

  @override
  RealtimeEventLogEntry describeIncoming(Uint8List data) =>
      RoomRealtimeCodec.describeIncoming(data);

  @override
  RealtimeEventLogEntry describeOutgoing(List<int> data) =>
      RoomRealtimeCodec.describeOutgoing(data);

  @override
  List<int> encodeChat(
    String content, {
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    Iterable<ChatMentionInfo> mentions = const [],
  }) => RoomRealtimeCodec.encodeChat(
    content,
    displayPosition: displayPosition,
    displayColor: displayColor,
    replyToMessageId: replyToMessageId,
    mentions: mentions,
  );

  @override
  List<int> encodeGuardedPlaybackStateUpdate(
    PlaybackControlAction action,
    SyncTvPlaybackStatus? currentStatus, {
    bool? isPlaying,
    double? position,
    double? playbackRate,
    String? clientOperationId,
    int? clientTimeMillis,
  }) => RoomRealtimeCodec.buildGuardedPlaybackStateUpdateMessage(
    action,
    currentStatus,
    isPlaying: isPlaying,
    position: position,
    playbackRate: playbackRate,
    clientOperationId: clientOperationId,
    clientTimeMillis: clientTimeMillis,
  ).writeToBuffer();

  @override
  List<List<int>> encodeInitialObservations({
    bool includeResolvedPlayback = true,
  }) => RoomRealtimeCodec.encodeInitialObservations(
    includeResolvedPlayback: includeResolvedPlayback,
  );

  @override
  List<int> encodePlaylistObservation({
    String observeId = 'playlist_items',
    String version = '',
    String playlistId = '',
    String? target,
    int? page,
    String? cursor,
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
  }) => RoomRealtimeCodec.encodePlaylistObservation(
    observeId: observeId,
    version: version,
    playlistId: playlistId,
    target: target,
    page: page,
    cursor: cursor,
    pageSize: pageSize,
    search: search,
    sourceProvider: sourceProvider,
    providerInstanceName: providerInstanceName,
    sortBy: sortBy,
    sortDirection: sortDirection,
    availability: availability,
  );

  @override
  List<int> encodeRoomMembersObservation({
    String observeId = 'room_member_events',
    String version = '',
    int page = 1,
    int pageSize = 100,
    String search = '',
    common_enum.RoomMemberRole? role,
    client_enum.RoomMemberListSortBy sortBy =
        client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) => RoomRealtimeCodec.encodeRoomMembersObservation(
    observeId: observeId,
    version: version,
    page: page,
    pageSize: pageSize,
    search: search,
    role: role,
    sortBy: sortBy,
    sortDirection: sortDirection,
  );

  @override
  List<int> encodeOnlineCountObservation({
    String observeId = 'online_count',
    Iterable<String> userIds = const [],
    Iterable<common_enum.RoomMemberRole> roles = const [],
  }) => RoomRealtimeCodec.encodeOnlineCountObservation(
    observeId: observeId,
    userIds: userIds,
    roles: roles,
  );

  @override
  List<int> encodeRoomSettingsObservation({
    String observeId = 'room_settings',
    String version = '',
  }) => RoomRealtimeCodec.encodeRoomSettingsObservation(
    observeId: observeId,
    version: version,
  );

  @override
  List<int> encodePlaybackHistoryObservation({
    String observeId = 'playback_history',
    String version = '',
    int limit = 50,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) => RoomRealtimeCodec.encodePlaybackHistoryObservation(
    observeId: observeId,
    version: version,
    limit: limit,
    sortDirection: sortDirection,
  );

  @override
  List<int> encodeChatEventsObservation({
    String observeId = 'chat_events',
    String version = '',
    String afterEventId = '',
  }) => RoomRealtimeCodec.encodeChatEventsObservation(
    observeId: observeId,
    version: version,
    afterEventId: afterEventId,
  );

  @override
  List<int> encodeUnobserveResource(String observeId) =>
      RoomRealtimeCodec.encodeUnobserveResource(observeId);

  @override
  List<int> encodeWebRtcMediaSignal(String type, Map<String, dynamic> data) =>
      RoomRealtimeCodec.encodeWebRtcMediaSignal(type, data);

  @override
  List<int> encodeWebRtcVoiceSignal(String type, Map<String, dynamic> data) =>
      RoomRealtimeCodec.encodeWebRtcVoiceSignal(type, data);
}
