import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/managers/webrtc_manager.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/models/playback_client_profile.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/source_config_codec.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/bilibili_geetest_service.dart';
import 'package:synctv_app/services/oauth2_callback_config.dart';
import 'package:synctv_app/services/oauth2_callback_parser.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/room_invite_service.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_auth_service.dart';
import 'package:synctv_app/services/synctv_admin_service.dart';
import 'package:synctv_app/services/synctv_public_room_service.dart';
import 'package:synctv_app/services/synctv_room_management_service.dart';
import 'package:synctv_app/services/synctv_room_media_service.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pb.dart' as common_pb;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/oauth2.pb.dart' as oauth2;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/src/generated/proto/providers/alist.pb.dart'
    as alist;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/emby.pb.dart' as emby;
import 'package:synctv_app/src/generated/proto/providers/rtmp.pb.dart' as rtmp;
import 'package:synctv_app/utils/chat_playback_danmaku.dart';
import 'package:synctv_app/utils/chat_reactions.dart';
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

void main() {
  test(
      'public settings derive user-facing auth policy hints from protobuf fields',
      () {
    const settings = PublicSettingsInfo(
      allowRoomCreation: true,
      maxRoomsPerUser: 3,
      maxMembersPerRoom: 12,
      disableCreateRoom: false,
      createRoomNeedReview: true,
      roomPasswordPolicy: 'required',
      enablePasswordSignup: true,
      passwordSignupNeedReview: true,
      enableEmailSignup: true,
      enableEmail: true,
      enableGuest: false,
      emailSignupNeedReview: true,
      enableWebauthn: true,
      enableWebauthnSignup: true,
      webauthnSignupNeedReview: true,
      movieProxy: false,
      liveProxy: true,
      emailWhitelistEnabled: true,
      emailWhitelistDomains: ['example.com'],
      tsDisguisedAsPng: true,
      customPublishHost: 'rtmp://publish.example.test/app',
    );

    expect(settings.authPolicyHints, [
      '密码注册需要管理员审核',
      '邮箱注册需要管理员审核',
      'Passkey 注册需要管理员审核',
      '服务器启用了邮箱白名单，注册邮箱需要在白名单内',
      '访客访问未启用',
    ]);
  });

  test('protobuf watch events preserve typed resource payloads', () {
    final observedJson = jsonDecode('''
      {
        "observed": {
          "observeId": "playback-state",
          "changed": true,
          "eventCursor": {"sequence": "42"}
        }
      }
    ''');
    final observed = client.WatchPlaybackStateEvent()
      ..mergeFromProto3Json(
        observedJson,
        supportNamesWithUnderscores: true,
        permissiveEnums: true,
        ignoreUnknownFields: true,
      );

    expect(observed.hasObserved(), isTrue);
    expect(observed.observed.eventCursor.sequence.toInt(), 42);
    expect(observed.observed.changed, isTrue);

    final changedJson = jsonDecode('''
      {
        "resourceEvent": {
          "observeId": "playback-state",
          "eventCursor": {"sequence": "43"},
          "playbackState": {
            "roomId": "room_abc",
            "playingMediaId": "med_abc",
            "position": 12.5,
            "speed": 1.25,
            "isPlaying": true,
            "version": "7"
          }
        }
      }
    ''');
    final changed = client.WatchPlaybackStateEvent()
      ..mergeFromProto3Json(
        changedJson,
        supportNamesWithUnderscores: true,
        permissiveEnums: true,
        ignoreUnknownFields: true,
      );

    expect(changed.hasResourceEvent(), isTrue);
    expect(changed.resourceEvent.eventCursor.sequence.toInt(), 43);
    expect(changed.resourceEvent.hasPlaybackState(), isTrue);
    expect(changed.resourceEvent.playbackState.position, 12.5);
    expect(changed.resourceEvent.playbackState.speed, 1.25);
    expect(changed.resourceEvent.playbackState.isPlaying, isTrue);
  });

  test('realtime event log displays protobuf JSON payloads', () {
    final heartbeat = client.ClientMessage(
      heartbeat: client.HeartbeatMessage(timestamp: Int64(1781248744)),
    ).writeToBuffer();
    final outgoing = RoomRealtimeCodec.describeOutgoing(heartbeat);
    expect(outgoing.payload, {
      'heartbeat': {'timestamp': '1781248744'},
    });

    final joined = client.ServerMessage(
      resourceEvent: client.ResourceEvent(
        observeId: 'room_member_events',
        roomMemberEvent: client.RoomMemberEvent(
          eventId: 'evt_member_1',
          roomId: 'room_140',
          kind: client.RoomMemberEventKind.ROOM_MEMBER_EVENT_KIND_JOINED,
          member: common_pb.RoomMember(
            roomId: 'room_140',
            userId: 'usr_133',
            username: 'test2',
            role: common.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
            permissions: Int64(1048575),
            joinedAt: Int64(1781248669),
            isOnline: true,
          ),
        ),
      ),
    ).writeToBuffer();
    final incoming = RoomRealtimeCodec.describeIncoming(
      Uint8List.fromList(joined),
    );

    expect(incoming.payload, {
      'resourceEvent': {
        'observeId': 'room_member_events',
        'roomMemberEvent': {
          'eventId': 'evt_member_1',
          'roomId': 'room_140',
          'kind': 'ROOM_MEMBER_EVENT_KIND_JOINED',
          'member': {
            'roomId': 'room_140',
            'userId': 'usr_133',
            'username': 'test2',
            'role': 'ROOM_MEMBER_ROLE_CREATOR',
            'permissions': '1048575',
            'joinedAt': '1781248669',
            'isOnline': true,
          },
        },
      },
    });
  });

  test('room resource watch DTO distinguishes observed, changed, and error',
      () {
    final observed = RoomResourceWatchEvent<void>.observed(
      version: '1',
      changed: false,
    );
    final changed = RoomResourceWatchEvent<String>.changed(
      version: '2',
      snapshot: 'snapshot',
    );
    final error = RoomResourceWatchEvent<void>.error(
      message: 'permission denied',
      code: 403,
    );

    expect(observed.kind, RoomResourceWatchKind.observed);
    expect(observed.version, '1');
    expect(observed.changed, isFalse);

    expect(changed.kind, RoomResourceWatchKind.changed);
    expect(changed.snapshot, 'snapshot');
    expect(changed.changed, isTrue);

    expect(error.kind, RoomResourceWatchKind.error);
    expect(error.errorMessage, 'permission denied');
    expect(error.errorCode, 403);
  });

  test('playback control uses playback state update oneof', () {
    final update = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodePlaybackStateUpdate(
        PlaybackControlAction.seek,
        isPlaying: true,
        position: 12.5,
        playbackRate: 1.25,
      ),
    );

    expect(update.hasPlaybackStateUpdate(), isTrue);
    expect(
      update.playbackStateUpdate.type,
      client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK,
    );
    expect(update.playbackStateUpdate.playing, isTrue);
    expect(update.playbackStateUpdate.position, 12.5);
    expect(update.playbackStateUpdate.speed, 1.25);
  });

  test('guarded playback state update uses source guard without version lock',
      () {
    final message = RoomRealtimeCodec.buildGuardedPlaybackStateUpdateMessage(
      PlaybackControlAction.pause,
      SyncTvPlaybackStatus(
        playbackRate: 1,
        version: 7,
        playingMediaId: 'med_1',
        playingPlaylistId: '',
        targetHash:
            'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      ),
      isPlaying: false,
      position: 0.658,
      playbackRate: 1,
    );

    expect(message.hasPlaybackStateUpdate(), isTrue);
    expect(
      message.playbackStateUpdate.type,
      client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PAUSE,
    );
    expect(message.playbackStateUpdate.playing, isFalse);
    expect(message.playbackStateUpdate.position, 0.658);
    expect(message.playbackStateUpdate.speed, 1);
    expect(message.playbackStateUpdate.hasVersion(), isFalse);
    expect(message.playbackStateUpdate.expectedMediaId, 'med_1');
    expect(message.playbackStateUpdate.expectedPlaylistId, '');
    expect(
      message.playbackStateUpdate.expectedTargetHash,
      'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    );
  });

  test('realtime chat messages preserve danmaku presentation fields', () {
    final chat = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeChat(
        'hello overlay',
        displayPosition: 'scroll',
        displayColor: '#ff6600',
      ),
    );

    expect(chat.hasChat(), isTrue);
    expect(chat.chat.content, 'hello overlay');
    expect(chat.chat.displayPosition, 'scroll');
    expect(chat.chat.displayColor, '#ff6600');
  });

  test('initial realtime observations include playback client profile', () {
    final messages = RoomRealtimeCodec.encodeInitialObservations()
        .map(client.ClientMessage.fromBuffer)
        .toList(growable: false);
    expect(
      messages
          .map((message) => message.observeResource.observeId)
          .contains('chat_events'),
      isTrue,
    );
    expect(
      messages
          .map((message) => message.observeResource.observeId)
          .contains('webrtc_events'),
      isFalse,
    );

    final snapshotObserve = messages
        .map((message) => message.observeResource)
        .firstWhere((observe) => observe.observeId == 'playback');

    expect(
      snapshotObserve.deliveryMode,
      client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
    );
    expect(snapshotObserve.hasPlayback(), isTrue);
    final profile = snapshotObserve.playback.playbackClientProfile;
    expect(
      profile.streamPreference,
      client.PlaybackStreamPreference.PLAYBACK_STREAM_PREFERENCE_AUTO,
    );
    expect(profile.maxAudioChannels, 2);
    expect(profile.supportedVideoCodecs, [
      client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
      client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
      client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
      client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
    ]);
    expect(profile.supportedContainers, [
      client.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
      client.PlaybackContainer.PLAYBACK_CONTAINER_MKV,
      client.PlaybackContainer.PLAYBACK_CONTAINER_WEBM,
    ]);
    expect(
      profile.audioCapability,
      client.PlaybackAudioCapability.PLAYBACK_AUDIO_CAPABILITY_STEREO,
    );
    expect(
      profile.subtitlePreference,
      client.PlaybackSubtitlePreference.PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL,
    );

    final chatObserve = messages
        .map((message) => message.observeResource)
        .firstWhere((observe) => observe.observeId == 'chat_events');
    expect(chatObserve.hasChatEvents(), isTrue);
    expect(
      chatObserve.deliveryMode,
      client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
    );
  });

  test('chat event observation uses event sequence cursor', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeInitialObservations(afterChatEventId: 'evt_42')
          .map(client.ClientMessage.fromBuffer)
          .firstWhere(
            (message) => message.observeResource.observeId == 'chat_events',
          )
          .writeToBuffer(),
    );

    expect(message.hasObserveResource(), isTrue);
    expect(message.observeResource.hasChatEvents(), isTrue);
    expect(message.observeResource.chatEvents.afterEventSequence.toInt(), 0);
  });

  test('online count observation supports member list filters', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeOnlineCountObservation(
        observeId: 'visible_member_online_count',
        userIds: const ['usr_1', 'usr_2'],
        roles: const [common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN],
      ),
    );

    expect(message.hasObserveResource(), isTrue);
    final observe = message.observeResource;
    expect(observe.observeId, 'visible_member_online_count');
    expect(observe.hasOnlineCount(), isTrue);
    expect(observe.onlineCount.userIds, ['usr_1', 'usr_2']);
    expect(observe.onlineCount.roles, [
      common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
    ]);
  });

  test('room realtime decoder exposes typed protobuf messages', () {
    final chat = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'chat_events',
          chatEvent: client.ChatMessageEvent(
            eventId: 'evt_chat',
            kind: client_enum
                .ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_CREATED,
            message: client.ChatMessageReceive(
              content: 'hello',
              userId: 'usr_sender',
              username: 'alice',
              timestamp: Int64(123),
            ),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(chat.kind, RoomRealtimeMessageKind.chat);
    expect(chat.chatContent, 'hello');
    expect(chat.senderUserId, 'usr_sender');
    expect(chat.senderUsername, 'alice');
    expect(chat.timestampMillis, 123000);

    final playback = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'playback_state',
          playbackState: client.PlaybackState(
            isPlaying: true,
            position: 42.5,
            speed: 1.25,
          ),
        ),
      ).writeToBuffer(),
    );

    expect(playback.kind, RoomRealtimeMessageKind.status);
    expect(playback.status?.isPlaying, isTrue);
    expect(playback.status?.currentTime, 42.5);
    expect(playback.status?.playbackRate, 1.25);

    final webrtc = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'webrtc',
          webrtcEvent: client.WebRtcEvent(
            offer: client.WebRTCOffer(
              from: 'usr_peer:conn_1',
              to: 'usr_me:conn_2',
              data: '{"sdp":"offer"}',
            ),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(webrtc.kind, RoomRealtimeMessageKind.webrtcOffer);
    expect(webrtc.webRtc?.signalType, 'offer');
    expect(webrtc.webRtc?.from, 'usr_peer:conn_1');
    expect(webrtc.webRtc?.to, 'usr_me:conn_2');
    expect(webrtc.webRtc?.payload(), {
      'sdp': 'offer',
      'from': 'usr_peer:conn_1',
      'type': 'offer',
    });

    final onlineEvent = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'manage_member_online_events',
          onlineEvent: client.OnlineEvent(
            eventId: 'evt_online_1',
            roomId: 'room_1',
            userId: 'usr_1',
            username: 'alice',
            role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
            kind: client.OnlineEventKind.ONLINE_EVENT_KIND_JOINED,
            occurredAt: Int64(1781260000),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(onlineEvent.kind, RoomRealtimeMessageKind.onlineEvent);
    expect(onlineEvent.resourceObserveId, 'manage_member_online_events');
    expect(onlineEvent.onlineEvent?.userId, 'usr_1');
    expect(onlineEvent.onlineEvent?.username, 'alice');
    expect(onlineEvent.onlineEvent?.isOnline, isTrue);
    expect(onlineEvent.timestampMillis, 1781260000000);
  });

  test('chat realtime events update existing entries and remove deleted ones',
      () {
    RoomRealtimeMessage decodeChatEvent({
      required String eventId,
      required client_enum.ChatMessageEventKind kind,
      required String content,
      client_enum.ChatMessageStatus status =
          client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE,
      int editedAt = 0,
      int deletedAt = 0,
    }) {
      return RoomRealtimeCodec.decode(
        client.ServerMessage(
          resourceEvent: client.ResourceEvent(
            observeId: 'chat_events',
            eventCursor:
                client.EventCursor(eventId: eventId, sequence: Int64(100)),
            chatEvent: client.ChatMessageEvent(
              eventId: eventId,
              roomId: 'room_1',
              kind: kind,
              message: client.ChatMessageReceive(
                id: 'msg_1',
                userId: 'usr_1',
                username: 'alice',
                content: content,
                timestamp: Int64(123),
                status: status,
                editedAt: Int64(editedAt),
                deletedAt: Int64(deletedAt),
              ),
            ),
          ),
        ).writeToBuffer(),
      );
    }

    final messages = <RoomRealtimeChatEntry>[];

    final created = decodeChatEvent(
      eventId: 'evt_1',
      kind: client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_CREATED,
      content: 'hello',
    );
    expect(created.kind, RoomRealtimeMessageKind.chat);
    expect(created.chatEventId, 'evt_1');
    expect(created.resourceVersion, '100');
    expect(created.isChatCreated, isTrue);

    messages.applyRealtimeEvent(
      RoomRealtimeChatEntry.fromMessage(created),
      eventKind: created.chatEventKind,
      maxEntries: 100,
    );
    expect(messages.map((entry) => entry.content), ['hello']);

    final edited = decodeChatEvent(
      eventId: 'evt_2',
      kind: client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_EDITED,
      content: 'hello edited',
      status: client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_EDITED,
      editedAt: 124,
    );
    expect(edited.chatEventId, 'evt_2');
    expect(edited.isChatEdited, isTrue);

    messages.applyRealtimeEvent(
      RoomRealtimeChatEntry.fromMessage(edited),
      eventKind: edited.chatEventKind,
      maxEntries: 100,
    );
    expect(messages, hasLength(1));
    expect(messages.single.content, 'hello edited');
    expect(messages.single.isEdited, isTrue);

    final deleted = decodeChatEvent(
      eventId: 'evt_3',
      kind: client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_DELETED,
      content: 'hello edited',
      status: client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_DELETED,
      deletedAt: 125,
    );
    expect(deleted.chatEventId, 'evt_3');
    expect(deleted.isChatDeleted, isTrue);

    messages.applyRealtimeEvent(
      RoomRealtimeChatEntry.fromMessage(deleted),
      eventKind: deleted.chatEventKind,
      maxEntries: 100,
    );
    expect(messages, isEmpty);
  });

  test('chat pin resource event is decoded from websocket payload', () {
    final decoded = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'chat_pin_events',
          eventCursor: client.EventCursor(sequence: Int64(78)),
          chatPinEvent: client.ChatPinEvent(
            eventId: 'pin_evt_1',
            roomId: 'room_1',
            kind: client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_PINNED,
            message: client.ChatMessageReceive(
              id: 'msg_1',
              roomId: 'room_1',
              userId: 'usr_sender',
              username: 'sender',
              content: 'pinned',
              timestamp: Int64(1760000100),
              status: client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE,
            ),
            pin: client.ChatMessagePin(
              pinnedByUserId: 'usr_mod',
              pinnedByUsername: 'mod',
              note: 'important',
              pinnedAt: Int64(1760000200),
            ),
            occurredAt: Int64(1760000201),
            sequence: Int64(78),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(decoded.kind, RoomRealtimeMessageKind.chatPin);
    expect(decoded.resourceObserveId, 'chat_pin_events');
    expect(decoded.resourceVersion, '78');
    expect(decoded.chatPinEvent?.eventId, 'pin_evt_1');
    expect(decoded.chatPinEvent?.message.id, 'msg_1');
    expect(decoded.chatPinEvent?.pin?.note, 'important');
    expect(decoded.chatPinEvent?.sequence, 78);

    final observe = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeChatPinEventsObservation(version: '78'),
    );
    expect(observe.observeResource.hasChatPinEvents(), isTrue);
    expect(
      observe.observeResource.chatPinEvents.afterEventSequence.toInt(),
      78,
    );
    expect(
      observe.observeResource.deliveryMode,
      client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
    );
  });

  test('chat pin state is preserved for realtime chat entries', () {
    const pin = ChatPinInfo(
      pinnedByUserId: 'usr_mod',
      pinnedByUsername: 'mod',
      note: 'important',
      pinnedAt: 1760000200,
    );
    const message = RoomChatMessageInfo(
      id: 'msg_1',
      roomId: 'room_1',
      userId: 'usr_sender',
      username: 'sender',
      content: 'pinned',
      timestamp: 1760000100,
      pin: pin,
    );

    final entry = RoomRealtimeChatEntry.fromHistory(message);
    expect(entry.isPinned, isTrue);
    expect(entry.pin?.note, 'important');

    final cleared = entry.copyWith(clearPin: true);
    expect(cleared.isPinned, isFalse);
    expect(cleared.pin, isNull);
  });

  test('chat reactions are mapped from protobuf events and endpoints',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path ==
            '/api/rooms/room_1/chat/messages/msg_1/reactions/%F0%9F%91%8D') {
          return http.Response(
            jsonEncode({
              'event': {
                'id': 'evt_1',
                'sequence': '8',
                'room_id': 'room_1',
                'kind': client_enum.ChatMessageEventKind
                    .CHAT_MESSAGE_EVENT_KIND_REACTIONS_CHANGED.value,
                'message': {
                  'id': 'msg_1',
                  'room_id': 'room_1',
                  'user_id': 'usr_sender',
                  'username': 'sender',
                  'content': 'hello',
                  'timestamp': '1760000100',
                  'version': '2',
                  'status': client_enum
                      .ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE.value,
                  'reactions': [
                    {
                      'key': '👍',
                      'count': '3',
                      'reacted_by_me': true,
                    }
                  ],
                  'reaction_count': 3,
                }
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path ==
            '/api/rooms/room_1/chat/messages/msg_1/reactions/%F0%9F%91%8D/users') {
          return http.Response(
            jsonEncode({
              'users': [
                {
                  'user_id': 'usr_1',
                  'username': 'alice',
                  'reacted_at': '1760000200',
                }
              ],
              'next_cursor': 'cursor_2',
              'total': '1',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
            'unexpected ${request.method} ${request.url}', 404);
      }),
    );
    final service = SyncTvRoomMediaDomainService(api);

    final reacted = await service.setChatReaction(
      'room_1',
      'msg_1',
      '👍',
      enabled: true,
    );
    final users = await service.listChatReactionUsers(
      'room_1',
      'msg_1',
      '👍',
      limit: 25,
      cursor: 'cursor_1',
    );

    expect(requests[0].method, 'PUT');
    expect(requests[0].url.queryParameters, isEmpty);
    expect(reacted.reactionCount, 3);
    expect(reacted.reactions, hasLength(1));
    expect(reacted.reactions.single.key, '👍');
    expect(reacted.reactions.single.count, 3);
    expect(reacted.reactions.single.reactedByMe, isTrue);

    expect(requests[1].method, 'GET');
    expect(requests[1].url.queryParameters, {
      'message_id': 'msg_1',
      'reaction_key': '👍',
      'limit': '25',
      'cursor': 'cursor_1',
    });
    expect(users.total, 1);
    expect(users.nextCursor, 'cursor_2');
    expect(users.users.single.userId, 'usr_1');
    expect(users.users.single.username, 'alice');
    expect(users.users.single.reactedAt, 1760000200);
  });

  test('chat search and pin endpoints map current protobuf contracts',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/room_1/chat/search':
            return http.Response(
              jsonEncode({
                'messages': [
                  {
                    'id': 'msg_1',
                    'room_id': 'room_1',
                    'user_id': 'usr_sender',
                    'username': 'sender',
                    'content': 'search hit',
                    'timestamp': '1760000100',
                    'version': '1',
                    'status': client_enum
                        .ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE.value,
                    'pin': {
                      'pinned_by_user_id': 'usr_mod',
                      'pinned_by_username': 'mod',
                      'note': 'important',
                      'pinned_at': '1760000200',
                    },
                  }
                ],
                'next_cursor': 'cursor_2',
                'event_cursor': {'sequence': '77'},
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/chat/pinned-messages':
            return http.Response(
              jsonEncode({
                'messages': [
                  {
                    'message': {
                      'id': 'msg_1',
                      'room_id': 'room_1',
                      'user_id': 'usr_sender',
                      'username': 'sender',
                      'content': 'pinned',
                      'timestamp': '1760000100',
                      'version': '1',
                      'status': client_enum
                          .ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE.value,
                    },
                    'pinned_by_user_id': 'usr_mod',
                    'pinned_by_username': 'mod',
                    'note': 'important',
                    'pinned_at': '1760000200',
                  }
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/chat/messages/msg_1/pin':
            if (request.method == 'PUT') {
              return http.Response(
                jsonEncode({
                  'event': {
                    'event_id': 'pin_evt_1',
                    'room_id': 'room_1',
                    'kind': client_enum
                        .ChatPinEventKind.CHAT_PIN_EVENT_KIND_PINNED.value,
                    'message': {
                      'id': 'msg_1',
                      'room_id': 'room_1',
                      'user_id': 'usr_sender',
                      'username': 'sender',
                      'content': 'pinned',
                      'timestamp': '1760000100',
                      'version': '1',
                      'status': client_enum
                          .ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE.value,
                    },
                    'pin': {
                      'pinned_by_user_id': 'usr_mod',
                      'pinned_by_username': 'mod',
                      'note': 'important',
                      'pinned_at': '1760000200',
                    },
                    'occurred_at': '1760000201',
                    'sequence': '78',
                  }
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            return http.Response(
              jsonEncode({
                'event': {
                  'event_id': 'pin_evt_2',
                  'room_id': 'room_1',
                  'kind': client_enum
                      .ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED.value,
                  'message': {
                    'id': 'msg_1',
                    'room_id': 'room_1',
                    'user_id': 'usr_sender',
                    'username': 'sender',
                    'content': 'unpinned',
                    'timestamp': '1760000100',
                    'version': '1',
                    'status': client_enum
                        .ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE.value,
                  },
                  'occurred_at': '1760000301',
                  'sequence': '79',
                }
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response(
            'unexpected ${request.method} ${request.url}', 404);
      }),
    );
    final service = SyncTvRoomMediaDomainService(api);

    final search = await service.searchChatMessages(
      'room_1',
      query: 'needle',
      limit: 25,
      cursor: 'cursor_1',
      includeDeleted: true,
      userId: 'usr_sender',
    );
    final pinned = await service.listPinnedChatMessages('room_1', limit: 10);
    final pinEvent = await service.pinChatMessage(
      'room_1',
      'msg_1',
      note: 'important',
    );
    final unpinEvent = await service.unpinChatMessage('room_1', 'msg_1');

    expect(requests[0].method, 'GET');
    expect(requests[0].url.queryParameters, {
      'query': 'needle',
      'cursor': 'cursor_1',
      'limit': '25',
      'include_deleted': 'true',
      'user_id': 'usr_sender',
    });
    expect(search.nextCursor, 'cursor_2');
    expect(search.eventCursor, '77');
    expect(search.messages.single.isPinned, isTrue);
    expect(search.messages.single.pin?.note, 'important');

    expect(requests[1].method, 'GET');
    expect(requests[1].url.queryParameters, {'limit': '10'});
    expect(pinned.single.message.id, 'msg_1');
    expect(pinned.single.pin.pinnedByUsername, 'mod');

    expect(requests[2].method, 'PUT');
    final pinBody = jsonDecode(requests[2].body) as Map<String, dynamic>;
    expect(pinBody..remove('client_operation_id'), {
      'message_id': 'msg_1',
      'note': 'important',
    });
    expect(jsonDecode(requests[2].body),
        containsPair('client_operation_id', isA<String>()));
    expect(pinEvent.eventId, 'pin_evt_1');
    expect(pinEvent.kind,
        client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_PINNED.value);
    expect(pinEvent.pin?.pinnedAt, 1760000200);

    expect(requests[3].method, 'DELETE');
    final unpinBody = jsonDecode(requests[3].body) as Map<String, dynamic>;
    expect(unpinBody..remove('client_operation_id'), {
      'message_id': 'msg_1',
    });
    expect(jsonDecode(requests[3].body),
        containsPair('client_operation_id', isA<String>()));
    expect(unpinEvent.kind,
        client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED.value);
    expect(unpinEvent.pin, isNull);
  });

  test('chat pin watch decodes SSE resource events', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/chat-pin-events');
      expect(request.uri.queryParameters, {
        'delivery_mode': 'push_snapshot',
        'after_event_sequence': '76',
      });
      request.response
        ..statusCode = 200
        ..headers.contentType =
            io.ContentType('text', 'event-stream', charset: 'utf-8')
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
                'observeId': 'chat_pin_events',
                'eventCursor': {'sequence': '78'},
                'chatPinEvent': {
                  'eventId': 'pin_evt_1',
                  'roomId': 'room_1',
                  'kind': 'CHAT_PIN_EVENT_KIND_PINNED',
                  'message': {
                    'id': 'msg_1',
                    'roomId': 'room_1',
                    'userId': 'usr_sender',
                    'username': 'sender',
                    'content': 'pinned',
                    'timestamp': '1760000100',
                    'status': 'CHAT_MESSAGE_STATUS_ACTIVE',
                  },
                  'pin': {
                    'pinnedByUserId': 'usr_mod',
                    'pinnedByUsername': 'mod',
                    'note': 'important',
                    'pinnedAt': '1760000200',
                  },
                  'occurredAt': '1760000201',
                  'sequence': '78',
                },
              })}\n\n',
        );
      await request.response.close();
    });
    final api = SyncTvApiClient(
      baseUrl: 'http://${server.address.host}:${server.port}',
      session: SyncTvSession()..accessToken = 'token',
    );
    final service = SyncTvRoomMediaDomainService(api);

    try {
      final event =
          await service.watchChatPinEvents('room_1', version: '76').first;

      expect(event.kind, RoomResourceWatchKind.changed);
      expect(event.version, '78');
      expect(event.snapshot?.eventId, 'pin_evt_1');
      expect(event.snapshot?.message.id, 'msg_1');
      expect(event.snapshot?.pin?.note, 'important');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('content reports can target rooms, users, members, and chat messages',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        expect(request.method, 'POST');
        expect(request.url.path, '/api/rooms/room_1/reports');
        return http.Response(
          jsonEncode({'report_id': 'report_${requests.length}'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvRoomMediaDomainService(api);

    await service.reportRoom(
      'room_1',
      reasonCode: 'spam',
      reason: 'room reason',
    );
    await service.reportUser(
      'room_1',
      'usr_target',
      reasonCode: 'abuse',
      reason: 'user reason',
    );
    await service.reportRoomMember(
      'room_1',
      'usr_member',
      reasonCode: 'illegal',
      reason: 'member reason',
    );
    await service.reportChatMessage(
      'room_1',
      'msg_1',
      reasonCode: 'other',
      reason: 'message reason',
    );

    expect(requests, hasLength(4));
    expect(jsonDecode(requests[0].body), {
      'room': {'room_id': 'room_1'},
      'reason_code': 'spam',
      'reason': 'room reason',
    });
    expect(jsonDecode(requests[1].body), {
      'user': {'user_id': 'usr_target'},
      'reason_code': 'abuse',
      'reason': 'user reason',
    });
    expect(jsonDecode(requests[2].body), {
      'room_member': {'room_id': 'room_1', 'user_id': 'usr_member'},
      'reason_code': 'illegal',
      'reason': 'member reason',
    });
    expect(jsonDecode(requests[3].body), {
      'chat_message': {'room_id': 'room_1', 'message_id': 'msg_1'},
      'reason_code': 'other',
      'reason': 'message reason',
    });
  });

  test('single chat message endpoint is exposed through room media service',
      () async {
    http.Request? captured;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        captured = request;
        return http.Response(
          jsonEncode({
            'message': {
              'id': 'msg_42',
              'room_id': 'room_1',
              'user_id': 'usr_sender',
              'username': 'sender',
              'content': 'single message',
              'timestamp': '1760000300',
              'version': '4',
              'status': client_enum
                  .ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE.value,
              'display_position': 'top',
              'display_color': '#ffcc00',
            }
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvRoomMediaDomainService(api);

    final message = await service.getChatMessage(
      'room_1',
      'msg_42',
      includeDeleted: true,
    );

    expect(captured, isNotNull);
    expect(captured!.method, 'GET');
    expect(captured!.url.path, '/api/rooms/room_1/chat/messages/msg_42');
    expect(captured!.url.queryParameters, {
      'message_id': 'msg_42',
      'include_deleted': 'true',
    });
    expect(message.id, 'msg_42');
    expect(message.content, 'single message');
    expect(message.version, 4);
    expect(message.displayPosition, 'top');
    expect(message.displayColor, '#ffcc00');
  });

  test('chat reaction realtime event updates the existing message', () {
    final messages = <RoomRealtimeChatEntry>[
      const RoomRealtimeChatEntry(
        id: 'msg_1',
        userId: 'usr_sender',
        username: 'sender',
        content: 'hello',
        timestampMillis: 1760000100000,
      ),
    ];
    final updated = RoomRealtimeChatEntry.fromHistory(
      const RoomChatMessageInfo(
        id: 'msg_1',
        roomId: 'room_1',
        userId: 'usr_sender',
        username: 'sender',
        content: 'hello',
        timestamp: 1760000100,
        reactions: [
          ChatReactionSummaryInfo(
            key: 'like',
            count: 1,
            reactedByMe: true,
          )
        ],
        reactionCount: 1,
      ),
    );

    messages.applyRealtimeEvent(
      updated,
      eventKind: RoomRealtimeChatEventKind.reactionsChanged,
      maxEntries: 100,
    );

    expect(messages, hasLength(1));
    expect(messages.single.id, 'msg_1');
    expect(messages.single.content, 'hello');
  });

  test('chat reaction summary is appended to playback danmaku text', () {
    const reactions = [
      ChatReactionSummaryInfo(key: '👍', count: 2, reactedByMe: false),
      ChatReactionSummaryInfo(key: '😂', count: 5, reactedByMe: true),
      ChatReactionSummaryInfo(key: '🎉', count: 3, reactedByMe: false),
    ];
    final danmaku = chatMessageToDanmaku(
      const RoomChatMessageInfo(
        id: 'msg_1',
        roomId: 'room_1',
        userId: 'usr_sender',
        username: 'sender',
        content: 'hello',
        timestamp: 1760000100,
        displayPosition: '12.5',
        reactions: reactions,
        reactionCount: 10,
      ),
    );

    expect(chatReactionSummarySuffix(reactions), '  😂5 🎉3');
    expect(danmaku.text, 'sender: hello  😂5 🎉3');
  });

  test('avatar upload completes ownership proof before update', () async {
    final upload = LocalImageUpload(
      bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
      fileName: 'avatar.png',
      mimeType: 'image/png',
      width: 2,
      height: 3,
    );
    Map<String, dynamic>? updateBody;
    Map<String, dynamic>? completeBody;
    var uploadSessionRequests = 0;

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        if (request.method == 'POST' &&
            request.url.path == '/api/user/avatar/upload-session') {
          uploadSessionRequests += 1;
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final parts = body['parts'] as List<dynamic>? ?? const [];
          if (parts.isEmpty) {
            return http.Response(
              jsonEncode({
                'plan': {
                  'checksum_algorithm': 'sha256',
                  'part_size_bytes': upload.sizeBytes,
                  'parts': [
                    {
                      'part_number': 1,
                      'offset_bytes': 0,
                      'size_bytes': upload.sizeBytes,
                    }
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          expect(parts, [
            {
              'part_number': 1,
              'offset_bytes': '0',
              'size_bytes': upload.sizeBytes.toString(),
              'checksum_sha256': upload.checksumSha256,
            }
          ]);
          return http.Response(
            jsonEncode({
              'session': {
                'avatar_reference': {'id': 'avatar_1'},
                'upload_required': false,
                'ownership_proof_required': true,
                'ownership_proof_nonce': 'nonce_1',
                'ownership_proof_ranges': [
                  {'offset': 1, 'length': 3}
                ],
                'upload_token': 'upload-token',
                'encoded_object_key': 'avatar-object-key',
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'POST' &&
            request.url.path ==
                '/api/user/avatar-objects/avatar-object-key/complete') {
          completeBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'complete': true,
              'uploaded_size_bytes': upload.sizeBytes,
              'uploaded_parts': [1],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' && request.url.path == '/api/user/avatar') {
          updateBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'usr_1',
                'username': 'root',
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
            'unexpected request: ${request.method} '
            '${request.url.path}',
            404);
      }),
    );

    final updated =
        await SyncTvFileUploadDomainService(api).updateUserAvatar(upload);

    expect(updated.id, 'usr_1');
    expect(uploadSessionRequests, 2);
    expect(updateBody?['avatar_reference'], {'id': 'avatar_1'});
    expect(completeBody?['file_id'], 'avatar_1');
    expect(completeBody?['token'], 'upload-token');
    expect(completeBody?['parts'], [
      {
        'part_number': 1,
        'etag': '',
        'size_bytes': upload.sizeBytes.toString(),
        'checksum_sha256': upload.checksumSha256,
      }
    ]);
    expect(
      completeBody?['ownership_proof'],
      _expectedOwnershipProof(
        upload.bytes,
        nonce: 'nonce_1',
        contentManifestSha256: _expectedContentManifestSha256(
          upload.sizeBytes,
          upload.sizeBytes,
          [
            (
              partNumber: 1,
              sizeBytes: upload.sizeBytes,
              checksum: upload.checksumSha256
            )
          ],
        ),
        ranges: const [(offset: 1, length: 3)],
      ),
    );
  });

  test('object upload facades send raw bytes and parse progress headers',
      () async {
    final uploadBytes = Uint8List.fromList([1, 2, 3, 4]);
    final range = client.FileUploadRange(
      start: Int64(1),
      endInclusive: Int64(3),
      totalSize: Int64(9),
    );
    final expectedPaths = <String>{
      '/api/user/avatar-objects/avatar-object-key',
      '/api/chat/attachment-objects/chat-attachment-key',
      '/api/room/cover-objects/room-cover-key',
      '/api/playlist/cover-objects/playlist-cover-key',
      '/api/media/cover-objects/media-cover-key',
    };
    final seenPaths = <String>[];

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'access-token',
      httpClient: MockClient((request) async {
        seenPaths.add(request.url.path);
        expect(request.method, 'PUT');
        expect(expectedPaths, contains(request.url.path));
        expect(request.headers.containsKey('authorization'), isFalse);
        expect(request.headers['x-synctv-file-upload-token'], 'upload-token');
        expect(request.headers['content-type'], 'image/png');
        expect(request.bodyBytes, uploadBytes);
        if (request.url.path.endsWith('/avatar-object-key')) {
          expect(request.headers['content-range'], 'bytes 1-3/9');
        } else {
          expect(request.headers.containsKey('content-range'), isFalse);
        }
        return http.Response(
          '',
          204,
          headers: {
            'x-synctv-upload-complete': 'true',
            'x-synctv-uploaded-size-bytes': uploadBytes.length.toString(),
            'x-synctv-uploaded-parts': '1,2',
          },
        );
      }),
    );

    final cases = <Future<dynamic>>[
      api.user.uploadUserAvatarObject(
        client.UploadUserAvatarObjectRequest(
          encodedObjectKey: 'avatar-object-key',
          token: 'upload-token',
          contentType: 'image/png',
          data: uploadBytes,
          contentRange: range,
        ),
      ),
      api.room.uploadChatAttachmentObject(
        client.UploadChatAttachmentObjectRequest(
          roomId: 'room_1',
          encodedObjectKey: 'chat-attachment-key',
          token: 'upload-token',
          contentType: 'image/png',
          data: uploadBytes,
        ),
      ),
      api.room.uploadRoomCoverObject(
        client.UploadRoomCoverObjectRequest(
          encodedObjectKey: 'room-cover-key',
          token: 'upload-token',
          contentType: 'image/png',
          data: uploadBytes,
        ),
      ),
      api.room.uploadPlaylistCoverObject(
        client.UploadPlaylistCoverObjectRequest(
          encodedObjectKey: 'playlist-cover-key',
          token: 'upload-token',
          contentType: 'image/png',
          data: uploadBytes,
        ),
      ),
      api.room.uploadMediaCoverObject(
        client.UploadMediaCoverObjectRequest(
          encodedObjectKey: 'media-cover-key',
          token: 'upload-token',
          contentType: 'image/png',
          data: uploadBytes,
        ),
      ),
    ];

    for (final pending in cases) {
      final response = await pending;
      expect(response.complete, isTrue);
      expect(response.uploadedSizeBytes, Int64(uploadBytes.length));
      expect(response.uploadedParts, [1, 2]);
    }
    expect(seenPaths.toSet(), expectedPaths);
  });

  test('object get facades map token, range, bytes, and response headers',
      () async {
    const manifest =
        '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
    final body = Uint8List.fromList([8, 9, 10]);
    final expectedPaths = <String>{
      '/api/user/avatar-objects/avatar-object-key',
      '/api/chat/attachment-objects/chat-attachment-key',
      '/api/room/cover-objects/room-cover-key',
      '/api/playlist/cover-objects/playlist-cover-key',
      '/api/media/cover-objects/media-cover-key',
    };
    final rangeHeaders = <String, String>{
      '/api/user/avatar-objects/avatar-object-key': 'bytes=1-3',
      '/api/chat/attachment-objects/chat-attachment-key': 'bytes=4-',
      '/api/room/cover-objects/room-cover-key': 'bytes=-5',
    };
    final seenPaths = <String>[];

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'access-token',
      httpClient: MockClient((request) async {
        seenPaths.add(request.url.path);
        expect(request.method, 'GET');
        expect(expectedPaths, contains(request.url.path));
        expect(request.headers.containsKey('authorization'), isFalse);
        expect(request.url.queryParameters['token'], 'download-token');
        final expectedRange = rangeHeaders[request.url.path];
        if (expectedRange == null) {
          expect(request.headers.containsKey('range'), isFalse);
          return http.Response.bytes(
            body,
            200,
            headers: {
              'content-type': 'image/webp',
              'content-length': body.length.toString(),
              'x-synctv-content-manifest-sha256': manifest,
            },
          );
        }
        expect(request.headers['range'], expectedRange);
        return http.Response.bytes(
          body,
          206,
          headers: {
            'content-type': 'image/webp',
            'content-range': 'bytes 1-3/9',
            'x-synctv-content-manifest-sha256': manifest,
          },
        );
      }),
    );

    final responses = <dynamic>[
      await api.user.getUserAvatarObject(
        client.GetUserAvatarObjectRequest(
          encodedObjectKey: 'avatar-object-key',
          token: 'download-token',
          range: client.FileRangeRequest(
            exact: client.FileByteRange(
              start: Int64(1),
              endInclusive: Int64(3),
            ),
          ),
        ),
      ),
      await api.room.getChatAttachmentObject(
        client.GetChatAttachmentObjectRequest(
          roomId: 'room_1',
          encodedObjectKey: 'chat-attachment-key',
          token: 'download-token',
          range: client.FileRangeRequest(fromStart: Int64(4)),
        ),
      ),
      await api.room.getRoomCoverObject(
        client.GetRoomCoverObjectRequest(
          encodedObjectKey: 'room-cover-key',
          token: 'download-token',
          range: client.FileRangeRequest(suffixLength: Int64(5)),
        ),
      ),
      await api.room.getPlaylistCoverObject(
        client.GetPlaylistCoverObjectRequest(
          encodedObjectKey: 'playlist-cover-key',
          token: 'download-token',
        ),
      ),
      await api.room.getMediaCoverObject(
        client.GetMediaCoverObjectRequest(
          encodedObjectKey: 'media-cover-key',
          token: 'download-token',
        ),
      ),
    ];

    for (final response in responses) {
      expect(response.mimeType, 'image/webp');
      expect(response.contentManifestSha256, manifest);
      expect(response.data, body);
    }
    expect(responses[0].totalSizeBytes, Int64(9));
    expect(responses[1].totalSizeBytes, Int64(9));
    expect(responses[2].totalSizeBytes, Int64(9));
    expect(responses[3].totalSizeBytes, Int64(body.length));
    expect(responses[4].totalSizeBytes, Int64(body.length));
    expect(responses[0].contentRange.start, Int64(1));
    expect(responses[0].contentRange.endInclusive, Int64(3));
    expect(responses[1].contentRange.start, Int64(1));
    expect(responses[2].contentRange.endInclusive, Int64(3));
    expect(responses[3].hasContentRange(), isFalse);
    expect(responses[4].hasContentRange(), isFalse);
    expect(responses[1].roomId, 'room_1');
    expect(seenPaths.toSet(), expectedPaths);
  });

  test('avatar upload session sends whole-object upload without byte range',
      () async {
    final upload = LocalImageUpload(
      bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
      fileName: 'avatar.png',
      mimeType: 'image/png',
      width: 2,
      height: 3,
    );
    Map<String, dynamic>? completeBody;
    List<int>? uploadedBody;
    Map<String, String>? uploadedHeaders;
    var uploadSessionRequests = 0;

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        if (request.method == 'POST' &&
            request.url.path == '/api/user/avatar/upload-session') {
          uploadSessionRequests += 1;
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final parts = body['parts'] as List<dynamic>? ?? const [];
          if (parts.isEmpty) {
            return http.Response(
              jsonEncode({
                'plan': {
                  'checksum_algorithm': 'sha256',
                  'part_size_bytes': upload.sizeBytes,
                  'parts': [
                    {
                      'part_number': 1,
                      'offset_bytes': 0,
                      'size_bytes': upload.sizeBytes,
                    }
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response(
            jsonEncode({
              'session': {
                'avatar_reference': {'id': 'avatar_2'},
                'upload_required': true,
                'upload_url': '/api/user/avatar-objects/avatar-object-key',
                'upload_headers': {
                  'x-synctv-file-upload-token': 'upload-token',
                  'x-upload-extra': '1',
                },
                'upload_token': 'upload-token',
                'encoded_object_key': 'avatar-object-key',
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' &&
            request.url.path == '/api/user/avatar-objects/avatar-object-key') {
          uploadedBody = request.bodyBytes;
          uploadedHeaders = Map<String, String>.from(request.headers);
          return http.Response('', 204, headers: {'etag': 'etag-1'});
        }
        if (request.method == 'POST' &&
            request.url.path ==
                '/api/user/avatar-objects/avatar-object-key/complete') {
          completeBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'complete': true,
              'uploaded_size_bytes': upload.sizeBytes,
              'uploaded_parts': [1],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' && request.url.path == '/api/user/avatar') {
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'usr_1',
                'username': 'root',
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
            'unexpected request: ${request.method} '
            '${request.url.path}',
            404);
      }),
    );

    final updated =
        await SyncTvFileUploadDomainService(api).updateUserAvatar(upload);

    expect(updated.id, 'usr_1');
    expect(uploadSessionRequests, 2);
    expect(uploadedBody, upload.bytes);
    expect(uploadedHeaders?['x-synctv-file-upload-token'], 'upload-token');
    expect(uploadedHeaders?['x-upload-extra'], '1');
    expect(uploadedHeaders?['content-type'], 'image/png');
    expect(uploadedHeaders?.containsKey('content-range'), isFalse);
    expect(completeBody?['parts'], [
      {
        'part_number': 1,
        'etag': 'etag-1',
        'size_bytes': upload.sizeBytes.toString(),
        'checksum_sha256': upload.checksumSha256,
      }
    ]);
  });

  test('avatar upload session sends byte ranges for server-mediated parts',
      () async {
    final upload = LocalImageUpload(
      bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
      fileName: 'avatar.png',
      mimeType: 'image/png',
      width: 2,
      height: 3,
    );
    final uploadedRanges = <String>[];
    var uploadSessionRequests = 0;

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        if (request.method == 'POST' &&
            request.url.path == '/api/user/avatar/upload-session') {
          uploadSessionRequests += 1;
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final parts = body['parts'] as List<dynamic>? ?? const [];
          if (parts.isEmpty) {
            return http.Response(
              jsonEncode({
                'plan': {
                  'checksum_algorithm': 'sha256',
                  'part_size_bytes': 3,
                  'parts': [
                    {
                      'part_number': 1,
                      'offset_bytes': 0,
                      'size_bytes': 3,
                    },
                    {
                      'part_number': 2,
                      'offset_bytes': 3,
                      'size_bytes': 3,
                    }
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response(
            jsonEncode({
              'session': {
                'avatar_reference': {'id': 'avatar_2'},
                'upload_required': true,
                'upload_url': '/api/user/avatar-objects/avatar-object-key',
                'upload_headers': {
                  'x-synctv-file-upload-token': 'upload-token',
                },
                'upload_token': 'upload-token',
                'encoded_object_key': 'avatar-object-key',
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' &&
            request.url.path == '/api/user/avatar-objects/avatar-object-key') {
          uploadedRanges.add(request.headers['content-range'] ?? '');
          return http.Response(
            '',
            204,
            headers: {'etag': 'etag-${uploadedRanges.length}'},
          );
        }
        if (request.method == 'POST' &&
            request.url.path ==
                '/api/user/avatar-objects/avatar-object-key/complete') {
          return http.Response(
            jsonEncode({
              'complete': true,
              'uploaded_size_bytes': upload.sizeBytes,
              'uploaded_parts': [1, 2],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' && request.url.path == '/api/user/avatar') {
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'usr_1',
                'username': 'root',
              }
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
            'unexpected request: ${request.method} '
            '${request.url.path}',
            404);
      }),
    );

    final updated =
        await SyncTvFileUploadDomainService(api).updateUserAvatar(upload);

    expect(updated.id, 'usr_1');
    expect(uploadSessionRequests, 2);
    expect(uploadedRanges, ['bytes 0-2/6', 'bytes 3-5/6']);
  });

  test('OAuth2 callback parser accepts callback URLs and validates state', () {
    final parsed = OAuth2CallbackParser.parse(
      Uri.parse(
        'http://127.0.0.1:49152/oauth2/callback?code=abc123._+-&state=AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
    );

    expect(parsed.code, 'abc123._+-');
    expect(parsed.state, 'AbCdEfGh1234567890aBcDeFgHiJkLm');

    final loopback = OAuth2CallbackParser.parse(
      Uri.parse(
        'http://127.0.0.1:49152/oauth2/callback?code=xyz&state=AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
    );
    expect(loopback.code, 'xyz');

    expect(
      () => OAuth2CallbackParser.parse(
        Uri.parse('code=xyz&state=AbCdEfGh1234567890aBcDeFgHiJkLm'),
        expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      throwsArgumentError,
    );

    expect(
      () => OAuth2CallbackParser.parse(
        Uri.parse(
            'http://127.0.0.1:49152/oauth2/callback?code=abc&state=wrong'),
        expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      throwsArgumentError,
    );

    expect(
      () => OAuth2CallbackParser.parse(
        Uri.parse(
          'http://example.com/oauth2/callback?code=abc&state=AbCdEfGh1234567890aBcDeFgHiJkLm',
        ),
        expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      throwsArgumentError,
    );

    expect(
      () => OAuth2CallbackParser.parse(Uri.parse('plain-code')),
      throwsArgumentError,
    );
  });

  test('OAuth2 app link origin rejects custom schemes', () {
    expect(OAuth2CallbackConfig.hasMobileOrigin, isFalse);
    expect(
      OAuth2DeepLinkService.canCreateSession,
      io.Platform.isWindows || io.Platform.isMacOS || io.Platform.isLinux,
    );
    expect(
      () => OAuth2DeepLinkService.mobileCallbackUrl,
      throwsStateError,
    );
    expect(
      OAuth2CallbackConfig.parseMobileOrigin('https://app.synctv.local').host,
      'app.synctv.local',
    );
    expect(
      OAuth2CallbackConfig.parseMobileOrigin(
        'https://app.synctv.local/oauth2/callback',
      ).toString(),
      'https://app.synctv.local',
    );
    final appLinkOrigin =
        OAuth2CallbackConfig.parseMobileOrigin('https://app.synctv.local');
    expect(
      OAuth2CallbackConfig.isMobileCallbackUriForOrigin(
        Uri.parse(
          'https://app.synctv.local/oauth2/callback?code=abc&state=xyz',
        ),
        appLinkOrigin,
      ),
      isTrue,
    );
    expect(
      OAuth2CallbackConfig.isMobileCallbackUriForOrigin(
        Uri.parse(
          'https://app.synctv.local:8443/oauth2/callback?code=abc&state=xyz',
        ),
        appLinkOrigin,
      ),
      isFalse,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin(
        'https://app.synctv.local:8443',
      ),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin('native-app://callback'),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin('http://app.synctv.local'),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin('https:///callback'),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin(
        'https://app.synctv.local?callback=1',
      ),
      throwsStateError,
    );
    expect(
      OAuth2DeepLinkService.isOAuth2Callback(
        Uri.parse(
          'https://app.synctv.local/oauth2/callback?code=abc&state=xyz',
        ),
      ),
      isFalse,
    );
  });

  test('WebRTC manager uses server-provided ICE servers', () async {
    var loadCount = 0;
    final manager = WebRTCManager(
      loadIceServers: () async {
        loadCount += 1;
        return [
          const IceServerInfo(
            urls: ['turn:turn.example.test:3478'],
            username: 'alice',
            credential: 'secret',
          ),
        ];
      },
      onSignalingMessage: (_, __) {},
      onStateChange: () {},
    );

    final first = await manager.loadIceServerConfigurationForTest();
    final second = await manager.loadIceServerConfigurationForTest();

    expect(loadCount, 1);
    expect(first, same(second));
    expect(first, [
      {
        'urls': ['turn:turn.example.test:3478'],
        'username': 'alice',
        'credential': 'secret',
      },
    ]);
  });

  test('WebRTC signaling encoder maps manager events to protobuf messages', () {
    final offer = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeWebRtcSignal('offer', {
        'sdp': 'sdp-offer',
        'type': 'offer',
        'to': 'usr_peer:conn_1',
      }),
    );
    expect(offer.hasWebrtc(), isTrue);
    expect(offer.webrtc.hasOffer(), isTrue);
    expect(offer.webrtc.offer.to, 'usr_peer:conn_1');
    expect(jsonDecode(offer.webrtc.offer.data), {
      'sdp': 'sdp-offer',
      'type': 'offer',
      'to': 'usr_peer:conn_1',
    });

    final join = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeWebRtcSignal('join', const {}),
    );
    expect(join.hasWebrtc(), isTrue);
    expect(join.webrtc.hasJoin(), isTrue);

    expect(RoomRealtimeCodec.encodeWebRtcSignal('unknown', const {}), isEmpty);
  });

  test('API client resolves server-relative resource URLs', () {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/synctv/api',
      session: SyncTvSession(),
    );
    expect(api.baseUrl, 'https://example.test/synctv');

    expect(
      api.resolveResourceUrl('/api/providers/proxy/emby/movie.mp4?token=abc'),
      'https://example.test/synctv/api/providers/proxy/emby/movie.mp4?token=abc',
    );
    expect(
      api.resolveResourceUrl('api/providers/emby/thumbnail/item_1'),
      'https://example.test/synctv/api/providers/emby/thumbnail/item_1',
    );
    expect(
      api.resolveResourceUrl('https://cdn.example.test/movie.mp4'),
      'https://cdn.example.test/movie.mp4',
    );
  });

  test('provider bind aggregation follows available instance protobuf API',
      () async {
    final requests = <http.Request>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requests.add(http.Request(request.method, request.uri));
      request.response.headers.contentType = io.ContentType.json;

      final instanceName = request.uri.queryParameters['instance_name'] ?? '';
      if (request.uri.path == '/api/providers/instances/available') {
        request.response.write(jsonEncode({
          'instances': ['', 'edge', 'edge'],
        }));
      } else if (request.uri.path == '/api/providers/alist/binds') {
        request.response.write(jsonEncode({
          'binds': instanceName == 'edge'
              ? [
                  {
                    'id': 'alist_edge',
                    'server_id': 'alist_server_edge',
                    'host': 'https://alist-edge.example.test',
                    'username': 'edge-user',
                    'created_at': 2,
                    'provider_instance_name': 'edge',
                  }
                ]
              : [
                  {
                    'id': 'alist_default_a',
                    'server_id': 'alist_server_default',
                    'host': 'https://alist.example.test',
                    'username': 'default-user',
                    'created_at': 1,
                    'provider_instance_name': '',
                  },
                  {
                    'id': 'alist_default_b',
                    'server_id': 'alist_server_default',
                    'host': 'https://alist.example.test',
                    'username': 'default-user',
                    'created_at': 1,
                    'provider_instance_name': '',
                  }
                ],
        }));
      } else if (request.uri.path == '/api/providers/emby/binds') {
        request.response.write(jsonEncode({
          'binds': [
            {
              'id': instanceName == 'edge' ? 'emby_edge' : 'emby_default',
              'server_id':
                  instanceName == 'edge' ? 'emby_server_edge' : 'emby_server',
              'host': instanceName == 'edge'
                  ? 'https://emby-edge.example.test'
                  : 'https://emby.example.test',
              'user_id': instanceName == 'edge' ? 'edge-user' : 'default-user',
              'created_at': instanceName == 'edge' ? 4 : 3,
              'provider_instance_name': instanceName,
            }
          ],
        }));
      } else if (request.uri.path == '/api/providers/bilibili/binds') {
        request.response.write(jsonEncode({
          'binds': [
            {
              'id': instanceName == 'edge' ? 'bili_edge' : 'bili_default',
              'server_id':
                  instanceName == 'edge' ? 'bili_server_edge' : 'bili_server',
              'created_at': instanceName == 'edge' ? 6 : 5,
              'provider_instance_name': instanceName,
            }
          ],
        }));
      } else {
        request.response
          ..statusCode = 404
          ..write('{}');
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final alistBinds = await SyncTvService.getAllAlistBindInfos();
      final embyBinds = await SyncTvService.getAllEmbyBindInfos();
      final bilibiliBinds = await SyncTvService.getAllBilibiliBindInfos();

      expect(alistBinds.map((bind) => bind.serverId), [
        'alist_server_default',
        'alist_server_edge',
      ]);
      expect(alistBinds.last.providerInstanceName, 'edge');
      expect(embyBinds.map((bind) => bind.providerInstanceName), ['', 'edge']);
      expect(
          bilibiliBinds.map((bind) => bind.providerInstanceName), ['', 'edge']);

      final availableRequests = requests.where(
        (request) => request.url.path == '/api/providers/instances/available',
      );
      expect(
        availableRequests.map(
          (request) => request.url.queryParameters['provider_type'],
        ),
        ['alist', 'emby', 'bilibili'],
      );
      expect(
        requests.map(
          (request) =>
              '${request.url.path}?${request.url.queryParameters['instance_name'] ?? ''}',
        ),
        containsAll([
          '/api/providers/alist/binds?',
          '/api/providers/alist/binds?edge',
          '/api/providers/emby/binds?',
          '/api/providers/emby/binds?edge',
          '/api/providers/bilibili/binds?',
          '/api/providers/bilibili/binds?edge',
        ]),
      );
      expect(
        requests
            .where((request) =>
                request.url.path == '/api/providers/alist/binds' &&
                !request.url.queryParameters.containsKey('instance_name'))
            .length,
        1,
      );
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test(
      'provider bind aggregation includes default local instance when discovery is empty',
      () async {
    final requests = <http.Request>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requests.add(http.Request(request.method, request.uri));
      request.response.headers.contentType = io.ContentType.json;
      if (request.uri.path == '/api/providers/instances/available') {
        request.response.write(jsonEncode({'instances': []}));
      } else if (request.uri.path == '/api/providers/alist/binds') {
        request.response.write(jsonEncode({
          'binds': [
            {
              'id': 'alist_default',
              'server_id': 'alist_server_default',
              'host': 'https://alist.example.test',
              'username': 'default-user',
              'created_at': 1,
              'provider_instance_name': '',
            }
          ],
        }));
      } else {
        request.response
          ..statusCode = 404
          ..write('{}');
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final binds = await SyncTvService.getAllAlistBindInfos();

      expect(binds.map((bind) => bind.serverId), ['alist_server_default']);
      expect(binds.single.providerInstanceName, isEmpty);

      final paths = requests.map((request) => request.url.path);
      expect(paths, contains('/api/providers/instances/available'));
      expect(paths, contains('/api/providers/alist/binds'));
      expect(
        requests
            .where(
                (request) => request.url.path == '/api/providers/alist/binds')
            .single
            .url
            .queryParameters,
        isNot(contains('instance_name')),
      );
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('API client refreshes access token once before retrying request',
      () async {
    final requests = <http.Request>[];
    var persistedRefresh = false;
    var authErrors = 0;
    final session = SyncTvSession()
      ..accessToken = 'expired-access'
      ..refreshToken = 'refresh-token';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      onAuthError: () => authErrors++,
      onTokenRefresh: () async => persistedRefresh = true,
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/user') {
          if (requests.where((item) => item.url.path == '/api/user').length ==
              1) {
            return http.Response(
              jsonEncode({'message': 'expired'}),
              401,
              headers: {'content-type': 'application/json'},
            );
          }
          expect(request.headers['authorization'], 'Bearer fresh-access');
          return http.Response(
            jsonEncode({
              'user': {'id': 'usr_1', 'username': 'alice'},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/auth/refresh') {
          expect(jsonDecode(request.body), {'refresh_token': 'refresh-token'});
          return http.Response(
            jsonEncode({
              'access_token': 'fresh-access',
              'refresh_token': 'fresh-refresh',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('not found', 404);
      }),
    );

    final profile = await api.user.getProfile(client.GetProfileRequest());

    expect(profile.user.id, 'usr_1');
    expect(session.accessToken, 'fresh-access');
    expect(session.refreshToken, 'fresh-refresh');
    expect(persistedRefresh, isTrue);
    expect(authErrors, 0);
    expect(requests.map((request) => request.url.path), [
      '/api/user',
      '/api/auth/refresh',
      '/api/user',
    ]);
  });

  test('service fetches a single media record from protobuf endpoint',
      () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'id': 'med_1',
            'room_id': 'room_1',
            'source_provider': 'direct_url',
            'name': 'Feature',
            'creator_id': 'user_1',
            'provider_instance_name': 'edge',
            'position': 12.5,
            'added_at': '1760000100',
            'availability': client.ResourceAvailability
                .RESOURCE_AVAILABILITY_CREATOR_INACTIVE.value,
            'version': '91',
            'metadata': {
              'url': '/api/providers/proxy/direct/feature.mp4',
              'headers': {'x-media': '1'},
            },
            'source_config': {'url': 'https://origin.example/feature.mp4'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final media = api.mapMedia(
      await api.room.getMedia(
        'room_1',
        client.GetMediaRequest(mediaId: 'med_1'),
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/media/med_1');
    expect(media.id, 'med_1');
    expect(media.name, 'Feature');
    expect(
      media.url,
      'https://example.test/api/providers/proxy/direct/feature.mp4',
    );
    expect(media.creator, 'user_1');
    expect(media.roomId, 'room_1');
    expect(media.position, 12.5);
    expect(media.addedAt, 1760000100);
    expect(media.sourceProvider, 'direct_url');
    expect(media.providerInstanceName, 'edge');
    expect(
      media.availability,
      client.ResourceAvailability.RESOURCE_AVAILABILITY_CREATOR_INACTIVE.value,
    );
    expect(media.version, 91);
    expect(media.proxy, isFalse);
    expect(media.headers, {'x-media': '1'});
    expect(media.sourceConfig['url'], 'https://origin.example/feature.mp4');
  });

  test('service fetches playlist and media details from protobuf endpoints',
      () async {
    final requests = <http.Request>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final listener = server.listen((request) async {
      requests.add(http.Request(request.method, request.uri));
      request.response.headers.contentType = io.ContentType.json;
      if (request.uri.path == '/api/rooms/room_1/playlists/pl_1') {
        request.response.write(jsonEncode({
          'playlist': {
            'id': 'pl_1',
            'room_id': 'room_1',
            'name': 'Season 1',
            'parent_id': '',
            'is_dynamic': true,
            'source_provider': 'alist',
            'provider_instance_name': 'alist_main',
            'source_config': {'path': '/shows/season-1'},
          },
          'child_folder_count': 2,
          'media_count': 8,
        }));
      } else if (request.uri.path == '/api/rooms/room_1/media/med_1') {
        request.response.write(jsonEncode({
          'id': 'med_1',
          'room_id': 'room_1',
          'source_provider': 'direct_url',
          'name': 'Episode 1',
          'creator_id': 'usr_creator',
          'provider_instance_name': 'edge',
          'metadata': {
            'url': '/api/providers/proxy/direct/episode-1.mp4',
          },
          'source_config': {'url': 'https://origin.example/episode-1.mp4'},
        }));
      } else {
        request.response.statusCode = 404;
        request.response.write('{}');
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final playlist = await SyncTvService.getPlaylist(
        'room_1',
        'pl_1',
      );
      final media = await SyncTvService.getMedia('room_1', 'med_1');

      expect(playlist.playlist.id, 'pl_1');
      expect(playlist.playlist.name, 'Season 1');
      expect(playlist.playlist.isFolder, isTrue);
      expect(playlist.playlist.playbackPlaylistId, 'pl_1');
      expect(playlist.playlist.metadata['is_dynamic'], isTrue);
      expect(playlist.playlist.sourceProvider, 'alist');
      expect(playlist.playlist.providerInstanceName, 'alist_main');
      expect(playlist.playlist.sourceConfig['path'], '/shows/season-1');
      expect(playlist.childFolderCount, 2);
      expect(playlist.mediaCount, 8);
      expect(media.id, 'med_1');
      expect(media.creator, 'usr_creator');
      expect(media.proxy, isFalse);
      expect(media.sourceConfig['url'], 'https://origin.example/episode-1.mp4');
      expect(requests.map((request) => request.url.path), [
        '/api/rooms/room_1/playlists/pl_1',
        '/api/rooms/room_1/media/med_1',
      ]);
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }
  });

  test('watch playlist items query is derived from protobuf requests',
      () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response('', 200, headers: {
          'content-type': 'text/event-stream',
        });
      }),
    );

    await api.room
        .watchPlaylistItems(
          'room_1',
          client.WatchPlaylistItemsRequest(
            deliveryMode:
                client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
            playlistItems: client.ObservePlaylistItems(
              afterEventSequence: Int64(7),
              request: client.ListPlaylistItemsRequest(
                playlistId: 'playlist_1',
                target: utf8.encode(jsonEncode({'cursor': 'season-1'})),
                page: 2,
                pageSize: 25,
                search: 'matrix',
                sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
                providerInstanceName: 'home',
                sortBy: client.MediaListSortBy.MEDIA_LIST_SORT_BY_NAME,
                sortDirection: client.SortDirection.SORT_DIRECTION_DESC,
                availability: client.ResourceAvailabilityFilter
                    .RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
              ),
            ),
          ),
        )
        .drain<void>();

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/watch/playlist-items');
    expect(
      requestedUri!.queryParameters,
      containsPair('after_event_sequence', '7'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('delivery_mode', 'notify_only'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('playlist_id', 'playlist_1'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('target', '{"cursor":"season-1"}'),
    );
    expect(requestedUri!.queryParameters, containsPair('page', '2'));
    expect(requestedUri!.queryParameters, containsPair('page_size', '25'));
    expect(requestedUri!.queryParameters, containsPair('search', 'matrix'));
    expect(
      requestedUri!.queryParameters,
      containsPair('source_provider', 'emby'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('provider_instance_name', 'home'),
    );
    expect(requestedUri!.queryParameters, containsPair('sort_by', '2'));
    expect(requestedUri!.queryParameters, containsPair('sort_direction', '2'));
    expect(requestedUri!.queryParameters, containsPair('availability', '1'));
  });

  test('playlist items watch decodes nested protobuf JSON bytes payloads',
      () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/playlist-items');
      request.response
        ..statusCode = 200
        ..headers.contentType =
            io.ContentType('text', 'event-stream', charset: 'utf-8')
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
                'observe_id': 'playlist-items',
                'version': 'items-v2',
                'playlist_items': {
                  'playlists': [
                    {
                      'id': 'pl_dynamic',
                      'room_id': 'room_1',
                      'name': 'Season 1',
                      'source_provider': 'alist',
                      'provider_instance_name': 'main',
                      'is_dynamic': true,
                      'source_config': {'path': '/shows/season-1'},
                    }
                  ],
                  'media': [
                    {
                      'id': 'med_1',
                      'room_id': 'room_1',
                      'source_provider': 'direct_url',
                      'name': 'Episode 1',
                      'creator_id': 'usr_creator',
                      'metadata': {
                        'url': '/api/media/med_1/stream',
                        'headers': {'x-media': '1'},
                      },
                      'source_config': {
                        'url': 'https://origin.example/episode-1.mp4',
                      },
                    }
                  ],
                  'dynamic_items': [
                    {
                      'name': 'Remote Episode',
                      'item_type': client.ItemType.ITEM_TYPE_MEDIA.value,
                      'target': {'path': '/remote/episode-1.mkv'},
                      'size': '123456',
                      'thumbnail': 'https://img.example/ep1.jpg',
                    }
                  ],
                  'current_path': [
                    {
                      'name': 'Season 1',
                      'target': {'cursor': 'season-1'},
                    }
                  ],
                  'version': 'snapshot-v2',
                },
              })}\n\n',
        );
      await request.response.close();
    });

    try {
      final api = SyncTvApiClient(
        baseUrl: 'http://${server.address.host}:${server.port}',
        session: SyncTvSession()..accessToken = 'token',
      );

      final event = await api.room
          .watchPlaylistItems(
            'room_1',
            client.WatchPlaylistItemsRequest(
              playlistItems: client.ObservePlaylistItems(
                request: client.ListPlaylistItemsRequest(
                  playlistId: 'pl_dynamic',
                ),
              ),
            ),
          )
          .first;

      expect(event.hasResourceEvent(), isTrue);
      final snapshot = event.resourceEvent.playlistItems;
      expect(snapshot.version, 'snapshot-v2');
      expect(
        SourceConfigCodec.playlistSourceConfigToMap(
          snapshot.playlists.single.sourceConfig,
        ),
        {'path': '/shows/season-1'},
      );
      expect(
        jsonDecode(utf8.decode(snapshot.media.single.metadata)),
        {
          'url': '/api/media/med_1/stream',
          'headers': {'x-media': '1'},
        },
      );
      expect(
        SourceConfigCodec.mediaSourceConfigToMap(
          snapshot.media.single.sourceConfig,
        ),
        {'url': 'https://origin.example/episode-1.mp4'},
      );
      expect(
        jsonDecode(utf8.decode(snapshot.dynamicItems.single.target)),
        {'path': '/remote/episode-1.mkv'},
      );
      expect(
        jsonDecode(utf8.decode(snapshot.currentPath.single.target)),
        {'cursor': 'season-1'},
      );
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('list playlists page preserves protobuf filters sorting and total',
      () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'playlists': [
            {
              'id': 'pl_1',
              'room_id': 'room_1',
              'name': 'Movies',
              'source_provider': 'emby',
              'provider_instance_name': 'home',
              'is_dynamic': true,
              'position': 4.5,
              'item_count': 12,
              'created_at': '1760000200',
              'updated_at': '1760000300',
              'availability': client
                  .ResourceAvailability.RESOURCE_AVAILABILITY_AVAILABLE.value,
              'version': '92',
            }
          ],
          'total': 5,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.listPlaylistsPage(
        'room_1',
        parentId: 'pl_parent',
        page: 2,
        pageSize: 25,
        search: 'movie',
        sourceProvider: 'emby',
        providerInstanceName: 'home',
        dynamicOnly: true,
        sortBy: client_enum.PlaylistListSortBy.PLAYLIST_LIST_SORT_BY_NAME,
        sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
        availability: client_enum
            .ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
      );

      expect(page.total, 5);
      expect(page.page, 2);
      expect(page.pageSize, 25);
      expect(page.playlists.single.id, 'pl_1');
      expect(page.playlists.single.type, 'emby');
      expect(page.playlists.single.roomId, 'room_1');
      expect(page.playlists.single.position, 4.5);
      expect(page.playlists.single.itemCount, 12);
      expect(page.playlists.single.createdAt, 1760000200);
      expect(page.playlists.single.updatedAt, 1760000300);
      expect(
        page.playlists.single.availability,
        client.ResourceAvailability.RESOURCE_AVAILABILITY_AVAILABLE.value,
      );
      expect(page.playlists.single.version, 92);
      expect(requestedUri!.path, '/api/rooms/room_1/playlists');
      expect(requestedUri!.queryParameters,
          containsPair('parent_id', 'pl_parent'));
      expect(requestedUri!.queryParameters, containsPair('page', '2'));
      expect(requestedUri!.queryParameters, containsPair('page_size', '25'));
      expect(requestedUri!.queryParameters, containsPair('search', 'movie'));
      expect(
        requestedUri!.queryParameters,
        containsPair('source_provider', 'emby'),
      );
      expect(
        requestedUri!.queryParameters,
        containsPair('provider_instance_name', 'home'),
      );
      expect(
          requestedUri!.queryParameters, containsPair('dynamic_only', 'true'));
      expect(requestedUri!.queryParameters, containsPair('sort_by', '2'));
      expect(
          requestedUri!.queryParameters, containsPair('sort_direction', '2'));
      expect(requestedUri!.queryParameters, containsPair('availability', '1'));
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('SSE watch refreshes access token before retrying stream', () async {
    final requests = <http.BaseRequest>[];
    var persistedRefresh = false;
    var authErrors = 0;
    final session = SyncTvSession()
      ..accessToken = 'expired-access'
      ..refreshToken = 'refresh-token';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      onAuthError: () => authErrors++,
      onTokenRefresh: () async => persistedRefresh = true,
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/rooms/room_1/watch/room-members') {
          if (requests
                  .where((item) =>
                      item.url.path == '/api/rooms/room_1/watch/room-members')
                  .length ==
              1) {
            return http.Response(
              jsonEncode({'message': 'expired'}),
              401,
              headers: {'content-type': 'application/json'},
            );
          }
          expect(request.headers['authorization'], 'Bearer fresh-access');
          return http.Response(
            'event: observed\n'
            'data: {"observeId":"room-members","eventCursor":{"eventId":"members-v2"},"changed":false}\n\n',
            200,
            headers: {'content-type': 'text/event-stream'},
          );
        }
        if (request.url.path == '/api/auth/refresh') {
          return http.Response(
            jsonEncode({
              'access_token': 'fresh-access',
              'refresh_token': 'fresh-refresh',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('not found', 404);
      }),
    );

    final event = await api.room
        .watchRoomMemberEvents(
          'room_1',
          client.WatchRoomMemberEventsRequest(),
        )
        .first;

    expect(event.observed.eventCursor.eventId, 'members-v2');
    expect(session.accessToken, 'fresh-access');
    expect(session.refreshToken, 'fresh-refresh');
    expect(persistedRefresh, isTrue);
    expect(authErrors, 0);
    expect(requests.map((request) => request.url.path), [
      '/api/rooms/room_1/watch/room-members',
      '/api/auth/refresh',
      '/api/rooms/room_1/watch/room-members',
    ]);
  });

  test('room settings watch decodes protobuf JSON settings payload', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/room-settings');
      request.response
        ..statusCode = 200
        ..headers.contentType =
            io.ContentType('text', 'event-stream', charset: 'utf-8')
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
                'observe_id': 'room-settings',
                'event_cursor': {'sequence': 99},
                'room_settings': {
                  'room_id': 'room_1',
                  'version': 99,
                  'settings': {
                    'allow_guest_join': true,
                    'require_approval': true,
                    'max_members': 42,
                    'chat_enabled': false,
                  },
                },
              })}\n\n',
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final event = await SyncTvService.watchRoomSettings('room_1')
          .firstWhere((event) => event.kind == RoomResourceWatchKind.changed);

      expect(event.version, '99');
      expect(event.snapshot, isNotNull);
      expect(event.snapshot!.allowGuestJoin, isTrue);
      expect(event.snapshot!.requireApproval, isTrue);
      expect(event.snapshot!.maxMembers, 42);
      expect(event.snapshot!.chatEnabled, isFalse);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('dynamic playlist item mapping keeps target for browsing and playback',
      () {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
    );
    final target = utf8.encode(jsonEncode({'path': '/shows/ep1.mkv'}));

    final movie = api.mapDynamicItem(
      client.PlaylistItem(
        name: 'Episode 1',
        itemType: client.ItemType.ITEM_TYPE_MEDIA,
        target: target,
      ),
      playlistId: 'pl_dynamic',
    );

    expect(movie.parentId, 'pl_dynamic');
    expect(movie.id, base64Url.encode(target));
    expect(movie.subPath, base64Url.encode(target));
    expect(movie.metadata['target_json'], {'path': '/shows/ep1.mkv'});
  });

  test('realtime dynamic playlist items keep observed playlist parent id', () {
    final target = utf8.encode(jsonEncode({'path': '/shows/ep1.mkv'}));
    RoomRealtimeCodec.encodePlaylistObservation(
      observeId: 'playlist_items',
      playlistId: 'pl_dynamic',
      target: base64Url.encode(utf8.encode(jsonEncode({'path': '/shows'}))),
    );

    final message = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'playlist_items',
          playlistItems: client.ListPlaylistItemsResponse(
            dynamicItems: [
              client.PlaylistItem(
                name: 'Episode 1',
                itemType: client.ItemType.ITEM_TYPE_MEDIA,
                target: target,
              ),
            ],
            currentPath: [
              client.PlaylistBrowsePathNode(
                name: 'Season 1',
                target: utf8.encode(jsonEncode({'path': '/shows'})),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );

    final movie = message.mediaLibrary!.dynamicItems.single;
    expect(movie.parentId, 'pl_dynamic');
    expect(movie.subPath, base64Url.encode(target));
    expect(movie.playbackPlaylistId, 'pl_dynamic');
    expect(movie.playbackTarget, base64Url.encode(target));
  });

  test('dynamic playlist playback sends playlist target protobuf body',
      () async {
    final requestBodies = <String>[];
    final requestedUris = <Uri>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final origin = 'http://${server.address.host}:${server.port}';
    final requests = server.listen((request) async {
      requestedUris.add(request.uri);
      requestBodies.add(await utf8.decoder.bind(request).join());
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write('{}');
      await request.response.close();
    });
    final target = utf8.encode(jsonEncode({'path': '/shows/ep1.mkv'}));

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(origin);

      await SyncTvService.switchMovie(
        'room_1',
        base64Url.encode(target),
        subPath: base64Url.encode(target),
        playlistId: 'pl_dynamic',
      );
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    expect(requestedUris.first.path, '/api/rooms/room_1/playback/start');
    final body = jsonDecode(requestBodies.first) as Map<String, dynamic>;
    expect(body['media_id'], '');
    expect(body['playlist_id'], 'pl_dynamic');
    expect(body['target'], {'path': '/shows/ep1.mkv'});
  });

  test('switch movie and play starts media then sends play state update',
      () async {
    final requestUris = <Uri>[];
    final requestBodies = <String>[];
    final requestMethods = <String>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestUris.add(request.uri);
      requestMethods.add(request.method);
      requestBodies.add(await utf8.decoder.bind(request).join());
      switch (request.uri.path) {
        case '/api/rooms/room_1/playback/start':
          request.response
            ..statusCode = 200
            ..headers.contentType = io.ContentType.json
            ..write('{}');
        case '/api/rooms/room_1/playback':
          if (request.method == 'GET') {
            request.response
              ..statusCode = 200
              ..headers.contentType = io.ContentType.json
              ..write(jsonEncode({
                'playback_state': {
                  'room_id': 'room_1',
                  'playing_media_id': 'med_1',
                  'position': 0.0,
                  'speed': 1.0,
                  'is_playing': true,
                  'version': '8',
                },
                'playback': {
                  'media_id': 'med_1',
                  'room_id': 'room_1',
                  'name': 'Episode 1',
                },
              }));
          } else {
            request.response
              ..statusCode = 200
              ..headers.contentType = io.ContentType.json
              ..write(jsonEncode({
                'playback_state': {
                  'room_id': 'room_1',
                  'playing_media_id': 'med_1',
                  'position': 0.0,
                  'speed': 1.0,
                  'is_playing': true,
                  'version': '9',
                },
              }));
          }
        default:
          request.response
            ..statusCode = 404
            ..write('unexpected ${request.method} ${request.uri}');
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final playback =
          await SyncTvService.switchMovieAndPlay('room_1', 'med_1');

      expect(playback.movie?.id, 'med_1');
      expect(playback.isPlaying, isTrue);
      expect(
        List.generate(
          requestUris.length,
          (index) => '${requestMethods[index]} ${requestUris[index].path}',
        ),
        [
          'POST /api/rooms/room_1/playback/start',
          'GET /api/rooms/room_1/playback',
          'GET /api/rooms/room_1/playback',
          'PATCH /api/rooms/room_1/playback',
        ],
      );
      expect(jsonDecode(requestBodies[0]), {
        'media_id': 'med_1',
        'playlist_id': '',
      });
      expect(jsonDecode(requestBodies[3]), {
        'type': client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PLAY.value,
        'playing': true,
        'position': 0.0,
        'speed': 1.0,
      });
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('dynamic playback state keeps playlist target identity', () {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
    );
    final target = utf8.encode(jsonEncode({'path': '/shows/ep1.mkv'}));

    final status = api.mapPlayback(
      client.GetPlaybackResponse(
        playbackState: client.PlaybackState(
          roomId: 'room_1',
          playingPlaylistId: 'pl_dynamic',
          target: target,
          position: 12,
          speed: 1,
          isPlaying: true,
        ),
        playback: client.Playback(
          roomId: 'room_1',
          playlistId: 'pl_dynamic',
          name: 'Episode 1',
          playbackInfos: [
            MapEntry(
              'direct',
              client.PlaybackInfo(
                medias: [
                  client.PlaybackMedia(
                    url: '/proxy/episode-1.m3u8',
                    format: 'hls',
                  ),
                ],
              ),
            ),
          ],
          defaultMode: 'direct',
        ),
      ),
    );

    final movie = status.movie!;
    expect(movie.id, base64Url.encode(target));
    expect(movie.parentId, 'pl_dynamic');
    expect(movie.subPath, base64Url.encode(target));
    expect(movie.playbackMediaId, '');
    expect(movie.playbackPlaylistId, 'pl_dynamic');
    expect(movie.playbackTarget, base64Url.encode(target));
    expect(movie.url, 'https://example.test/proxy/episode-1.m3u8');
  });

  test('playback mapping preserves mode and url choices', () {
    final movie = SyncTvMovie.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_1',
        roomId: 'room_1',
        name: 'Multi Source',
        playlistPosition: 3.5,
        provider: 'alist',
        providerInstanceName: 'alist_main',
        isLive: true,
        expiresAt: Int64(1700000000),
        durationSeconds: 3661.5,
        playbackInfos: [
          MapEntry(
            'direct',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Original',
                  url: 'http://origin.test/video.mp4',
                  headers: const {'Authorization': 'Bearer media'}.entries,
                  metadata: client.PlaybackMediaMetadata(
                    resolution: '1920x1080',
                    codec: 'h264',
                  ),
                  format: 'mp4',
                ),
              ],
              subtitles: [
                client.PlaybackSubtitle(
                  name: '中文',
                  url: 'http://origin.test/video.srt',
                  headers: const {'Referer': 'https://subtitle.test/'}.entries,
                  format: 'srt',
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: '弹幕',
                  url: 'http://origin.test/danmaku.xml',
                  headers: const {'User-Agent': 'danmaku-client'}.entries,
                  format: 'xml',
                ),
              ],
            ),
          ),
          MapEntry(
            'proxied',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Proxy 720P',
                  url: '/proxy/video-720.m3u8',
                  metadata: client.PlaybackMediaMetadata(
                    resolution: '1280x720',
                    codec: 'h264',
                  ),
                  format: 'hls',
                ),
                client.PlaybackMedia(
                  name: 'Proxy 1080P',
                  url: '/proxy/video-1080.m3u8',
                  metadata: client.PlaybackMediaMetadata(
                    resolution: '1920x1080',
                    codec: 'hevc',
                  ),
                  format: 'hls',
                ),
              ],
              defaultMediaIndex: 1,
            ),
          ),
        ],
        defaultMode: 'proxied',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(movie.url, 'https://example.test/proxy/video-1080.m3u8');
    expect(movie.roomId, 'room_1');
    expect(movie.position, 3.5);
    expect(movie.live, isTrue);
    expect(movie.sourceProvider, 'alist');
    expect(movie.providerInstanceName, 'alist_main');
    expect(movie.metadata['expires_at'], 1700000000);
    expect(movie.metadata['duration_seconds'], 3661.5);
    expect(movie.playbackModes, hasLength(2));
    expect(movie.hasPlaybackChoices, isTrue);
    expect(movie.selectedPlaybackMode, 'proxied');
    expect(movie.selectedPlaybackUrlIndex, 1);
    expect(movie.playbackModes.first.key, 'proxied');

    final switched = movie.selectPlayback(
      modeKey: 'direct',
      urlIndex: 0,
      resolveUrl: (url) => url,
    );
    expect(switched.url, 'http://origin.test/video.mp4');
    expect(switched.headers, {'Authorization': 'Bearer media'});
    expect(switched.type, 'mp4');
    expect(switched.subtitles, isNotNull);
    expect(switched.subtitles?['sub_0']['headers'], {
      'Referer': 'https://subtitle.test/',
    });
    expect(switched.danmu, 'http://origin.test/danmaku.xml');
    expect(switched.danmuHeaders, {'User-Agent': 'danmaku-client'});
    expect(switched.playbackChoiceLabel, contains('原始'));
  });

  test('playback mapping routes live danmaku to stream channel', () {
    final movie = SyncTvMovie.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_1',
        name: 'Bilibili Live Source',
        playbackInfos: [
          MapEntry(
            'direct',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'File',
                  url: 'http://origin.test/video.mp4',
                  format: 'mp4',
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: 'XML',
                  url: 'http://origin.test/danmaku.xml',
                  format: 'xml',
                ),
              ],
            ),
          ),
          MapEntry(
            'bilibili_live',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Live',
                  url: '/api/playback-providers/bilibili/live/med_public',
                  format: 'flv',
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: 'Live Danmaku',
                  url:
                      '/api/playback-providers/bilibili/live-danmaku/med_public',
                  headers: const {'X-Live': '1'}.entries,
                  format: 'synctv-bilibili-live',
                ),
              ],
            ),
          ),
        ],
        defaultMode: 'direct',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(movie.danmu, 'http://origin.test/danmaku.xml');
    expect(movie.streamDanmu, isNull);
    expect(
        movie.playbackModes.singleWhere((mode) => mode.key == 'direct').danmu,
        'http://origin.test/danmaku.xml');

    final live = movie.selectPlayback(
      modeKey: 'bilibili_live',
      urlIndex: 0,
      resolveUrl: (url) => url,
    );
    expect(
      live.url,
      'https://example.test/api/playback-providers/bilibili/live/med_public',
    );
    expect(live.danmu, isNull);
    expect(
      live.streamDanmu,
      'https://example.test/api/playback-providers/bilibili/live-danmaku/med_public',
    );
    expect(live.streamDanmuHeaders, {'X-Live': '1'});
    expect(
      live.playbackModes
          .singleWhere((mode) => mode.key == 'bilibili_live')
          .streamDanmu,
      'https://example.test/api/playback-providers/bilibili/live-danmaku/med_public',
    );
  });

  test('playback mapping preserves live proxy HLS and FLV choices', () {
    final movie = SyncTvMovie.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_live_proxy',
        roomId: 'room_1',
        name: 'Upstream Live',
        provider: 'live_proxy',
        isLive: true,
        playbackInfos: [
          MapEntry(
            'hls',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'HLS',
                  url: '/api/playback-providers/live-proxy/ver_1/hls-playlist',
                  format: 'hls',
                ),
              ],
            ),
          ),
          MapEntry(
            'flv',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'FLV',
                  url: '/api/playback-providers/live-proxy/ver_1/flv-stream',
                  format: 'flv',
                ),
              ],
            ),
          ),
        ],
        defaultMode: 'hls',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(movie.live, isTrue);
    expect(movie.sourceProvider, 'live_proxy');
    expect(movie.type, 'hls');
    expect(
      movie.url,
      'https://example.test/api/playback-providers/live-proxy/ver_1/hls-playlist',
    );

    final flv = movie.selectPlayback(
      modeKey: 'flv',
      urlIndex: 0,
      resolveUrl: (url) => url,
    );
    expect(flv.type, 'flv');
    expect(
      flv.url,
      'https://example.test/api/playback-providers/live-proxy/ver_1/flv-stream',
    );
    expect(flv.playbackChoiceLabel, contains('FLV'));
  });

  test('playback mapping resolves nested playback resources', () {
    final movie = SyncTvMovie.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_1',
        name: 'AList Source',
        playbackInfos: [
          MapEntry(
            'proxy',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Proxy',
                  url: '/api/providers/proxy/alist/item/stream?token=abc',
                  format: 'mp4',
                ),
              ],
              subtitles: [
                client.PlaybackSubtitle(
                  name: '中文',
                  url: '/api/providers/proxy/alist/subtitle.srt',
                  format: 'srt',
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: '弹幕',
                  url: '/api/providers/proxy/alist/danmaku.xml',
                  format: 'xml',
                ),
              ],
            ),
          ),
        ],
        defaultMode: 'proxy',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(
      movie.url,
      'https://example.test/api/providers/proxy/alist/item/stream?token=abc',
    );
    expect(
      movie.playbackModes.single.urls.single.url,
      'https://example.test/api/providers/proxy/alist/item/stream?token=abc',
    );
    expect(
      movie.subtitles?['sub_0']['url'],
      'https://example.test/api/providers/proxy/alist/subtitle.srt',
    );
    expect(
      movie.danmu,
      'https://example.test/api/providers/proxy/alist/danmaku.xml',
    );
  });

  test('playback state watch decodes protobuf JSON target payload', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/playback-state');
      request.response
        ..statusCode = 200
        ..headers.contentType =
            io.ContentType('text', 'event-stream', charset: 'utf-8')
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
                'observe_id': 'playback-state',
                'event_cursor': {'sequence': 100},
                'playback_state': {
                  'room_id': 'room_1',
                  'playing_playlist_id': 'pl_dynamic',
                  'target': {'path': '/shows/ep1.mkv'},
                  'position': 24.5,
                  'speed': 1.25,
                  'is_playing': true,
                },
              })}\n\n',
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final event = await SyncTvService.watchPlaybackState('room_1')
          .firstWhere((event) => event.kind == RoomResourceWatchKind.changed);
      final target = utf8.encode(jsonEncode({'path': '/shows/ep1.mkv'}));

      expect(event.version, '100');
      expect(event.snapshot, isNotNull);
      expect(event.snapshot!.isPlaying, isTrue);
      expect(event.snapshot!.currentTime, 24.5);
      expect(event.snapshot!.playbackRate, 1.25);
      expect(event.snapshot!.movie!.parentId, 'pl_dynamic');
      expect(event.snapshot!.movie!.playbackTarget, base64Url.encode(target));
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('watch playback snapshot query includes dynamic playlist target',
      () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response('', 200, headers: {
          'content-type': 'text/event-stream',
        });
      }),
    );

    await api.room
        .watchPlayback(
          'room_1',
          client.WatchPlaybackRequest(
            playback: client.ObservePlayback(
              playbackClientProfile: defaultPlaybackClientProfile(),
              afterEventSequence: Int64(42),
            ),
          ),
        )
        .drain<void>();

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/watch/playback');
    expect(
      requestedUri!.queryParameters,
      containsPair('stream_preference', 'auto'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('after_event_sequence', '42'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('max_audio_channels', '2'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('video_codecs', 'h264,hevc,vp9,av1'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('containers', 'mp4,mkv,webm'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('audio_capability', 'stereo'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('subtitle_preference', 'external'),
    );
  });

  test(
      'playback state update parses UpdatePlaybackStateResponse from protobuf endpoint',
      () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'playback_state': {
              'room_id': 'room_1',
              'playing_media_id': 'med_1',
              'position': 42.5,
              'speed': 1.25,
              'is_playing': true,
              'version': '8',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.updatePlaybackState(
      'room_1',
      client.UpdatePlaybackStateRequest(
        type: client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED,
        playing: true,
        position: 42.5,
        speed: 1.25,
      ),
    );

    expect(requestMethod, 'PATCH');
    expect(requestedUri!.path, '/api/rooms/room_1/playback');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body['type'],
        client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED.value);
    expect(body['playing'], isTrue);
    expect(body['position'], 42.5);
    expect(body['speed'], 1.25);
    expect(response.playbackState.playingMediaId, 'med_1');
    expect(response.playbackState.position, 42.5);
    expect(response.playbackState.speed, 1.25);
  });

  test('move media sends protobuf body for arbitrary target playlist',
      () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'moved_count': 1,
            'media': [
              {
                'id': 'med_1',
                'room_id': 'room_1',
                'source_provider': 'direct_url',
                'name': 'Feature',
              }
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.moveMedia(
      'room_1',
      client.MoveMediaRequest(
        mediaIds: ['med_1'],
        sourcePlaylistId: 'pl_source',
        targetPlaylistId: 'pl_target',
        afterMediaId: 'med_anchor',
      ),
    );

    expect(requestMethod, 'POST');
    expect(requestedUri!.path, '/api/rooms/room_1/media/move');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body['media_ids'], ['med_1']);
    expect(body['source_playlist_id'], 'pl_source');
    expect(body['target_playlist_id'], 'pl_target');
    expect(body['after_media_id'], 'med_anchor');
    expect(body.containsKey('before_media_id'), isFalse);
    expect(response.movedCount, 1);
    expect(response.media.single.id, 'med_1');
  });

  test('direct url source config only accepts backend-supported fields', () {
    final parsed = DirectUrlSourceConfig.parseHeaderLines(
      'Referer: https://media.example.test\n'
      'User-Agent: SyncTV\n'
      'Authorization: Bearer token\n'
      'Cookie: session=secret',
    );
    expect(parsed, {
      'Referer': 'https://media.example.test',
      'User-Agent': 'SyncTV',
      'Authorization': 'Bearer token',
      'Cookie': 'session=secret',
    });
    expect(DirectUrlSourceConfig.hasCredentialHeaders(parsed), isTrue);
    expect(DirectUrlSourceConfig.credentialHeaderNames(parsed), {
      'Authorization',
      'Cookie',
    });

    final config = DirectUrlSourceConfig.fromUserInput(
      url: ' https://media.example.test/feature.mp4 ',
      headers: parsed,
      preferProxy: true,
    );
    expect(config.toJson(), {
      'url': 'https://media.example.test/feature.mp4',
      'headers': {
        'Referer': 'https://media.example.test',
        'User-Agent': 'SyncTV',
        'Authorization': 'Bearer token',
        'Cookie': 'session=secret',
      },
      'prefer_proxy': true,
    });
    expect(
      DirectUrlSourceConfig.credentialHeaderRiskKey(parsed),
      'authorization|cookie',
    );
    expect(
      DirectUrlSourceConfig.credentialHeaderRiskKey({
        'cookie': 'session=secret',
        'AUTHORIZATION': 'Bearer token',
        'User-Agent': 'SyncTV',
      }),
      'authorization|cookie',
    );
    expect(
      DirectUrlSourceConfig.credentialHeaderRiskKey({
        'Referer': 'https://example.test',
        'User-Agent': 'SyncTV',
      }),
      isEmpty,
    );

    expect(
      () => DirectUrlSourceConfig.parseHeaderLines(
        'Host: internal.example.test',
      ),
      throwsA(isA<DirectUrlSourceConfigException>()),
    );
    expect(
      () => DirectUrlSourceConfig.fromUserInput(
        url: 'rtmp://media.example.test/live',
      ),
      throwsA(isA<DirectUrlSourceConfigException>()),
    );
  });

  test('direct url media creation rejects dangerous headers before request',
      () async {
    var requestCount = 0;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestCount += 1;
        return http.Response(
          jsonEncode({'media': {}}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final domain = SyncTvRoomMediaDomainService(api);

    await expectLater(
      domain.addDirectUrlMedia(
        'room_1',
        url: 'https://media.example.test/movie.mp4',
        headers: const {'Host': 'internal.example.test'},
      ),
      throwsA(isA<DirectUrlSourceConfigException>()),
    );
    expect(requestCount, 0);
  });

  test('direct url batch media sends protobuf body with shared headers',
      () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'results': [
              {
                'media': {
                  'id': 'med_1',
                  'room_id': 'room_1',
                  'source_provider': 'direct_url',
                  'name': 'Episode 1',
                },
              },
              {
                'media': {
                  'id': 'med_2',
                  'room_id': 'room_1',
                  'source_provider': 'direct_url',
                  'name': 'Episode 2',
                },
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final domain = SyncTvRoomMediaDomainService(api);

    await domain.addMediaBatch('room_1', [
      {
        'playlist_id': 'pl_1',
        'source_provider': 'direct_url',
        'source_config': {
          'url': 'https://media.example.test/episode-1.mp4',
          'headers': {
            'Referer': 'https://media.example.test',
            'Authorization': 'Bearer shared-token',
            'Cookie': 'sid=shared',
          },
        },
        'name': '',
      },
      {
        'playlist_id': 'pl_1',
        'source_provider': 'direct_url',
        'source_config': {
          'url': 'https://media.example.test/episode-2.mp4',
          'headers': {
            'Referer': 'https://media.example.test',
            'Authorization': 'Bearer shared-token',
            'Cookie': 'sid=shared',
          },
        },
        'name': '',
      },
    ]);

    expect(requestMethod, 'POST');
    expect(requestedUri!.path, '/api/rooms/room_1/media/batch');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    final items = body['items'] as List<dynamic>;
    expect(items, hasLength(2));
    expect(items[0], {
      'playlist_id': 'pl_1',
      'source_provider': 'direct_url',
      'provider_instance_name': '',
      'source_config': {
        'direct_url': {
          'medias': [
            {
              'url': 'https://media.example.test/episode-1.mp4',
              'headers': {
                'Referer': 'https://media.example.test',
                'Authorization': 'Bearer shared-token',
                'Cookie': 'sid=shared',
              },
            }
          ],
          'url': 'https://media.example.test/episode-1.mp4',
          'headers': {
            'Referer': 'https://media.example.test',
            'Authorization': 'Bearer shared-token',
            'Cookie': 'sid=shared',
          },
        },
      },
      'name': '',
    });
    expect(items[1], {
      'playlist_id': 'pl_1',
      'source_provider': 'direct_url',
      'provider_instance_name': '',
      'source_config': {
        'direct_url': {
          'medias': [
            {
              'url': 'https://media.example.test/episode-2.mp4',
              'headers': {
                'Referer': 'https://media.example.test',
                'Authorization': 'Bearer shared-token',
                'Cookie': 'sid=shared',
              },
            }
          ],
          'url': 'https://media.example.test/episode-2.mp4',
          'headers': {
            'Referer': 'https://media.example.test',
            'Authorization': 'Bearer shared-token',
            'Cookie': 'sid=shared',
          },
        },
      },
      'name': '',
    });
  });

  test('delete media uses protobuf path and query contract', () async {
    Uri? requestedUri;
    String? requestMethod;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        return http.Response(
          jsonEncode({'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.deleteMedia(
      'room_1',
      client.DeleteMediaRequest(mediaId: 'med_1', force: true),
    );

    expect(requestMethod, 'DELETE');
    expect(requestedUri!.path, '/api/rooms/room_1/media/med_1');
    expect(requestedUri!.queryParameters, containsPair('force', 'true'));
    expect(response.success, isTrue);
  });

  test('move playlist sends protobuf oneof anchor body', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'playlist': {
              'id': 'pl_1',
              'room_id': 'room_1',
              'name': 'Moved',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.room.movePlaylist(
      'room_1',
      client.MovePlaylistRequest(
        playlistId: 'pl_1',
        beforePlaylistId: 'pl_0',
      ),
    );
    await api.room.movePlaylist(
      'room_1',
      client.MovePlaylistRequest(
        playlistId: 'pl_1',
        afterPlaylistId: 'pl_2',
      ),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(
      requests.first.url.path,
      '/api/rooms/room_1/playlists/pl_1/move',
    );
    final beforeBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(beforeBody['playlist_id'], 'pl_1');
    expect(beforeBody['before_playlist_id'], 'pl_0');
    expect(beforeBody.containsKey('after_playlist_id'), isFalse);

    final afterBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(afterBody['playlist_id'], 'pl_1');
    expect(afterBody['after_playlist_id'], 'pl_2');
    expect(afterBody.containsKey('before_playlist_id'), isFalse);
  });

  test('delete entries sends media and playlist ids in protobuf body',
      () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'deleted_media': 2, 'deleted_playlists': 1}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.deleteEntries(
      'room_1',
      client.DeleteEntriesRequest(
        mediaIds: ['med_1', 'med_2'],
        playlistIds: ['pl_1'],
        force: true,
      ),
    );

    expect(requestMethod, 'DELETE');
    expect(requestedUri!.path, '/api/rooms/room_1/entries');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body['media_ids'], ['med_1', 'med_2']);
    expect(body['playlist_ids'], ['pl_1']);
    expect(body['force'], isTrue);
    expect(response.deletedMedia, 2);
    expect(response.deletedPlaylists, 1);
  });

  test('clear root playlist sends protobuf request body', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'success': true, 'deleted_count': 2}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.clearPlaylist(
      'room_1',
      client.ClearPlaylistRequest(),
    );

    expect(requestMethod, 'DELETE');
    expect(requestedUri!.path, '/api/rooms/room_1/media');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body, isEmpty);
    expect(response.success, isTrue);
    expect(response.deletedCount, 2);
  });

  test('clear playlist scope uses ClearPlaylist protobuf body', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'success': true,
            'deleted_count': 2,
            'deleted_playlists': 1,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.clearPlaylist(
      'room_1',
      client.ClearPlaylistRequest(playlistId: 'pl_1'),
    );

    expect(requestMethod, 'DELETE');
    expect(requestedUri!.path, '/api/rooms/room_1/media');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body['playlist_id'], 'pl_1');
    expect(response.deletedCount, 2);
    expect(response.deletedPlaylists, 1);
  });

  test('clear movies keeps playlist scope through ClearPlaylist protobuf',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final media = SyncTvRoomMediaDomainService(api);

    await media.clearMovies('room_1', parentId: 'pl_1');

    expect(requests, hasLength(1));
    expect(requests.single.method, 'DELETE');
    expect(requests.single.url.path, '/api/rooms/room_1/media');
    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(body, {'playlist_id': 'pl_1'});
  });

  test('watch room members query uses protobuf enum values', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response('', 200, headers: {
          'content-type': 'text/event-stream',
        });
      }),
    );

    await api.room
        .watchRoomMemberEvents(
          'room_1',
          client.WatchRoomMemberEventsRequest(
            deliveryMode: client
                .ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
            roomMemberEvents: client.ObserveRoomMemberEvents(
              afterEventSequence: Int64(1),
            ),
          ),
        )
        .drain<void>();

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/watch/room-members');
    expect(
      requestedUri!.queryParameters,
      containsPair('after_event_sequence', '1'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('delivery_mode', 'push_snapshot'),
    );
  });

  test('admin list users query preserves protobuf filters', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({'instances': [], 'total': 0}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.listUsers(
      admin.ListUsersRequest(
        page: 4,
        pageSize: 30,
        search: 'alice',
        status: common.UserStatus.USER_STATUS_ACTIVE,
        role: common.UserRole.USER_ROLE_ADMIN,
        isBanned: false,
        sortBy: admin.UserListSortBy.USER_LIST_SORT_BY_USERNAME,
        sortDirection: admin.SortDirection.SORT_DIRECTION_ASC,
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/users');
    expect(requestedUri!.queryParameters, containsPair('page', '4'));
    expect(requestedUri!.queryParameters, containsPair('page_size', '30'));
    expect(requestedUri!.queryParameters, containsPair('search', 'alice'));
    expect(requestedUri!.queryParameters, containsPair('status', '1'));
    expect(requestedUri!.queryParameters, containsPair('role', '2'));
    expect(requestedUri!.queryParameters, containsPair('is_banned', 'false'));
    expect(requestedUri!.queryParameters, containsPair('sort_by', '3'));
    expect(requestedUri!.queryParameters, containsPair('sort_direction', '1'));
  });

  test('admin user service preserves pagination sorting and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'users': [
            {
              'id': 'usr_1',
              'username': 'alice',
              'email': 'alice@example.test',
              'role': common.UserRole.USER_ROLE_ADMIN.value,
              'status': common.UserStatus.USER_STATUS_ACTIVE.value,
            }
          ],
          'total': 9,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListUsersPage(
        page: 2,
        pageSize: 50,
        search: 'alice',
        status: common.UserStatus.USER_STATUS_ACTIVE,
        role: common.UserRole.USER_ROLE_ADMIN,
        isBanned: false,
        sortBy: admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 9);
      expect(page.users.single.id, 'usr_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/users');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'page_size': '50',
      'status': '${common.UserStatus.USER_STATUS_ACTIVE.value}',
      'role': '${common.UserRole.USER_ROLE_ADMIN.value}',
      'search': 'alice',
      'sort_by': '${admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL.value}',
      'sort_direction': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
      'is_banned': 'false',
    });
  });

  test('admin user mapping preserves current protobuf role and status enums',
      () {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
    );
    final user = api.mapAdminUser(
      admin.AdminUser(
        id: 'usr_1',
        username: 'root',
        role: common.UserRole.USER_ROLE_ROOT,
        status: common.UserStatus.USER_STATUS_ACTIVE,
        createdAt: Int64(1760000001),
        updatedAt: Int64(1760000002),
        isBanned: false,
      ),
    );
    final banned = api.mapAdminUser(
      admin.AdminUser(
        id: 'usr_2',
        username: 'blocked',
        role: common.UserRole.USER_ROLE_USER,
        status: common.UserStatus.USER_STATUS_ACTIVE,
        isBanned: true,
        bannedAt: Int64(1760000003),
        bannedBy: 'usr_root',
        bannedReason: 'abuse',
      ),
    );

    expect(user.role, common.UserRole.USER_ROLE_ROOT.value);
    expect(user.status, common.UserStatus.USER_STATUS_ACTIVE.value);
    expect(user.createdAt, 1760000001);
    expect(user.updatedAt, 1760000002);
    expect(user.isBanned, isFalse);
    expect(banned.role, common.UserRole.USER_ROLE_USER.value);
    expect(banned.status, common.UserStatus.USER_STATUS_BANNED.value);
    expect(banned.isBanned, isTrue);
    expect(banned.bannedAt, 1760000003);
    expect(banned.bannedBy, 'usr_root');
    expect(banned.bannedReason, 'abuse');
  });

  test('admin user create and ban preserve protobuf request fields', () async {
    final requests = <http.Request>[];
    const adminCredential = 'not-a-real-test-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/ban')) {
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'usr_1',
                'username': 'alice',
                'role': common.UserRole.USER_ROLE_ADMIN.value,
                'status': common.UserStatus.USER_STATUS_BANNED.value,
                'is_banned': true,
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'user': {
              'id': 'usr_1',
              'username': 'alice',
              'email': 'alice@example.test',
              'role': common.UserRole.USER_ROLE_ADMIN.value,
              'status': common.UserStatus.USER_STATUS_BANNED.value,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.createUser(
      admin.CreateUserRequest(
        username: 'alice',
        password: adminCredential,
        email: 'alice@example.test',
        role: common.UserRole.USER_ROLE_ADMIN,
        status: common.UserStatus.USER_STATUS_BANNED,
      ),
    );
    await api.adminService.banUser(
      admin.BanUserRequest(userId: 'usr_1', reason: 'spam'),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(requests.first.url.path, '/api/admin/users');
    expect(jsonDecode(requests.first.body), {
      'username': 'alice',
      'password': adminCredential,
      'email': 'alice@example.test',
      'role': common.UserRole.USER_ROLE_ADMIN.value,
      'status': common.UserStatus.USER_STATUS_BANNED.value,
    });
    expect(requests.last.method, 'POST');
    expect(requests.last.url.path, '/api/admin/users/usr_1/ban');
    expect(jsonDecode(requests.last.body), {
      'user_id': 'usr_1',
      'reason': 'spam',
    });
  });

  test('admin unban user uses protobuf path command endpoint', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'user': {
              'id': 'usr_1',
              'username': 'alice',
              'role': common.UserRole.USER_ROLE_USER.value,
              'status': common.UserStatus.USER_STATUS_ACTIVE.value,
              'is_banned': false,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.unbanUser(
      admin.UnbanUserRequest(userId: 'usr_1'),
    );

    expect(requests, hasLength(1));
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/api/admin/users/usr_1/unban');
    expect(requests.single.body, isEmpty);
  });

  test('admin room mapping keeps lifecycle status separate from ban flag', () {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
    );
    final room = api.mapAdminRoom(
      admin.AdminRoom(
        id: 'room_1',
        name: 'The Room',
        creatorId: 'usr_1',
        creatorUsername: 'alice',
        status: common.RoomStatus.ROOM_STATUS_ACTIVE,
        isBanned: true,
        memberCount: 9,
        description: 'Admin room description',
        updatedAt: Int64(1760000010),
        creatorStatus: common.UserStatus.USER_STATUS_BANNED,
        version: Int64(88),
      ),
    );

    expect(room.status, common.RoomStatus.ROOM_STATUS_ACTIVE.value);
    expect(room.isBanned, isTrue);
    expect(room.viewerCount, 9);
    expect(room.memberCount, 9);
    expect(room.description, 'Admin room description');
    expect(room.updatedAt, 1760000010);
    expect(room.creatorStatus, common.UserStatus.USER_STATUS_BANNED.value);
    expect(room.version, 88);
  });

  test('public room service preserves pagination sorting and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'rooms': [
            {
              'id': 'room_1',
              'name': 'Public Room',
              'created_by': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              'description': 'Public room description',
              'updated_at': '1760000020',
              'is_banned': true,
              'availability': client.ResourceAvailability
                  .RESOURCE_AVAILABILITY_CREATOR_INACTIVE.value,
              'version': '89',
            }
          ],
          'total': 12,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.getRoomsPage(
        page: 2,
        pageSize: 30,
        search: 'Public',
        categoryId: 'roomcat_anime',
        labelIds: const ['roomlbl_weekly', 'roomlbl_friends'],
        sortBy: client_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
        sortDirection: client_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 12);
      expect(page.page, 2);
      expect(page.pageSize, 30);
      expect(page.rooms.single.roomId, 'room_1');
      expect(page.rooms.single.description, 'Public room description');
      expect(page.rooms.single.updatedAt, 1760000020);
      expect(page.rooms.single.isBanned, isTrue);
      expect(
        page.rooms.single.availability,
        client
            .ResourceAvailability.RESOURCE_AVAILABILITY_CREATOR_INACTIVE.value,
      );
      expect(page.rooms.single.version, 89);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'page_size': '30',
      'search': 'Public',
      'category_id': 'roomcat_anime',
      'label_ids': '["roomlbl_weekly","roomlbl_friends"]',
      'sort_by': '${client_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME.value}',
      'sort_direction': '${client_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test('my room service preserves relation filters sorting and total',
      () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'rooms': [
            {
              'room': {
                'id': 'room_2',
                'name': 'Mine',
                'created_by': 'usr_1',
                'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              },
              'permissions': '7',
              'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
            }
          ],
          'total': 8,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({
        'synctv_access_token': 'access',
        'synctv_refresh_token': 'refresh',
      });
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.getMyRoomsPage(
        page: 3,
        pageSize: 40,
        search: 'Mine',
        status: common.RoomStatus.ROOM_STATUS_ACTIVE,
        isBanned: false,
        relation: client_enum.MyRoomRelation.MY_ROOM_RELATION_PARTICIPATING,
        sortBy: client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_NAME,
        sortDirection: client_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 8);
      expect(page.page, 3);
      expect(page.pageSize, 40);
      expect(page.rooms.single.roomId, 'room_2');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/rooms');
    expect(requestedUri!.queryParameters, {
      'page': '3',
      'page_size': '40',
      'status': '${common.RoomStatus.ROOM_STATUS_ACTIVE.value}',
      'search': 'Mine',
      'is_banned': 'false',
      'relation':
          '${client_enum.MyRoomRelation.MY_ROOM_RELATION_PARTICIPATING.value}',
      'sort_by':
          '${client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_NAME.value}',
      'sort_direction': '${client_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test('admin room service preserves pagination sorting ban filter and total',
      () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'rooms': [
            {
              'id': 'room_1',
              'name': 'Room',
              'created_by': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              'is_banned': false,
            }
          ],
          'total': 7,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListRoomsPage(
        page: 3,
        pageSize: 50,
        search: 'Room',
        categoryId: 'roomcat_anime',
        labelIds: const ['roomlbl_weekly'],
        status: common.RoomStatus.ROOM_STATUS_ACTIVE,
        isBanned: false,
        sortBy: admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 7);
      expect(page.rooms.single.roomId, 'room_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/rooms');
    expect(requestedUri!.queryParameters, {
      'page': '3',
      'page_size': '50',
      'status': '${common.RoomStatus.ROOM_STATUS_ACTIVE.value}',
      'search': 'Room',
      'category_id': 'roomcat_anime',
      'label_ids': '["roomlbl_weekly"]',
      'is_banned': 'false',
      'sort_by':
          '${admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT.value}',
      'sort_direction': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test('admin user rooms service preserves protobuf query and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'rooms': [
            {
              'id': 'room_2',
              'name': 'Owned Room',
              'created_by': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_CLOSED.value,
              'is_banned': true,
            }
          ],
          'total': 4,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListUserRoomsPage(
        'usr_1',
        page: 2,
        pageSize: 20,
        search: 'Owned',
        status: common.RoomStatus.ROOM_STATUS_CLOSED,
        isBanned: true,
        sortBy: admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 4);
      expect(page.rooms.single.roomId, 'room_2');
      expect(page.rooms.single.isBanned, isTrue);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/users/usr_1/rooms');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'page_size': '20',
      'status': '${common.RoomStatus.ROOM_STATUS_CLOSED.value}',
      'search': 'Owned',
      'is_banned': 'true',
      'sort_by': '${admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME.value}',
      'sort_direction': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test('chat history query is generated from protobuf request', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response('{}', 200, headers: {
          'content-type': 'application/json',
        });
      }),
    );

    await api.room.getChatHistory(
      'room_1',
      client.GetChatHistoryRequest(
        limit: 75,
        cursor: '2026-05-27T01:02:03Z|msg_1',
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/chat/history');
    expect(requestedUri!.queryParameters, containsPair('limit', '75'));
    expect(
      requestedUri!.queryParameters,
      containsPair('cursor', '2026-05-27T01:02:03Z|msg_1'),
    );
  });

  test('account preferences preserve protobuf settings payload', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'preferences': {
            'two_factor_enabled': true,
            'notifications': {
              'room_invitation_in_app': true,
              'room_event_in_app': false,
              'system_announcement_in_app': true,
              'room_invitation_email': false,
              'room_event_email': true,
              'system_announcement_email': false,
            },
            'settings': {
              'quiet_hours': {'start': '22:00', 'end': '07:00'},
              'compact_mode': true,
            },
          },
          'auth_factors': {
            'password': true,
            'webauthn': true,
            'email': false,
            'eligible_count': 2,
          },
        }));
      await request.response.close();
    });

    late final AccountPreferences preferences;
    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      preferences = await SyncTvService.getAccountPreferences();
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/preferences');
    expect(preferences.twoFactorEnabled, isTrue);
    expect(preferences.canUsePasskey, isTrue);
    expect(preferences.eligibleFactorCount, 2);
    expect(preferences.settings['compact_mode'], isTrue);
    expect(preferences.settings['quiet_hours'], {
      'start': '22:00',
      'end': '07:00',
    });
  });

  test('notification detail endpoint maps protobuf response', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'notification': {
              'id': '42',
              'notification_type': 3,
              'title': 'Room updated',
              'content': 'Playback changed',
              'data': {'room_id': 'room_1'},
              'is_read': false,
              'created_at': '1760000000',
              'updated_at': '1760000010',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.notifications.getNotification(
      client.GetNotificationRequest(notificationId: Int64(42)),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/notifications/42');
    expect(response.notification.id, '42');
    expect(response.notification.title, 'Room updated');
    expect(jsonDecode(utf8.decode(response.notification.data)), {
      'room_id': 'room_1',
    });
  });

  test('room stream query and kick use protobuf contract', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/kick')) {
          return http.Response('{}', 200, headers: {
            'content-type': 'application/json',
          });
        }
        return http.Response(
          jsonEncode({
            'streams': [
              {'media_id': 'med_1', 'active': true},
            ],
            'total': 1,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final streams = await api.room.listRoomStreams(
      'room_1',
      client.ListRoomStreamsRequest(
        page: 2,
        pageSize: 20,
        search: 'med',
        sortBy: client.RoomStreamListSortBy.ROOM_STREAM_LIST_SORT_BY_MEDIA_ID,
        sortDirection: client.SortDirection.SORT_DIRECTION_DESC,
      ),
    );
    await api.room.kickRoomStream(
      'room_1',
      client.KickRoomStreamRequest(
        mediaId: 'med_1',
        reason: 'stale publisher',
      ),
    );

    expect(streams.streams.single.mediaId, 'med_1');
    expect(requests.first.url.path, '/api/rooms/room_1/streams');
    expect(requests.first.url.queryParameters, containsPair('page', '2'));
    expect(requests.first.url.queryParameters, containsPair('page_size', '20'));
    expect(requests.first.url.queryParameters, containsPair('search', 'med'));
    expect(requests.first.url.queryParameters, containsPair('sort_by', '1'));
    expect(
      requests.first.url.queryParameters,
      containsPair('sort_direction', '2'),
    );
    expect(requests.last.method, 'POST');
    expect(requests.last.url.path, '/api/rooms/room_1/streams/med_1/kick');
    expect(jsonDecode(requests.last.body), {
      'media_id': 'med_1',
      'reason': 'stale publisher',
    });
  });

  test('room stream service maps detail endpoint and pagination', () async {
    final requests = <http.Request>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final listener = server.listen((request) async {
      requests.add(http.Request(request.method, request.uri));
      request.response.headers.contentType = io.ContentType.json;
      if (request.uri.path == '/api/rooms/room_1/streams/med_1') {
        request.response.write(jsonEncode({
          'active': true,
          'publisher': {
            'user_id': 'usr_publisher',
            'started_at': '1760000000',
          },
        }));
      } else if (request.uri.path == '/api/rooms/room_1/streams') {
        request.response.write(jsonEncode({
          'streams': [
            {'media_id': 'med_1', 'active': true},
            {'media_id': 'med_2', 'active': false},
          ],
          'total': 12,
        }));
      } else {
        request.response.statusCode = 404;
        request.response.write('{}');
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.listRoomStreamsPage(
        'room_1',
        page: 2,
        pageSize: 50,
        search: 'med',
        sortDirection: client.SortDirection.SORT_DIRECTION_DESC,
      );
      final detail = await SyncTvService.getRoomStreamInfo(
        'room_1',
        'med_1',
      );

      expect(page.total, 12);
      expect(page.page, 2);
      expect(page.pageSize, 50);
      expect(page.streams, hasLength(2));
      expect(page.streams.first.publisherUserId, 'usr_publisher');
      expect(page.streams.first.startedAt, 1760000000);
      expect(page.streams.last.active, isFalse);
      expect(detail.publisherUserId, 'usr_publisher');
      expect(requests.map((request) => request.url.path), [
        '/api/rooms/room_1/streams',
        '/api/rooms/room_1/streams/med_1',
        '/api/rooms/room_1/streams/med_1',
      ]);
      expect(requests.first.url.queryParameters, containsPair('page', '2'));
      expect(
        requests.first.url.queryParameters,
        containsPair('page_size', '50'),
      );
      expect(requests.first.url.queryParameters, containsPair('search', 'med'));
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }
  });

  test('rtmp provider endpoints use path protobuf parameters', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.contains('/publish-key/')) {
          return http.Response(
            jsonEncode({
              'publish_key': 'pub_1',
              'rtmp_url': 'rtmp://example.test/live',
              'stream_key': 'stream_1',
              'expires_at': '1760000100',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'active': true,
            'publisher': {'user_id': 'user_1', 'started_at': '1760000000'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final publish = await api.rtmpProvider.createPublishKey(
      rtmp.CreatePublishKeyRequest(roomId: 'room_1', mediaId: 'med_1'),
    );
    final info = await api.rtmpProvider.getStreamInfo(
      rtmp.GetStreamInfoRequest(roomId: 'room_1', mediaId: 'med_1'),
    );

    expect(publish.publishKey, 'pub_1');
    expect(info.active, isTrue);
    expect(info.publisher.userId, 'user_1');
    expect(requests.first.method, 'POST');
    expect(
      requests.first.url.path,
      '/api/providers/rtmp/rooms/room_1/publish-key/med_1',
    );
    expect(requests.first.body, isEmpty);
    expect(requests.last.method, 'GET');
    expect(
      requests.last.url.path,
      '/api/providers/rtmp/rooms/room_1/info/med_1',
    );
  });

  test(
      'direct url, rtmp, and live proxy media creation use distinct provider contracts',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/rooms/room_1/media' &&
            request.method == 'POST') {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final provider = body['source_provider']?.toString() ?? '';
          return http.Response(
            jsonEncode({
              'media': {
                'id': switch (provider) {
                  'rtmp' => 'med_rtmp',
                  'live_proxy' => 'med_live_proxy',
                  _ => 'med_direct',
                },
                'room_id': 'room_1',
                'source_provider': provider,
                'name': body['name'] ?? '',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path ==
            '/api/providers/rtmp/rooms/room_1/publish-key/med_rtmp') {
          return http.Response(
            jsonEncode({
              'publish_key': 'pub_1',
              'rtmp_url': 'rtmp://example.test/live',
              'stream_key': 'stream_1',
              'expires_at': '1760000100',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('{}', 404);
      }),
    );
    final domain = SyncTvRoomMediaDomainService(api);

    final directId = await domain.addDirectUrlMedia(
      'room_1',
      playlistId: 'pl_1',
      url: 'https://media.example.test/movie.m3u8',
      headers: const {'User-Agent': 'Mozilla/5.0'},
      name: 'Direct HLS',
      preferProxy: true,
    );
    final rtmpId = await domain.addRtmpMedia(
      'room_1',
      playlistId: 'pl_1',
      name: 'Camera',
    );
    final liveProxyId = await domain.addLiveProxyMedia(
      'room_1',
      playlistId: 'pl_1',
      url: 'rtmp://upstream.example.test/live/room',
      name: 'Upstream Live',
    );
    final publish = await domain.createRtmpPublishKeyInfo('room_1', rtmpId);

    expect(directId, 'med_direct');
    expect(rtmpId, 'med_rtmp');
    expect(liveProxyId, 'med_live_proxy');
    expect(publish.streamKey, 'stream_1');

    final directBody = jsonDecode(requests[0].body) as Map<String, dynamic>;
    expect(directBody['source_provider'], 'direct_url');
    expect(directBody['playlist_id'], 'pl_1');
    expect(directBody['source_config'], {
      'direct_url': {
        'medias': [
          {
            'url': 'https://media.example.test/movie.m3u8',
            'headers': {'User-Agent': 'Mozilla/5.0'},
          }
        ],
        'url': 'https://media.example.test/movie.m3u8',
        'headers': {'User-Agent': 'Mozilla/5.0'},
        'prefer_proxy': true,
      },
    });

    final rtmpBody = jsonDecode(requests[1].body) as Map<String, dynamic>;
    expect(rtmpBody['source_provider'], 'rtmp');
    expect(rtmpBody['playlist_id'], 'pl_1');
    expect(rtmpBody['source_config'], {'rtmp': <String, dynamic>{}});

    final liveProxyBody = jsonDecode(requests[2].body) as Map<String, dynamic>;
    expect(liveProxyBody['source_provider'], 'live_proxy');
    expect(liveProxyBody['playlist_id'], 'pl_1');
    expect(liveProxyBody['source_config'], {
      'live_proxy': {'url': 'rtmp://upstream.example.test/live/room'},
    });
    expect(
      requests[3].url.path,
      '/api/providers/rtmp/rooms/room_1/publish-key/med_rtmp',
    );
  });

  test('emby dynamic playlist creation sends playlist source config oneof',
      () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'playlist': {
              'id': 'pl_emby',
              'room_id': 'room_1',
              'name': 'Season 1',
              'is_dynamic': true,
              'source_provider': 'emby',
              'provider_instance_name': 'emby_main',
              'source_config': {
                'emby': {
                  'server_id': 'server_1',
                  'item_id': 'folder_1',
                },
              },
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final domain = SyncTvRoomMediaDomainService(api);

    final playlist = await domain.createPlaylist(
      'room_1',
      name: 'Season 1',
      parentId: 'pl_parent',
      sourceProvider: 'emby',
      providerInstanceName: 'emby_main',
      sourceConfig: const {
        'server_id': 'server_1',
        'item_id': 'folder_1',
      },
    );

    expect(requestMethod, 'POST');
    expect(requestedUri!.path, '/api/rooms/room_1/playlists');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body['name'], 'Season 1');
    expect(body['parent_id'], 'pl_parent');
    expect(body['source_provider'], 'emby');
    expect(body['provider_instance_name'], 'emby_main');
    expect(body['source_config'], {
      'emby': {
        'server_id': 'server_1',
        'item_id': 'folder_1',
      },
    });
    expect(playlist.id, 'pl_emby');
    expect(playlist.isDynamicPlaylist, isTrue);
  });

  test('account closure uses protobuf command endpoint and body', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final session = SyncTvSession()..accessToken = 'token';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.closeAccount(client.CloseAccountRequest());

    expect(response.success, isTrue);
    expect(requestMethod, 'POST');
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/account-closure');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), <String, dynamic>{});
    expect(session.accessToken, isNull);
  });

  test('email unbind uses protobuf command endpoint', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'user': {
              'id': 'usr_1',
              'username': 'alice',
              'email': '',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.unbindEmail(client.UnbindEmailRequest());

    expect(response.user.id, 'usr_1');
    expect(response.user.email, isEmpty);
    expect(requestMethod, 'POST');
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/email/unbind');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), <String, dynamic>{});
  });

  test('admin test email uses protobuf request body only', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'message': 'ok'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.adminService.sendTestEmail(
      admin.SendTestEmailRequest(to: 'ops@example.test'),
    );

    expect(response.message, 'ok');
    expect(requestMethod, 'POST');
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/email/test');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), {'to': 'ops@example.test'});
  });

  test('room settings update keeps typed service model and protobuf bytes body',
      () async {
    String? requestBody;
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final origin = 'http://${server.address.host}:${server.port}';
    final requests = server.listen((request) async {
      requestedUri = request.uri;
      requestBody = await utf8.decoder.bind(request).join();
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'room': {
            'room_id': 'room_1',
            'room_name': 'Room 1',
            'creator_id': 'user_1',
            'settings': utf8.encode(jsonEncode({
              'allow_guest_join': true,
            })),
          },
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(origin);

      await SyncTvService.updateRoomSettings(
        'room_1',
        SyncTvRoomSettings(
          allowGuestJoin: true,
          requireApproval: true,
          maxMembers: 42,
          chatEnabled: false,
          guestAddedPermissions: RoomGuestPermissions.viewMemberList,
        ),
      );
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/settings');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    final settings = body['settings'] as Map<String, dynamic>;
    expect(settings['allow_guest_join'], isTrue);
    expect(settings['require_approval'], isTrue);
    expect(settings['max_members'], 42);
    expect(settings['chat_enabled'], isFalse);
    expect(settings['guest_added_permissions'],
        RoomGuestPermissions.viewMemberList);
    expect(body.containsKey('room_id'), isFalse);
  });

  test('admin settings group reads dedicated protobuf endpoint', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'group': {
            'name': 'email',
            'settings': base64Encode(utf8.encode(jsonEncode({
              'smtp_enabled': true,
              'smtp_host': 'mail.example.test',
            }))),
          },
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final group = await SyncTvService.adminGetSettingsGroup('email');

      expect(group.name, 'email');
      expect(group.settings['smtp_enabled'], isTrue);
      expect(group.settings['smtp_host'], 'mail.example.test');
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/settings/email');
    expect(requestedUri!.queryParameters, isEmpty);
  });

  test('room member service preserves pagination filters and version',
      () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'members': [
            {
              'room_id': 'room_1',
              'user_id': 'usr_1',
              'username': 'alice',
              'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
              'permissions': '7',
              'joined_at': '1700000000',
              'is_online': true,
            }
          ],
          'total': 6,
          'version': 'members-v3',
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.getRoomMemberDetailsPage(
        'room_1',
        page: 2,
        pageSize: 25,
        search: 'alice',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        sortBy:
            client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME,
        sortDirection: client_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 6);
      expect(page.page, 2);
      expect(page.pageSize, 25);
      expect(page.version, 'members-v3');
      expect(page.members.single.userId, 'usr_1');
      expect(page.members.single.isOnline, isTrue);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/members');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'page_size': '25',
      'search': 'alice',
      'role': '${common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value}',
      'sort_by':
          '${client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME.value}',
      'sort_direction': '${client_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test('room join review service preserves pagination filters and total',
      () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'reviews': [
            {
              'id': 'rev_1',
              'room_id': 'room_1',
              'user_id': 'usr_2',
              'username': 'bob',
              'requested_role':
                  common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
              'status': common.ReviewStatus.REVIEW_STATUS_PENDING.value,
              'requested_at': '1700000001',
            }
          ],
          'total': 3,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.listRoomJoinReviewsPage(
        'room_1',
        page: 4,
        pageSize: 10,
        status: common.ReviewStatus.REVIEW_STATUS_PENDING,
        userId: 'usr_2',
      );

      expect(page.total, 3);
      expect(page.page, 4);
      expect(page.pageSize, 10);
      expect(page.reviews.single.id, 'rev_1');
      expect(page.reviews.single.username, 'bob');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/reviews/joins');
    expect(requestedUri!.queryParameters, {
      'page': '4',
      'page_size': '10',
      'status': '${common.ReviewStatus.REVIEW_STATUS_PENDING.value}',
      'user_id': 'usr_2',
    });
  });

  test('kick member sends protobuf request body instead of query', () async {
    Uri? requestedUri;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response('{}', 200, headers: {
          'content-type': 'application/json',
        });
      }),
    );

    await api.room.kickMember(
      'room_1',
      client.KickMemberRequest(
        userId: 'user_1',
        kickCooldownSeconds: Int64(120),
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/members/user_1');
    expect(requestedUri!.queryParameters,
        isNot(contains('kick_cooldown_seconds')));
    expect(jsonDecode(requestBody!), {
      'user_id': 'user_1',
      'kick_cooldown_seconds': '120',
    });
  });

  test('room management kick member preserves custom cooldown', () async {
    Uri? requestedUri;
    String? requestBody;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      requestBody = await utf8.decoder.bind(request).join();
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write('{}');
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      await SyncTvService.kickMember(
        'room_1',
        'usr_9',
        kickCooldownSeconds: 300,
      );
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/members/usr_9');
    expect(jsonDecode(requestBody!), {
      'user_id': 'usr_9',
      'kick_cooldown_seconds': '300',
    });
  });

  test('member permission overrides send protobuf request body', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'member': {
              'room_id': 'room_1',
              'user_id': 'usr_1',
              'username': 'alice',
              'role': 3,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.room.updateMemberPermissions(
      'room_1',
      client.UpdateMemberPermissionsRequest(
        userId: 'usr_1',
        addedPermissions: Int64(1),
        removedPermissions: Int64(4),
        adminAddedPermissions: Int64(0),
        adminRemovedPermissions: Int64(0),
      ),
    );
    await api.room.updateMemberPermissions(
      'room_1',
      client.UpdateMemberPermissionsRequest(
        userId: 'usr_1',
        addedPermissions: Int64(0),
        removedPermissions: Int64(0),
        adminAddedPermissions: Int64(2),
        adminRemovedPermissions: Int64(8),
      ),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'PATCH');
    expect(requests.first.url.path, '/api/rooms/room_1/members/usr_1');
    final memberBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(memberBody['user_id'], 'usr_1');
    expect(memberBody['added_permissions'], '1');
    expect(memberBody['removed_permissions'], '4');
    expect(memberBody['admin_added_permissions'], '0');
    expect(memberBody['admin_removed_permissions'], '0');

    final adminBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(adminBody['user_id'], 'usr_1');
    expect(adminBody['added_permissions'], '0');
    expect(adminBody['removed_permissions'], '0');
    expect(adminBody['admin_added_permissions'], '2');
    expect(adminBody['admin_removed_permissions'], '8');
  });

  test('room lifecycle and member commands use protobuf contract', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/room_1/owner':
            return http.Response(
              jsonEncode({
                'room': {
                  'id': 'room_1',
                  'name': 'Room',
                  'created_by': 'usr_2',
                  'status': 1,
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/members':
            return http.Response(
              jsonEncode({
                'member': {
                  'room_id': 'room_1',
                  'user_id': 'usr_3',
                  'username': 'carol',
                  'role': 3,
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/members/@me':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );

    await api.room.transferRoomOwnership(
      'room_1',
      client.TransferRoomOwnershipRequest(newOwnerUserId: 'usr_2'),
    );
    await api.room.addMember(
      'room_1',
      client.AddMemberRequest(
        userId: 'usr_3',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
        notify: false,
      ),
    );
    await api.room.leaveRoom('room_1', client.LeaveRoomRequest());
    await api.room.deleteRoom('room_1', client.DeleteRoomRequest());

    expect(requests.map((request) => request.method), [
      'POST',
      'POST',
      'DELETE',
      'DELETE',
    ]);
    expect(requests.map((request) => request.url.path), [
      '/api/rooms/room_1/owner',
      '/api/rooms/room_1/members',
      '/api/rooms/room_1/members/@me',
      '/api/rooms/room_1',
    ]);
    expect(jsonDecode(requests[0].body), {'new_owner_user_id': 'usr_2'});
    expect(jsonDecode(requests[1].body), {
      'user_id': 'usr_3',
      'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
      'notify': false,
    });
    expect(requests[2].body, isEmpty);
    expect(requests[3].body, isEmpty);
  });

  test('admin room ban and password update preserve protobuf fields', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/password')) {
          return http.Response(
            jsonEncode({'success': true}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_1',
              'name': 'Room',
              'created_by': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              'is_banned': true,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.banRoom(
      admin.BanRoomRequest(roomId: 'room_1', reason: 'abuse'),
    );
    await api.adminService.updateRoomPassword(
      admin.UpdateRoomPasswordRequest(roomId: 'room_1', newPassword: ''),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(requests.first.url.path, '/api/admin/rooms/room_1/ban');
    expect(jsonDecode(requests.first.body), {
      'room_id': 'room_1',
      'reason': 'abuse',
    });
    expect(requests.last.method, 'POST');
    expect(requests.last.url.path, '/api/admin/rooms/room_1/password');
    expect(jsonDecode(requests.last.body), {
      'room_id': 'room_1',
      'new_password': '',
    });
  });

  test('room password clear uses room password delete endpoint', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvRoomManagementDomainService(api);

    await service.updateRoomPassword('room_1', '');

    expect(requests, hasLength(1));
    expect(requests.single.method, 'DELETE');
    expect(requests.single.url.path, '/api/rooms/room_1/password');
    expect(jsonDecode(requests.single.body), <String, dynamic>{});
  });

  test('room password update registers OPAQUE bytes without plaintext',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/room_1/password/opaque/registration/start':
            return http.Response(
              jsonEncode({
                'session_id': 'room_password_session',
                'registration_response': base64Encode([9, 8, 7]),
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/password/opaque/registration/finish':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );
    final service = SyncTvRoomManagementDomainService(
      api,
      opaqueClient: _FakeOpaqueClient(),
    );

    await service.updateRoomPassword('room_1', 'plain-room-password');

    expect(requests.map((request) => request.method), ['PATCH', 'PATCH']);
    expect(requests.map((request) => request.url.path), [
      '/api/rooms/room_1/password/opaque/registration/start',
      '/api/rooms/room_1/password/opaque/registration/finish',
    ]);

    final bodies = requests
        .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
        .toList();
    expect(bodies[0], {
      'registration_request': base64Encode([1, 2, 3]),
    });
    expect(bodies[1], {
      'session_id': 'room_password_session',
      'registration_upload': base64Encode([4, 5, 6]),
    });
    for (final body in bodies) {
      expect(body.containsKey('password'), isFalse);
      expect(body.values, isNot(contains('plain-room-password')));
    }
  });

  test('room join with password uses OPAQUE login bytes without plaintext',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/room_1/password/opaque/login/start':
            return http.Response(
              jsonEncode({
                'session_id': 'room_login_session',
                'credential_response': base64Encode([30, 31, 32]),
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/password/opaque/login/finish':
            return http.Response(
              jsonEncode({
                'room': {
                  'id': 'room_1',
                  'name': 'Room',
                  'created_by': 'usr_1',
                  'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
                },
                'member': {
                  'room_id': 'room_1',
                  'user_id': 'usr_2',
                  'username': 'bob',
                  'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );
    final service = SyncTvPublicRoomDomainService(
      api: api,
      sessionStore: SyncTvSessionStore(api.session),
      authService: SyncTvAuthDomainService(
        api: api,
        sessionStore: SyncTvSessionStore(api.session),
      ),
      opaqueClient: _FakeOpaqueClient(),
    );

    await service.joinRoom('room_1', 'plain-room-password');

    expect(requests.map((request) => request.method), ['POST', 'POST']);
    expect(requests.map((request) => request.url.path), [
      '/api/rooms/room_1/password/opaque/login/start',
      '/api/rooms/room_1/password/opaque/login/finish',
    ]);

    final bodies = requests
        .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
        .toList();
    expect(bodies[0], {
      'room_id': 'room_1',
      'credential_request': base64Encode([40, 41, 42]),
    });
    expect(bodies[1], {
      'session_id': 'room_login_session',
      'credential_finalization': base64Encode([50, 51, 52]),
    });
    for (final body in bodies) {
      expect(body.containsKey('password'), isFalse);
      expect(body.values, isNot(contains('plain-room-password')));
    }
  });

  test('room join without password keeps plain membership endpoint empty',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_1',
              'name': 'Room',
              'created_by': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
            },
            'member': {
              'room_id': 'room_1',
              'user_id': 'usr_2',
              'username': 'bob',
              'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final sessionStore = SyncTvSessionStore(api.session);
    final service = SyncTvPublicRoomDomainService(
      api: api,
      sessionStore: sessionStore,
      authService: SyncTvAuthDomainService(
        api: api,
        sessionStore: sessionStore,
      ),
    );

    await service.joinRoom('room_1', '');

    expect(requests, hasLength(1));
    expect(requests.single.method, 'PUT');
    expect(requests.single.url.path, '/api/rooms/room_1/members/@me');
    expect(jsonDecode(requests.single.body), {'room_id': 'room_1'});
  });

  test('admin unban room uses protobuf path command endpoint', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_1',
              'name': 'Room',
              'created_by': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              'is_banned': false,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.unbanRoom(
      admin.UnbanRoomRequest(roomId: 'room_1'),
    );

    expect(requests, hasLength(1));
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/api/admin/rooms/room_1/unban');
    expect(requests.single.body, isEmpty);
  });

  test('admin kick member sends protobuf request body instead of query',
      () async {
    Uri? requestedUri;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response('{}', 200, headers: {
          'content-type': 'application/json',
        });
      }),
    );

    await api.adminService.kickMember(
      admin.KickMemberRequest(
        roomId: 'room_1',
        userId: 'user_1',
        kickCooldownSeconds: Int64(180),
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/rooms/room_1/members/user_1');
    expect(requestedUri!.queryParameters,
        isNot(contains('kick_cooldown_seconds')));
    expect(jsonDecode(requestBody!), {
      'room_id': 'room_1',
      'user_id': 'user_1',
      'kick_cooldown_seconds': '180',
    });
  });

  test('admin add member sends current room member role enum body', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'member': {
              'room_id': 'room_1',
              'user_id': 'usr_1',
              'username': 'alice',
              'role': 3,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.addMember(
      admin.AddMemberRequest(
        roomId: 'room_1',
        userId: 'usr_1',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
        notify: true,
      ),
    );
    await api.adminService.addMember(
      admin.AddMemberRequest(
        roomId: 'room_1',
        userId: 'usr_2',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        notify: false,
      ),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(requests.first.url.path, '/api/admin/rooms/room_1/members');
    final memberBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(memberBody['room_id'], 'room_1');
    expect(memberBody['user_id'], 'usr_1');
    expect(memberBody['role'],
        common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value);
    expect(memberBody['notify'], isTrue);

    final adminBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(adminBody['user_id'], 'usr_2');
    expect(
        adminBody['role'], common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value);
    expect(adminBody['notify'], isFalse);
  });

  test('admin room member service preserves protobuf filters and options',
      () async {
    final requests = <http.Request>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      final body = await utf8.decoder.bind(request).join();
      requests.add(http.Request(request.method, request.uri)..body = body);
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json;
      if (request.method == 'GET') {
        request.response.write(jsonEncode({
          'members': [
            {
              'room_id': 'room_1',
              'user_id': 'usr_1',
              'username': 'alice',
              'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
              'joined_at': '1700000000',
              'is_online': true,
            }
          ],
          'total': 1,
        }));
      } else if (request.method == 'POST') {
        request.response.write(jsonEncode({
          'member': {
            'room_id': 'room_1',
            'user_id': 'usr_2',
            'username': 'bob',
            'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
          },
        }));
      } else {
        request.response.write(jsonEncode({'success': true}));
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListRoomMembersPage(
        'room_1',
        page: 2,
        pageSize: 20,
        search: 'alice',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        sortBy:
            admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );
      await SyncTvService.adminAddRoomMember(
        'room_1',
        'usr_2',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
        notify: false,
      );
      await SyncTvService.adminKickRoomMember(
        'room_1',
        'usr_1',
        kickCooldownSeconds: 900,
      );

      expect(page.total, 1);
      expect(page.members.single.userId, 'usr_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requests, hasLength(3));
    expect(requests[0].method, 'GET');
    expect(requests[0].url.path, '/api/admin/rooms/room_1/members');
    expect(requests[0].url.queryParameters, {
      'page': '2',
      'page_size': '20',
      'search': 'alice',
      'role': '${common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value}',
      'sort_by':
          '${admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME.value}',
      'sort_direction': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
    expect(jsonDecode(requests[1].body), {
      'room_id': 'room_1',
      'user_id': 'usr_2',
      'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
      'notify': false,
    });
    expect(jsonDecode(requests[2].body), {
      'room_id': 'room_1',
      'user_id': 'usr_1',
      'kick_cooldown_seconds': '900',
    });
  });

  test('admin list admins service preserves pagination and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'admins': [
            {
              'id': 'usr_1',
              'username': 'root',
              'email': 'root@example.test',
              'role': common.UserRole.USER_ROLE_ROOT.value,
              'status': common.UserStatus.USER_STATUS_ACTIVE.value,
            }
          ],
          'total': 12,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListAdminsPage(
        page: 3,
        pageSize: 20,
        search: 'root',
        sortBy: admin_enum.UserListSortBy.USER_LIST_SORT_BY_USERNAME,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 12);
      expect(page.admins.single.id, 'usr_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/admins');
    expect(requestedUri!.queryParameters, {
      'page': '3',
      'page_size': '20',
      'search': 'root',
      'sort_by':
          '${admin_enum.UserListSortBy.USER_LIST_SORT_BY_USERNAME.value}',
      'sort_direction': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test('admin add admin promotes an existing user through path command',
      () async {
    http.Request? capturedRequest;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          '{}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvAdminDomainService(api);

    await service.addAdmin('usr_2');

    expect(capturedRequest, isNotNull);
    expect(capturedRequest!.method, 'POST');
    expect(capturedRequest!.url.path, '/api/admin/admins/usr_2');
    expect(jsonDecode(capturedRequest!.body), {'user_id': 'usr_2'});
  });

  test('admin member role and permission overrides use protobuf body',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'member': {
              'room_id': 'room_1',
              'user_id': 'usr_1',
              'username': 'alice',
              'role': 2,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.updateMemberPermissions(
      admin.UpdateMemberPermissionsRequest(
        roomId: 'room_1',
        userId: 'usr_1',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        adminAddedPermissions: Int64(2),
        adminRemovedPermissions: Int64(8),
      ),
    );
    await api.adminService.updateMemberPermissions(
      admin.UpdateMemberPermissionsRequest(
        roomId: 'room_1',
        userId: 'usr_1',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
        addedPermissions: Int64(1),
        removedPermissions: Int64(4),
      ),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'PATCH');
    expect(requests.first.url.path, '/api/admin/rooms/room_1/members/usr_1');
    final adminBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(adminBody['room_id'], 'room_1');
    expect(adminBody['user_id'], 'usr_1');
    expect(
        adminBody['role'], common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value);
    expect(adminBody['admin_added_permissions'], '2');
    expect(adminBody['admin_removed_permissions'], '8');

    final memberBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(memberBody['role'],
        common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value);
    expect(memberBody['added_permissions'], '1');
    expect(memberBody['removed_permissions'], '4');
  });

  test('available provider instances query is generated from protobuf request',
      () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response('{}', 200, headers: {
          'content-type': 'application/json',
        });
      }),
    );

    await api.providerCommon.listAvailableProviderInstances(
      provider_common.ListAvailableProviderInstancesRequest(
        providerType: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/instances/available');
    expect(
      requestedUri!.queryParameters,
      containsPair('provider_type', 'emby'),
    );
  });

  test('provider instance domain service maps protobuf response', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final listener = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'instances': ['home', 'edge'],
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final instances = await SyncTvService.listAvailableProviderInstances(
        providerType: 'emby',
      );

      expect(instances, ['home', 'edge']);
      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/providers/instances/available');
      expect(
        requestedUri!.queryParameters,
        containsPair('provider_type', 'emby'),
      );
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }
  });

  test('alist search sends protobuf request body', () async {
    Uri? requestedUri;
    String? requestBody;
    const directoryCredential = 'not-real-directory-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'content': <Object?>[],
            'total': '0',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.alistProvider.search(
      alist.SearchRequest(
        serverId: 'server_1',
        parent: '/movies',
        keywords: 'matrix',
        scope: Int64(2),
        page: Int64(3),
        perPage: Int64(40),
        password: directoryCredential,
        instanceName: 'edge',
      ),
    );

    expect(response, isA<alist.SearchResponse>());
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/alist/search');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), {
      'server_id': 'server_1',
      'parent': '/movies',
      'keywords': 'matrix',
      'scope': '2',
      'page': '3',
      'per_page': '40',
      'password': directoryCredential,
      'instance_name': 'edge',
    });
  });

  test('alist list sends directory password in protobuf request body',
      () async {
    Uri? requestedUri;
    String? requestBody;
    const directoryCredential = 'not-real-directory-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'content': [
              {
                'name': 'movie.mp4',
                'size': '1024',
                'is_dir': false,
                'modified': '1760000100',
                'thumb': '/thumb.jpg',
                'type': '2',
                'sign': 'signed-query-fragment',
              }
            ],
            'total': '1',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.alistProvider.list(
      alist.ListRequest(
        serverId: 'server_1',
        path: '/private',
        page: Int64(2),
        perPage: Int64(30),
        password: directoryCredential,
        refresh: true,
        instanceName: 'edge',
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/alist/list');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), {
      'server_id': 'server_1',
      'path': '/private',
      'password': directoryCredential,
      'page': '2',
      'per_page': '30',
      'refresh': true,
      'instance_name': 'edge',
    });
    expect(response.content.single.sign, 'signed-query-fragment');
  });

  test('alist domain model preserves file item sign', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'content': [
            {
              'name': 'movie.mp4',
              'size': '1024',
              'is_dir': false,
              'modified': '1760000100',
              'thumb': '/thumb.jpg',
              'type': '2',
              'sign': 'signed-query-fragment',
            }
          ],
          'total': '1',
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.listAlistPage(
        '/private',
        serverId: 'server_1',
      );

      expect(page.items.single.sign, 'signed-query-fragment');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('alist login sends plaintext credential and optional otp fields',
      () async {
    Uri? requestedUri;
    String? requestBody;
    const providerCredential = 'not-real-provider-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'token': 'alist_token',
            'server_id': 'server_1',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.alistProvider.login(
      alist.LoginRequest(
        host: 'https://alist.example.test',
        username: 'alice',
        password: providerCredential,
        otpCode: '',
        otpSecret: '',
        instanceName: 'edge',
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/alist/login');
    expect(response.token, 'alist_token');
    expect(response.serverId, 'server_1');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), {
      'host': 'https://alist.example.test',
      'username': 'alice',
      'password': providerCredential,
      'otp_code': '',
      'otp_secret': '',
      'instance_name': 'edge',
    });
  });

  test('provider login supports alist otp and emby api key protobuf oneof',
      () async {
    final requests = <http.Request>[];
    const providerCredential = 'not-real-provider-credential';
    const embyCredential = 'not-real-emby-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/providers/alist/login') {
          return http.Response(
            jsonEncode({'token': 'alist_token', 'server_id': 'alist_server'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/providers/emby/login') {
          return http.Response(
            jsonEncode({
              'user_id': 'emby_user',
              'username': 'alice',
              'is_admin': true,
              'server_id': 'emby_server',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('not found', 404);
      }),
    );

    await api.alistProvider.login(
      alist.LoginRequest(
        host: 'https://alist.example.test',
        username: 'alice',
        password: providerCredential,
        otpCode: '123456',
        otpSecret: 'totp-secret',
        instanceName: 'alist-edge',
      ),
    );
    await api.alistProvider.login(
      alist.LoginRequest(
        host: 'https://alist2.example.test',
        username: 'alice',
        hashedPassword: 'hashed-password',
        otpCode: '',
        otpSecret: '',
        instanceName: 'alist-hashed',
      ),
    );
    await api.embyProvider.login(
      emby.LoginRequest(
        host: 'https://jellyfin.example.test',
        username: 'bob',
        apiKey: embyCredential,
        instanceName: 'emby-edge',
      ),
    );

    expect(requests.map((request) => request.url.path), [
      '/api/providers/alist/login',
      '/api/providers/alist/login',
      '/api/providers/emby/login',
    ]);
    expect(jsonDecode(requests[0].body), {
      'host': 'https://alist.example.test',
      'username': 'alice',
      'password': providerCredential,
      'otp_code': '123456',
      'otp_secret': 'totp-secret',
      'instance_name': 'alist-edge',
    });
    expect(jsonDecode(requests[1].body), {
      'host': 'https://alist2.example.test',
      'username': 'alice',
      'hashed_password': 'hashed-password',
      'otp_code': '',
      'otp_secret': '',
      'instance_name': 'alist-hashed',
    });
    expect(
        (jsonDecode(requests[1].body) as Map).containsKey('password'), isFalse);
    expect(jsonDecode(requests[2].body), {
      'host': 'https://jellyfin.example.test',
      'username': 'bob',
      'api_key': embyCredential,
      'instance_name': 'emby-edge',
    });
    expect(
        (jsonDecode(requests[2].body) as Map).containsKey('password'), isFalse);
  });

  test('emby list maps server thumbnail proxy url from protobuf response',
      () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final origin = 'http://${server.address.host}:${server.port}';
    final requests = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'items': [
            {
              'id': 'emby-item-1',
              'name': 'Episode 1',
              'type': 'Episode',
              'description': 'Pilot episode',
              'thumbnail':
                  '/api/providers/emby/thumbnail/emby-item-1?server_id=srv_1&credential_owner_id=usr_1&max_height=300',
            },
          ],
          'total': '1',
        }));
      await request.response.close();
    });

    late final EmbyListPage page;
    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(origin);

      page = await SyncTvService.listEmbyPage(
        '/',
        serverId: 'srv_1',
      );
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/emby/list');
    expect(page.items, hasLength(1));
    expect(
      page.items.single.thumbnail,
      '$origin/api/providers/emby/thumbnail/emby-item-1?server_id=srv_1&credential_owner_id=usr_1&max_height=300',
    );
    expect(page.items.single.description, 'Pilot episode');
  });

  test('provider instance query is generated from protobuf request', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response('{}', 200, headers: {
          'content-type': 'application/json',
        });
      }),
    );

    await api.providerCommon.listProviderInstances(
      provider_common.ListProviderInstancesRequest(
        page: 2,
        pageSize: 10,
        providerType: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        search: 'home',
        enabled: true,
        tls: false,
        sortBy: provider_common.ProviderInstanceListSortBy
            .PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT,
        sortDirection: provider_common.SortDirection.SORT_DIRECTION_DESC,
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/instances');
    expect(requestedUri!.queryParameters, containsPair('page', '2'));
    expect(requestedUri!.queryParameters, containsPair('page_size', '10'));
    expect(
        requestedUri!.queryParameters, containsPair('provider_type', 'emby'));
    expect(requestedUri!.queryParameters, containsPair('search', 'home'));
    expect(requestedUri!.queryParameters, containsPair('enabled', 'true'));
    expect(requestedUri!.queryParameters, containsPair('tls', 'false'));
    expect(requestedUri!.queryParameters, containsPair('sort_by', '3'));
    expect(requestedUri!.queryParameters, containsPair('sort_direction', '2'));
  });

  test('provider instance service forwards paging TLS sort filters and total',
      () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final origin = 'http://${server.address.host}:${server.port}';
    final requests = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'instances': [
            {
              'name': 'edge',
              'endpoint': 'https://edge.example.test',
              'providers': ['alist'],
              'timeout_seconds': 30,
              'tls': true,
              'insecure_tls': false,
              'enabled': true,
              'status': provider_common.ProviderInstanceStatus
                  .PROVIDER_INSTANCE_STATUS_CONNECTED.value,
              'created_at': '1700000000',
              'updated_at': '1700000100',
            }
          ],
          'total': 11,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(origin);

      final page = await SyncTvService.adminListProviderInstancesPage(
        page: 3,
        pageSize: 20,
        providerType: 'alist',
        search: 'edge',
        enabled: true,
        tls: false,
        sortBy: provider_common.ProviderInstanceListSortBy
            .PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT,
        sortDirection: provider_common.SortDirection.SORT_DIRECTION_DESC,
      );

      expect(page.total, 11);
      expect(page.instances.single.name, 'edge');
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/instances');
    expect(requestedUri!.queryParameters, containsPair('page', '3'));
    expect(requestedUri!.queryParameters, containsPair('page_size', '20'));
    expect(
        requestedUri!.queryParameters, containsPair('provider_type', 'alist'));
    expect(requestedUri!.queryParameters, containsPair('search', 'edge'));
    expect(requestedUri!.queryParameters, containsPair('enabled', 'true'));
    expect(requestedUri!.queryParameters, containsPair('tls', 'false'));
    expect(requestedUri!.queryParameters, containsPair('sort_by', '4'));
    expect(requestedUri!.queryParameters, containsPair('sort_direction', '2'));
  });

  test('provider backend discovery uses protobuf path request', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'backends': ['alist', 'alist-edge'],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.providerCommon.listProviderBackends(
      provider_common.ListProviderBackendsRequest(
        providerType: source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/backends/alist');
    expect(response.backends, ['alist', 'alist-edge']);
  });

  test('provider instance mutations send protobuf request bodies', () async {
    final requests = <http.Request>[];
    Map<String, Object?> instanceJson({
      String name = 'edge',
      List<String> providers = const ['alist'],
      bool enabled = true,
    }) {
      return {
        'instance': {
          'name': name,
          'endpoint': 'https://provider.example.test',
          'comment': 'edge node',
          'timeout_seconds': 30,
          'tls': true,
          'insecure_tls': false,
          'providers': providers,
          'enabled': enabled,
          'status': 1,
          'created_at': '1760000000',
          'updated_at': '1760000010',
        },
      };
    }

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.method == 'DELETE') {
          return http.Response(
            jsonEncode({'success': true}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode(
              instanceJson(enabled: !request.url.path.endsWith('/disable'))),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.providerCommon.addProviderInstance(
      provider_common.AddProviderInstanceRequest(
        name: 'edge',
        endpoint: 'https://provider.example.test',
        providers: [
          source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
          source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        ],
        comment: 'edge node',
        timeoutSeconds: 45,
        tls: true,
        insecureTls: false,
        jwtSecret: 'jwt-secret',
        customCa: 'pem',
      ),
    );
    await api.providerCommon.updateProviderInstance(
      provider_common.UpdateProviderInstanceRequest(
        name: 'edge',
        endpoint: 'https://provider2.example.test',
        providers: [source_enum.SourceProvider.SOURCE_PROVIDER_ALIST],
        clearComment_10: true,
        clearJwtSecret_11: true,
        clearCustomCa_12: true,
      ),
    );
    await api.providerCommon.reconnectProviderInstance(
      provider_common.ReconnectProviderInstanceRequest(name: 'edge'),
    );
    await api.providerCommon.enableProviderInstance(
      provider_common.EnableProviderInstanceRequest(name: 'edge'),
    );
    await api.providerCommon.disableProviderInstance(
      provider_common.DisableProviderInstanceRequest(name: 'edge'),
    );
    await api.providerCommon.deleteProviderInstance(
      provider_common.DeleteProviderInstanceRequest(name: 'edge'),
    );

    expect(requests[0].method, 'POST');
    expect(requests[0].url.path, '/api/providers/instances');
    expect(jsonDecode(requests[0].body), {
      'name': 'edge',
      'endpoint': 'https://provider.example.test',
      'comment': 'edge node',
      'timeout_seconds': 45,
      'tls': true,
      'insecure_tls': false,
      'providers': ['alist', 'emby'],
      'jwt_secret': 'jwt-secret',
      'custom_ca': 'pem',
    });

    expect(requests[1].method, 'PUT');
    expect(requests[1].url.path, '/api/providers/instances/edge');
    expect(jsonDecode(requests[1].body), {
      'name': 'edge',
      'endpoint': 'https://provider2.example.test',
      'providers': ['alist'],
      'clear_comment': true,
      'clear_jwt_secret': true,
      'clear_custom_ca': true,
    });

    expect(requests[2].method, 'POST');
    expect(requests[2].url.path, '/api/providers/instances/edge/reconnect');
    expect(requests[2].body, isEmpty);
    expect(requests[3].url.path, '/api/providers/instances/edge/enable');
    expect(requests[4].url.path, '/api/providers/instances/edge/disable');
    expect(requests[5].method, 'DELETE');
    expect(requests[5].url.path, '/api/providers/instances/edge');
  });

  test('OAuth2 unlink sends provider instance and user id query', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({'success': true, 'removed_count': 1}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.oauth2Service.unlinkProvider(
      oauth2.UnlinkProviderRequest(
        provider: 'github',
        providerInstanceName: 'github-main',
        providerUserId: 'gh_123',
      ),
    );

    expect(response.success, isTrue);
    expect(response.removedCount, 1);
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/oauth2/type/github/unlink');
    expect(requestedUri!.queryParameters, {
      'provider_user_id': 'gh_123',
      'provider_instance_name': 'github-main',
    });
  });

  test('OAuth2 bind options keep already linked provider instances available',
      () {
    final providers = [
      const OAuth2ProviderOption(
        name: 'github-main',
        type: 'github',
        signupEnabled: true,
        signupNeedReview: false,
      ),
    ];
    const linked = [
      OAuth2LinkedAccount(
        providerType: 'github',
        providerUsername: 'alice',
        providerInstanceName: 'github-main',
        providerIssuer: 'https://github.com',
        providerUserId: 'gh_alice',
        linkedAt: 1_700_000_000,
      ),
    ];

    final bindable = oauth2BindableProviders(providers);

    expect(linked.single.providerInstanceName, 'github-main');
    expect(bindable, hasLength(1));
    expect(bindable.single.name, 'github-main');
  });

  test('OAuth2 login result preserves review and redirect protobuf fields',
      () async {
    Uri? requestedUri;
    String? requestBody;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      requestBody = await utf8.decoder.bind(request).join();
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'access_token': '',
          'refresh_token': '',
          'expires_in': '600',
          'redirect_url': 'https://app.example.test/oauth2/done',
          'is_bind': false,
          'registration_review_required': true,
          'registration_review_id': 'rev_oauth2_1',
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      expect(await SyncTvService.getToken(), isNull);
      final result = await SyncTvService.finishOAuth2Login(
        provider: 'github-main',
        code: 'abc123',
        state: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      );

      expect(result.authenticated, isFalse);
      expect(result.registrationReviewRequired, isTrue);
      expect(result.registrationReviewId, 'rev_oauth2_1');
      expect(result.redirectUrl, 'https://app.example.test/oauth2/done');
      expect(result.expiresIn, 600);
      expect(result.oauth2Bind, isFalse);
      expect(await SyncTvService.getToken(), isNull);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/oauth2/github-main/exchange');
    expect(jsonDecode(requestBody!), {
      'provider': 'github-main',
      'code': 'abc123',
      'state': 'AbCdEfGh1234567890aBcDeFgHiJkLm',
    });
  });

  test('OAuth2 bind exchange does not overwrite the signed-in session',
      () async {
    final session = SyncTvSession()
      ..accessToken = 'existing-access'
      ..refreshToken = 'existing-refresh';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        expect(request.headers['authorization'], 'Bearer existing-access');
        return http.Response(
          jsonEncode({
            'access_token': '',
            'refresh_token': '',
            'is_bind': true,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.oauth2Service.exchangeAuthorizationCode(
      oauth2.ExchangeAuthorizationCodeRequest(
        provider: 'github-main',
        code: 'abc123',
        state: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
    );

    expect(response.isBind, isTrue);
    expect(session.accessToken, 'existing-access');
    expect(session.refreshToken, 'existing-refresh');
    expect(session.isGuest, isFalse);
  });

  test('Bilibili QR and SMS login endpoints use protobuf request bodies',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/login/qr/generate')) {
          return http.Response(
            jsonEncode({
              'url': 'https://passport.bilibili.com/qr',
              'key': 'qr_key',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path.endsWith('/login/sms/start')) {
          return http.Response(
            jsonEncode({
              'session_token': 'sms_session_1',
              'gt': 'gt_value',
              'challenge': 'challenge_value',
              'expires_at': 1710000300,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path.endsWith('/login/sms/send')) {
          return http.Response(
            jsonEncode({
              'session_token': 'sms_session_2',
              'expires_at': 1710000360,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path.endsWith('/login/sms/login')) {
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('{}', 404);
      }),
    );

    final qr = await api.bilibiliProvider.loginQR(
      bilibili.LoginQRRequest(instanceName: 'main'),
    );
    final smsStart = await api.bilibiliProvider.startSMSLogin(
      bilibili.StartSMSLoginRequest(instanceName: 'main'),
    );
    final smsSend = await api.bilibiliProvider.sendSMS(
      bilibili.SendSMSRequest(
        sessionToken: 'sms_session_1',
        phone: '13800138000',
        validate: 'geetest_validate',
      ),
    );
    await api.bilibiliProvider.loginSMS(
      bilibili.LoginSMSRequest(
        sessionToken: 'sms_session_2',
        code: '123456',
      ),
    );

    expect(qr.url, 'https://passport.bilibili.com/qr');
    expect(qr.key, 'qr_key');
    expect(smsStart.sessionToken, 'sms_session_1');
    expect(smsStart.gt, 'gt_value');
    expect(smsStart.challenge, 'challenge_value');
    expect(smsStart.expiresAt.toInt(), 1710000300);
    expect(smsSend.sessionToken, 'sms_session_2');
    expect(smsSend.expiresAt.toInt(), 1710000360);
    expect(requests[0].url.path, '/api/providers/bilibili/login/qr/generate');
    expect(jsonDecode(requests[0].body), {'instance_name': 'main'});
    expect(requests[1].url.path, '/api/providers/bilibili/login/sms/start');
    expect(jsonDecode(requests[1].body), {'instance_name': 'main'});
    expect(requests[2].url.path, '/api/providers/bilibili/login/sms/send');
    expect(jsonDecode(requests[2].body), {
      'session_token': 'sms_session_1',
      'phone': '13800138000',
      'validate': 'geetest_validate',
    });
    expect(requests[3].url.path, '/api/providers/bilibili/login/sms/login');
    expect(jsonDecode(requests[3].body), {
      'session_token': 'sms_session_2',
      'code': '123456',
    });
  });

  test('Bilibili Geetest page bridges frontend-rendered validate result', () {
    final html = buildBilibiliGeetestHtml(
      gt: 'gt"</script><script>bad()</script>',
      challenge: r'challenge\value',
    );

    expect(html, contains('https://static.geetest.com/static/tools/gt.js'));
    expect(html, contains('initGeetest({'));
    expect(html, contains('SyncTVGeetest.postMessage'));
    expect(html, contains(r'gt\"\u003c/script\u003e'));
    expect(html, contains(r'challenge\\value'));

    final result = parseBilibiliGeetestMessage(
      jsonEncode({'validate': ' geetest_validate '}),
    );
    expect(result.validate, 'geetest_validate');

    expect(
      () => parseBilibiliGeetestMessage(jsonEncode({'validate': ''})),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => parseBilibiliGeetestMessage(jsonEncode({'error': 'load failed'})),
      throwsA(isA<StateError>()),
    );
  });

  test('notification write endpoints accept protobuf bodies and 204 responses',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response('', 204);
      }),
    );

    await api.notifications.markAsRead(
      client.MarkAsReadRequest(notificationIds: [Int64(42), Int64(43)]),
    );
    await api.notifications.markAllAsRead(
      client.MarkAllAsReadRequest(before: Int64(1_700_000_000)),
    );
    await api.notifications.deleteAllRead(client.DeleteAllReadRequest());

    expect(requests, hasLength(3));
    expect(requests[0].method, 'POST');
    expect(requests[0].url.path, '/api/notifications/actions/mark-read');
    expect(jsonDecode(requests[0].body), {
      'notification_ids': ['42', '43'],
    });
    expect(requests[1].method, 'POST');
    expect(requests[1].url.path, '/api/notifications/read-all');
    expect(jsonDecode(requests[1].body), {'before': '1700000000'});
    expect(requests[2].method, 'DELETE');
    expect(requests[2].url.path, '/api/notifications/read');
    expect(requests[2].body, isEmpty);
  });

  test('notification service batches valid ids for mark read', () async {
    http.Request? capturedRequest;
    final server = await io.HttpServer.bind('127.0.0.1', 0);
    final listener = server.listen((request) async {
      final body = await utf8.decoder.bind(request).join();
      capturedRequest = http.Request(request.method, request.uri)..body = body;
      request.response
        ..statusCode = 204
        ..headers.contentType = io.ContentType.json;
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      await SyncTvService.markNotificationsAsRead([0, 42, -1, 43]);
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }

    expect(capturedRequest, isNotNull);
    expect(capturedRequest!.method, 'POST');
    expect(
      capturedRequest!.url.path,
      '/api/notifications/actions/mark-read',
    );
    expect(jsonDecode(capturedRequest!.body), {
      'notification_ids': ['42', '43'],
    });
  });

  test('websocket ticket endpoint uses protobuf body for signed-in users',
      () async {
    Uri? requestedUri;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'ticket': 'ws_ticket_1',
            'room_id': 'room_1',
            'expires_in_secs': '30',
            'usage': 'Use in WebSocket URL',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.createWebSocketTicket(
      client.CreateWebSocketTicketRequest(roomId: 'room_1'),
    );

    expect(response.ticket, 'ws_ticket_1');
    expect(response.roomId, 'room_1');
    expect(response.expiresInSecs.toInt(), 30);
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/tickets');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), {'room_id': 'room_1'});
  });

  test('room facade keeps room path separate from protobuf bodies and queries',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/room_1/members':
            if (request.method == 'GET') {
              return http.Response(
                jsonEncode({'members': [], 'total': 0, 'version': 'v1'}),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            return http.Response(
              jsonEncode({
                'member': {
                  'room_id': 'room_1',
                  'user_id': 'usr_2',
                  'username': 'bob',
                  'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/members/usr_2':
            return http.Response(
              jsonEncode({
                'member': {
                  'room_id': 'room_1',
                  'user_id': 'usr_2',
                  'username': 'bob',
                  'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
                  'added_permissions': '7',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/playlists/pl_1':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/playback/stop':
            return http.Response(
              '{}',
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );

    await api.room.getRoomMembers(
      'room_1',
      client.GetRoomMembersRequest(
        page: 2,
        pageSize: 10,
        search: 'bob',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        sortBy:
            client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME,
        sortDirection: client_enum.SortDirection.SORT_DIRECTION_ASC,
      ),
    );
    await api.room.addMember(
      'room_1',
      client.AddMemberRequest(
        userId: 'usr_2',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
        notify: true,
      ),
    );
    await api.room.updateMemberPermissions(
      'room_1',
      client.UpdateMemberPermissionsRequest(
        userId: 'usr_2',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        addedPermissions: Int64(7),
      ),
    );
    await api.room.deletePlaylist(
      'room_1',
      client.DeletePlaylistRequest(playlistId: 'pl_1', force: true),
    );
    await api.room.stopPlayback('room_1', client.StopPlaybackRequest());

    expect(requests[0].method, 'GET');
    expect(requests[0].url.path, '/api/rooms/room_1/members');
    expect(requests[0].url.queryParameters, {
      'page': '2',
      'page_size': '10',
      'search': 'bob',
      'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value.toString(),
      'sort_by': client_enum
          .RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME.value
          .toString(),
      'sort_direction':
          client_enum.SortDirection.SORT_DIRECTION_ASC.value.toString(),
    });

    expect(requests[1].method, 'POST');
    expect(requests[1].url.path, '/api/rooms/room_1/members');
    expect(jsonDecode(requests[1].body), {
      'user_id': 'usr_2',
      'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
      'notify': true,
    });

    expect(requests[2].method, 'PATCH');
    expect(requests[2].url.path, '/api/rooms/room_1/members/usr_2');
    final permissionBody = jsonDecode(requests[2].body) as Map<String, dynamic>;
    expect(permissionBody, containsPair('user_id', 'usr_2'));
    expect(
      permissionBody,
      containsPair('role', common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value),
    );
    expect(permissionBody, containsPair('added_permissions', '7'));
    expect(permissionBody, isNot(contains('room_id')));

    expect(requests[3].method, 'DELETE');
    expect(requests[3].url.path, '/api/rooms/room_1/playlists/pl_1');
    expect(requests[3].url.queryParameters, {'force': 'true'});
    expect(requests[3].body, isEmpty);

    expect(requests[4].method, 'POST');
    expect(requests[4].url.path, '/api/rooms/room_1/playback/stop');
    expect(jsonDecode(requests[4].body), <String, dynamic>{});
  });

  test('room websocket uri uses ticket and json transport', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        expect(request.url.path, '/api/tickets');
        return http.Response(
          jsonEncode(<String, dynamic>{
            'ticket': 'ws_ticket',
            'expires_in_secs': '30',
          }),
          200,
        );
      }),
    );

    final ticket = await api.room.createWebSocketTicket(
      client.CreateWebSocketTicketRequest(),
    );
    final uri = api.roomWebSocketUri('room_1', ticket: ticket.ticket);

    expect(requests.single.method, 'POST');
    expect(uri.scheme, 'wss');
    expect(uri.path, '/ws/rooms/room_1');
    expect(uri.queryParameters, {
      'ticket': 'ws_ticket',
      'format': 'json',
    });
  });

  test('admin review endpoints use current protobuf query and body contracts',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        final path = request.url.path;
        if (path.endsWith('/user-registrations')) {
          return http.Response(
            jsonEncode({'reviews': [], 'total': 0}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (path.endsWith('/room-creations')) {
          return http.Response(
            jsonEncode({'reviews': [], 'total': 0}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (path.endsWith('/room-joins')) {
          return http.Response(
            jsonEncode({'reviews': [], 'total': 0}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('{}', 200, headers: {
          'content-type': 'application/json',
        });
      }),
    );

    await api.adminService.listUserRegistrationReviews(
      admin.ListUserRegistrationReviewsRequest(
        page: 2,
        pageSize: 30,
        status: common.ReviewStatus.REVIEW_STATUS_APPROVED,
        search: 'alice',
      ),
    );
    await api.adminService.approveUserRegistrationReview(
      admin.ApproveUserRegistrationReviewRequest(requestId: 'usr_1'),
    );
    await api.adminService.rejectUserRegistrationReview(
      admin.RejectUserRegistrationReviewRequest(
        requestId: 'usr_2',
        reason: 'duplicate',
      ),
    );
    await api.adminService.listRoomCreationReviews(
      admin.ListRoomCreationReviewsRequest(
        page: 3,
        pageSize: 25,
        status: common.ReviewStatus.REVIEW_STATUS_REJECTED,
        requestedBy: 'usr_3',
        search: 'movie night',
      ),
    );
    await api.adminService.approveRoomCreationReview(
      admin.ApproveRoomCreationReviewRequest(requestId: 'room_1'),
    );
    await api.adminService.rejectRoomCreationReview(
      admin.RejectRoomCreationReviewRequest(
        requestId: 'room_2',
        reason: 'policy',
      ),
    );
    await api.adminService.listRoomJoinReviews(
      admin.ListRoomJoinReviewsRequest(
        page: 4,
        pageSize: 20,
        status: common.ReviewStatus.REVIEW_STATUS_PENDING,
        roomId: 'room_3',
        userId: 'usr_4',
      ),
    );
    await api.adminService.approveRoomJoinReview(
      admin.ApproveRoomJoinReviewRequest(requestId: 'rev_1'),
    );
    await api.adminService.rejectRoomJoinReview(
      admin.RejectRoomJoinReviewRequest(
        requestId: 'rev_2',
        reason: 'full',
      ),
    );

    expect(requests, hasLength(9));
    expect(requests[0].method, 'GET');
    expect(requests[0].url.path, '/api/admin/reviews/user-registrations');
    expect(requests[0].url.queryParameters, {
      'page': '2',
      'page_size': '30',
      'status': '${common.ReviewStatus.REVIEW_STATUS_APPROVED.value}',
      'search': 'alice',
    });
    expect(
        requests[1].url.path, '/api/admin/reviews/user-registrations/approve');
    expect(jsonDecode(requests[1].body), {'request_id': 'usr_1'});
    expect(
        requests[2].url.path, '/api/admin/reviews/user-registrations/reject');
    expect(jsonDecode(requests[2].body), {
      'request_id': 'usr_2',
      'reason': 'duplicate',
    });

    expect(requests[3].url.path, '/api/admin/reviews/room-creations');
    expect(requests[3].url.queryParameters, {
      'page': '3',
      'page_size': '25',
      'status': '${common.ReviewStatus.REVIEW_STATUS_REJECTED.value}',
      'requested_by': 'usr_3',
      'search': 'movie night',
    });
    expect(requests[4].url.path, '/api/admin/reviews/room-creations/approve');
    expect(jsonDecode(requests[4].body), {'request_id': 'room_1'});
    expect(requests[5].url.path, '/api/admin/reviews/room-creations/reject');
    expect(jsonDecode(requests[5].body), {
      'request_id': 'room_2',
      'reason': 'policy',
    });

    expect(requests[6].url.path, '/api/admin/reviews/room-joins');
    expect(requests[6].url.queryParameters, {
      'page': '4',
      'page_size': '20',
      'status': '${common.ReviewStatus.REVIEW_STATUS_PENDING.value}',
      'room_id': 'room_3',
      'user_id': 'usr_4',
    });
    expect(requests[7].url.path, '/api/admin/reviews/room-joins/approve');
    expect(jsonDecode(requests[7].body), {'request_id': 'rev_1'});
    expect(requests[8].url.path, '/api/admin/reviews/room-joins/reject');
    expect(jsonDecode(requests[8].body), {
      'request_id': 'rev_2',
      'reason': 'full',
    });
  });

  test('admin registration review maps OAuth2 protobuf details', () async {
    SharedPreferences.setMockInitialValues({'synctv_token': 'token'});
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      expect(request.uri.path, '/api/admin/reviews/user-registrations');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'reviews': [
            {
              'id': 'usr_review_1',
              'username': 'alice',
              'email': 'alice@example.test',
              'signup_method': 3,
              'status': common.ReviewStatus.REVIEW_STATUS_PENDING.value,
              'requested_at': 1710000000,
              'oauth2_provider': 'oidc',
              'oauth2_provider_user_id': 'sub-123',
              'oauth2_provider_username': 'alice-oidc',
              'oauth2_avatar_url': 'https://issuer.example.test/a.png',
              'oauth2_email_trusted': true,
              'oauth2_provider_instance_name': 'logto-main',
              'oauth2_provider_issuer': 'https://issuer.example.test',
            }
          ],
          'total': 1,
        }));
      await request.response.close();
    });

    try {
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      final page = await SyncTvService.adminListReviewsPage(kind: 'user');
      expect(page.total, 1);
      final review = page.reviews.single;
      expect(review.signupMethod, 3);
      expect(review.oauth2Provider, 'oidc');
      expect(review.oauth2ProviderInstanceName, 'logto-main');
      expect(review.oauth2ProviderUserId, 'sub-123');
      expect(review.oauth2ProviderUsername, 'alice-oidc');
      expect(review.oauth2ProviderIssuer, 'https://issuer.example.test');
      expect(review.oauth2AvatarUrl, 'https://issuer.example.test/a.png');
      expect(review.oauth2EmailTrusted, isTrue);
      expect(review.details, contains('注册方式 OAuth2'));
      expect(review.details, contains('实例 logto-main'));
      expect(review.details, contains('Provider ID sub-123'));
      expect(review.details, contains('OAuth2 邮箱可信'));
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }
  });

  test('admin registration review maps Passkey protobuf details', () async {
    SharedPreferences.setMockInitialValues({'synctv_token': 'token'});
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      expect(request.uri.path, '/api/admin/reviews/user-registrations');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'reviews': [
            {
              'id': 'usr_review_2',
              'username': 'bob',
              'email': '',
              'signup_method': 5,
              'status': common.ReviewStatus.REVIEW_STATUS_PENDING.value,
              'requested_at': 1710000300,
              'webauthn_credential_id': 'Y3JlZGVudGlhbC0x',
              'webauthn_credential_name': 'MacBook Touch ID',
            }
          ],
          'total': 1,
        }));
      await request.response.close();
    });

    try {
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      final page = await SyncTvService.adminListReviewsPage(kind: 'user');
      expect(page.total, 1);
      final review = page.reviews.single;
      expect(review.signupMethod, 5);
      expect(review.webauthnCredentialId, 'Y3JlZGVudGlhbC0x');
      expect(review.webauthnCredentialName, 'MacBook Touch ID');
      expect(review.details, contains('注册方式 Passkey'));
      expect(review.details, contains('Passkey MacBook Touch ID'));
      expect(review.details, contains('Credential Y3JlZGVudGlhbC0x'));
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }
  });

  test('admin stream and ban list queries preserve protobuf filters', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/admin/streams') {
          return http.Response(
            jsonEncode({
              'streams': [
                {
                  'room_id': 'room_1',
                  'media_id': 'med_1',
                  'user_id': 'usr_1',
                  'node_id': 'node_a',
                  'started_at': '11',
                }
              ],
              'total': 6,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/admin/bans') {
          return http.Response(
            jsonEncode({
              'bans': [
                {
                  'id': 'ban_1',
                  'target_type': admin.BanTargetType.BAN_TARGET_TYPE_ROOM.value,
                  'room_id': 'room_1',
                  'room_name': 'Room 1',
                  'banned_by': 'usr_admin',
                  'banned_by_username': 'root',
                  'reason': 'policy',
                  'starts_at': '12',
                  'ends_at': '0',
                  'revoked_at': '0',
                  'revoked_by': '',
                  'is_active': true,
                }
              ],
              'total': 1,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('not found', 404);
      }),
    );

    final streams = await api.adminService.listActiveStreams(
      admin.ListActiveStreamsRequest(
        page: 3,
        pageSize: 40,
        roomId: 'room_1',
        userId: 'usr_1',
        nodeId: 'node_a',
        search: 'feature',
        sortBy: admin_enum
            .ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_NODE_ID,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      ),
    );
    final bans = await api.adminService.listBanRecords(
      admin.ListBanRecordsRequest(
        page: 2,
        pageSize: 25,
        targetType: admin.BanTargetType.BAN_TARGET_TYPE_ROOM,
        active: true,
        userId: 'usr_2',
        roomId: 'room_1',
      ),
    );

    expect(streams.streams.single.nodeId, 'node_a');
    expect(streams.total, 6);
    expect(bans.total, 1);
    expect(requests, hasLength(2));
    expect(requests[0].method, 'GET');
    expect(requests[0].url.path, '/api/admin/streams');
    expect(requests[0].url.queryParameters, {
      'page': '3',
      'page_size': '40',
      'room_id': 'room_1',
      'user_id': 'usr_1',
      'node_id': 'node_a',
      'search': 'feature',
      'sort_by':
          '${admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_NODE_ID.value}',
      'sort_direction': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
    expect(requests[1].method, 'GET');
    expect(requests[1].url.path, '/api/admin/bans');
    expect(requests[1].url.queryParameters, {
      'page': '2',
      'page_size': '25',
      'target_type': '${admin.BanTargetType.BAN_TARGET_TYPE_ROOM.value}',
      'active': 'true',
      'user_id': 'usr_2',
      'room_id': 'room_1',
    });
  });

  test('admin active stream service preserves total for paging', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'streams': [
            {
              'room_id': 'room_1',
              'media_id': 'med_1',
              'user_id': 'usr_1',
              'node_id': 'node_a',
              'started_at': '1700000000',
            }
          ],
          'total': 3,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListActiveStreamsPage(
        page: 2,
        pageSize: 20,
        roomId: 'room_1',
        userId: 'usr_1',
        nodeId: 'node_a',
        search: 'med_1',
        sortBy: admin_enum
            .ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_DESC,
      );

      expect(page.total, 3);
      expect(page.streams.single.mediaId, 'med_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/streams');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'page_size': '20',
      'room_id': 'room_1',
      'user_id': 'usr_1',
      'node_id': 'node_a',
      'search': 'med_1',
      'sort_by':
          '${admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT.value}',
      'sort_direction': '${admin_enum.SortDirection.SORT_DIRECTION_DESC.value}',
    });
  });

  test('public settings response stays typed instead of map-shaped', () async {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'allow_room_creation': true,
            'max_rooms_per_user': 8,
            'max_members_per_room': 64,
            'disable_create_room': false,
            'create_room_need_review': true,
            'room_password_policy': 'optional',
            'enable_password_signup': true,
            'password_signup_need_review': false,
            'enable_email_signup': true,
            'enable_email': true,
            'enable_guest': false,
            'email_signup_need_review': true,
            'enable_webauthn': true,
            'enable_webauthn_signup': true,
            'webauthn_signup_need_review': false,
            'movie_proxy': true,
            'live_proxy': false,
            'ts_disguised_as_png': true,
            'custom_publish_host': 'rtmp://publish.example.test/live',
            'email_whitelist_enabled': true,
            'email_whitelist_domains': ['example.com', 'corp.test'],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final settings = await api.publicService.getPublicSettings(
      client.GetPublicSettingsRequest(),
    );

    expect(settings.enableEmailSignup, isTrue);
    expect(settings.enableWebauthnSignup, isTrue);
    expect(settings.enableGuest, isFalse);
    expect(settings.maxRoomsPerUser.toInt(), 8);
    expect(settings.roomPasswordPolicy, 'optional');
    expect(settings.tsDisguisedAsPng, isTrue);
    expect(settings.customPublishHost, 'rtmp://publish.example.test/live');
    expect(settings.emailWhitelistEnabled, isTrue);
    expect(settings.enableEmail, isTrue);
    expect(settings.enableWebauthn, isTrue);
    expect(settings.emailWhitelistDomains, ['example.com', 'corp.test']);
  });

  test('public settings domain maps RTMP publishing options', () async {
    SharedPreferences.setMockInitialValues({});
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      expect(request.uri.path, '/api/public/settings');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'allow_room_creation': true,
          'max_rooms_per_user': 3,
          'max_members_per_room': 12,
          'disable_create_room': false,
          'create_room_need_review': false,
          'room_password_policy': 'optional',
          'enable_password_signup': true,
          'password_signup_need_review': false,
          'enable_email_signup': true,
          'enable_email': true,
          'enable_guest': true,
          'email_signup_need_review': false,
          'enable_webauthn': false,
          'enable_webauthn_signup': true,
          'webauthn_signup_need_review': true,
          'movie_proxy': false,
          'live_proxy': true,
          'ts_disguised_as_png': true,
          'custom_publish_host': 'rtmp://publish.example.test/app',
          'email_whitelist_enabled': false,
          'email_whitelist_domains': [],
        }));
      await request.response.close();
    });

    try {
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      final settings = await SyncTvService.getPublicSettings();
      expect(settings.liveProxy, isTrue);
      expect(settings.tsDisguisedAsPng, isTrue);
      expect(settings.customPublishHost, 'rtmp://publish.example.test/app');
      expect(settings.enableEmail, isTrue);
      expect(settings.enableWebauthn, isFalse);
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }
  });

  test('public server info endpoint maps protobuf response', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'server_id': 'srv_prod',
            'server_name': 'SyncTV Prod',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.publicService.getServerInfo(
      client.GetServerInfoRequest(),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/public/server-info');
    expect(response.serverId, 'srv_prod');
    expect(response.serverName, 'SyncTV Prod');
  });

  test('public server info is exposed through SyncTV service domain', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response.headers.contentType = io.ContentType.json;
      request.response.write(jsonEncode({
        'server_id': 'srv_local',
        'server_name': 'Local Dev',
      }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final info = await SyncTvService.getServerInfo(refresh: true);

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/public/server-info');
      expect(info.serverId, 'srv_local');
      expect(info.serverName, 'Local Dev');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('public room taxonomy endpoints map categories and labels', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/categories':
            return http.Response(
              jsonEncode({
                'categories': [
                  {
                    'id': 'roomcat_anime',
                    'key': 'anime',
                    'name': 'Anime',
                    'description': 'Animation rooms',
                    'sort_order': 10,
                    'is_enabled': true,
                  }
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/labels':
            return http.Response(
              jsonEncode({
                'labels': [
                  {
                    'id': 'roomlbl_weekly',
                    'key': 'weekly',
                    'name': 'Weekly',
                    'description': 'Weekly sessions',
                    'color': '#3366ff',
                    'category_id': 'roomcat_anime',
                    'sort_order': 20,
                    'is_enabled': true,
                  }
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response(
            'unexpected ${request.method} ${request.url}', 404);
      }),
    );
    final sessionStore = SyncTvSessionStore(api.session);
    final service = SyncTvPublicRoomDomainService(
      api: api,
      sessionStore: sessionStore,
      authService: SyncTvAuthDomainService(
        api: api,
        sessionStore: sessionStore,
      ),
    );

    final categories = await service.listRoomCategories(
      includeDisabled: true,
      refresh: true,
    );
    final labels = await service.listRoomLabels(
      categoryId: 'roomcat_anime',
      refresh: true,
    );

    expect(requests[0].url.path, '/api/rooms/categories');
    expect(requests[0].url.queryParameters, {'include_disabled': 'true'});
    expect(categories.single.id, 'roomcat_anime');
    expect(categories.single.sortOrder, 10);

    expect(requests[1].url.path, '/api/rooms/labels');
    expect(requests[1].url.queryParameters, {
      'include_disabled': 'false',
      'category_id': 'roomcat_anime',
    });
    expect(labels.single.id, 'roomlbl_weekly');
    expect(labels.single.color, '#3366ff');
  });

  test('room mapping preserves category and labels from protobuf response',
      () async {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_tax',
              'name': 'Taxonomy Room',
              'created_by': 'usr_owner',
              'status': 1,
              'category': {
                'id': 'roomcat_anime',
                'key': 'anime',
                'name': 'Anime',
                'sort_order': 10,
                'is_enabled': true,
              },
              'labels': [
                {
                  'id': 'roomlbl_weekly',
                  'key': 'weekly',
                  'name': 'Weekly',
                  'color': '#3366ff',
                  'category_id': 'roomcat_anime',
                  'sort_order': 20,
                  'is_enabled': true,
                }
              ],
            }
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.getRoom(
      client.GetRoomRequest(roomId: 'room_tax'),
    );
    final room = api.mapRoom(response.room);

    expect(room.category?.id, 'roomcat_anime');
    expect(room.category?.name, 'Anime');
    expect(room.labels.single.id, 'roomlbl_weekly');
    expect(room.labels.single.categoryId, 'roomcat_anime');
  });

  test('server profiles merge endpoints for one server id', () async {
    SharedPreferences.setMockInitialValues({});
    final session = SyncTvSession();
    final store = SyncTvSessionStore(session);

    await store.load();
    await store.addOrUpdateServer(
      serverId: 'srv_same',
      name: 'Main',
      endpoint: 'https://one.example.test',
    );
    await store.addOrUpdateServer(
      serverId: 'srv_same',
      name: 'Main',
      endpoint: 'https://two.example.test/',
    );

    expect(store.servers, hasLength(1));
    expect(store.activeServerId, 'srv_same');
    expect(store.activeServer!.endpoints, [
      'https://one.example.test',
      'https://two.example.test',
    ]);
    expect(store.baseUrl, 'https://two.example.test');
  });

  test('server sessions are isolated when switching servers', () async {
    SharedPreferences.setMockInitialValues({});
    final session = SyncTvSession();
    final store = SyncTvSessionStore(session);

    await store.load();
    await store.addOrUpdateServer(
      serverId: 'srv_a',
      name: 'A',
      endpoint: 'https://a.example.test',
    );
    session.accessToken = 'token-a';
    session.refreshToken = 'refresh-a';
    await store.persistTokens();

    await store.addOrUpdateServer(
      serverId: 'srv_b',
      name: 'B',
      endpoint: 'https://b.example.test',
    );
    expect(session.accessToken, isNull);
    session.accessToken = 'token-b';
    await store.persistTokens();

    await store.activateServer('srv_a');
    expect(store.baseUrl, 'https://a.example.test');
    expect(session.accessToken, 'token-a');
    expect(session.refreshToken, 'refresh-a');

    await store.activateServer('srv_b');
    expect(store.baseUrl, 'https://b.example.test');
    expect(session.accessToken, 'token-b');
    expect(session.refreshToken, isNull);
  });

  test('room invite links carry server identity and room id', () async {
    SharedPreferences.setMockInitialValues({});
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/public/server-info');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'server_id': 'srv_share',
          'server_name': 'Share',
        }));
      await request.response.close();
    });

    try {
      await SyncTvService.init();
      await SyncTvService.addServer(
        'http://${server.address.host}:${server.port}',
      );

      final link = RoomInviteService.createInviteLink(
        SyncTvRoom(roomId: 'room_123', roomName: 'Room', creatorId: 'usr_1'),
      );
      final parsed = RoomInviteService.parse(link);

      expect(Uri.parse(link).path, '/rooms/join');
      expect(parsed.roomId, 'room_123');
      expect(parsed.serverId, 'srv_share');
      expect(RoomInviteService.parse('room_plain').roomId, 'room_plain');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('create room sends current protobuf body and maps review response',
      () async {
    http.Request? capturedRequest;
    const roomCredential = 'not-real-room-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_pending',
              'name': 'Review Room',
              'created_by': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_UNSPECIFIED.value,
              'settings': {'require_password': true},
              'description': '',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final sessionStore = SyncTvSessionStore(api.session);
    final service = SyncTvPublicRoomDomainService(
      api: api,
      sessionStore: sessionStore,
      authService: SyncTvAuthDomainService(
        api: api,
        sessionStore: sessionStore,
      ),
    );

    final room = await service.createRoom(
      'Review Room',
      password: roomCredential,
      categoryId: 'roomcat_anime',
      labelIds: const ['roomlbl_weekly'],
    );

    expect(capturedRequest, isNotNull);
    expect(capturedRequest!.url.path, '/api/rooms');
    expect(jsonDecode(capturedRequest!.body), {
      'name': 'Review Room',
      'password': roomCredential,
      'category_id': 'roomcat_anime',
      'label_ids': ['roomlbl_weekly'],
    });
    expect(room.roomId, 'room_pending');
    expect(room.status, common.RoomStatus.ROOM_STATUS_UNSPECIFIED.value);
    expect(room.needPassword, isTrue);
  });

  test('hot rooms endpoint maps online and total member counts', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'rooms': [
            {
              'room': {
                'id': 'room_hot',
                'name': 'Hot Room',
                'created_by': 'usr_owner',
                'status': 1,
                'member_count': 2,
              },
              'online_count': 7,
              'total_members': 12,
            },
          ],
        }));
      await request.response.close();
    });

    late final List<SyncTvRoom> serviceRooms;
    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      serviceRooms = await SyncTvService.getHotRooms(limit: 8);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/hot');
    expect(requestedUri!.queryParameters, {'limit': '8'});
    expect(serviceRooms.single.roomId, 'room_hot');
    expect(serviceRooms.single.viewerCount, 7);
    expect(serviceRooms.single.memberCount, 12);
  });

  test('check room endpoint maps availability preflight details', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'exists': true,
            'requires_password': true,
            'name': 'Private Room',
            'availability': 1,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.publicService.checkRoom(
      client.CheckRoomRequest(roomId: 'room_private'),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_private/check');
    expect(response.exists, isTrue);
    expect(response.requiresPassword, isTrue);
    expect(response.name, 'Private Room');
    expect(
      response.availability,
      client.ResourceAvailability.RESOURCE_AVAILABILITY_AVAILABLE,
    );
  });

  test('SyncTV service preserves check room preflight details', () async {
    http.Request? capturedRequest;
    final server = await io.HttpServer.bind('127.0.0.1', 0);
    final listener = server.listen((request) async {
      capturedRequest = http.Request(request.method, request.uri);
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(jsonEncode({
          'exists': true,
          'requires_password': false,
          'name': 'Lobby',
          'availability': 2,
        }));
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final check = await SyncTvService.checkRoom('room_lobby');

      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.url.path, '/api/rooms/room_lobby/check');
      expect(check.exists, isTrue);
      expect(check.requiresPassword, isFalse);
      expect(check.name, 'Lobby');
      expect(
        check.availability,
        client
            .ResourceAvailability.RESOURCE_AVAILABILITY_CREATOR_INACTIVE.value,
      );
      expect(check.isAvailable, isFalse);
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }
  });

  test('email login confirmation uses dedicated protobuf contract', () async {
    http.Request? capturedRequest;
    const emailLoginToken = 'not-real-email-login-token';
    final session = SyncTvSession();
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'user': {
              'id': 'usr_1',
              'username': 'alice',
              'email': 'alice@example.test',
            },
            'access_token': 'access-token',
            'refresh_token': 'refresh-token',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.auth.confirmEmailLogin(
      client.ConfirmEmailLoginRequest(
        email: 'alice@example.test',
        emailToken: emailLoginToken,
      ),
    );

    expect(response.user.email, 'alice@example.test');
    expect(capturedRequest, isNotNull);
    expect(capturedRequest!.url.path, '/api/auth/email/confirm');
    expect(jsonDecode(capturedRequest!.body), {
      'email': 'alice@example.test',
      'email_token': emailLoginToken,
    });
    expect(session.accessToken, 'access-token');
    expect(session.refreshToken, 'refresh-token');
  });

  test('direct password and email registration use protobuf auth contracts',
      () async {
    final requests = <http.Request>[];
    final session = SyncTvSession();
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/auth/direct-password/register':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_register',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
                'access_token': 'register-access',
                'refresh_token': 'register-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/direct-password/login':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_login',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
                'access_token': 'login-access',
                'refresh_token': 'login-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/email/registration/request':
            return http.Response(
              jsonEncode({'message': 'sent'}),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/email/registration/confirm':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_email',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
                'access_token': 'email-access',
                'refresh_token': 'email-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );

    await api.auth.registerWithDirectPassword(
      client.RegisterWithDirectPasswordRequest(
        username: 'alice',
        email: 'alice@example.test',
        password: 'plain-password',
      ),
    );
    await api.auth.loginWithDirectPassword(
      client.LoginWithDirectPasswordRequest(
        email: 'alice@example.test',
        password: 'plain-password',
      ),
    );
    await api.auth.requestEmailRegistration(
      client.RequestEmailRegistrationRequest(
        username: 'alice',
        email: 'alice@example.test',
      ),
    );
    await api.auth.confirmEmailRegistration(
      client.ConfirmEmailRegistrationRequest(
        emailToken: 'email-register-token',
        password: 'plain-password',
      ),
    );

    expect(requests.map((request) => request.url.path), [
      '/api/auth/direct-password/register',
      '/api/auth/direct-password/login',
      '/api/auth/email/registration/request',
      '/api/auth/email/registration/confirm',
    ]);
    expect(jsonDecode(requests[0].body), {
      'username': 'alice',
      'email': 'alice@example.test',
      'password': 'plain-password',
    });
    expect(jsonDecode(requests[1].body), {
      'email': 'alice@example.test',
      'password': 'plain-password',
    });
    expect(jsonDecode(requests[2].body), {
      'username': 'alice',
      'email': 'alice@example.test',
    });
    expect(jsonDecode(requests[3].body), {
      'email_token': 'email-register-token',
      'password': 'plain-password',
    });
    expect(session.accessToken, 'email-access');
    expect(session.refreshToken, 'email-refresh');
  });

  test('admin taxonomy endpoints use current protobuf routes and bodies',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/admin/rooms/categories':
            if (request.method == 'GET') {
              return http.Response(
                jsonEncode({
                  'categories': [
                    {
                      'id': 'roomcat_anime',
                      'key': 'anime',
                      'name': 'Anime',
                      'sort_order': 10,
                      'is_enabled': true,
                    }
                  ],
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            return http.Response(
              jsonEncode({
                'category': {
                  'id': 'roomcat_anime',
                  'key': 'anime',
                  'name': 'Anime',
                  'description': 'Animation rooms',
                  'sort_order': 10,
                  'is_enabled': true,
                }
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/admin/rooms/categories/roomcat_anime':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/admin/rooms/labels':
            if (request.method == 'GET') {
              return http.Response(
                jsonEncode({
                  'labels': [
                    {
                      'id': 'roomlbl_weekly',
                      'key': 'weekly',
                      'name': 'Weekly',
                      'color': '#3366ff',
                      'category_id': 'roomcat_anime',
                      'sort_order': 20,
                      'is_enabled': true,
                    }
                  ],
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            return http.Response(
              jsonEncode({
                'label': {
                  'id': 'roomlbl_weekly',
                  'key': 'weekly',
                  'name': 'Weekly',
                  'description': 'Weekly sessions',
                  'color': '#3366ff',
                  'category_id': 'roomcat_anime',
                  'sort_order': 20,
                  'is_enabled': true,
                }
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/admin/rooms/labels/roomlbl_weekly':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/admin/rooms/room_tax/taxonomy':
            return http.Response(
              jsonEncode({
                'room': {
                  'id': 'room_tax',
                  'name': 'Taxonomy Room',
                  'created_by': 'usr_owner',
                  'status': 1,
                  'category': {
                    'id': 'roomcat_anime',
                    'key': 'anime',
                    'name': 'Anime',
                    'sort_order': 10,
                    'is_enabled': true,
                  },
                  'labels': [
                    {
                      'id': 'roomlbl_weekly',
                      'key': 'weekly',
                      'name': 'Weekly',
                      'color': '#3366ff',
                      'category_id': 'roomcat_anime',
                      'sort_order': 20,
                      'is_enabled': true,
                    }
                  ],
                }
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response(
            'unexpected ${request.method} ${request.url}', 404);
      }),
    );
    final service = SyncTvAdminDomainService(api);

    final categories = await service.listRoomCategories(
      includeDisabled: true,
      refresh: true,
    );
    final category = await service.upsertRoomCategory(
      key: 'anime',
      name: 'Anime',
      description: 'Animation rooms',
      sortOrder: 10,
      isEnabled: true,
    );
    await service.deleteRoomCategory('roomcat_anime');
    final labels = await service.listRoomLabels(
      includeDisabled: true,
      categoryId: 'roomcat_anime',
      refresh: true,
    );
    final label = await service.upsertRoomLabel(
      key: 'weekly',
      name: 'Weekly',
      description: 'Weekly sessions',
      color: '#3366ff',
      categoryId: 'roomcat_anime',
      sortOrder: 20,
      isEnabled: true,
    );
    await service.deleteRoomLabel('roomlbl_weekly');
    final room = await service.updateRoomTaxonomy(
      'room_tax',
      categoryId: 'roomcat_anime',
      labelIds: const ['roomlbl_weekly'],
    );

    expect(requests.map((request) => '${request.method} ${request.url.path}'), [
      'GET /api/admin/rooms/categories',
      'POST /api/admin/rooms/categories',
      'DELETE /api/admin/rooms/categories/roomcat_anime',
      'GET /api/admin/rooms/labels',
      'POST /api/admin/rooms/labels',
      'DELETE /api/admin/rooms/labels/roomlbl_weekly',
      'PATCH /api/admin/rooms/room_tax/taxonomy',
    ]);
    expect(requests[0].url.queryParameters, {'include_disabled': 'true'});
    expect(categories.single.id, 'roomcat_anime');
    expect(jsonDecode(requests[1].body), {
      'key': 'anime',
      'name': 'Anime',
      'description': 'Animation rooms',
      'sort_order': 10,
      'is_enabled': true,
    });
    expect(category.id, 'roomcat_anime');
    expect(requests[3].url.queryParameters, {
      'include_disabled': 'true',
      'category_id': 'roomcat_anime',
    });
    expect(labels.single.id, 'roomlbl_weekly');
    expect(jsonDecode(requests[4].body), {
      'key': 'weekly',
      'name': 'Weekly',
      'description': 'Weekly sessions',
      'color': '#3366ff',
      'category_id': 'roomcat_anime',
      'sort_order': 20,
      'is_enabled': true,
    });
    expect(label.id, 'roomlbl_weekly');
    expect(jsonDecode(requests[6].body), {
      'room_id': 'room_tax',
      'category_id': 'roomcat_anime',
      'label_ids': ['roomlbl_weekly'],
      'clear_category': false,
    });
    expect(room.category?.id, 'roomcat_anime');
    expect(room.labels.single.id, 'roomlbl_weekly');
  });

  test('direct password domain selects one populated login identifier',
      () async {
    final requests = <http.Request>[];
    final session = SyncTvSession();
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'user': {
              'id': 'usr_1',
              'username': 'alice',
              'email': 'alice@example.test',
            },
            'access_token': 'access',
            'refresh_token': 'refresh',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvAuthDomainService(
      api: api,
      sessionStore: SyncTvSessionStore(session),
    );

    await service.loginWithDirectPassword(
      username: 'alice',
      email: '',
      password: 'plain-password',
    );
    await service.loginWithDirectPassword(
      username: 'alice',
      email: 'alice@example.test',
      password: 'plain-password',
    );

    expect(requests.map((request) => jsonDecode(request.body)), [
      {
        'username': 'alice',
        'password': 'plain-password',
      },
      {
        'email': 'alice@example.test',
        'password': 'plain-password',
      },
    ]);
    expect(session.accessToken, 'access');
    expect(session.refreshToken, 'refresh');
  });

  test('passkey endpoints translate WebAuthn JSON through protobuf bytes',
      () async {
    final requests = <http.Request>[];
    final session = SyncTvSession()..accessToken = 'access';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/auth/passkeys/login/start':
            return http.Response(
              jsonEncode({
                'session_id': 'login_passkey_session',
                'options': {
                  'challenge': 'login-challenge',
                  'rpId': 'example.test',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/passkeys/login/finish':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_1',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
                'access_token': 'new-access',
                'refresh_token': 'new-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/mfa/passkeys/start':
            return http.Response(
              jsonEncode({
                'passkey_session_id': 'mfa_passkey_session',
                'options': {
                  'challenge': 'mfa-challenge',
                  'allowCredentials': [
                    {'id': 'cred-1', 'type': 'public-key'}
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/mfa/passkeys/finish':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_1',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
                'access_token': 'mfa-access',
                'refresh_token': 'mfa-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/user/passkeys/bind/start':
            return http.Response(
              jsonEncode({
                'session_id': 'bind_session',
                'options': {
                  'challenge': 'bind-challenge',
                  'user': {'id': 'usr_1', 'name': 'alice'},
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/user/passkeys/bind/finish':
            return http.Response(
              jsonEncode({
                'credential': {
                  'credential_id': 'cred_1',
                  'name': 'MacBook Touch ID',
                  'sign_count': '1',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );

    final loginStart = await api.auth.startPasskeyLogin(
      client.StartPasskeyLoginRequest(username: 'alice'),
    );
    await api.auth.finishPasskeyLogin(
      client.FinishPasskeyLoginRequest(
        sessionId: loginStart.sessionId,
        credential: utf8.encode(jsonEncode({
          'id': 'cred-login',
          'type': 'public-key',
          'response': {'authenticatorData': 'auth-data'},
        })),
      ),
    );
    final mfaStart = await api.auth.startMfaPasskey(
      client.StartMfaPasskeyRequest(mfaSessionId: 'mfa_session'),
    );
    await api.auth.finishMfaPasskey(
      client.FinishMfaPasskeyRequest(
        mfaSessionId: 'mfa_session',
        passkeySessionId: mfaStart.passkeySessionId,
        credential: utf8.encode(jsonEncode({
          'id': 'cred-mfa',
          'type': 'public-key',
        })),
      ),
    );
    final bindStart = await api.user.startPasskeyBind(
      client.StartPasskeyBindRequest(name: 'MacBook Touch ID'),
    );
    await api.user.finishPasskeyBind(
      client.FinishPasskeyBindRequest(
        sessionId: bindStart.sessionId,
        credential: utf8.encode(jsonEncode({
          'id': 'cred-bind',
          'type': 'public-key',
        })),
      ),
    );

    expect(jsonDecode(utf8.decode(loginStart.options)), {
      'challenge': 'login-challenge',
      'rpId': 'example.test',
    });
    expect(jsonDecode(utf8.decode(mfaStart.options)), {
      'challenge': 'mfa-challenge',
      'allowCredentials': [
        {'id': 'cred-1', 'type': 'public-key'}
      ],
    });
    expect(jsonDecode(utf8.decode(bindStart.options)), {
      'challenge': 'bind-challenge',
      'user': {'id': 'usr_1', 'name': 'alice'},
    });
    expect(session.accessToken, 'mfa-access');
    expect(session.refreshToken, 'mfa-refresh');

    final bodies = requests
        .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
        .toList();
    expect(bodies[0], {'username': 'alice'});
    expect(bodies[1], {
      'session_id': 'login_passkey_session',
      'credential': {
        'id': 'cred-login',
        'type': 'public-key',
        'response': {'authenticatorData': 'auth-data'},
      },
    });
    expect(bodies[2], {'mfa_session_id': 'mfa_session'});
    expect(bodies[3], {
      'mfa_session_id': 'mfa_session',
      'passkey_session_id': 'mfa_passkey_session',
      'credential': {
        'id': 'cred-mfa',
        'type': 'public-key',
      },
    });
    expect(bodies[4], {'name': 'MacBook Touch ID'});
    expect(bodies[5], {
      'session_id': 'bind_session',
      'credential': {
        'id': 'cred-bind',
        'type': 'public-key',
      },
    });
  });

  test('sensitive operation verification endpoints use protobuf payloads',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'access',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/user/sensitive-verification/start':
            return http.Response(
              jsonEncode({
                'verification_id': 'verification_1',
                'challenge': {
                  'session_id': 'sensitive_session',
                  'required_methods': [
                    'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN'
                  ],
                  'completed_methods': [],
                  'available_methods': [
                    'SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD',
                    'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN',
                    'SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL'
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/user/sensitive-verification/passkey/start':
            return http.Response(
              jsonEncode({
                'passkey_session_id': 'passkey_session',
                'options': {'challenge': 'sensitive-passkey'},
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/user/sensitive-verification/email/request':
            return http.Response(
              jsonEncode({
                'message': 'sent',
                'masked_email': 'a***@example.test',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/user/sensitive-verification/finish':
            return http.Response(
              jsonEncode({
                'verification_id': 'verification_1',
                'challenge': {
                  'session_id': 'sensitive_session',
                  'required_methods': [
                    'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN'
                  ],
                  'completed_methods': [
                    'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN'
                  ],
                  'available_methods': [
                    'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN'
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );
    final service = SyncTvAuthDomainService(
      api: api,
      sessionStore: SyncTvSessionStore(api.session),
    );

    final start = await service.startSensitiveOperationVerification();
    final passkey = await service.startSensitiveOperationPasskey(
      start.challenge.sessionId,
    );
    final emailCode = await service.requestSensitiveOperationEmailCode(
      start.challenge.sessionId,
    );
    final finish = await service.finishSensitiveOperationVerification(
      sessionId: start.challenge.sessionId,
      method: client.SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN,
      passkeySessionId: passkey.passkeySessionId,
      passkeyCredential: {
        'id': 'cred-sensitive',
        'type': 'public-key',
      },
    );

    expect(start.verificationId, 'verification_1');
    expect(start.challenge.requiresPasskey, isTrue);
    expect(jsonDecode(utf8.decode(passkey.options)), {
      'challenge': 'sensitive-passkey',
    });
    expect(emailCode.maskedEmail, 'a***@example.test');
    expect(finish.challenge.completedMethods, [
      client.SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN.value,
    ]);

    expect(requests.map((request) => request.url.path), [
      '/api/user/sensitive-verification/start',
      '/api/user/sensitive-verification/passkey/start',
      '/api/user/sensitive-verification/email/request',
      '/api/user/sensitive-verification/finish',
    ]);
    expect(jsonDecode(requests[0].body), <String, dynamic>{});
    expect(jsonDecode(requests[1].body), {
      'session_id': 'sensitive_session',
    });
    expect(jsonDecode(requests[2].body), {
      'session_id': 'sensitive_session',
    });
    expect(jsonDecode(requests[3].body), {
      'session_id': 'sensitive_session',
      'method': client.SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN.value,
      'password': '',
      'email_token': '',
      'passkey_session_id': 'passkey_session',
      'passkey_credential': {
        'id': 'cred-sensitive',
        'type': 'public-key',
      },
    });
  });

  test('opaque auth endpoints send protocol bytes without plaintext password',
      () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/auth/opaque/registration/start':
            return http.Response(
              jsonEncode({
                'session_id': 'reg_session',
                'registration_response': base64Encode([9, 8, 7]),
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/opaque/registration/finish':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_1',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
                'access_token': 'access',
                'refresh_token': 'refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/opaque/login/start':
            return http.Response(
              jsonEncode({
                'session_id': 'login_session',
                'credential_response': base64Encode([6, 5, 4]),
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/auth/opaque/login/finish':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_1',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
                'access_token': 'access',
                'refresh_token': 'refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );

    await api.auth.startOpaqueRegistration(
      client.StartOpaqueRegistrationRequest(
        username: 'alice',
        email: 'alice@example.test',
        registrationRequest: [1, 2, 3],
      ),
    );
    await api.auth.finishOpaqueRegistration(
      client.FinishOpaqueRegistrationRequest(
        sessionId: 'reg_session',
        registrationUpload: [4, 5, 6],
      ),
    );
    await api.auth.startOpaqueLogin(
      client.StartOpaqueLoginRequest(
        username: 'alice',
        credentialRequest: [7, 8, 9],
      ),
    );
    await api.auth.finishOpaqueLogin(
      client.FinishOpaqueLoginRequest(
        sessionId: 'login_session',
        credentialFinalization: [10, 11, 12],
      ),
    );

    expect(requests.map((request) => request.url.path), [
      '/api/auth/opaque/registration/start',
      '/api/auth/opaque/registration/finish',
      '/api/auth/opaque/login/start',
      '/api/auth/opaque/login/finish',
    ]);

    final bodies = requests
        .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
        .toList();
    expect(bodies[0], {
      'username': 'alice',
      'email': 'alice@example.test',
      'registration_request': base64Encode([1, 2, 3]),
    });
    expect(bodies[1], {
      'session_id': 'reg_session',
      'registration_upload': base64Encode([4, 5, 6]),
    });
    expect(bodies[2], {
      'username': 'alice',
      'credential_request': base64Encode([7, 8, 9]),
    });
    expect(bodies[3], {
      'session_id': 'login_session',
      'credential_finalization': base64Encode([10, 11, 12]),
    });
    for (final body in bodies) {
      expect(body.containsKey('password'), isFalse);
      expect(body.values, isNot(contains('plain-password')));
    }
  });

  test('opaque registration domain omits blank email identifier', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'session_id': 'reg_session',
            'registration_response': base64Encode([9, 8, 7]),
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final sessionStore = SyncTvSessionStore(api.session);
    final service = SyncTvAuthDomainService(
      api: api,
      sessionStore: sessionStore,
    );

    await service.startOpaqueRegistration(
      username: 'alice',
      email: '',
      registrationRequest: [1, 2, 3],
    );

    expect(requests, hasLength(1));
    expect(requests.single.url.path, '/api/auth/opaque/registration/start');
    expect(jsonDecode(requests.single.body), {
      'username': 'alice',
      'registration_request': base64Encode([1, 2, 3]),
    });
  });

  test('opaque password management sends protocol bytes without plaintext',
      () async {
    final requests = <http.Request>[];
    const emailResetToken = 'not-real-email-reset-token';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..accessToken = 'access',
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/user/opaque-password/update/start':
            return http.Response(
              jsonEncode({
                'session_id': 'update_session',
                'credential_response': base64Encode([9, 8, 7]),
                'registration_response': base64Encode([6, 5, 4]),
                'passkey_session_id': 'passkey_session',
                'passkey_options': {'challenge': 'opaque-update-passkey'},
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/user/opaque-password/update/finish':
            return http.Response(
              jsonEncode({
                'user': {
                  'id': 'usr_1',
                  'username': 'alice',
                  'email': 'alice@example.test',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/email/password/reset':
            return http.Response(
              jsonEncode({'message': 'sent'}),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/email/password/opaque/start':
            return http.Response(
              jsonEncode({
                'session_id': 'reset_session',
                'registration_response': base64Encode([11, 12, 13]),
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/email/password/opaque/finish':
            return http.Response(
              jsonEncode({'message': 'reset', 'user_id': 'usr_1'}),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );

    await api.user.startOpaquePasswordUpdate(
      client.StartOpaquePasswordUpdateRequest(
        credentialRequest: [1, 2, 3],
        registrationRequest: [4, 5, 6],
        verificationMethod: client_enum.OpaquePasswordUpdateVerificationMethod
            .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD,
        emailToken: '',
      ),
    );
    await api.user.finishOpaquePasswordUpdate(
      client.FinishOpaquePasswordUpdateRequest(
        sessionId: 'update_session',
        credentialFinalization: [7, 8, 9],
        registrationUpload: [10, 11, 12],
        passkeySessionId: '',
      ),
    );
    await api.emailService.requestPasswordReset(
      client.RequestPasswordResetRequest(email: 'alice@example.test'),
    );
    await api.emailService.startOpaquePasswordReset(
      client.StartOpaquePasswordResetRequest(
        email: 'alice@example.test',
        token: emailResetToken,
        registrationRequest: [13, 14, 15],
      ),
    );
    await api.emailService.finishOpaquePasswordReset(
      client.FinishOpaquePasswordResetRequest(
        sessionId: 'reset_session',
        registrationUpload: [16, 17, 18],
      ),
    );

    expect(requests.map((request) => request.url.path), [
      '/api/user/opaque-password/update/start',
      '/api/user/opaque-password/update/finish',
      '/api/email/password/reset',
      '/api/email/password/opaque/start',
      '/api/email/password/opaque/finish',
    ]);

    final bodies = requests
        .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
        .toList();
    expect(bodies[0], {
      'credential_request': base64Encode([1, 2, 3]),
      'registration_request': base64Encode([4, 5, 6]),
      'verification_method': client_enum
          .OpaquePasswordUpdateVerificationMethod
          .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD
          .value,
      'email_token': '',
    });
    expect(bodies[1], {
      'session_id': 'update_session',
      'credential_finalization': base64Encode([7, 8, 9]),
      'registration_upload': base64Encode([10, 11, 12]),
      'passkey_session_id': '',
    });
    expect(bodies[1].containsKey('passkey_credential'), isFalse);
    expect(bodies[2], {'email': 'alice@example.test'});
    expect(bodies[3], {
      'email': 'alice@example.test',
      'token': emailResetToken,
      'registration_request': base64Encode([13, 14, 15]),
    });
    expect(bodies[4], {
      'session_id': 'reset_session',
      'registration_upload': base64Encode([16, 17, 18]),
    });
    for (final body in bodies) {
      expect(body.containsKey('password'), isFalse);
      expect(body.values, isNot(contains('not-real-provider-credential')));
    }
  });
}

String _expectedOwnershipProof(
  List<int> bytes, {
  required String nonce,
  required String contentManifestSha256,
  required List<({int offset, int length})> ranges,
}) {
  final proofBytes = BytesBuilder();
  proofBytes.add(utf8.encode('synctv-file-ownership-proof-v1'));
  proofBytes.add([0]);
  proofBytes.add(utf8.encode(nonce));
  proofBytes.add([0]);
  proofBytes.add(utf8.encode(contentManifestSha256.trim().toLowerCase()));
  proofBytes.add((ByteData(8)..setInt64(0, bytes.length, Endian.big))
      .buffer
      .asUint8List());
  proofBytes.add((ByteData(8)..setUint64(0, ranges.length, Endian.big))
      .buffer
      .asUint8List());
  for (final range in ranges) {
    proofBytes.add((ByteData(8)..setInt64(0, range.offset, Endian.big))
        .buffer
        .asUint8List());
    proofBytes.add((ByteData(4)..setInt32(0, range.length, Endian.big))
        .buffer
        .asUint8List());
    proofBytes.add(Uint8List.sublistView(
      Uint8List.fromList(bytes),
      range.offset,
      range.offset + range.length,
    ));
  }
  return sha256.convert(proofBytes.toBytes()).toString();
}

String _expectedContentManifestSha256(
  int sizeBytes,
  int partSizeBytes,
  List<({int partNumber, int sizeBytes, String checksum})> parts,
) {
  final sorted = [...parts]
    ..sort((a, b) => a.partNumber.compareTo(b.partNumber));
  final bytes = BytesBuilder();
  bytes.add(utf8.encode('synctv-file-part-manifest-sha256-v1'));
  bytes.add([0]);
  bytes.add(
      (ByteData(8)..setInt64(0, sizeBytes, Endian.big)).buffer.asUint8List());
  bytes.add((ByteData(8)..setInt64(0, partSizeBytes, Endian.big))
      .buffer
      .asUint8List());
  bytes.add((ByteData(8)..setUint64(0, sorted.length, Endian.big))
      .buffer
      .asUint8List());
  for (final part in sorted) {
    bytes.add((ByteData(4)..setInt32(0, part.partNumber, Endian.big))
        .buffer
        .asUint8List());
    bytes.add((ByteData(8)..setInt64(0, part.sizeBytes, Endian.big))
        .buffer
        .asUint8List());
    bytes.add(utf8.encode(part.checksum.trim().toLowerCase()));
  }
  return sha256.convert(bytes.toBytes()).toString();
}

class _FakeOpaqueClient extends opaque.SyncTvOpaqueClient {
  @override
  opaque.OpaqueRegistrationStart startRegistration(String password) {
    expect(password, 'plain-room-password');
    return opaque.OpaqueRegistrationStart(
      registrationRequest: Uint8List.fromList([1, 2, 3]),
      state: Uint8List.fromList([20, 21, 22]),
    );
  }

  @override
  opaque.OpaqueRegistrationFinish finishRegistration({
    required String password,
    required Uint8List state,
    required Uint8List registrationResponse,
  }) {
    expect(password, 'plain-room-password');
    expect(state, [20, 21, 22]);
    expect(registrationResponse, [9, 8, 7]);
    return opaque.OpaqueRegistrationFinish(
      registrationUpload: Uint8List.fromList([4, 5, 6]),
    );
  }

  @override
  opaque.OpaqueLoginStart startLogin(String password) {
    expect(password, 'plain-room-password');
    return opaque.OpaqueLoginStart(
      credentialRequest: Uint8List.fromList([40, 41, 42]),
      state: Uint8List.fromList([60, 61, 62]),
    );
  }

  @override
  opaque.OpaqueLoginFinish finishLogin({
    required String password,
    required Uint8List state,
    required Uint8List credentialResponse,
  }) {
    expect(password, 'plain-room-password');
    expect(state, [60, 61, 62]);
    expect(credentialResponse, [30, 31, 32]);
    return opaque.OpaqueLoginFinish(
      credentialFinalization: Uint8List.fromList([50, 51, 52]),
      sessionKey: Uint8List.fromList([70, 71, 72]),
    );
  }
}
