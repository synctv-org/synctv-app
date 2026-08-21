import 'dart:typed_data';

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

abstract interface class RoomRealtimeProtocol {
  RealtimeEventLogEntry describeIncoming(Uint8List data);

  RealtimeEventLogEntry describeOutgoing(List<int> data);

  RoomRealtimeMessage decode(Uint8List data);

  List<int> encodeChat(
    String content, {
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    Iterable<ChatMentionInfo> mentions = const [],
  });

  List<int> encodeGuardedPlaybackStateUpdate(
    PlaybackControlAction action,
    SyncTvPlaybackStatus? currentStatus, {
    bool? isPlaying,
    double? position,
    double? playbackRate,
    String? clientOperationId,
    int? clientTimeMillis,
  });

  List<List<int>> encodeInitialObservations({
    bool includeResolvedPlayback = true,
  });

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
  });

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
  });

  List<int> encodeOnlineCountObservation({
    String observeId = 'online_count',
    Iterable<String> userIds = const [],
    Iterable<common_enum.RoomMemberRole> roles = const [],
  });

  List<int> encodeRoomSettingsObservation({
    String observeId = 'room_settings',
    String version = '',
  });

  List<int> encodePlaybackHistoryObservation({
    String observeId = 'playback_history',
    String version = '',
    int limit = 50,
  });

  List<int> encodeChatEventsObservation({
    String observeId = 'chat_events',
    String version = '',
    String afterEventId = '',
  });

  List<int> encodeUnobserveResource(String observeId);

  List<int> encodeWebRtcVoiceSignal(String type, Map<String, dynamic> data);

  List<int> encodeWebRtcMediaSignal(String type, Map<String, dynamic> data);
}
