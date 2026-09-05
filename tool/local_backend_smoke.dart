// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/data/room_realtime_connection.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import 'local_backend_test_auth.dart';
import 'local_backend_media_helpers.dart';

void main() {
  test('local_backend_smoke', () async {
    const baseUrl = String.fromEnvironment('SYNCTV_SMOKE_BASE_URL');
    if (baseUrl.isEmpty) {
      throw StateError('SYNCTV_SMOKE_BASE_URL is required');
    }
    await runSmoke(baseUrl);
  }, timeout: const Timeout(Duration(minutes: 2)));
}

Future<void> runSmoke(String baseUrl) async {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  final username = 'smoke_$stamp';
  final password = 'SmokePass_$stamp!';
  final roomName = 'Smoke Room $stamp';
  const rootPassword = String.fromEnvironment('SYNCTV_SMOKE_ROOT_PASSWORD');

  SharedPreferences.setMockInitialValues({});
  await SyncTvService.init();
  await SyncTvService.setBaseUrl(baseUrl);

  final serverInfo = await SyncTvService.getServerInfo(refresh: true);
  final publicSettings = await SyncTvService.getPublicSettings(refresh: true);
  print('server=${serverInfo.serverName} guest=${publicSettings.enableGuest}');

  await _ensureSmokeUser(
    username: username,
    password: password,
    publicSettings: publicSettings,
    rootPassword: rootPassword,
  );

  final me = await SyncTvService.getMe(refresh: true);
  if (me.username != username) {
    throw StateError('profile username mismatch: ${me.username}');
  }

  final room = await SyncTvService.createRoom(
    roomName,
    description: 'local smoke room',
  );
  print('room=${room.roomId}');

  final roomInfo = await SyncTvService.getRoomInfo(room.roomId);
  final members = await SyncTvService.getRoomMembers(room.roomId);
  print('room_info=${roomInfo.roomName} members=${members.length}');

  final playlist = await SyncTvService.createPlaylist(
    room.roomId,
    name: 'Smoke Playlist',
    description: 'created by smoke test',
  );
  print('playlist=${playlist.id}');

  final mediaId = await prepareDirectUrlAndAdd(
    room.roomId,
    playlistId: playlist.id,
    url: 'https://example.com/smoke.mp4',
    playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
    name: 'Smoke Direct URL',
  );
  final mediaPage = await SyncTvService.listMediaLibrary(
    room.roomId,
    playlistId: playlist.id,
    refresh: true,
  );
  print('media=$mediaId page_total=${mediaPage.total}');

  await SyncTvService.switchMedia(room.roomId, mediaId);
  await SyncTvService.updatePlaybackState(
    room.roomId,
    action: PlaybackControlAction.pause,
    isPlaying: false,
    position: 2,
    speed: 1,
  );

  final realtime = await _verifyRealtime(room.roomId);
  try {
    final message = await SyncTvService.sendChatMessage(
      room.roomId,
      content: 'hello from smoke $stamp',
      displayPosition: 'scroll',
      displayColor: '#00AAFF',
    );
    await realtime.expectChat(message.id);
    await SyncTvService.setChatReaction(
      room.roomId,
      message.id,
      'thumbs_up',
      enabled: true,
    );
    final history = await SyncTvService.getChatHistory(room.roomId);
    final nearby = await SyncTvService.getChatPlaybackMessages(
      room.roomId,
      playbackMediaId: mediaId,
      positionSeconds: 2,
    );
    print(
      'chat=${message.id} history=${history.messages.length} nearby=${nearby.length}',
    );
  } finally {
    await realtime.close();
  }

  final rtmpMediaId = await prepareRtmpAndAdd(room.roomId, name: 'Smoke RTMP');
  final publish = await SyncTvService.createRtmpPublishKeyInfo(
    room.roomId,
    rtmpMediaId,
    keyType: client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
    expiresAt: DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 + 3600,
  );
  final streamInfo = await SyncTvService.getRtmpStreamInfo(
    roomId: room.roomId,
    mediaId: rtmpMediaId,
  );
  print(
    'rtmp=$rtmpMediaId key=${publish.streamKey.isNotEmpty} active=${streamInfo.active}',
  );

  final providers = await Future.wait([
    SyncTvService.getAllAlistBindInfos(),
    SyncTvService.getAllEmbyBindInfos(),
    SyncTvService.getAllBilibiliBindInfos(),
  ]);
  print('provider_binds=${providers.map((items) => items.length).join(',')}');

  await SyncTvService.logout();
  await loginLocalRoot(rootPassword);
  final stats = await SyncTvService.adminGetServiceState();
  final users = await SyncTvService.adminListUsersPage(pageSize: 5);
  final rooms = await SyncTvService.adminListRoomsPage(pageSize: 5);
  final streams = await SyncTvService.adminListActiveStreamsPage();
  final settings = await SyncTvService.runtimeGetSettings(refresh: true);
  final providerInstances =
      await SyncTvService.adminListProviderInstancesPage();
  print(
    jsonEncode({
      'stats_users': stats.totalUsers,
      'users_page': users.total,
      'rooms_page': rooms.total,
      'active_streams': streams.total,
      'settings_sections': settings.sections.length,
      'provider_instances': providerInstances.total,
    }),
  );

  await SyncTvService.adminBanRoom(
    room.roomId,
    true,
    reason: 'smoke verify ban',
  );
  await SyncTvService.adminBanRoom(room.roomId, false);
  await SyncTvService.adminBanUser(me.id, true, reason: 'smoke verify ban');
  await SyncTvService.adminBanUser(me.id, false);
  final bans = await SyncTvService.adminListBanRecordsPage(
    pageSize: 10,
    active: false,
  );
  print('ban_records=${bans.total}');

  print('OK');
}

Future<_RealtimeSmokeProbe> _verifyRealtime(String roomId) async {
  final probe = _RealtimeSmokeProbe.connect(roomId);
  await probe.expectObserved({
    'playback_state',
    'playback',
    'room_settings',
    'playlist_items',
    'self_room_member',
    'online_count',
    'chat_events',
  });
  await probe.expectPlaybackPosition(2);
  await SyncTvService.updatePlaybackState(
    roomId,
    action: PlaybackControlAction.pause,
    isPlaying: false,
    position: 3,
    speed: 1,
  );
  await probe.expectPlaybackPosition(3);
  print('realtime=observed playback');
  return probe;
}

class _RealtimeSmokeProbe {
  _RealtimeSmokeProbe._(
    this._connection,
    this._subscription,
    this._messages,
    this._errors,
  );

  final RoomRealtimeConnection _connection;
  final StreamSubscription<Uint8List> _subscription;
  final List<RoomRealtimeMessage> _messages;
  final List<Object> _errors;

  static _RealtimeSmokeProbe connect(String roomId) {
    final connection = RoomRealtimeConnection.connect(
      roomId,
      createWebSocketUri: SyncTvService.createRoomWebSocketUri,
      encodeMessage: SyncTvService.encodeRealtimeMessageJson,
      decodeMessage: SyncTvService.decodeRealtimeMessageJson,
      nowMillis: SyncedClock.nowMillis,
      initialMessages: [
        ...RoomRealtimeCodec.encodeInitialObservations(),
        RoomRealtimeCodec.encodePlaylistObservation(),
        RoomRealtimeCodec.encodeChatEventsObservation(),
      ],
    );
    final messages = <RoomRealtimeMessage>[];
    final errors = <Object>[];
    final subscription = connection.stream.listen((bytes) {
      try {
        messages.add(RoomRealtimeCodec.decode(bytes));
      } catch (error) {
        errors.add(error);
      }
    }, onError: errors.add);
    return _RealtimeSmokeProbe._(connection, subscription, messages, errors);
  }

  Future<void> expectObserved(Set<String> observeIds) async {
    await _waitFor(() {
      final observed = _messages
          .where(
            (message) =>
                message.kind == RoomRealtimeMessageKind.checkStatus &&
                message.resourceObserveId.isNotEmpty,
          )
          .map((message) => message.resourceObserveId)
          .toSet();
      return observed.containsAll(observeIds);
    }, 'realtime observed ${observeIds.join(', ')}');
  }

  Future<void> expectPlaybackPosition(double position) async {
    await _waitFor(
      () => _messages.any(
        (message) =>
            message.kind == RoomRealtimeMessageKind.status &&
            ((message.status?.currentTime == position) ||
                (message.playbackStatus?.currentTime == position)),
      ),
      'realtime playback position $position',
    );
  }

  Future<void> expectChat(String messageId) async {
    await _waitFor(
      () => _messages.any(
        (message) =>
            message.kind == RoomRealtimeMessageKind.chat &&
            message.chatId == messageId &&
            message.chatEventKind == RoomRealtimeChatEventKind.created,
      ),
      'realtime chat message $messageId',
    );
  }

  Future<void> close() async {
    await _subscription.cancel();
    await _connection.close();
  }

  Future<void> _waitFor(
    bool Function() predicate,
    String label, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (_errors.isNotEmpty) {
        throw StateError('$label failed with realtime error: ${_errors.first}');
      }
      if (predicate()) return;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    final seen = _messages
        .map((message) => '${message.kind}:${message.resourceObserveId}')
        .join(', ');
    throw StateError('Timed out waiting for $label. Seen: $seen');
  }
}

Future<void> _ensureSmokeUser({
  required String username,
  required String password,
  required PublicSettingsInfo publicSettings,
  required String rootPassword,
}) async {
  if (publicSettings.enablePasswordSignup &&
      !publicSettings.passwordSignupNeedReview) {
    final auth = await SyncTvService.registerWithDirectPassword(
      username: username,
      password: password,
    );
    switch (auth) {
      case Authenticated(:final user):
        print('registered user=${user.id}');
      case MfaRequired():
        throw StateError('registration unexpectedly requires MFA');
      case RegistrationReviewPending(:final reviewId):
        print('registration review pending=$reviewId');
    }
    return;
  }

  if (rootPassword.trim().isEmpty) {
    throw StateError(
      'Password signup is unavailable. Set SYNCTV_SMOKE_ROOT_PASSWORD to let '
      'the smoke test create its user through the admin API.',
    );
  }
  await loginLocalRoot(rootPassword);
  await SyncTvService.adminAddUser(
    username,
    password,
    common_enum.UserRole.USER_ROLE_USER,
  );
  await SyncTvService.logout();
  await loginLocalPasswordUser(username, password);
  print('created user through admin');
}
