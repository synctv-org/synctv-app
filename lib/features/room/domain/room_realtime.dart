import 'dart:convert';

import 'package:synctv_app/features/room/domain/realtime_event_log.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/contracts/synctv_models.dart';

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
  playbackHistory,
  presenceCount,
  memberEvent,
  onlineEvent,
  chatPin,
  sync,
  myStatus,
  webrtcVoiceOffer,
  webrtcVoiceAnswer,
  webrtcVoiceIceCandidate,
  webrtcVoicePeerJoined,
  webrtcVoicePeerLeft,
  webrtcMediaOffer,
  webrtcMediaAnswer,
  webrtcMediaIceCandidate,
  webrtcMediaSwarmPeers,
  webrtcMediaPeerLeft,
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
    this.clientOperationId = '',
  });

  final String message;
  final int code;
  final String detail;
  final String clientOperationId;

  bool get isConflict => code == 2003;

  bool get isPermissionDenied => code == 4000;
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

sealed class RoomRealtimeWebRtcSignal {
  const RoomRealtimeWebRtcSignal({required this.kind});

  final RoomRealtimeMessageKind kind;

  String get signalType {
    return switch (kind) {
      RoomRealtimeMessageKind.webrtcVoiceOffer ||
      RoomRealtimeMessageKind.webrtcMediaOffer => 'offer',
      RoomRealtimeMessageKind.webrtcVoiceAnswer ||
      RoomRealtimeMessageKind.webrtcMediaAnswer => 'answer',
      RoomRealtimeMessageKind.webrtcVoiceIceCandidate ||
      RoomRealtimeMessageKind.webrtcMediaIceCandidate => 'candidate',
      RoomRealtimeMessageKind.webrtcVoicePeerJoined => 'join',
      RoomRealtimeMessageKind.webrtcVoicePeerLeft => 'leave',
      RoomRealtimeMessageKind.webrtcMediaSwarmPeers => 'media_swarm_peers',
      RoomRealtimeMessageKind.webrtcMediaPeerLeft => 'media_swarm_leave',
      _ => '',
    };
  }

  Map<String, dynamic> payload();
}

sealed class RoomRealtimeWebRtcVoiceSignal extends RoomRealtimeWebRtcSignal {
  const RoomRealtimeWebRtcVoiceSignal({required super.kind});
}

final class RoomRealtimeWebRtcVoiceNegotiationSignal
    extends RoomRealtimeWebRtcVoiceSignal {
  const RoomRealtimeWebRtcVoiceNegotiationSignal({
    required super.kind,
    required this.from,
    required this.data,
  });

  final String from;
  final String data;

  @override
  Map<String, dynamic> payload() =>
      _webRtcNegotiationPayload(data, from, signalType);
}

final class RoomRealtimeWebRtcVoicePeerJoinedSignal
    extends RoomRealtimeWebRtcVoiceSignal {
  const RoomRealtimeWebRtcVoicePeerJoinedSignal({
    required super.kind,
    required this.userId,
    required this.connId,
    required this.username,
  });

  final String userId;
  final String connId;
  final String username;

  @override
  Map<String, dynamic> payload() => {
    'user_id': userId,
    'conn_id': connId,
    'username': username,
    'from': '$userId:$connId',
  };
}

final class RoomRealtimeWebRtcVoicePeerLeftSignal
    extends RoomRealtimeWebRtcVoiceSignal {
  const RoomRealtimeWebRtcVoicePeerLeftSignal({
    required super.kind,
    required this.userId,
    required this.connId,
  });

  final String userId;
  final String connId;

  @override
  Map<String, dynamic> payload() => {
    'user_id': userId,
    'conn_id': connId,
    'from': '$userId:$connId',
  };
}

sealed class RoomRealtimeWebRtcMediaSignal extends RoomRealtimeWebRtcSignal {
  const RoomRealtimeWebRtcMediaSignal({required super.kind});
}

final class RoomRealtimeWebRtcMediaNegotiationSignal
    extends RoomRealtimeWebRtcMediaSignal {
  const RoomRealtimeWebRtcMediaNegotiationSignal({
    required super.kind,
    required this.from,
    required this.data,
    required this.swarmId,
  });

  final String from;
  final String data;
  final String swarmId;

  @override
  Map<String, dynamic> payload() => {
    ..._webRtcNegotiationPayload(data, from, signalType),
    'media_swarm_id': swarmId,
  };
}

final class RoomRealtimeWebRtcMediaSwarmPeersSignal
    extends RoomRealtimeWebRtcMediaSignal {
  const RoomRealtimeWebRtcMediaSwarmPeersSignal({
    required super.kind,
    required this.swarmId,
    required this.swarmTicket,
    required this.peers,
  });

  final String swarmId;
  final String swarmTicket;
  final List<RoomRealtimeWebRtcPeer> peers;

  @override
  Map<String, dynamic> payload() => {
    'media_swarm_id': swarmId,
    'media_swarm_ticket': swarmTicket,
    'peers': peers.map((peer) => peer.toJson()).toList(growable: false),
  };
}

final class RoomRealtimeWebRtcMediaPeerLeftSignal
    extends RoomRealtimeWebRtcMediaSignal {
  const RoomRealtimeWebRtcMediaPeerLeftSignal({
    required super.kind,
    required this.swarmId,
    required this.userId,
    required this.connId,
  });

  final String swarmId;
  final String userId;
  final String connId;

  @override
  Map<String, dynamic> payload() => {
    'user_id': userId,
    'conn_id': connId,
    'media_swarm_id': swarmId,
    'from': '$userId:$connId',
  };
}

class RoomRealtimeWebRtcPeer {
  const RoomRealtimeWebRtcPeer({required this.userId, required this.connId});

  final String userId;
  final String connId;

  Map<String, String> toJson() => {'user_id': userId, 'conn_id': connId};
}

Map<String, dynamic> _webRtcNegotiationPayload(
  String data,
  String from,
  String signalType,
) {
  final result = <String, dynamic>{};
  if (data.isNotEmpty) {
    final decoded = jsonDecode(data);
    if (decoded is Map<String, dynamic>) {
      result.addAll(decoded);
    }
  }
  result['from'] = from;
  if ((signalType == 'offer' || signalType == 'answer') &&
      result['type'] == null) {
    result['type'] = signalType;
  }
  return result;
}

class RoomRealtimeMessage {
  const RoomRealtimeMessage({
    required this.kind,
    this.chatId = '',
    this.chatContent = '',
    this.senderUserId = '',
    this.senderUsername,
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
    this.chatStatus =
        client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_UNSPECIFIED,
    this.chatMessageType = client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
    this.chatDisplayPosition = '',
    this.chatDisplayColor = '',
    this.chatReplyToMessageId = '',
    this.status,
    this.playbackStatus,
    this.roomSettings,
    this.mediaLibrary,
    this.playbackHistory,
    this.members,
    this.adminMembers,
    this.selfMember,
    this.onlineEvent,
    this.error,
    this.webRtc,
    this.resourceObserveId = '',
    this.resourceVersion = '',
    this.resourceEvent = false,
    this.onlineMemberCount = 0,
    this.onlineGuestCount = 0,
  });

  final RoomRealtimeMessageKind kind;
  final String chatId;
  final String chatContent;
  final String senderUserId;
  final String? senderUsername;
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
  final client_enum.ChatMessageStatus chatStatus;
  final client_enum.ChatMessageType chatMessageType;
  final String chatDisplayPosition;
  final String chatDisplayColor;
  final String chatReplyToMessageId;
  final RoomRealtimePlaybackStatus? status;
  final SyncTvPlaybackStatus? playbackStatus;
  final SyncTvRoomSettings? roomSettings;
  final RoomMediaLibraryPage? mediaLibrary;
  final client.ListPlaybackHistoryResponse? playbackHistory;
  final List<SyncTvUser>? members;
  final List<AdminRoomMember>? adminMembers;
  final AdminRoomMember? selfMember;
  final RoomRealtimeOnlineEvent? onlineEvent;
  final RoomRealtimeError? error;
  final RoomRealtimeWebRtcSignal? webRtc;
  final String resourceObserveId;
  final String resourceVersion;
  final bool resourceEvent;
  final int onlineMemberCount;
  final int onlineGuestCount;

  bool get isChatCreated => chatEventKind == RoomRealtimeChatEventKind.created;
  bool get isChatEdited =>
      chatEdited || chatEventKind == RoomRealtimeChatEventKind.edited;
  bool get isChatDeleted =>
      chatDeleted || chatEventKind == RoomRealtimeChatEventKind.deleted;

  bool get isPlaylistBrowseAccessDenied =>
      resourceObserveId == 'playlist_items' &&
      error?.isPermissionDenied == true;
}

class RoomRealtimeSession {
  const RoomRealtimeSession({
    required this.send,
    required this.messages,
    required this.events,
    required this.reconnects,
    this.disconnections = const Stream<void>.empty(),
  });

  final void Function(List<int> bytes) send;
  final Stream<RoomRealtimeMessage> messages;
  final Stream<RealtimeEventLogEntry> events;
  final Stream<void> reconnects;
  final Stream<void> disconnections;
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

  factory RoomRealtimeChatEntry.fromMessage(
    RoomRealtimeMessage message, {
    required int receivedAtMillis,
    String missingUsername = 'Deleted user',
  }) {
    return RoomRealtimeChatEntry(
      id: message.chatId,
      userId: message.senderUserId,
      username: chatMessageDisplayUsername(
        messageType: message.chatMessageType,
        username: message.senderUsername,
        missingUsername: missingUsername,
      ),
      content: message.chatContent,
      images: message.images,
      reactions: message.reactions,
      reactionCount: message.reactionCount,
      mentions: message.mentions,
      version: message.chatVersion,
      replyToMessageId: message.chatReplyToMessageId,
      timestampMillis: message.timestampMillis == 0
          ? receivedAtMillis
          : message.timestampMillis,
      isDeleted: message.isChatDeleted,
      isEdited: message.isChatEdited,
      pin: message.chatPinEvent?.pin,
    );
  }

  factory RoomRealtimeChatEntry.fromHistory(
    RoomChatMessageInfo message, {
    String missingUsername = 'Deleted user',
  }) {
    return RoomRealtimeChatEntry(
      id: message.id,
      userId: message.userId,
      username: chatMessageDisplayUsername(
        messageType: message.messageType,
        username: message.username,
        missingUsername: missingUsername,
      ),
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

String chatMessageDisplayUsername({
  required client_enum.ChatMessageType messageType,
  String? username,
  String missingUsername = 'Deleted user',
}) {
  if (messageType ==
          client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED ||
      messageType ==
          client_enum
              .ChatMessageType
              .CHAT_MESSAGE_TYPE_SYSTEM_PLAYBACK_CHANGED) {
    return 'SyncTV';
  }
  final normalized = username?.trim();
  return normalized == null || normalized.isEmpty
      ? missingUsername
      : normalized;
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
