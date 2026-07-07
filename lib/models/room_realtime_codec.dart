import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:synctv_app/models/playback_client_profile.dart';
import 'package:synctv_app/models/realtime_event_log.dart';
import 'package:synctv_app/models/proto_mapping.dart';
import 'package:synctv_app/models/room_media_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/source_config_codec.dart';
import 'package:synctv_app/services/synctv_clock.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/common.pb.dart' as common;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/models/synctv_models.dart';

enum RoomRealtimeMessageKind {
  unknown,
  error,
  chat,
  status,
  checkStatus,
  expired,
  current,
  roomSettings,
  mediaLibrary,
  viewerCount,
  memberEvent,
  onlineEvent,
  chatPin,
  sync,
  myStatus,
  webrtcOffer,
  webrtcAnswer,
  webrtcIceCandidate,
  webrtcJoin,
  webrtcLeave,
}

enum RoomRealtimeChatEventKind { created, edited, deleted, reactionsChanged }

enum PlaybackControlAction { play, pause, seek, speed }

class RoomRealtimePlaybackStatus {
  const RoomRealtimePlaybackStatus({
    required this.isPlaying,
    required this.currentTime,
    required this.playbackRate,
  });

  final bool isPlaying;
  final double currentTime;
  final double playbackRate;
}

class RoomRealtimeError {
  const RoomRealtimeError({
    required this.message,
    required this.code,
    required this.detail,
  });

  final String message;
  final int code;
  final String detail;
}

class RoomRealtimeOnlineEvent {
  const RoomRealtimeOnlineEvent({
    required this.userId,
    required this.username,
    required this.role,
    required this.kind,
    required this.occurredAtMillis,
  });

  final String userId;
  final String username;
  final common_enum.RoomMemberRole role;
  final client.OnlineEventKind kind;
  final int occurredAtMillis;

  bool get isOnline => kind == client.OnlineEventKind.ONLINE_EVENT_KIND_JOINED;
}

class RoomRealtimeWebRtcSignal {
  const RoomRealtimeWebRtcSignal({
    required this.kind,
    required this.from,
    required this.to,
    required this.data,
  });

  final RoomRealtimeMessageKind kind;
  final String from;
  final String to;
  final String data;

  String get signalType {
    return switch (kind) {
      RoomRealtimeMessageKind.webrtcOffer => 'offer',
      RoomRealtimeMessageKind.webrtcAnswer => 'answer',
      RoomRealtimeMessageKind.webrtcIceCandidate => 'candidate',
      RoomRealtimeMessageKind.webrtcJoin => 'join',
      RoomRealtimeMessageKind.webrtcLeave => 'leave',
      _ => '',
    };
  }

  Map<String, dynamic> payload() {
    final result = <String, dynamic>{};
    if (data.isNotEmpty) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        result.addAll(decoded);
      }
    }
    if (from.isNotEmpty) result['from'] = from;
    if ((signalType == 'offer' || signalType == 'answer') &&
        result['type'] == null) {
      result['type'] = signalType;
    }
    return result;
  }
}

class RoomRealtimeMessage {
  const RoomRealtimeMessage({
    required this.kind,
    this.chatId = '',
    this.chatContent = '',
    this.senderUserId = '',
    this.senderUsername = '',
    this.timestampMillis = 0,
    this.images = const [],
    this.reactions = const [],
    this.reactionCount = 0,
    this.mentions = const [],
    this.chatPinEvent,
    this.chatEventId = '',
    this.chatEventKind = RoomRealtimeChatEventKind.created,
    this.chatDeleted = false,
    this.chatEdited = false,
    this.chatVersion = 0,
    this.chatEditedAt = 0,
    this.chatDeletedAt = 0,
    this.chatStatus = 0,
    this.chatMessageType = 1,
    this.chatDisplayPosition = '',
    this.chatDisplayColor = '',
    this.chatReplyToMessageId = '',
    this.status,
    this.playbackStatus,
    this.roomSettings,
    this.mediaLibrary,
    this.members,
    this.adminMembers,
    this.selfMember,
    this.onlineEvent,
    this.error,
    this.webRtc,
    this.resourceObserveId = '',
    this.resourceVersion = '',
    this.resourceEvent = false,
    this.resourceTotal = 0,
  });

  final RoomRealtimeMessageKind kind;
  final String chatId;
  final String chatContent;
  final String senderUserId;
  final String senderUsername;
  final int timestampMillis;
  final List<StoredImageInfo> images;
  final List<ChatReactionSummaryInfo> reactions;
  final int reactionCount;
  final List<ChatMentionInfo> mentions;
  final ChatPinEventInfo? chatPinEvent;
  final String chatEventId;
  final RoomRealtimeChatEventKind chatEventKind;
  final bool chatDeleted;
  final bool chatEdited;
  final int chatVersion;
  final int chatEditedAt;
  final int chatDeletedAt;
  final int chatStatus;
  final int chatMessageType;
  final String chatDisplayPosition;
  final String chatDisplayColor;
  final String chatReplyToMessageId;
  final RoomRealtimePlaybackStatus? status;
  final SyncTvPlaybackStatus? playbackStatus;
  final SyncTvRoomSettings? roomSettings;
  final RoomMediaLibraryPage? mediaLibrary;
  final List<SyncTvUser>? members;
  final List<AdminRoomMember>? adminMembers;
  final AdminRoomMember? selfMember;
  final RoomRealtimeOnlineEvent? onlineEvent;
  final RoomRealtimeError? error;
  final RoomRealtimeWebRtcSignal? webRtc;
  final String resourceObserveId;
  final String resourceVersion;
  final bool resourceEvent;
  final int resourceTotal;

  bool get isChatCreated => chatEventKind == RoomRealtimeChatEventKind.created;
  bool get isChatEdited => chatEventKind == RoomRealtimeChatEventKind.edited;
  bool get isChatDeleted =>
      chatDeleted || chatEventKind == RoomRealtimeChatEventKind.deleted;
}

class RoomRealtimeSession {
  const RoomRealtimeSession({
    required this.send,
    required this.messages,
    required this.events,
    required this.reconnects,
  });

  final void Function(List<int> bytes) send;
  final Stream<RoomRealtimeMessage> messages;
  final Stream<RealtimeEventLogEntry> events;
  final Stream<void> reconnects;
}

class RoomRealtimeChatEntry {
  const RoomRealtimeChatEntry({
    this.id = '',
    required this.userId,
    required this.username,
    required this.content,
    required this.timestampMillis,
    this.images = const [],
    this.reactions = const [],
    this.reactionCount = 0,
    this.mentions = const [],
    this.version = 0,
    this.isDeleted = false,
    this.isEdited = false,
    this.replyToMessageId = '',
    this.pin,
  });

  factory RoomRealtimeChatEntry.fromMessage(RoomRealtimeMessage message) {
    return RoomRealtimeChatEntry(
      id: message.chatId,
      userId: message.senderUserId,
      username: message.senderUsername.isEmpty
          ? 'Unknown'
          : message.senderUsername,
      content: message.chatContent,
      images: message.images,
      reactions: message.reactions,
      reactionCount: message.reactionCount,
      mentions: message.mentions,
      version: message.chatVersion,
      replyToMessageId: message.chatReplyToMessageId,
      timestampMillis: message.timestampMillis == 0
          ? SyncedClock.nowMillis()
          : message.timestampMillis,
      isDeleted: message.isChatDeleted,
      isEdited: message.isChatEdited,
      pin: message.chatPinEvent?.pin,
    );
  }

  factory RoomRealtimeChatEntry.fromHistory(RoomChatMessageInfo message) {
    return RoomRealtimeChatEntry(
      id: message.id,
      userId: message.userId,
      username: message.username.isEmpty ? 'Unknown' : message.username,
      content: message.content,
      images: message.images,
      reactions: message.reactions,
      reactionCount: message.reactionCount,
      mentions: message.mentions,
      version: message.version,
      replyToMessageId: message.replyToMessageId,
      timestampMillis: message.timestamp * 1000,
      isDeleted: message.isDeleted,
      isEdited: message.isEdited,
      pin: message.pin,
    );
  }

  final String id;
  final String userId;
  final String username;
  final String content;
  final int timestampMillis;
  final List<StoredImageInfo> images;
  final List<ChatReactionSummaryInfo> reactions;
  final int reactionCount;
  final List<ChatMentionInfo> mentions;
  final int version;
  final bool isDeleted;
  final bool isEdited;
  final String replyToMessageId;
  final ChatPinInfo? pin;

  String get dedupeKey {
    if (id.isNotEmpty) return 'id:$id';
    return 'local:$userId:$timestampMillis:$content';
  }

  String get timeLabel {
    var timestamp = timestampMillis;
    if (timestamp < 100000000000) timestamp *= 1000;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool get isPinned => pin != null;

  RoomRealtimeChatEntry copyWith({
    String? id,
    String? userId,
    String? username,
    String? content,
    int? timestampMillis,
    List<StoredImageInfo>? images,
    List<ChatReactionSummaryInfo>? reactions,
    int? reactionCount,
    List<ChatMentionInfo>? mentions,
    int? version,
    bool? isDeleted,
    bool? isEdited,
    String? replyToMessageId,
    ChatPinInfo? pin,
    bool clearPin = false,
  }) {
    return RoomRealtimeChatEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      timestampMillis: timestampMillis ?? this.timestampMillis,
      images: images ?? this.images,
      reactions: reactions ?? this.reactions,
      reactionCount: reactionCount ?? this.reactionCount,
      mentions: mentions ?? this.mentions,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      pin: clearPin ? null : pin ?? this.pin,
    );
  }
}

extension RoomRealtimeChatEntries on List<RoomRealtimeChatEntry> {
  void prependUnique(
    Iterable<RoomRealtimeChatEntry> entries, {
    required int maxEntries,
  }) {
    final existingKeys = map((message) => message.dedupeKey).toSet();
    final incoming = <RoomRealtimeChatEntry>[];
    for (final entry in entries) {
      if (existingKeys.add(entry.dedupeKey)) incoming.add(entry);
    }
    insertAll(0, incoming);
    trimToLatest(maxEntries);
  }

  void appendUnique(RoomRealtimeChatEntry entry, {required int maxEntries}) {
    if (any((message) => message.dedupeKey == entry.dedupeKey)) return;
    add(entry);
    trimToLatest(maxEntries);
  }

  void applyRealtimeEvent(
    RoomRealtimeChatEntry entry, {
    required RoomRealtimeChatEventKind eventKind,
    required int maxEntries,
  }) {
    final index = indexWhere((message) => message.dedupeKey == entry.dedupeKey);
    if (eventKind == RoomRealtimeChatEventKind.deleted || entry.isDeleted) {
      if (index >= 0) removeAt(index);
      return;
    }
    if (index >= 0) {
      this[index] = entry;
      return;
    }
    add(entry);
    trimToLatest(maxEntries);
  }

  void trimToLatest(int maxEntries) {
    if (length > maxEntries) {
      removeRange(0, length - maxEntries);
    }
  }
}

class RoomRealtimeCodec {
  static final Map<String, String> _playlistObserveParents = <String, String>{};
  static final Map<String, client.ResourceDeliveryMode> _observeDeliveryModes =
      <String, client.ResourceDeliveryMode>{};

  static RealtimeEventLogEntry describeOutgoing(List<int> data) {
    try {
      final message = client.ClientMessage.fromBuffer(data);
      return describeOutgoingMessage(message, byteLength: data.length);
    } catch (error) {
      return RealtimeEventLogEntry.outgoing(
        label: 'decode_error',
        detail: error.toString(),
        byteLength: data.length,
      );
    }
  }

  static RealtimeEventLogEntry describeOutgoingMessage(
    client.ClientMessage message, {
    int? byteLength,
  }) {
    final kind = realtimeEnumName(message.whichMessage());
    return RealtimeEventLogEntry.outgoing(
      label: kind,
      detail: _clientMessageDetail(message),
      byteLength: byteLength ?? message.writeToBuffer().length,
      payload: _clientMessagePayload(message),
    );
  }

  static RealtimeEventLogEntry describeIncoming(Uint8List data) {
    try {
      final message = client.ServerMessage.fromBuffer(data);
      final kind = realtimeEnumName(message.whichMessage());
      return RealtimeEventLogEntry.incoming(
        label: kind,
        detail: _serverMessageDetail(message),
        byteLength: data.length,
        payload: _protoJsonPayload(message),
      );
    } catch (error) {
      return RealtimeEventLogEntry.incoming(
        label: 'decode_error',
        detail: error.toString(),
        byteLength: data.length,
      );
    }
  }

  static List<int> encodeChat(
    String content, {
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    Iterable<ChatMentionInfo> mentions = const [],
  }) {
    return client.ClientMessage(
      chat: client.ChatMessageSend(
        content: content,
        displayPosition: displayPosition,
        displayColor: displayColor,
        replyToMessageId: replyToMessageId,
        mentions: mentions.map(_chatMentionInputFromInfo),
      ),
    ).writeToBuffer();
  }

  static List<int> encodeChatMessage({
    String content = '',
    Iterable<StoredImageInfo> images = const [],
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    Iterable<ChatMentionInfo> mentions = const [],
  }) {
    return client.ClientMessage(
      chat: client.ChatMessageSend(
        content: content,
        clientMessageId: 'msg_${SyncedClock.now().microsecondsSinceEpoch}',
        displayPosition: displayPosition,
        displayColor: displayColor,
        replyToMessageId: replyToMessageId,
        mentions: mentions.map(_chatMentionInputFromInfo),
        attachments: images.map(
          (image) => client.ChatAttachmentReference(
            id: image.id,
            kind: image.uploadReference
                ? client_enum
                      .ChatAttachmentReferenceKind
                      .CHAT_ATTACHMENT_REFERENCE_KIND_UPLOAD
                : client_enum
                      .ChatAttachmentReferenceKind
                      .CHAT_ATTACHMENT_REFERENCE_KIND_REUSE,
          ),
        ),
      ),
    ).writeToBuffer();
  }

  static client.ChatMentionInput _chatMentionInputFromInfo(
    ChatMentionInfo mention,
  ) {
    return client.ChatMentionInput(
      userId: mention.userId,
      start: mention.start,
      length: mention.length,
    );
  }

  static String _clientMessageDetail(client.ClientMessage message) {
    switch (message.whichMessage()) {
      case client.ClientMessage_Message.chat:
        return message.chat.content;
      case client.ClientMessage_Message.playbackUpdate:
        final update = message.playbackUpdate;
        return 'media=${update.mediaId} playlist=${update.playlistId} target=${providerTargetToJson(update.target).length}';
      case client.ClientMessage_Message.playbackStateUpdate:
        final update = message.playbackStateUpdate;
        return [
          realtimeEnumName(update.type),
          'pos=${update.position.toStringAsFixed(2)}',
          'playing=${update.playing}',
          'speed=${update.speed.toStringAsFixed(2)}',
        ].join(' ');
      case client.ClientMessage_Message.observeResource:
        final observe = message.observeResource;
        return '${observe.observeId} ${realtimeEnumName(observe.whichResource())}';
      case client.ClientMessage_Message.unobserveResource:
        return message.unobserveResource.observeId;
      case client.ClientMessage_Message.heartbeat:
        return 'ts=${message.heartbeat.timestamp}';
      case client.ClientMessage_Message.webrtc:
        return realtimeEnumName(message.webrtc.whichCommand());
      default:
        return '';
    }
  }

  static Object? _protoJsonPayload(GeneratedMessage message) {
    return message.toProto3Json();
  }

  static Map<String, Object?> _clientMessagePayload(
    client.ClientMessage message,
  ) {
    switch (message.whichMessage()) {
      case client.ClientMessage_Message.chat:
        final chat = message.chat;
        return {
          'chat': {
            'content': chat.content,
            if (chat.clientMessageId.isNotEmpty)
              'clientMessageId': chat.clientMessageId,
            if (chat.displayPosition.isNotEmpty)
              'displayPosition': chat.displayPosition,
            if (chat.displayColor.isNotEmpty) 'displayColor': chat.displayColor,
            if (chat.attachments.isNotEmpty)
              'attachments': chat.attachments.length,
          },
        };
      case client.ClientMessage_Message.heartbeat:
        return {
          'heartbeat': {'timestamp': message.heartbeat.timestamp.toString()},
        };
      case client.ClientMessage_Message.playbackStateUpdate:
        final update = message.playbackStateUpdate;
        return {
          'playbackStateUpdate': {
            'type': realtimeEnumName(update.type),
            if (update.hasPlaying()) 'playing': update.playing,
            if (update.hasPosition()) 'position': update.position,
            if (update.hasSpeed()) 'speed': update.speed,
            if (update.hasVersion()) 'version': update.version.toString(),
            if (update.hasExpectedMediaId())
              'expectedMediaId': update.expectedMediaId,
            if (update.hasExpectedPlaylistId())
              'expectedPlaylistId': update.expectedPlaylistId,
            if (update.hasExpectedTargetHash())
              'expectedTargetHash': update.expectedTargetHash,
          },
        };
      case client.ClientMessage_Message.playbackUpdate:
        final update = message.playbackUpdate;
        return {
          'playbackUpdate': {
            if (update.mediaId.isNotEmpty) 'mediaId': update.mediaId,
            if (update.playlistId.isNotEmpty) 'playlistId': update.playlistId,
            if (!providerTargetIsEmpty(update.target))
              'target': providerTargetToJson(update.target),
          },
        };
      case client.ClientMessage_Message.observeResource:
        final observe = message.observeResource;
        final payload = <String, Object?>{
          'observeId': observe.observeId,
          'deliveryMode': realtimeEnumName(observe.deliveryMode),
          'type': realtimeEnumName(observe.whichResource()),
        };
        if (observe.hasOnlineEvent()) {
          payload['onlineEvent'] = {
            'userIds': observe.onlineEvent.userIds.toList(),
            'roles': observe.onlineEvent.roles.map(realtimeEnumName).toList(),
            'kinds': observe.onlineEvent.kinds.map(realtimeEnumName).toList(),
          };
        }
        if (observe.hasOnlineCount()) {
          payload['onlineCount'] = {
            'userIds': observe.onlineCount.userIds.toList(),
            'roles': observe.onlineCount.roles.map(realtimeEnumName).toList(),
          };
        }
        return {'observeResource': payload};
      case client.ClientMessage_Message.unobserveResource:
        return {
          'unobserveResource': {
            'observeId': message.unobserveResource.observeId,
          },
        };
      case client.ClientMessage_Message.webrtc:
        return {
          'webrtc': {
            'command': realtimeEnumName(message.webrtc.whichCommand()),
          },
        };
      default:
        return {'kind': realtimeEnumName(message.whichMessage())};
    }
  }

  static String _serverMessageDetail(client.ServerMessage message) {
    switch (message.whichMessage()) {
      case client.ServerMessage_Message.resourceEvent:
        return '${message.resourceEvent.observeId} v${_cursorVersion(message.resourceEvent.eventCursor)}';
      case client.ServerMessage_Message.resourceObserved:
        return '${message.resourceObserved.observeId} v${_cursorVersion(message.resourceObserved.eventCursor)}';
      case client.ServerMessage_Message.resourceObserveError:
        return '${message.resourceObserveError.observeId}: ${message.resourceObserveError.error.message}';
      case client.ServerMessage_Message.error:
        return message.error.message;
      case client.ServerMessage_Message.heartbeatAck:
        return 'ts=${message.heartbeatAck.timestamp}';
      default:
        return realtimeEnumName(message.whichMessage());
    }
  }

  static client.ClientMessage buildPlaybackStateUpdateMessage(
    PlaybackControlAction action, {
    bool? isPlaying,
    double? position,
    double? playbackRate,
    int? version,
    String? expectedMediaId,
    String? expectedPlaylistId,
    String? expectedTargetHash,
  }) {
    final update = client.UpdatePlaybackStateRequest(
      type: switch (action) {
        PlaybackControlAction.play =>
          client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PLAY,
        PlaybackControlAction.pause =>
          client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PAUSE,
        PlaybackControlAction.seek =>
          client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK,
        PlaybackControlAction.speed =>
          client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED,
      },
    );
    if (isPlaying != null) update.playing = isPlaying;
    if (position != null) update.position = position;
    if (playbackRate != null) update.speed = playbackRate;
    if (version != null) update.version = Int64(version);
    if (expectedMediaId != null) update.expectedMediaId = expectedMediaId;
    if (expectedPlaylistId != null) {
      update.expectedPlaylistId = expectedPlaylistId;
    }
    if (expectedTargetHash != null) {
      update.expectedTargetHash = expectedTargetHash;
    }
    return client.ClientMessage(playbackStateUpdate: update);
  }

  static List<int> encodePlaybackStateUpdate(
    PlaybackControlAction action, {
    bool? isPlaying,
    double? position,
    double? playbackRate,
    int? version,
    String? expectedMediaId,
    String? expectedPlaylistId,
    String? expectedTargetHash,
  }) {
    return buildPlaybackStateUpdateMessage(
      action,
      isPlaying: isPlaying,
      position: position,
      playbackRate: playbackRate,
      version: version,
      expectedMediaId: expectedMediaId,
      expectedPlaylistId: expectedPlaylistId,
      expectedTargetHash: expectedTargetHash,
    ).writeToBuffer();
  }

  static client.ClientMessage buildGuardedPlaybackStateUpdateMessage(
    PlaybackControlAction action,
    SyncTvPlaybackStatus? currentStatus, {
    bool? isPlaying,
    double? position,
    double? playbackRate,
  }) {
    final status = currentStatus;
    return buildPlaybackStateUpdateMessage(
      action,
      isPlaying: isPlaying,
      position: position,
      playbackRate: playbackRate,
      expectedMediaId: status?.playingMediaId,
      expectedPlaylistId: status?.playingPlaylistId,
      expectedTargetHash: status?.targetHash,
    );
  }

  static List<int> encodeSync() {
    return client.ClientMessage(
      heartbeat: client.HeartbeatMessage(
        timestamp: Int64(SyncedClock.nowMillis()),
      ),
    ).writeToBuffer();
  }

  static List<List<int>> encodeInitialObservations({
    String afterChatEventId = '',
  }) {
    return [
      ...encodePlaybackObservations(),
      encodeRoomSettingsObservation(),
      encodePlaylistObservation(),
      encodeSelfRoomMemberObservation(),
      encodeOnlineCountObservation(),
      encodeChatEventsObservation(afterEventId: afterChatEventId),
    ];
  }

  static List<List<int>> encodePlaybackObservations() {
    return [
      _observe('playback_state', playbackState: client.ObservePlaybackState()),
      _observe(
        'playback',
        playback: client.ObservePlayback(
          playbackClientProfile: defaultPlaybackClientProfile(),
        ),
      ),
    ];
  }

  static List<int> encodePlaylistObservation({
    String observeId = 'playlist_items',
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
    if (playlistId.isEmpty) {
      _playlistObserveParents.remove(observeId);
    } else {
      _playlistObserveParents[observeId] = playlistId;
    }
    return _observe(
      observeId,
      playlistItems: client.ObservePlaylistItems(
        afterEventSequence: _watchSequence(version),
        request: client.ListPlaylistItemsRequest(
          playlistId: playlistId,
          target: providerTargetFromBase64(target),
          page: page,
          pageSize: pageSize,
          search: search,
          sourceProvider: SourceConfigCodec.providerFromString(sourceProvider),
          providerInstanceName: providerInstanceName,
          sortBy: sortBy,
          sortDirection: sortDirection,
          availability: availability,
        ),
      ),
    );
  }

  static List<int> encodeRoomMemberEventsObservation({
    String observeId = 'room_member_events',
    String version = '',
  }) {
    return _observe(
      observeId,
      deliveryMode:
          client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
      roomMemberEvents: client.ObserveRoomMemberEvents(
        afterEventSequence: _watchSequence(version),
      ),
    );
  }

  static List<int> encodeSelfRoomMemberObservation({
    String observeId = 'self_room_member',
    String version = '',
  }) {
    return _observe(
      observeId,
      selfRoomMember: client.ObserveSelfRoomMember(
        afterEventSequence: _watchSequence(version),
      ),
    );
  }

  static List<int> encodeRoomMembersObservation({
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
  }) {
    return encodeRoomMemberEventsObservation(
      observeId: observeId,
      version: version,
    );
  }

  static List<int> encodeOnlineCountObservation({
    String observeId = 'online_count',
    Iterable<String> userIds = const [],
    Iterable<common_enum.RoomMemberRole> roles = const [],
  }) {
    return _observe(
      observeId,
      onlineCount: client.ObserveOnlineCount(
        userIds: userIds.where((id) => id.trim().isNotEmpty).toSet(),
        roles: roles,
      ),
    );
  }

  static List<int> encodeOnlineEventObservation({
    String observeId = 'online_events',
    Iterable<String> userIds = const [],
    Iterable<common_enum.RoomMemberRole> roles = const [],
    Iterable<client.OnlineEventKind> kinds = const [],
  }) {
    return _observe(
      observeId,
      deliveryMode:
          client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
      onlineEvent: client.ObserveOnlineEvent(
        userIds: userIds.where((id) => id.trim().isNotEmpty).toSet(),
        roles: roles,
        kinds: kinds,
      ),
    );
  }

  static List<int> encodeRoomSettingsObservation({
    String observeId = 'room_settings',
    String version = '',
  }) {
    return _observe(
      observeId,
      roomSettings: client.ObserveRoomSettings(
        afterEventSequence: _watchSequence(version),
      ),
    );
  }

  static List<int> encodeChatEventsObservation({
    String observeId = 'chat_events',
    String version = '',
    String afterEventId = '',
  }) {
    final cursor = afterEventId.isEmpty ? version : afterEventId;
    return _observe(
      observeId,
      deliveryMode:
          client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
      chatEvents: client.ObserveChatEvents(
        afterEventSequence: _watchSequence(cursor),
        includeMessageTypes: const [
          client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
          client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED,
        ],
      ),
    );
  }

  static List<int> encodeChatPinEventsObservation({
    String observeId = 'chat_pin_events',
    String version = '',
  }) {
    return _observe(
      observeId,
      deliveryMode:
          client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
      chatPinEvents: client.ObserveChatPinEvents(
        afterEventSequence: _watchSequence(version),
      ),
    );
  }

  static List<int> encodeUnobserveResource(String observeId) {
    _observeDeliveryModes.remove(observeId);
    _playlistObserveParents.remove(observeId);
    return client.ClientMessage(
      unobserveResource: client.UnobserveResource(observeId: observeId),
    ).writeToBuffer();
  }

  static List<int> _observe(
    String observeId, {
    client.ObservePlaybackState? playbackState,
    client.ObservePlayback? playback,
    client.ObserveRoomSettings? roomSettings,
    client.ObservePlaylistItems? playlistItems,
    client.ObserveRoomMemberEvents? roomMemberEvents,
    client.ObserveChatEvents? chatEvents,
    client.ObserveChatPinEvents? chatPinEvents,
    client.ObserveOnlineCount? onlineCount,
    client.ObserveOnlineEvent? onlineEvent,
    client.ObserveSelfRoomMember? selfRoomMember,
    client.ResourceDeliveryMode deliveryMode =
        client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
  }) {
    _observeDeliveryModes[observeId] = deliveryMode;
    return client.ClientMessage(
      observeResource: client.ObserveResource(
        observeId: observeId,
        deliveryMode: deliveryMode,
        playbackState: playbackState,
        playback: playback,
        roomSettings: roomSettings,
        playlistItems: playlistItems,
        roomMemberEvents: roomMemberEvents,
        chatEvents: chatEvents,
        chatPinEvents: chatPinEvents,
        onlineCount: onlineCount,
        onlineEvent: onlineEvent,
        selfRoomMember: selfRoomMember,
      ),
    ).writeToBuffer();
  }

  static List<int> encodeWebRTC(
    RoomRealtimeMessageKind type,
    Map<String, dynamic> data,
  ) {
    final payload = (data['data'] ?? '').toString();
    final to = (data['to'] ?? '').toString();
    final command = client.WebRtcCommand();
    switch (type) {
      case RoomRealtimeMessageKind.webrtcOffer:
        command.offer = client.WebRTCOffer(to: to, data: payload);
        break;
      case RoomRealtimeMessageKind.webrtcAnswer:
        command.answer = client.WebRTCAnswer(to: to, data: payload);
        break;
      case RoomRealtimeMessageKind.webrtcIceCandidate:
        command.iceCandidate = client.WebRTCIceCandidate(to: to, data: payload);
        break;
      case RoomRealtimeMessageKind.webrtcJoin:
        command.join = client.WebRTCJoin();
        break;
      case RoomRealtimeMessageKind.webrtcLeave:
        command.leave = client.WebRTCLeave();
        break;
      default:
        return Uint8List(0);
    }
    final message = client.ClientMessage(webrtc: command);
    return message.writeToBuffer();
  }

  static List<int> encodeWebRtcSignal(String type, Map<String, dynamic> data) {
    final messageKind = switch (type) {
      'offer' => RoomRealtimeMessageKind.webrtcOffer,
      'answer' => RoomRealtimeMessageKind.webrtcAnswer,
      'candidate' => RoomRealtimeMessageKind.webrtcIceCandidate,
      'join' => RoomRealtimeMessageKind.webrtcJoin,
      'leave' => RoomRealtimeMessageKind.webrtcLeave,
      _ => RoomRealtimeMessageKind.unknown,
    };
    if (messageKind == RoomRealtimeMessageKind.unknown) return Uint8List(0);

    final payload = <String, dynamic>{'data': jsonEncode(data)};
    final to = data['to'];
    if (to != null) payload['to'] = to;
    return encodeWebRTC(messageKind, payload);
  }

  static RoomRealtimeMessage decode(Uint8List data) {
    final message = client.ServerMessage.fromBuffer(data);
    switch (message.whichMessage()) {
      case client.ServerMessage_Message.heartbeatAck:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.checkStatus,
          timestampMillis: message.heartbeatAck.timestamp.toInt() * 1000,
        );
      case client.ServerMessage_Message.error:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.error,
          error: RoomRealtimeError(
            message: message.error.message,
            code: message.error.code,
            detail: message.error.detail,
          ),
        );
      case client.ServerMessage_Message.resourceEvent:
        return _resourceEvent(message.resourceEvent);
      case client.ServerMessage_Message.resourceObserved:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.checkStatus,
          resourceObserveId: message.resourceObserved.observeId,
          resourceVersion: _cursorVersion(message.resourceObserved.eventCursor),
          resourceEvent: message.resourceObserved.changed,
        );
      case client.ServerMessage_Message.resourceObserveError:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.error,
          resourceObserveId: message.resourceObserveError.observeId,
          error: RoomRealtimeError(
            message: message.resourceObserveError.error.message,
            code: message.resourceObserveError.error.code,
            detail: message.resourceObserveError.error.detail,
          ),
        );
      default:
        return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.unknown);
    }
  }

  static RoomRealtimeMessage _chatEvent(
    client.ChatMessageEvent event, {
    String observeId = '',
    String version = '',
  }) {
    if (!event.hasMessage()) {
      return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.unknown);
    }
    return _chatMessage(
      event.message,
      observeId: observeId,
      version: version.isEmpty ? event.eventId : version,
      eventId: event.eventId,
      eventKind: _chatEventKind(event.kind),
    );
  }

  static RoomRealtimeMessage _chatMessage(
    client.ChatMessageReceive chat, {
    String observeId = '',
    String version = '',
    String eventId = '',
    RoomRealtimeChatEventKind eventKind = RoomRealtimeChatEventKind.created,
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.chat,
      chatId: chat.id,
      chatContent: chat.content,
      timestampMillis: chat.timestamp.toInt() * 1000,
      senderUserId: chat.userId,
      senderUsername: chat.username,
      chatEventId: eventId,
      chatEventKind: eventKind,
      chatDeleted:
          chat.deletedAt.toInt() > 0 ||
          chat.status ==
              client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_DELETED,
      chatEdited:
          chat.editedAt.toInt() > 0 ||
          chat.status ==
              client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_EDITED,
      chatVersion: chat.version.toInt(),
      chatEditedAt: chat.editedAt.toInt(),
      chatDeletedAt: chat.deletedAt.toInt(),
      chatStatus: chat.status.value,
      chatMessageType: chat.messageType.value,
      chatReplyToMessageId: chat.replyToMessageId,
      chatDisplayPosition: chat.displayPosition,
      chatDisplayColor: chat.displayColor,
      resourceObserveId: observeId,
      resourceVersion: version,
      reactions: chat.reactions
          .map(
            (reaction) => ChatReactionSummaryInfo(
              key: reaction.key,
              count: reaction.count.toInt(),
              reactedByMe: reaction.reactedByMe,
            ),
          )
          .toList(),
      reactionCount: chat.reactionCount,
      mentions: chat.mentions
          .map(
            (mention) => ChatMentionInfo(
              userId: mention.userId,
              username: mention.username,
              start: mention.start,
              length: mention.length,
            ),
          )
          .toList(),
      images: chat.attachments
          .map(
            (attachment) => StoredImageInfo(
              id: attachment.id,
              storageBackend: '',
              objectKey: '',
              url: attachment.url,
              mimeType: attachment.mimeType,
              sizeBytes: attachment.sizeBytes.toInt(),
              width: attachment.width,
              height: attachment.height,
              metadata: utf8.encode(
                jsonEncode(fileMetadataToJson(attachment.metadata)),
              ),
            ),
          )
          .toList(),
    );
  }

  static RoomRealtimeChatEventKind _chatEventKind(
    client_enum.ChatMessageEventKind kind,
  ) {
    return switch (kind) {
      client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_EDITED =>
        RoomRealtimeChatEventKind.edited,
      client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_DELETED =>
        RoomRealtimeChatEventKind.deleted,
      client_enum
          .ChatMessageEventKind
          .CHAT_MESSAGE_EVENT_KIND_REACTIONS_CHANGED =>
        RoomRealtimeChatEventKind.reactionsChanged,
      _ => RoomRealtimeChatEventKind.created,
    };
  }

  static RoomRealtimeMessage _playbackState(client.PlaybackState state) {
    final playbackStatus = _playbackStatusFromState(state);
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.status,
      status: RoomRealtimePlaybackStatus(
        isPlaying: playbackStatus.isPlaying,
        currentTime: playbackStatus.currentTime,
        playbackRate: playbackStatus.playbackRate,
      ),
      playbackStatus: playbackStatus,
    );
  }

  static RoomRealtimeMessage _playback(client.Playback playback) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.current,
      playbackStatus: _playbackStatusFromPlayback(playback),
    );
  }

  static RoomRealtimeMessage _playlistItems(
    client.ListPlaylistItemsResponse response, {
    String observeId = '',
    String version = '',
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.mediaLibrary,
      mediaLibrary: _mediaLibraryPageFromProto(
        response,
        parentId: _playlistObserveParents[observeId] ?? '',
      ),
      resourceObserveId: observeId,
      resourceVersion: version,
    );
  }

  static RoomRealtimeMessage _roomSettings(
    client.GetRoomSettingsResponse changed, {
    String observeId = '',
    String version = '',
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.roomSettings,
      roomSettings: SyncTvRoomSettings.fromJson(
        roomSettingsToJson(changed.settings),
      ),
      resourceObserveId: observeId,
      resourceVersion: version,
    );
  }

  static RoomRealtimeMessage _roomMemberEvent(
    client.RoomMemberEvent event, {
    String observeId = '',
    String version = '',
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.memberEvent,
      members: event.hasMember()
          ? <SyncTvUser>[_memberFromProto(event.member)]
          : const <SyncTvUser>[],
      adminMembers: event.hasMember()
          ? <AdminRoomMember>[_adminMemberFromProto(event.member)]
          : const <AdminRoomMember>[],
      senderUserId: event.userId.isNotEmpty ? event.userId : event.guestId,
      senderUsername: event.username,
      timestampMillis: event.occurredAt.toInt() * 1000,
      resourceObserveId: observeId,
      resourceVersion: version,
    );
  }

  static RoomRealtimeMessage _resourceEvent(client.ResourceEvent changed) {
    switch (changed.whichPayload()) {
      case client.ResourceEvent_Payload.playbackState:
        return _playbackState(changed.playbackState);
      case client.ResourceEvent_Payload.playback:
        return _playback(changed.playback);
      case client.ResourceEvent_Payload.roomSettings:
        return _roomSettings(
          changed.roomSettings,
          observeId: changed.observeId,
          version: _cursorVersion(changed.eventCursor),
        );
      case client.ResourceEvent_Payload.playlistItems:
        return _playlistItems(
          changed.playlistItems,
          observeId: changed.observeId,
          version: _cursorVersion(changed.eventCursor),
        );
      case client.ResourceEvent_Payload.roomMemberEvent:
        return _roomMemberEvent(
          changed.roomMemberEvent,
          observeId: changed.observeId,
          version: _cursorVersion(changed.eventCursor),
        );
      case client.ResourceEvent_Payload.selfRoomMember:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.myStatus,
          selfMember: _adminMemberFromProto(changed.selfRoomMember),
          members: <SyncTvUser>[_memberFromProto(changed.selfRoomMember)],
          adminMembers: <AdminRoomMember>[
            _adminMemberFromProto(changed.selfRoomMember),
          ],
          resourceObserveId: changed.observeId,
          resourceVersion: _cursorVersion(changed.eventCursor),
        );
      case client.ResourceEvent_Payload.chatEvent:
        return _chatEvent(
          changed.chatEvent,
          observeId: changed.observeId,
          version: _cursorVersion(changed.eventCursor),
        );
      case client.ResourceEvent_Payload.chatPinEvent:
        return _chatPinEvent(
          changed.chatPinEvent,
          observeId: changed.observeId,
          version: _cursorVersion(changed.eventCursor),
        );
      case client.ResourceEvent_Payload.onlineCount:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.viewerCount,
          resourceObserveId: changed.observeId,
          resourceVersion: _cursorVersion(changed.eventCursor),
          resourceTotal: changed.onlineCount.count,
        );
      case client.ResourceEvent_Payload.onlineEvent:
        return _onlineEvent(
          changed.onlineEvent,
          observeId: changed.observeId,
          version: _cursorVersion(changed.eventCursor),
        );
      case client.ResourceEvent_Payload.webrtcEvent:
        return _webrtcEvent(changed.webrtcEvent);
      case client.ResourceEvent_Payload.changedOnly:
        if (_isNotifyOnlyObserveId(changed.observeId)) {
          return RoomRealtimeMessage(
            kind: RoomRealtimeMessageKind.checkStatus,
            resourceObserveId: changed.observeId,
            resourceVersion: _cursorVersion(changed.eventCursor),
            resourceEvent: true,
          );
        }
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.error,
          error: RoomRealtimeError(
            message: '服务端未推送资源快照: ${changed.observeId}',
            code: 0,
            detail:
                'ResourceEvent used changed_only while the client requested PUSH_SNAPSHOT.',
          ),
        );
      default:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.error,
          error: RoomRealtimeError(
            message: '服务端推送了空资源变更: ${changed.observeId}',
            code: 0,
            detail: 'ResourceEvent has no payload.',
          ),
        );
    }
  }

  static RoomRealtimeMessage _chatPinEvent(
    client.ChatPinEvent event, {
    String observeId = '',
    String version = '',
  }) {
    if (!event.hasMessage()) {
      return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.unknown);
    }
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.chatPin,
      chatId: event.message.id,
      chatContent: event.message.content,
      timestampMillis: event.occurredAt.toInt() * 1000,
      senderUserId: event.message.userId,
      senderUsername: event.message.username,
      chatPinEvent: ChatPinEventInfo(
        eventId: event.eventId,
        roomId: event.roomId,
        kind: event.kind.value,
        message: _chatMessageInfoFromProto(event.message),
        pin: event.hasPin() ? _chatPinFromProto(event.pin) : null,
        occurredAt: event.occurredAt.toInt(),
        sequence: event.sequence.toInt(),
      ),
      resourceObserveId: observeId,
      resourceVersion: version.isEmpty ? event.sequence.toString() : version,
    );
  }

  static RoomChatMessageInfo _chatMessageInfoFromProto(
    client.ChatMessageReceive message,
  ) {
    return RoomChatMessageInfo(
      id: message.id,
      roomId: message.roomId,
      userId: message.userId,
      username: message.username,
      content: message.content,
      timestamp: message.timestamp.toInt(),
      messageType: message.messageType.value,
      displayPosition: message.displayPosition,
      displayColor: message.displayColor,
      version: message.version.toInt(),
      editedAt: message.editedAt.toInt(),
      deletedAt: message.deletedAt.toInt(),
      status: message.status.value,
      replyToMessageId: message.replyToMessageId,
      images: message.attachments
          .map(
            (attachment) => StoredImageInfo(
              id: attachment.id,
              storageBackend: '',
              objectKey: '',
              url: attachment.url,
              mimeType: attachment.mimeType,
              sizeBytes: attachment.sizeBytes.toInt(),
              width: attachment.width,
              height: attachment.height,
              metadata: utf8.encode(
                jsonEncode(fileMetadataToJson(attachment.metadata)),
              ),
            ),
          )
          .toList(),
      reactions: message.reactions
          .map(
            (reaction) => ChatReactionSummaryInfo(
              key: reaction.key,
              count: reaction.count.toInt(),
              reactedByMe: reaction.reactedByMe,
            ),
          )
          .toList(),
      reactionCount: message.reactionCount,
      mentions: message.mentions
          .map(
            (mention) => ChatMentionInfo(
              userId: mention.userId,
              username: mention.username,
              start: mention.start,
              length: mention.length,
            ),
          )
          .toList(),
      pin: message.hasPin() ? _chatPinFromProto(message.pin) : null,
    );
  }

  static ChatPinInfo _chatPinFromProto(client.ChatMessagePin pin) {
    return ChatPinInfo(
      pinnedByUserId: pin.pinnedByUserId,
      pinnedByUsername: pin.pinnedByUsername,
      note: pin.note,
      pinnedAt: pin.pinnedAt.toInt(),
    );
  }

  static bool _isNotifyOnlyObserveId(String observeId) {
    return _observeDeliveryModes[observeId] ==
        client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY;
  }

  static RoomRealtimeMessage _onlineEvent(
    client.OnlineEvent event, {
    String observeId = '',
    String version = '',
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.onlineEvent,
      senderUserId: event.userId,
      senderUsername: event.username,
      timestampMillis: event.occurredAt.toInt() * 1000,
      onlineEvent: RoomRealtimeOnlineEvent(
        userId: event.userId,
        username: event.username,
        role: event.role,
        kind: event.kind,
        occurredAtMillis: event.occurredAt.toInt() * 1000,
      ),
      resourceObserveId: observeId,
      resourceVersion: version,
    );
  }

  static SyncTvPlaybackStatus _playbackStatusFromState(
    client.PlaybackState state,
  ) {
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
    );
  }

  static SyncTvPlaybackStatus _playbackStatusFromPlayback(
    client.Playback playback,
  ) {
    final entry = playback.mediaId.isEmpty && playback.playlistId.isEmpty
        ? null
        : RoomMediaEntry.fromPlaybackProto(playback);
    return SyncTvPlaybackStatus(entry: entry);
  }

  static Int64? _watchSequence(String version) {
    if (version.isEmpty) return null;
    final parsed = int.tryParse(version);
    return parsed == null ? null : Int64(parsed);
  }

  static String _cursorVersion(client.EventCursor cursor) {
    final sequence = cursor.sequence.toInt();
    return sequence == 0 ? cursor.eventId : sequence.toString();
  }

  static RoomMediaLibraryPage _mediaLibraryPageFromProto(
    client.ListPlaylistItemsResponse response, {
    String parentId = '',
  }) {
    final resolvedParentId = parentId.isNotEmpty
        ? parentId
        : response.currentPath.isEmpty
        ? ''
        : response.currentPath.last.playlistId;
    return RoomMediaLibraryPage(
      playlists: response.playlists.map(_playlistFromProto).toList(),
      media: response.media.map(_mediaFromProto).toList(),
      dynamicItems: response.dynamicItems
          .map(
            (item) => _dynamicItemFromProto(item, playlistId: resolvedParentId),
          )
          .toList(),
      currentPath: response.currentPath.map(_browsePathFromProto).toList(),
      total: response.total,
      folderCount: response.folderCount,
      fileCount: response.fileCount,
      version: response.version,
    );
  }

  static PlaylistBrowsePathInfo _browsePathFromProto(
    client.PlaylistBrowsePathNode node,
  ) {
    return PlaylistBrowsePathInfo(
      playlistId: node.playlistId,
      name: node.name,
      target: providerTargetToBase64(node.target),
    );
  }

  static RoomMediaItem _mediaFromProto(client.Media media) {
    final metadata = media.hasMetadata()
        ? resourceMetadataToJson(media.metadata)
        : <String, dynamic>{};
    final sourceConfig = media.hasSourceConfig()
        ? SourceConfigCodec.mediaSourceConfigToMap(media.sourceConfig)
        : <String, dynamic>{};
    final sourceProvider = media.hasSourceProvider()
        ? SourceConfigCodec.providerToString(media.sourceProvider)
        : SourceConfigCodec.providerForMediaSourceConfig(media.sourceConfig);
    return RoomMediaItem(
      id: media.id,
      name: media.name,
      url: RoomMediaEntry.playbackUrlFromResource(
        metadata: metadata,
        sourceConfig: sourceConfig,
      ),
      creator: media.creatorId,
      roomId: media.roomId,
      position: media.position,
      addedAt: media.addedAt.toInt(),
      availability: media.availability.value,
      version: media.version.toInt(),
      type: sourceProvider,
      headers: _stringMap(metadata['headers']),
      proxy: metadata['proxy'] == true,
      live:
          sourceProvider == 'rtmp' ||
          (sourceProvider == 'bilibili' && sourceConfig['type'] == 'live') ||
          metadata['isLive'] == true,
      sourceProvider: sourceProvider,
      providerInstanceName: media.providerInstanceName,
      sourceConfig: sourceConfig,
      metadata: metadata,
      description: media.description,
      coverUrl: media.hasCover() ? media.cover.url : '',
      thumbnailUrl: media.hasThumbnail() ? media.thumbnail.url : '',
    );
  }

  static RoomPlaylistItem _playlistFromProto(client.Playlist playlist) {
    final sourceProvider = playlist.hasSourceProvider()
        ? SourceConfigCodec.providerToString(playlist.sourceProvider)
        : SourceConfigCodec.providerForPlaylistSourceConfig(
            playlist.sourceConfig,
          );
    final sourceConfig = playlist.hasSourceConfig()
        ? SourceConfigCodec.playlistSourceConfigToMap(playlist.sourceConfig)
        : <String, dynamic>{};
    return RoomPlaylistItem(
      id: playlist.id,
      name: playlist.name,
      creator: playlist.creatorId,
      roomId: playlist.roomId,
      parentId: playlist.parentId.isEmpty ? null : playlist.parentId,
      position: playlist.position,
      createdAt: playlist.createdAt.toInt(),
      updatedAt: playlist.updatedAt.toInt(),
      itemCount: playlist.itemCount,
      availability: playlist.availability.value,
      version: playlist.version.toInt(),
      description: playlist.description,
      coverUrl: playlist.hasCover() ? playlist.cover.url : '',
      type: playlist.isDynamic ? sourceProvider : 'playlist',
      sourceProvider: sourceProvider,
      providerInstanceName: playlist.providerInstanceName,
      sourceConfig: sourceConfig,
      metadata: {'isDynamic': playlist.isDynamic},
    );
  }

  static RoomDynamicMediaEntry _dynamicItemFromProto(
    client.PlaylistItem item, {
    required String playlistId,
  }) {
    final target = item.target;
    final encodedTarget = providerTargetToBase64(target);
    final thumbnailUrl = item.hasThumbnail() ? item.thumbnail : '';
    return RoomDynamicMediaEntry(
      id: encodedTarget,
      name: item.name,
      isFolder: item.itemType == client_enum.ItemType.ITEM_TYPE_PLAYLIST,
      parentId: playlistId,
      subPath: encodedTarget,
      coverUrl: thumbnailUrl,
      metadata: {
        'target': target,
        'target_json': providerTargetToJson(target),
        'thumbnail': thumbnailUrl,
        'size': item.hasSize() ? item.size.toInt() : null,
      },
    );
  }

  static SyncTvUser _memberFromProto(common.RoomMember member) {
    return SyncTvUser(
      id: member.userId,
      username: member.username,
      role: member.role.value,
      createdAt: member.joinedAt.toInt(),
      status: common_enum.MemberStatus.MEMBER_STATUS_ACTIVE.value,
      onlineCount: member.isOnline ? 1 : 0,
    );
  }

  static AdminRoomMember _adminMemberFromProto(common.RoomMember member) {
    return AdminRoomMember(
      roomId: member.roomId,
      userId: member.userId,
      username: member.username,
      remarkName: member.remarkName,
      displayTag: member.displayTag,
      role: member.role.value,
      permissions: member.permissions.toInt(),
      addedPermissions: member.addedPermissions.toInt(),
      removedPermissions: member.removedPermissions.toInt(),
      adminAddedPermissions: member.adminAddedPermissions.toInt(),
      adminRemovedPermissions: member.adminRemovedPermissions.toInt(),
      joinedAt: member.joinedAt.toInt(),
      isOnline: member.isOnline,
    );
  }

  static Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }

  static RoomRealtimeMessage _webrtc(
    RoomRealtimeMessageKind type,
    String from,
    String to,
    String data,
  ) {
    return RoomRealtimeMessage(
      kind: type,
      webRtc: RoomRealtimeWebRtcSignal(
        kind: type,
        from: from,
        to: to,
        data: data,
      ),
    );
  }

  static RoomRealtimeMessage _webrtcEvent(client.WebRtcEvent event) {
    switch (event.whichEvent()) {
      case client.WebRtcEvent_Event.offer:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcOffer,
          event.offer.from,
          event.offer.to,
          event.offer.data,
        );
      case client.WebRtcEvent_Event.answer:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcAnswer,
          event.answer.from,
          event.answer.to,
          event.answer.data,
        );
      case client.WebRtcEvent_Event.iceCandidate:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcIceCandidate,
          event.iceCandidate.from,
          event.iceCandidate.to,
          event.iceCandidate.data,
        );
      case client.WebRtcEvent_Event.join:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcJoin,
          '${event.join.userId}:${event.join.connId}',
          '',
          jsonEncode({
            'user_id': event.join.userId,
            'conn_id': event.join.connId,
            'username': event.join.username,
          }),
        );
      case client.WebRtcEvent_Event.leave:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcLeave,
          '${event.leave.userId}:${event.leave.connId}',
          '',
          jsonEncode({
            'user_id': event.leave.userId,
            'conn_id': event.leave.connId,
          }),
        );
      default:
        return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.unknown);
    }
  }
}
