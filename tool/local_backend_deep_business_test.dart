// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import 'local_backend_test_auth.dart';

void main() {
  test(
    'local_backend_deep_business_test',
    () async {
      await runDeepBusinessTest(
        const String.fromEnvironment('SYNCTV_SMOKE_BASE_URL'),
        const String.fromEnvironment('SYNCTV_SMOKE_ROOT_PASSWORD'),
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}

Future<void> runDeepBusinessTest(String baseUrl, String rootPassword) async {
  if (baseUrl.isEmpty || rootPassword.isEmpty) {
    throw StateError(
      'SYNCTV_SMOKE_BASE_URL and SYNCTV_SMOKE_ROOT_PASSWORD are required',
    );
  }
  final stamp = DateTime.now().microsecondsSinceEpoch;
  final owner = _UserSeed('deep_owner_$stamp', 'DeepOwnerPass9!');
  final member = _UserSeed('deep_member_$stamp', 'DeepMemberPass8!');
  final guest = _UserSeed('deep_guest_$stamp', 'DeepGuestPass7!');

  await _init(baseUrl);
  await _rootLogin(rootPassword);
  await _createUser(owner);
  await _createUser(member);
  await _createUser(guest);

  await _login(owner);
  final room = await SyncTvService.createRoom(
    'Deep Business $stamp',
    description: 'deep generated business room',
  );
  final roomId = room.roomId;
  print('room=$roomId owner=${owner.username}');

  await _exerciseWatchers(roomId, stamp);
  await _exerciseMediaAndRealtime(roomId, stamp, owner);
  await _exerciseRoomLifecycle(roomId, owner, member, guest);

  await _rootLogin(rootPassword);
  await _exerciseAdminLifecycle(
    roomId: roomId,
    rootPassword: rootPassword,
    owner: owner,
    member: member,
    stamp: stamp,
  );

  print('OK_DEEP_BUSINESS');
}

Future<void> _init(String baseUrl) async {
  SharedPreferences.setMockInitialValues({});
  await SyncTvService.init();
  await SyncTvService.setBaseUrl(baseUrl);
}

Future<void> _rootLogin(String rootPassword) async {
  await SyncTvService.logout().catchError((_) {});
  await _retryRateLimited(() => loginLocalRoot(rootPassword), 'login_root');
}

Future<void> _login(_UserSeed seed) async {
  await SyncTvService.logout().catchError((_) {});
  await _retryRateLimited(
    () => loginLocalPasswordUser(seed.username, seed.password),
    'login_${seed.username}',
  );
}

Future<void> _createUser(_UserSeed seed) async {
  await SyncTvService.adminAddUser(
    seed.username,
    seed.password,
    common_enum.UserRole.USER_ROLE_USER.value,
  );
}

Future<void> _exerciseWatchers(String roomId, int stamp) async {
  final settingsEvents = <RoomResourceWatchEvent<SyncTvRoomSettings>>[];
  final playbackEvents = <RoomResourceWatchEvent<SyncTvPlaybackStatus>>[];
  final playlistEvents = <RoomResourceWatchEvent<RoomMediaLibraryPage>>[];
  final memberEvents = <RoomResourceWatchEvent<List<AdminRoomMember>>>[];
  final pinEvents = <RoomResourceWatchEvent<ChatPinEventInfo>>[];

  final subs = <StreamSubscription<dynamic>>[
    SyncTvService.watchRoomSettings(roomId).listen(
      settingsEvents.add,
      onError: (Object error) {
        throw StateError('watchRoomSettings error: $error');
      },
    ),
    SyncTvService.watchPlaybackState(roomId).listen(
      playbackEvents.add,
      onError: (Object error) {
        throw StateError('watchPlaybackState error: $error');
      },
    ),
    SyncTvService.watchPlaylistItems(roomId).listen(
      playlistEvents.add,
      onError: (Object error) {
        throw StateError('watchPlaylistItems error: $error');
      },
    ),
    SyncTvService.watchRoomMembers(roomId).listen(
      memberEvents.add,
      onError: (Object error) {
        throw StateError('watchRoomMembers error: $error');
      },
    ),
    SyncTvService.watchChatPinEvents(roomId).listen(
      pinEvents.add,
      onError: (Object error) {
        throw StateError('watchChatPinEvents error: $error');
      },
    ),
  ];

  print('watchers_wait_initial');
  await _waitFor(() => settingsEvents.isNotEmpty, 'room settings watch');
  await _waitFor(() => playbackEvents.isNotEmpty, 'playback state watch');
  await _waitFor(() => playlistEvents.isNotEmpty, 'playlist item watch');
  await _waitFor(() => memberEvents.isNotEmpty, 'member watch');
  await _waitFor(() => pinEvents.isNotEmpty, 'chat pin watch');
  print('watchers_initial=ok');

  print('watchers_add_media');
  final mediaId = await SyncTvService.addDirectUrlMedia(
    roomId,
    url: 'https://example.com/deep-watch-$stamp.mp4',
    playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
    name: 'watch direct $stamp',
  );
  print('watchers_send_chat');
  final msg = await SyncTvService.sendChatMessage(
    roomId,
    content: 'watch message $stamp',
  );
  print('watchers_pin_chat');
  await SyncTvService.pinChatMessage(roomId, msg.id, note: 'watch pin');
  print('watchers_switch_playback');
  await SyncTvService.switchMediaAndPlay(roomId, mediaId);

  print('watchers_update_settings');
  final settings = await SyncTvService.getRoomSettings(roomId, refresh: true);
  final originalDanmaku = settings.danmakuEnabled;
  settings.danmakuEnabled = !originalDanmaku;
  await SyncTvService.updateRoomSettings(roomId, settings);
  settings.danmakuEnabled = originalDanmaku;
  await SyncTvService.updateRoomSettings(roomId, settings);

  await _waitFor(
    () => playlistEvents.any(
      (event) => event.kind == RoomResourceWatchKind.changed,
    ),
    'playlist changed watch',
  );
  await _waitFor(
    () => playbackEvents.any(
      (event) => event.kind == RoomResourceWatchKind.changed,
    ),
    'playback changed watch',
  );
  await _waitFor(
    () => settingsEvents.any(
      (event) => event.kind == RoomResourceWatchKind.changed,
    ),
    'settings changed watch',
  );
  await _waitFor(
    () => pinEvents.any((event) => event.kind == RoomResourceWatchKind.changed),
    'pin changed watch',
  );

  print('watchers_cancel');
  for (final sub in subs) {
    await sub.cancel().timeout(const Duration(seconds: 2), onTimeout: () {});
  }
  print('watchers=ok');
}

Future<void> _exerciseMediaAndRealtime(
  String roomId,
  int stamp,
  _UserSeed owner,
) async {
  final root = await SyncTvService.createPlaylist(
    roomId,
    name: 'Deep root $stamp',
    description: 'root playlist',
  );
  final nested = await SyncTvService.createPlaylist(
    roomId,
    name: 'Deep nested $stamp',
    parentId: root.id,
    description: 'nested playlist',
  );
  final detail = await SyncTvService.getPlaylist(roomId, root.id);
  if (detail.playlist.id != root.id) {
    throw StateError('playlist detail mismatch');
  }

  final batchUrl = 'https://example.com/deep-batch-$stamp.mp4';
  await SyncTvService.addMediaBatch(roomId, [
    {
      'playlistId': nested.id,
      'sourceProvider': 'directUrl',
      'sourceConfig': {'url': batchUrl},
      'name': 'batch direct $stamp',
      'description': 'batch insert',
    },
    {
      'playlistId': nested.id,
      'sourceProvider': 'liveProxy',
      'sourceConfig': {'url': 'http://127.0.0.1:18081/live.flv'},
      'name': 'batch live proxy $stamp',
    },
  ]);

  final searchPage = await SyncTvService.listMediaLibrary(
    roomId,
    playlistId: nested.id,
    search: 'batch',
    refresh: true,
  );
  if (searchPage.media.length < 2) {
    throw StateError('batch media missing: ${searchPage.media.length}');
  }

  final rtmpId = await SyncTvService.addRtmpMedia(
    roomId,
    playlistId: nested.id,
    name: 'rtmp generated $stamp',
  );
  final publish = await SyncTvService.createRtmpPublishKeyInfo(roomId, rtmpId);
  if (publish.publishKey.isEmpty ||
      publish.rtmpUrl.isEmpty ||
      publish.streamKey.isEmpty) {
    throw StateError('rtmp publish key incomplete');
  }
  final rtmpInfo = await SyncTvService.getRtmpStreamInfo(
    roomId: roomId,
    mediaId: rtmpId,
  );
  if (rtmpInfo.mediaId != rtmpId) {
    throw StateError('rtmp stream info mismatch');
  }

  final directId = await SyncTvService.addDirectUrlMedia(
    roomId,
    playlistId: nested.id,
    url: 'https://example.com/deep-playback-$stamp.mp4',
    playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
    name: 'playback direct $stamp',
  );
  await SyncTvService.switchMediaAndPlay(roomId, directId);
  await SyncTvService.updatePlaybackState(
    roomId,
    action: PlaybackControlAction.seek,
    isPlaying: true,
    position: 12.5,
    speed: 1.25,
  );
  final playbackMessages = await SyncTvService.getChatPlaybackMessages(
    roomId,
    playbackMediaId: directId,
    positionSeconds: 12.5,
  );
  print('playback_messages=${playbackMessages.length}');

  await SyncTvService.clearMediaLibrary(roomId, parentId: nested.id);
  final afterClear = await SyncTvService.listMediaLibrary(
    roomId,
    playlistId: nested.id,
    refresh: true,
  );
  if (afterClear.media.isNotEmpty) {
    throw StateError('clearMediaLibrary left media=${afterClear.media.length}');
  }

  final alistBinds = await SyncTvService.getAllAlistBindInfos();
  if (alistBinds.isNotEmpty) {
    final bind = alistBinds.first;
    final page = await SyncTvService.listAlistPage(
      '/',
      keyword: 'direct',
      serverId: bind.serverId,
      instanceName: bind.providerInstanceName,
    );
    print('alist_search=${page.total}');
  }

  final embyBinds = await SyncTvService.getAllEmbyBindInfos();
  if (embyBinds.isNotEmpty) {
    final bind = embyBinds.first;
    final page = await SyncTvService.listEmbyPage(
      '/',
      keyword: 'Big Buck',
      serverId: bind.serverId,
      instanceName: bind.providerInstanceName,
    );
    print('emby_search=${page.total}');
  }

  final bilibiliAccount = await SyncTvService.getBilibiliAccount();
  final bilibiliBinds = await SyncTvService.getAllBilibiliBindInfos();
  print(
    'bilibili_account=${bilibiliAccount.isLogin} binds=${bilibiliBinds.length}',
  );

  await SyncTvService.startBilibiliQrLogin().then((qr) async {
    if (qr.key.isEmpty || qr.url.isEmpty) {
      throw StateError('bilibili qr login missing key or url');
    }
    final status = await SyncTvService.checkBilibiliQrLogin(qr.key);
    print('bilibili_qr_status=${status.name}');
  });
  final invalidQrStatus = await SyncTvService.checkBilibiliQrLogin(
    'invalid-key-$stamp',
  );
  print('bilibili_invalid_qr_status=${invalidQrStatus.name}');
  await _expectApiFailure(
    () => SyncTvService.loginBilibiliSms(
      sessionToken: 'invalid-session-$stamp',
      code: '000000',
    ),
    'bilibili_invalid_sms_login',
  );

  await _login(owner);
  await SyncTvService.deleteMediaLibraryEntries(roomId, playlistIds: [root.id]);
  print('media_realtime=ok');
}

Future<void> _exerciseRoomLifecycle(
  String roomId,
  _UserSeed owner,
  _UserSeed member,
  _UserSeed guest,
) async {
  print('room_lifecycle_update_password_set');
  await _retryRateLimited(
    () => SyncTvService.updateRoomPassword(roomId, 'DeepRoomPass_123!'),
    'update_room_password_set',
  );
  print('room_lifecycle_member_join');
  await _login(member);
  final passwordCheck = await SyncTvService.getRoomDiscovery(roomId);
  if (passwordCheck.discoveryAccess !=
      client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_PASSWORD.value) {
    throw StateError('room password was not required');
  }

  await _retryRateLimited(
    () => SyncTvService.joinRoom(roomId, 'DeepRoomPass_123!'),
    'member_join_password_room',
  );
  final memberProfile = await SyncTvService.getMe(refresh: true);

  print('room_lifecycle_update_password_clear');
  await _login(owner);
  await _retryRateLimited(
    () => SyncTvService.updateRoomPassword(roomId, null),
    'update_room_password_clear',
  );
  await SyncTvService.setRoomAdmin(roomId, memberProfile.id);
  await SyncTvService.removeRoomAdmin(roomId, memberProfile.id);
  await SyncTvService.updateRoomMemberPermissionOverrides(
    roomId,
    memberProfile.id,
    addedPermissions: 1,
  );
  final memberPage = await SyncTvService.getRoomMemberDetailsPage(
    roomId,
    search: member.username,
  );
  if (!memberPage.members.any((item) => item.userId == memberProfile.id)) {
    throw StateError('member not listed after add');
  }

  final reportUserId = await SyncTvService.reportUser(
    roomId,
    memberProfile.id,
    reasonCode: 'other',
    reason: 'deep user report',
  );
  final reportMemberId = await SyncTvService.reportRoomMember(
    roomId,
    memberProfile.id,
    reasonCode: 'other',
    reason: 'deep member report',
  );
  if (reportUserId.isEmpty || reportMemberId.isEmpty) {
    throw StateError('report ids missing');
  }

  await SyncTvService.kickMember(
    roomId,
    memberProfile.id,
    kickCooldownSeconds: 1,
  );

  await _login(guest);
  final guestProfile = await SyncTvService.getMe(refresh: true);
  await _login(owner);
  await SyncTvService.addRoomMember(roomId, guestProfile.id, role: 3);
  await SyncTvService.transferRoomOwnership(roomId, guestProfile.id);
  await _login(guest);
  final transferred = await SyncTvService.getRoomInfo(roomId);
  if (transferred.creatorId != guestProfile.id) {
    throw StateError('room ownership transfer failed');
  }

  await Future<void>.delayed(const Duration(seconds: 2));
  await SyncTvService.addRoomMember(roomId, memberProfile.id, role: 3);
  await SyncTvService.transferRoomOwnership(roomId, memberProfile.id);
  await _login(member);
  final finalRoom = await SyncTvService.getRoomInfo(roomId);
  if (finalRoom.creatorId != memberProfile.id) {
    throw StateError('second ownership transfer failed');
  }
  await _login(owner);
  await SyncTvService.leaveRoom(roomId);
  print('room_lifecycle=ok owner=$owner guest=${guest.username}');
}

Future<void> _exerciseAdminLifecycle({
  required String roomId,
  required String rootPassword,
  required _UserSeed owner,
  required _UserSeed member,
  required int stamp,
}) async {
  final users = await SyncTvService.adminListUsersPage(
    pageSize: 20,
    search: member.username,
  );
  final memberUser = users.users.firstWhere(
    (user) => user.username == member.username,
  );

  final prefs = await SyncTvService.adminGetUserPreferences(memberUser.id);
  await SyncTvService.adminUpdateUserPreferences(
    memberUser.id,
    twoFactorEnabled: prefs.twoFactorEnabled,
  );
  await SyncTvService.adminBanUser(memberUser.id, true, reason: 'deep ban');
  await SyncTvService.adminBanUser(memberUser.id, false);

  final banBatch = await SyncTvService.adminBatchBanUsers([
    memberUser.id,
  ], reason: 'deep batch ban');
  if (banBatch.succeeded < 1) {
    throw StateError('batch user ban failed');
  }
  await SyncTvService.adminBanUser(memberUser.id, false);

  await SyncTvService.adminBanRoom(roomId, true, reason: 'deep room ban');
  await SyncTvService.adminBanRoom(roomId, false);
  final roomBatch = await SyncTvService.adminBatchBanRooms([
    roomId,
  ], reason: 'deep batch room ban');
  if (roomBatch.succeeded < 1) {
    throw StateError('batch room ban failed');
  }
  await SyncTvService.adminBanRoom(roomId, false);

  final providerName = 'deep-provider-$stamp';
  await _expectApiFailure(() async {
    await SyncTvService.adminAddProviderInstance(
      name: providerName,
      endpoint: 'http://127.0.0.1:65535',
      providers: const ['alist'],
      comment: 'deep generated',
      timeoutSeconds: 1,
      tls: false,
      jwtSecret: 'deep-provider-secret',
    );
  }, 'provider_create_unreachable');
  await _expectApiFailure(
    () => SyncTvService.adminReconnectProviderInstance(providerName),
    'provider_reconnect_missing',
  );
  final listed = await SyncTvService.adminListProviderInstances();
  final availableAlist = await SyncTvService.listAvailableProviderInstances(
    providerType: 'alist',
  );
  final alistBackends = await SyncTvService.listProviderBackends('alist');
  if (!alistBackends.contains('alist')) {
    throw StateError('provider discovery incomplete');
  }
  print(
    'provider_instances=${listed.length} alist_available=$availableAlist alist_backends=$alistBackends',
  );

  final settings = await SyncTvService.runtimeGetSettings(refresh: true);
  final roomSettings =
      settings.section('roomCreation') ??
      const RuntimeSettingsSection(name: 'roomCreation', settings: {});
  final roomCreationEnabled = roomSettings.settings['enabled'] == true;
  await SyncTvService.runtimeUpdateSettingInSection(
    'roomCreation',
    'enabled',
    roomCreationEnabled,
  );

  final reportPage = await SyncTvService.adminListContentReportsPage(
    pageSize: 20,
    roomId: roomId,
  );
  if (reportPage.reports.isNotEmpty) {
    final report = reportPage.reports.first;
    await SyncTvService.adminGetContentReport(report.id);
    await SyncTvService.adminUpdateContentReportStatus(
      report.id,
      2,
      resolutionNote: 'deep resolved',
    );
  }

  final streams = await SyncTvService.adminListActiveStreams(roomId: roomId);
  print('active_streams=${streams.length}');
  final stats = await SyncTvService.adminGetServiceState();
  if (stats.totalUsers < 1 || stats.totalRooms < 1) {
    throw StateError('admin stats incomplete');
  }

  final ownerRows = await SyncTvService.adminListUsersPage(
    search: owner.username,
  );
  if (ownerRows.users.isEmpty) {
    throw StateError('owner missing from admin search');
  }
  print('admin_lifecycle=ok');
}

Future<void> _expectApiFailure(
  Future<void> Function() action,
  String label,
) async {
  try {
    await action();
  } catch (error) {
    print('$label=expected_failure ${error.runtimeType}');
    return;
  }
  throw StateError('$label unexpectedly succeeded');
}

Future<void> _waitFor(
  bool Function() predicate,
  String label, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (predicate()) return;
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  throw TimeoutException(label, timeout);
}

Future<T> _retryRateLimited<T>(
  Future<T> Function() action,
  String label, {
  int maxAttempts = 3,
}) async {
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await action();
    } on SyncTvApiException catch (error) {
      if (error.statusCode != 429 || attempt == maxAttempts) rethrow;
      final seconds = _rateLimitDelaySeconds(error.message);
      print('$label=rate_limited wait=${seconds}s attempt=$attempt');
      await Future<void>.delayed(Duration(seconds: seconds));
    }
  }
  throw StateError('$label retry loop exhausted');
}

int _rateLimitDelaySeconds(String message) {
  final match = RegExp(r'(\d+)s').firstMatch(message);
  final parsed = match == null ? null : int.tryParse(match.group(1)!);
  return (parsed ?? 10).clamp(1, 60);
}

class _UserSeed {
  const _UserSeed(this.username, this.password);

  final String username;
  final String password;
}
