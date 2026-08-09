// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import 'local_backend_test_auth.dart';

/// Exercises flows not covered by tool/local_backend_smoke.dart:
/// chat edit/delete/pin/search/context/read-receipts, media & playlist
/// mutations, the chunked file-upload pipeline (avatar + room cover), and
/// notifications listing. Run against a local backend that allows root login.
void main() {
  test('local_backend_smoke_extended', () async {
    const baseUrl = String.fromEnvironment('SYNCTV_SMOKE_BASE_URL');
    const rootPassword = String.fromEnvironment('SYNCTV_SMOKE_ROOT_PASSWORD');
    if (baseUrl.isEmpty || rootPassword.isEmpty) {
      throw StateError(
        'SYNCTV_SMOKE_BASE_URL and SYNCTV_SMOKE_ROOT_PASSWORD are required',
      );
    }
    await runExtendedSmoke(baseUrl, rootPassword);
  }, timeout: const Timeout(Duration(minutes: 3)));
}

Future<void> runExtendedSmoke(String baseUrl, String rootPassword) async {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  final username = 'ext_$stamp';
  final password = 'ExtPass_$stamp!';

  SharedPreferences.setMockInitialValues({});
  await SyncTvService.init();
  await SyncTvService.setBaseUrl(baseUrl);

  // Bootstrap: password signup is usually off in local dev, so create the
  // user through the admin API as root, then log in as that user.
  await loginLocalRoot(rootPassword);
  await SyncTvService.adminAddUser(
    username,
    password,
    common_enum.UserRole.USER_ROLE_USER.value,
  );
  await SyncTvService.logout();
  await loginLocalPasswordUser(username, password);
  print('extended user=$username');

  // ---- File-upload pipeline: avatar ----
  // A real 2x2 PNG (random bytes fail the server's image-format validation).
  final avatarBytes = Uint8List.fromList(const [
    137,
    80,
    78,
    71,
    13,
    10,
    26,
    10,
    0,
    0,
    0,
    13,
    73,
    72,
    68,
    82,
    0,
    0,
    0,
    2,
    0,
    0,
    0,
    2,
    8,
    2,
    0,
    0,
    0,
    253,
    212,
    154,
    115,
    0,
    0,
    0,
    16,
    73,
    68,
    65,
    84,
    120,
    156,
    99,
    248,
    207,
    192,
    0,
    68,
    12,
    16,
    10,
    0,
    31,
    238,
    3,
    253,
    139,
    95,
    20,
    212,
    0,
    0,
    0,
    0,
    73,
    69,
    78,
    68,
    174,
    66,
    96,
    130,
  ]);
  await SyncTvService.updateUserAvatar(
    LocalImageUpload(
      bytes: avatarBytes,
      fileName: 'avatar.png',
      mimeType: 'image/png',
      width: 64,
      height: 64,
    ),
  );
  // The chunked upload + manifest + complete pipeline is the real signal;
  // getting here without throwing means it worked end-to-end.
  await SyncTvService.clearUserAvatar();
  print('avatar_uploaded_and_cleared');

  // ---- Room + playlist + media ----
  final room = await SyncTvService.createRoom(
    'Extended Room $stamp',
    description: 'extended smoke',
  );
  final roomId = room.roomId;

  final pl1 = await SyncTvService.createPlaylist(
    roomId,
    name: 'PL1',
    description: 'first',
  );
  final pl2 = await SyncTvService.createPlaylist(
    roomId,
    name: 'PL2',
    description: 'second',
  );

  final m1 = await SyncTvService.addDirectUrlMedia(
    roomId,
    playlistId: pl1.id,
    url: 'https://example.com/a.mp4',
    playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
    name: 'A',
  );
  final m2 = await SyncTvService.addDirectUrlMedia(
    roomId,
    playlistId: pl1.id,
    url: 'https://example.com/b.mp4',
    playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
    name: 'B',
  );

  // media edit
  final edited = await SyncTvService.editMedia(
    roomId,
    m1,
    name: 'A-renamed',
    description: 'edited name',
  );
  if (edited.name != 'A-renamed') {
    throw StateError('media edit failed: ${edited.name}');
  }
  print('media_edit=${edited.name}');

  // media move m1 before m2 within pl1
  final movedCount = await SyncTvService.moveMedia(
    roomId,
    mediaIds: [m1],
    targetPlaylistId: pl1.id,
    beforeMediaId: m2,
  );
  print('media_moved=$movedCount');

  // playlist move pl2 before pl1
  await SyncTvService.movePlaylist(roomId, pl2.id, beforePlaylistId: pl1.id);
  print('playlist_moved');

  // ---- Room cover upload (file pipeline, second path) ----
  final coverRoom = await SyncTvService.updateRoomCover(
    roomId,
    LocalImageUpload(
      bytes: avatarBytes,
      fileName: 'cover.png',
      mimeType: 'image/png',
      width: 2,
      height: 2,
    ),
  );
  print('room_cover_uploaded=${coverRoom.coverUrl.isNotEmpty}');
  await SyncTvService.clearRoomCover(roomId);

  // ---- Chat: send -> edit -> pin -> search -> context -> read state ----
  final msg = await SyncTvService.sendChatMessage(
    roomId,
    content: 'needle in extended haystack $stamp',
  );
  final editedMsg = await SyncTvService.editChatMessage(
    roomId,
    msg.id,
    content: 'needle EDITED $stamp',
    expectedVersion: msg.version,
  );
  if (!editedMsg.content.contains('EDITED')) {
    throw StateError('chat edit failed: ${editedMsg.content}');
  }
  print('chat_edit=${editedMsg.content}');

  final pin = await SyncTvService.pinChatMessage(
    roomId,
    editedMsg.id,
    note: 'pinned by extended smoke',
  );
  print('chat_pinned=${pin.message.id}');
  final pinnedList = await SyncTvService.listPinnedChatMessages(roomId);
  if (!pinnedList.any((p) => p.message.id == editedMsg.id)) {
    throw StateError('pinned list missing message');
  }

  final searchPage = await SyncTvService.searchChatMessages(
    roomId,
    query: 'needle',
    limit: 10,
  );
  print('chat_search_hits=${searchPage.messages.length}');
  if (!searchPage.messages.any((m) => m.id == editedMsg.id)) {
    throw StateError('chat search did not find edited message');
  }

  final context = await SyncTvService.getChatMessageContext(
    roomId,
    editedMsg.id,
    beforeLimit: 5,
    afterLimit: 5,
  );
  print('chat_context=${context.before.length}+${context.after.length}');

  final readState = await SyncTvService.markChatRead(roomId, editedMsg.id);
  print('chat_read_state=${readState.lastReadMessageId}');
  final receipts = await SyncTvService.getChatMessageReadReceipts(
    roomId,
    editedMsg.id,
  );
  print('chat_read_receipts=${receipts.readers.length}');

  await SyncTvService.unpinChatMessage(roomId, editedMsg.id);

  // delete chat message
  final deleted = await SyncTvService.deleteChatMessage(
    roomId,
    editedMsg.id,
    expectedVersion: editedMsg.version,
  );
  print('chat_deleted=${deleted.id}');

  // ---- Content report (room) ----
  final reportId = await SyncTvService.reportRoom(
    roomId,
    reasonCode: 'other',
    reason: 'extended smoke report',
  );
  print('content_report=$reportId');

  // ---- Notifications ----
  final notifications = await SyncTvService.listNotifications();
  print('notifications=${notifications.total}');

  // ---- Room settings round-trip ----
  final settings = await SyncTvService.getRoomSettings(roomId, refresh: true);
  final before = settings.chatEnabled;
  settings.chatEnabled = !before;
  await SyncTvService.updateRoomSettings(roomId, settings);
  final settingsAfter = await SyncTvService.getRoomSettings(
    roomId,
    refresh: true,
  );
  if (settingsAfter.chatEnabled == before) {
    throw StateError('room settings update did not persist chatEnabled');
  }
  // restore
  settingsAfter.chatEnabled = before;
  await SyncTvService.updateRoomSettings(roomId, settingsAfter);
  print('room_settings_roundtrip=ok');

  // ---- Chat attachment image + message with image ----
  final attachment = await SyncTvService.uploadChatImage(
    roomId,
    LocalImageUpload(
      bytes: avatarBytes,
      fileName: 'chat.png',
      mimeType: 'image/png',
      width: 2,
      height: 2,
    ),
  );
  final imgMsg = await SyncTvService.sendChatMessage(
    roomId,
    content: 'with image $stamp',
    images: [attachment],
  );
  if (imgMsg.images.isEmpty) {
    throw StateError('chat message missing attached image');
  }
  print('chat_image_msg=${imgMsg.id} images=${imgMsg.images.length}');

  // ---- Media + playlist cover uploads (file pipeline) ----
  await SyncTvService.updateVideoCover(
    roomId,
    m1,
    LocalImageUpload(
      bytes: avatarBytes,
      fileName: 'media_cover.png',
      mimeType: 'image/png',
      width: 2,
      height: 2,
    ),
  );
  await SyncTvService.updatePlaylistCover(
    roomId,
    pl1.id,
    LocalImageUpload(
      bytes: avatarBytes,
      fileName: 'pl_cover.png',
      mimeType: 'image/png',
      width: 2,
      height: 2,
    ),
  );
  print('media_and_playlist_cover_uploaded');

  // ---- Playlist deletion (cleanup) ----
  await SyncTvService.deletePlaylist(roomId, pl1.id, force: true);
  await SyncTvService.deletePlaylist(roomId, pl2.id, force: true);
  print('playlists_deleted');

  // silence unused warning for me where analyzer is strict
  print('OK_EXTENDED');
}
