import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/watch_together_service.dart';

void main() {
  test('local_backend_smoke', () async {
    await runSmoke(
      const String.fromEnvironment(
        'SYNCTV_SMOKE_BASE_URL',
        defaultValue: 'http://127.0.0.1:8080',
      ),
    );
  }, timeout: const Timeout(Duration(minutes: 2)));
}

Future<void> runSmoke(String baseUrl) async {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  final username = 'smoke_$stamp';
  final password = 'SmokePass_$stamp!';
  final roomName = 'Smoke Room $stamp';

  SharedPreferences.setMockInitialValues({});
  await WatchTogetherService.init();
  await WatchTogetherService.setBaseUrl(baseUrl);

  final serverInfo = await WatchTogetherService.getServerInfo(refresh: true);
  final publicSettings =
      await WatchTogetherService.getPublicSettings(refresh: true);
  print('server=${serverInfo.serverName} guest=${publicSettings.enableGuest}');

  final auth = await WatchTogetherService.registerWithDirectPassword(
    username: username,
    password: password,
  );
  print('registered user=${auth.user?.id}');

  final me = await WatchTogetherService.getMe(refresh: true);
  if (me.username != username) {
    throw StateError('profile username mismatch: ${me.username}');
  }

  final room = await WatchTogetherService.createRoom(
    roomName,
    description: 'local smoke room',
  );
  print('room=${room.roomId}');

  final roomInfo = await WatchTogetherService.getRoomInfo(room.roomId);
  final members = await WatchTogetherService.getRoomMembers(room.roomId);
  print('room_info=${roomInfo.roomName} members=${members.length}');

  final playlist = await WatchTogetherService.createPlaylist(
    room.roomId,
    name: 'Smoke Playlist',
    description: 'created by smoke test',
  );
  print('playlist=${playlist.id}');

  final mediaId = await WatchTogetherService.addDirectUrlMedia(
    room.roomId,
    playlistId: playlist.id,
    url: 'https://example.com/smoke.mp4',
    name: 'Smoke Direct URL',
  );
  final mediaPage = await WatchTogetherService.listMediaLibrary(
    room.roomId,
    playlistId: playlist.id,
    refresh: true,
  );
  print('media=$mediaId page_total=${mediaPage.total}');

  await WatchTogetherService.switchMovieAndPlay(room.roomId, mediaId);
  final playback = await WatchTogetherService.getCurrentMovie(room.roomId);
  if (playback.movie?.id != mediaId) {
    throw StateError('playback media mismatch: ${playback.movie?.id}');
  }
  await WatchTogetherService.updatePlayback(
    room.roomId,
    action: PlaybackControlAction.pause,
    isPlaying: false,
    position: 2,
    speed: 1,
  );

  final message = await WatchTogetherService.sendChatMessage(
    room.roomId,
    content: 'hello from smoke $stamp',
    displayPosition: 'scroll',
    displayColor: '#00AAFF',
  );
  await WatchTogetherService.setChatReaction(
    room.roomId,
    message.id,
    'thumbs_up',
    enabled: true,
  );
  final history = await WatchTogetherService.getChatHistory(room.roomId);
  final nearby = await WatchTogetherService.getChatPlaybackMessages(
    room.roomId,
    playbackMediaId: mediaId,
    positionSeconds: 2,
  );
  print('chat=${message.id} history=${history.messages.length} nearby=${nearby.length}');

  final rtmpMediaId = await WatchTogetherService.addRtmpMedia(
    room.roomId,
    name: 'Smoke RTMP',
  );
  final publish = await WatchTogetherService.createRtmpPublishKeyInfo(
    room.roomId,
    rtmpMediaId,
  );
  final streamInfo = await WatchTogetherService.getRtmpStreamInfo(
    roomId: room.roomId,
    mediaId: rtmpMediaId,
  );
  print('rtmp=$rtmpMediaId key=${publish.streamKey.isNotEmpty} active=${streamInfo.active}');

  final providers = await Future.wait([
    WatchTogetherService.getAllAlistBindInfos(),
    WatchTogetherService.getAllEmbyBindInfos(),
    WatchTogetherService.getAllBilibiliBindInfos(),
  ]);
  print('provider_binds=${providers.map((items) => items.length).join(',')}');

  await WatchTogetherService.logout();
  await WatchTogetherService.loginWithDirectPassword(
    username: 'root',
    password: 'LocalDevRootPass2026!',
  );
  final stats = await WatchTogetherService.adminGetSystemStats();
  final users = await WatchTogetherService.adminListUsersPage(pageSize: 5);
  final rooms = await WatchTogetherService.adminListRoomsPage(pageSize: 5);
  final streams = await WatchTogetherService.adminListActiveStreamsPage();
  final settings = await WatchTogetherService.adminGetAllSettings(refresh: true);
  final providerInstances =
      await WatchTogetherService.adminListProviderInstancesPage();
  print(
    jsonEncode({
      'stats_users': stats.totalUsers,
      'users_page': users.total,
      'rooms_page': rooms.total,
      'active_streams': streams.total,
      'settings_groups': settings.length,
      'provider_instances': providerInstances.total,
    }),
  );

  await WatchTogetherService.adminBanRoom(
    room.roomId,
    true,
    reason: 'smoke verify ban',
  );
  await WatchTogetherService.adminBanRoom(room.roomId, false);
  await WatchTogetherService.adminBanUser(
    me.id,
    true,
    reason: 'smoke verify ban',
  );
  await WatchTogetherService.adminBanUser(me.id, false);
  final bans = await WatchTogetherService.adminListBanRecordsPage(
    pageSize: 10,
    active: false,
  );
  print('ban_records=${bans.total}');

  print('OK');
}
