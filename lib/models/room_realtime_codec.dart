import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/models/playback_client_profile.dart';
import 'package:synctv_app/models/realtime_event_log.dart';
import 'package:synctv_app/models/room_media_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/common.pb.dart' as common;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/models/watch_together_models.dart';

enum RoomRealtimeMessageKind {
  unknown,
  error,
  chat,
  status,
  checkStatus,
  expired,
  current,
  roomSettings,
  movies,
  viewerCount,
  memberEvent,
  sync,
  myStatus,
  webrtcOffer,
  webrtcAnswer,
  webrtcIceCandidate,
  webrtcJoin,
  webrtcLeave,
}

enum PlaybackControlAction {
  play,
  pause,
  seek,
  speed,
}

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
    this.status,
    this.playbackStatus,
    this.roomSettings,
    this.mediaLibrary,
    this.members,
    this.adminMembers,
    this.error,
    this.webRtc,
    this.resourceObserveId = '',
    this.resourceVersion = '',
    this.resourceChanged = false,
    this.resourceTotal = 0,
  });

  final RoomRealtimeMessageKind kind;
  final String chatId;
  final String chatContent;
  final String senderUserId;
  final String senderUsername;
  final int timestampMillis;
  final RoomRealtimePlaybackStatus? status;
  final WPlaybackStatus? playbackStatus;
  final WRoomSettings? roomSettings;
  final RoomMediaLibraryPage? mediaLibrary;
  final List<WUser>? members;
  final List<AdminRoomMember>? adminMembers;
  final RoomRealtimeError? error;
  final RoomRealtimeWebRtcSignal? webRtc;
  final String resourceObserveId;
  final String resourceVersion;
  final bool resourceChanged;
  final int resourceTotal;
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
  });

  factory RoomRealtimeChatEntry.fromMessage(RoomRealtimeMessage message) {
    return RoomRealtimeChatEntry(
      id: message.chatId,
      userId: message.senderUserId,
      username:
          message.senderUsername.isEmpty ? 'Unknown' : message.senderUsername,
      content: message.chatContent,
      timestampMillis: message.timestampMillis == 0
          ? DateTime.now().millisecondsSinceEpoch
          : message.timestampMillis,
    );
  }

  factory RoomRealtimeChatEntry.fromHistory(RoomChatMessageInfo message) {
    return RoomRealtimeChatEntry(
      id: message.id,
      userId: message.userId,
      username: message.username.isEmpty ? 'Unknown' : message.username,
      content: message.content,
      timestampMillis: message.timestamp * 1000,
    );
  }

  final String id;
  final String userId;
  final String username;
  final String content;
  final int timestampMillis;

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

  void appendUnique(
    RoomRealtimeChatEntry entry, {
    required int maxEntries,
  }) {
    if (any((message) => message.dedupeKey == entry.dedupeKey)) return;
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
  static RealtimeEventLogEntry describeOutgoing(List<int> data) {
    try {
      final message = client.ClientMessage.fromBuffer(data);
      final kind = realtimeEnumName(message.whichMessage());
      return RealtimeEventLogEntry.outgoing(
        label: kind,
        detail: _clientMessageDetail(message),
        byteLength: data.length,
        payload: _clientMessagePayload(message),
      );
    } catch (error) {
      return RealtimeEventLogEntry.outgoing(
        label: 'decode_error',
        detail: error.toString(),
        byteLength: data.length,
      );
    }
  }

  static RealtimeEventLogEntry describeIncoming(Uint8List data) {
    try {
      final message = client.ServerMessage.fromBuffer(data);
      final kind = realtimeEnumName(message.whichMessage());
      return RealtimeEventLogEntry.incoming(
        label: kind,
        detail: _serverMessageDetail(message),
        byteLength: data.length,
        payload: _serverMessagePayload(message),
      );
    } catch (error) {
      return RealtimeEventLogEntry.incoming(
        label: 'decode_error',
        detail: error.toString(),
        byteLength: data.length,
      );
    }
  }

  static List<int> encodeChat(String content) {
    return client.ClientMessage(
      chat: client.ChatMessageSend(content: content),
    ).writeToBuffer();
  }

  static String _clientMessageDetail(client.ClientMessage message) {
    switch (message.whichMessage()) {
      case client.ClientMessage_Message.chat:
        return message.chat.content;
      case client.ClientMessage_Message.playbackUpdate:
        final update = message.playbackUpdate;
        return [
          realtimeEnumName(update.type),
          'pos=${update.position.toStringAsFixed(2)}',
          'playing=${update.playing}',
          'speed=${update.speed.toStringAsFixed(2)}',
        ].join(' ');
      case client.ClientMessage_Message.playbackProgress:
        final progress = message.playbackProgress;
        return 'pos=${progress.position.toStringAsFixed(2)} playing=${progress.isPlaying}';
      case client.ClientMessage_Message.observeResource:
        final observe = message.observeResource;
        return '${observe.observeId} ${realtimeEnumName(observe.whichResource())} v${observe.version}';
      case client.ClientMessage_Message.unobserveResource:
        return message.unobserveResource.observeId;
      case client.ClientMessage_Message.heartbeat:
        return 'ts=${message.heartbeat.timestamp}';
      case client.ClientMessage_Message.webrtcOffer:
      case client.ClientMessage_Message.webrtcAnswer:
      case client.ClientMessage_Message.webrtcIceCandidate:
      case client.ClientMessage_Message.webrtcJoin:
      case client.ClientMessage_Message.webrtcLeave:
        return 'webrtc';
      default:
        return '';
    }
  }

  static Map<String, Object?> _clientMessagePayload(
    client.ClientMessage message,
  ) {
    switch (message.whichMessage()) {
      case client.ClientMessage_Message.chat:
        return {'content': message.chat.content};
      case client.ClientMessage_Message.playbackUpdate:
        final update = message.playbackUpdate;
        return {
          'type': realtimeEnumName(update.type),
          'position': update.position,
          'playing': update.playing,
          'speed': update.speed,
          'version': update.version.toInt(),
        };
      case client.ClientMessage_Message.playbackProgress:
        return {
          'position': message.playbackProgress.position,
          'is_playing': message.playbackProgress.isPlaying,
        };
      case client.ClientMessage_Message.observeResource:
        return {
          'observe_id': message.observeResource.observeId,
          'version': message.observeResource.version,
          'type': realtimeEnumName(message.observeResource.whichResource()),
        };
      case client.ClientMessage_Message.unobserveResource:
        return {'observe_id': message.unobserveResource.observeId};
      case client.ClientMessage_Message.heartbeat:
        return {'timestamp': message.heartbeat.timestamp.toInt()};
      default:
        return {'kind': realtimeEnumName(message.whichMessage())};
    }
  }

  static String _serverMessageDetail(client.ServerMessage message) {
    switch (message.whichMessage()) {
      case client.ServerMessage_Message.chat:
        return '${message.chat.username}: ${message.chat.content}';
      case client.ServerMessage_Message.playbackState:
        final state = message.playbackState.state;
        return 'pos=${state.position.toStringAsFixed(2)} playing=${state.isPlaying}';
      case client.ServerMessage_Message.playbackSnapshot:
        final state = message.playbackSnapshot.snapshot;
        return '${state.name} pos=${state.position.toStringAsFixed(2)}';
      case client.ServerMessage_Message.resourceChanged:
        return '${message.resourceChanged.observeId} v${message.resourceChanged.version}';
      case client.ServerMessage_Message.resourceObserved:
        return '${message.resourceObserved.observeId} v${message.resourceObserved.version}';
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

  static Map<String, Object?> _serverMessagePayload(
    client.ServerMessage message,
  ) {
    switch (message.whichMessage()) {
      case client.ServerMessage_Message.chat:
        return {
          'id': message.chat.id,
          'user_id': message.chat.userId,
          'username': message.chat.username,
          'content': message.chat.content,
          'timestamp': message.chat.timestamp.toInt(),
        };
      case client.ServerMessage_Message.playbackState:
        return _playbackStatePayload(message.playbackState.state);
      case client.ServerMessage_Message.playbackSnapshot:
        return _playbackSnapshotPayload(message.playbackSnapshot.snapshot);
      case client.ServerMessage_Message.resourceChanged:
        return {
          'observe_id': message.resourceChanged.observeId,
          'version': message.resourceChanged.version,
          'payload': realtimeEnumName(message.resourceChanged.whichPayload()),
        };
      case client.ServerMessage_Message.resourceObserved:
        return {
          'observe_id': message.resourceObserved.observeId,
          'version': message.resourceObserved.version,
          'changed': message.resourceObserved.changed,
        };
      case client.ServerMessage_Message.resourceObserveError:
        return {
          'observe_id': message.resourceObserveError.observeId,
          'code': message.resourceObserveError.error.code,
          'message': message.resourceObserveError.error.message,
          'detail': message.resourceObserveError.error.detail,
        };
      case client.ServerMessage_Message.error:
        return {
          'code': message.error.code,
          'message': message.error.message,
          'detail': message.error.detail,
        };
      case client.ServerMessage_Message.heartbeatAck:
        return {'timestamp': message.heartbeatAck.timestamp.toInt()};
      default:
        return {'kind': realtimeEnumName(message.whichMessage())};
    }
  }

  static Map<String, Object?> _playbackStatePayload(
    client.PlaybackState state,
  ) {
    return {
      'playing_media_id': state.playingMediaId,
      'playing_playlist_id': state.playingPlaylistId,
      'position': state.position,
      'playing': state.isPlaying,
      'speed': state.speed,
      'version': state.version.toInt(),
    };
  }

  static Map<String, Object?> _playbackSnapshotPayload(
    client.PlaybackSnapshot snapshot,
  ) {
    return {
      'media_id': snapshot.mediaId,
      'playlist_id': snapshot.playlistId,
      'room_id': snapshot.roomId,
      'name': snapshot.name,
      'position': snapshot.position,
      'default_mode': snapshot.defaultMode,
      'playback_infos': snapshot.playbackInfos.length,
      'version': snapshot.version,
      'expires_at': snapshot.expiresAt.toInt(),
    };
  }

  static List<int> encodePlaybackUpdate(
    PlaybackControlAction action, {
    bool? isPlaying,
    double? position,
    double? playbackRate,
    int? version,
  }) {
    final update = client.UpdatePlaybackRequest(
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
    return client.ClientMessage(playbackUpdate: update).writeToBuffer();
  }

  static List<int> encodePlaybackProgress(
    bool isPlaying,
    double currentTime,
  ) {
    return client.ClientMessage(
      playbackProgress: client.PlaybackProgressReport(
        position: currentTime,
        isPlaying: isPlaying,
      ),
    ).writeToBuffer();
  }

  static List<int> encodeSync() {
    return client.ClientMessage(
      heartbeat: client.HeartbeatMessage(
        timestamp: Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000),
      ),
    ).writeToBuffer();
  }

  static List<List<int>> encodeInitialObservations() {
    return [
      ...encodePlaybackObservations(),
      encodeRoomSettingsObservation(),
      encodePlaylistObservation(),
      encodeRoomMembersObservation(),
    ];
  }

  static List<List<int>> encodePlaybackObservations() {
    return [
      _observe(
        'playback_state',
        playbackState: client.ObservePlaybackState(),
      ),
      _observe(
        'playback_snapshot',
        playbackSnapshot: client.ObservePlaybackSnapshot(
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
    return _observe(
      observeId,
      version: version,
      playlistItems: client.ObservePlaylistItems(
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
    );
  }

  static List<int> encodeRoomMembersObservation({
    String observeId = 'room_members',
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
    return _observe(
      observeId,
      version: version,
      roomMembers: client.ObserveRoomMembers(
        request: client.GetRoomMembersRequest(
          page: page,
          pageSize: pageSize,
          search: search,
          role: role,
          sortBy: sortBy,
          sortDirection: sortDirection,
        ),
      ),
    );
  }

  static List<int> encodeRoomSettingsObservation({
    String observeId = 'room_settings',
    String version = '',
  }) {
    return _observe(
      observeId,
      version: version,
      roomSettings: client.ObserveRoomSettings(),
    );
  }

  static List<int> encodeUnobserveResource(String observeId) {
    return client.ClientMessage(
      unobserveResource: client.UnobserveResource(observeId: observeId),
    ).writeToBuffer();
  }

  static List<int> _observe(
    String observeId, {
    String version = '',
    client.ObservePlaybackState? playbackState,
    client.ObservePlaybackSnapshot? playbackSnapshot,
    client.ObserveRoomSettings? roomSettings,
    client.ObservePlaylistItems? playlistItems,
    client.ObserveRoomMembers? roomMembers,
  }) {
    return client.ClientMessage(
      observeResource: client.ObserveResource(
        observeId: observeId,
        version: version,
        deliveryMode:
            client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
        playbackState: playbackState,
        playbackSnapshot: playbackSnapshot,
        roomSettings: roomSettings,
        playlistItems: playlistItems,
        roomMembers: roomMembers,
      ),
    ).writeToBuffer();
  }

  static List<int> encodeWebRTC(
    RoomRealtimeMessageKind type,
    Map<String, dynamic> data,
  ) {
    final payload = (data['data'] ?? '').toString();
    final to = (data['to'] ?? '').toString();
    final message = client.ClientMessage();
    switch (type) {
      case RoomRealtimeMessageKind.webrtcOffer:
        message.webrtcOffer = client.WebRTCOffer(to: to, data: payload);
        break;
      case RoomRealtimeMessageKind.webrtcAnswer:
        message.webrtcAnswer = client.WebRTCAnswer(to: to, data: payload);
        break;
      case RoomRealtimeMessageKind.webrtcIceCandidate:
        message.webrtcIceCandidate =
            client.WebRTCIceCandidate(to: to, data: payload);
        break;
      case RoomRealtimeMessageKind.webrtcJoin:
        message.webrtcJoin = client.WebRTCJoin();
        break;
      case RoomRealtimeMessageKind.webrtcLeave:
        message.webrtcLeave = client.WebRTCLeave();
        break;
      default:
        return Uint8List(0);
    }
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

  static List<int>? _decodeTarget(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return base64Url.decode(value);
    } catch (_) {
      return utf8.encode(value);
    }
  }

  static RoomRealtimeMessage decode(Uint8List data) {
    final message = client.ServerMessage.fromBuffer(data);
    switch (message.whichMessage()) {
      case client.ServerMessage_Message.chat:
        final chat = message.chat;
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.chat,
          chatId: chat.id,
          chatContent: chat.content,
          timestampMillis: chat.timestamp.toInt() * 1000,
          senderUserId: chat.userId,
          senderUsername: chat.username,
        );
      case client.ServerMessage_Message.playbackState:
        return _playbackState(message.playbackState.state);
      case client.ServerMessage_Message.playingChanged:
        return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.current);
      case client.ServerMessage_Message.playbackSnapshot:
        return _playbackSnapshot(message.playbackSnapshot.snapshot);
      case client.ServerMessage_Message.roomSettings:
        return _roomSettings(message.roomSettings);
      case client.ServerMessage_Message.playlistItems:
        return _playlistItems(message.playlistItems.snapshot);
      case client.ServerMessage_Message.mediaAdded:
      case client.ServerMessage_Message.mediaUpdated:
      case client.ServerMessage_Message.mediaRemoved:
      case client.ServerMessage_Message.mediaRemovedBatch:
      case client.ServerMessage_Message.playlistCreated:
      case client.ServerMessage_Message.playlistUpdated:
      case client.ServerMessage_Message.playlistDeleted:
      case client.ServerMessage_Message.playlistReordered:
        return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.movies);
      case client.ServerMessage_Message.userJoined:
      case client.ServerMessage_Message.userLeft:
      case client.ServerMessage_Message.permissionChanged:
        return const RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.memberEvent,
        );
      case client.ServerMessage_Message.roomMembers:
        return _roomMembers(message.roomMembers.snapshot);
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
      case client.ServerMessage_Message.webrtcOffer:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcOffer,
          message.webrtcOffer.from,
          message.webrtcOffer.to,
          message.webrtcOffer.data,
        );
      case client.ServerMessage_Message.webrtcAnswer:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcAnswer,
          message.webrtcAnswer.from,
          message.webrtcAnswer.to,
          message.webrtcAnswer.data,
        );
      case client.ServerMessage_Message.webrtcIceCandidate:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcIceCandidate,
          message.webrtcIceCandidate.from,
          message.webrtcIceCandidate.to,
          message.webrtcIceCandidate.data,
        );
      case client.ServerMessage_Message.webrtcJoin:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcJoin,
          '${message.webrtcJoin.userId}:${message.webrtcJoin.connId}',
          '',
          jsonEncode({
            'user_id': message.webrtcJoin.userId,
            'conn_id': message.webrtcJoin.connId,
            'username': message.webrtcJoin.username,
          }),
        );
      case client.ServerMessage_Message.webrtcLeave:
        return _webrtc(
          RoomRealtimeMessageKind.webrtcLeave,
          '${message.webrtcLeave.userId}:${message.webrtcLeave.connId}',
          '',
          jsonEncode({
            'user_id': message.webrtcLeave.userId,
            'conn_id': message.webrtcLeave.connId,
          }),
        );
      case client.ServerMessage_Message.resourceChanged:
        return _resourceChanged(message.resourceChanged);
      case client.ServerMessage_Message.resourceObserved:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.checkStatus,
          resourceObserveId: message.resourceObserved.observeId,
          resourceVersion: message.resourceObserved.version,
          resourceChanged: message.resourceObserved.changed,
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

  static RoomRealtimeMessage _playbackSnapshot(
    client.PlaybackSnapshot snapshot,
  ) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.current,
      playbackStatus: _playbackStatusFromSnapshot(snapshot),
    );
  }

  static RoomRealtimeMessage _playlistItems(
    client.ListPlaylistItemsResponse response, {
    String observeId = '',
    String version = '',
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.movies,
      mediaLibrary: _mediaLibraryPageFromProto(response),
      resourceObserveId: observeId,
      resourceVersion: version,
    );
  }

  static RoomRealtimeMessage _roomSettings(
    client.RoomSettingsChanged changed, {
    String observeId = '',
    String version = '',
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.roomSettings,
      roomSettings: WRoomSettings.fromJson(_decodeJsonBytes(changed.settings)),
      resourceObserveId: observeId,
      resourceVersion: version,
    );
  }

  static RoomRealtimeMessage _roomMembers(
    client.GetRoomMembersResponse response, {
    String observeId = '',
    String version = '',
  }) {
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.viewerCount,
      members: response.members.map(_memberFromProto).toList(growable: false),
      adminMembers:
          response.members.map(_adminMemberFromProto).toList(growable: false),
      resourceObserveId: observeId,
      resourceVersion: version,
      resourceTotal: response.total,
    );
  }

  static RoomRealtimeMessage _resourceChanged(
    client.ResourceChanged changed,
  ) {
    switch (changed.whichPayload()) {
      case client.ResourceChanged_Payload.playbackState:
        return _playbackState(changed.playbackState);
      case client.ResourceChanged_Payload.playbackSnapshot:
        return _playbackSnapshot(changed.playbackSnapshot);
      case client.ResourceChanged_Payload.roomSettings:
        return _roomSettings(
          changed.roomSettings,
          observeId: changed.observeId,
          version: changed.version,
        );
      case client.ResourceChanged_Payload.playlistItems:
        return _playlistItems(
          changed.playlistItems,
          observeId: changed.observeId,
          version: changed.version,
        );
      case client.ResourceChanged_Payload.roomMembers:
        return _roomMembers(
          changed.roomMembers,
          observeId: changed.observeId,
          version: changed.version,
        );
      case client.ResourceChanged_Payload.changedOnly:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.error,
          error: RoomRealtimeError(
            message: '服务端未推送资源快照: ${changed.observeId}',
            code: 0,
            detail:
                'ResourceChanged used changed_only while the client requested PUSH_SNAPSHOT.',
          ),
        );
      default:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.error,
          error: RoomRealtimeError(
            message: '服务端推送了空资源变更: ${changed.observeId}',
            code: 0,
            detail: 'ResourceChanged has no payload.',
          ),
        );
    }
  }

  static WPlaybackStatus _playbackStatusFromState(
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

  static WPlaybackStatus _playbackStatusFromSnapshot(
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
            url: playbackUrl?.url ?? '',
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

  static RoomMediaLibraryPage _mediaLibraryPageFromProto(
    client.ListPlaylistItemsResponse response,
  ) {
    final parentId = response.currentPath.isEmpty
        ? ''
        : response.currentPath.last.playlistId;
    return RoomMediaLibraryPage(
      playlists: response.playlists.map(_playlistFromProto).toList(),
      media: response.media.map(_mediaFromProto).toList(),
      dynamicItems: response.dynamicItems
          .map((item) => _dynamicItemFromProto(item, playlistId: parentId))
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
      target: base64Url.encode(node.target),
    );
  }

  static WMovie _mediaFromProto(client.Media media) {
    final metadata = _decodeJsonBytes(media.metadata);
    final sourceConfig = _decodeJsonBytes(media.sourceConfig);
    return WMovie(
      id: media.id,
      name: media.name,
      url: (metadata['url'] ?? sourceConfig['url'] ?? '').toString(),
      creator: media.creatorId,
      roomId: media.roomId,
      position: media.position,
      addedAt: media.addedAt.toInt(),
      availability: media.availability.value,
      version: media.version.toInt(),
      type: media.sourceProvider,
      headers: _stringMap(metadata['headers']),
      proxy: metadata['proxy'] == true,
      live: media.sourceProvider == 'rtmp' ||
          (media.sourceProvider == 'bilibili' &&
              sourceConfig['type'] == 'live') ||
          metadata['is_live'] == true,
      sourceProvider: media.sourceProvider,
      providerInstanceName: media.providerInstanceName,
      sourceConfig: sourceConfig,
      metadata: metadata,
    );
  }

  static WMovie _playlistFromProto(client.Playlist playlist) {
    return WMovie(
      id: playlist.id,
      name: playlist.name,
      url: '',
      isFolder: true,
      roomId: playlist.roomId,
      parentId: playlist.parentId.isEmpty ? null : playlist.parentId,
      position: playlist.position,
      createdAt: playlist.createdAt.toInt(),
      updatedAt: playlist.updatedAt.toInt(),
      itemCount: playlist.itemCount,
      availability: playlist.availability.value,
      version: playlist.version.toInt(),
      type: playlist.isDynamic ? playlist.sourceProvider : 'playlist',
      sourceProvider: playlist.sourceProvider,
      providerInstanceName: playlist.providerInstanceName,
      sourceConfig: _decodeJsonBytes(playlist.sourceConfig),
      metadata: {'is_dynamic': playlist.isDynamic},
    );
  }

  static WMovie _dynamicItemFromProto(
    client.PlaylistItem item, {
    required String playlistId,
  }) {
    final target = Uint8List.fromList(item.target);
    final encodedTarget = base64Url.encode(target);
    return WMovie(
      id: encodedTarget,
      name: item.name,
      url: '',
      isFolder: item.itemType == client_enum.ItemType.ITEM_TYPE_PLAYLIST,
      parentId: playlistId,
      subPath: encodedTarget,
      metadata: {
        'target': target,
        'target_json': _decodeJsonBytes(item.target),
        'thumbnail': item.hasThumbnail() ? item.thumbnail : '',
        'size': item.hasSize() ? item.size.toInt() : null,
      },
    );
  }

  static WUser _memberFromProto(common.RoomMember member) {
    return WUser(
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

  static Map<String, dynamic> _decodeJsonBytes(List<int> bytes) {
    if (bytes.isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  static Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) return const {};
    return value
        .map((key, value) => MapEntry(key.toString(), value.toString()));
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
}
