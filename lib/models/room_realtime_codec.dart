import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/models/playback_client_profile.dart';
import 'package:synctv_app/models/room_media_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

enum RoomRealtimeMessageKind {
  unknown,
  error,
  chat,
  status,
  checkStatus,
  expired,
  current,
  movies,
  viewerCount,
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
    this.error,
    this.webRtc,
  });

  final RoomRealtimeMessageKind kind;
  final String chatId;
  final String chatContent;
  final String senderUserId;
  final String senderUsername;
  final int timestampMillis;
  final RoomRealtimePlaybackStatus? status;
  final RoomRealtimeError? error;
  final RoomRealtimeWebRtcSignal? webRtc;
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
  static List<int> encodeChat(String content) {
    return client.ClientMessage(
      chat: client.ChatMessageSend(content: content),
    ).writeToBuffer();
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
      _observe(
        'room_settings',
        roomSettings: client.ObserveRoomSettings(),
      ),
      _observe(
        'playlist_items',
        playlistItems: client.ObservePlaylistItems(
          request: client.ListPlaylistItemsRequest(page: 1, pageSize: 100),
        ),
      ),
      _observe(
        'room_members',
        roomMembers: client.ObserveRoomMembers(
          request: client.GetRoomMembersRequest(page: 1, pageSize: 100),
        ),
      ),
    ];
  }

  static List<int> _observe(
    String observeId, {
    client.ObservePlaybackState? playbackState,
    client.ObservePlaybackSnapshot? playbackSnapshot,
    client.ObserveRoomSettings? roomSettings,
    client.ObservePlaylistItems? playlistItems,
    client.ObserveRoomMembers? roomMembers,
  }) {
    return client.ClientMessage(
      observeResource: client.ObserveResource(
        observeId: observeId,
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
        return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.current);
      case client.ServerMessage_Message.playlistItems:
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
      case client.ServerMessage_Message.roomMembers:
        return const RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.viewerCount,
        );
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
        return const RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.checkStatus,
        );
      case client.ServerMessage_Message.resourceObserveError:
        return RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.error,
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
    return RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.status,
      status: RoomRealtimePlaybackStatus(
        isPlaying: state.isPlaying,
        currentTime: state.position,
        playbackRate: state.speed == 0 ? 1.0 : state.speed,
      ),
    );
  }

  static RoomRealtimeMessage _resourceChanged(
    client.ResourceChanged changed,
  ) {
    switch (changed.whichPayload()) {
      case client.ResourceChanged_Payload.playbackState:
        return _playbackState(changed.playbackState);
      case client.ResourceChanged_Payload.playbackSnapshot:
        return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.current);
      case client.ResourceChanged_Payload.playlistItems:
        return const RoomRealtimeMessage(kind: RoomRealtimeMessageKind.movies);
      case client.ResourceChanged_Payload.roomMembers:
        return const RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.viewerCount,
        );
      default:
        return const RoomRealtimeMessage(
          kind: RoomRealtimeMessageKind.checkStatus,
        );
    }
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
