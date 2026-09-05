// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/data/synctv_opaque_auth_gateway.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

import 'local_showcase_seed_config.dart';

const _password = String.fromEnvironment('SYNCTV_SHOWCASE_USER_PASSWORD');
final _opaqueAuthenticator = OpaqueAuthenticatorService(
  gateway: const SyncTvOpaqueAuthGateway(),
);

const _categorySeeds = <(String, String, String)>[
  (
    'showcase-film-tv',
    'Film & TV',
    'Films, series, and community watch parties.',
  ),
  ('showcase-animation', 'Animation', 'Animated features, shorts, and series.'),
  (
    'showcase-documentary-culture',
    'Documentary & Culture',
    'Documentaries, culture, and thoughtful discussion.',
  ),
  ('showcase-music-live', 'Music & Live', 'Concerts and live performances.'),
];

const _labelSeeds = <(String, String, String, String)>[
  ('showcase-weekly-pick', 'Weekly Pick', '#4F7CAC', 'showcase-film-tv'),
  (
    'showcase-film-open-to-guests',
    'Open to Guests',
    '#2E8B70',
    'showcase-film-tv',
  ),
  ('showcase-independent', 'Independent', '#9B6B43', 'showcase-animation'),
  (
    'showcase-animation-open-to-guests',
    'Open to Guests',
    '#2E8B70',
    'showcase-animation',
  ),
  (
    'showcase-documentary-discussion',
    'Discussion',
    '#7B61A8',
    'showcase-documentary-culture',
  ),
  (
    'showcase-documentary-weekly-pick',
    'Weekly Pick',
    '#4F7CAC',
    'showcase-documentary-culture',
  ),
  ('showcase-live-music', 'Live Music', '#C65A45', 'showcase-music-live'),
  (
    'showcase-music-open-to-guests',
    'Open to Guests',
    '#2E8B70',
    'showcase-music-live',
  ),
  (
    'showcase-restored-classics',
    'Restored Classics',
    '#8B6F47',
    'showcase-film-tv',
  ),
  ('showcase-film-discussion', 'Discussion', '#7B61A8', 'showcase-film-tv'),
];

const _users = [
  'olivia',
  'marcus',
  'maya',
  'theo',
  'nora',
  'ethan',
  'ava',
  'lucas',
  'sophie',
  'noah',
  'chloe',
  'daniel',
];

const _rooms = [
  _RoomSeed(
    key: 'friday-film-club',
    name: 'Friday Film Club',
    description: 'A relaxed Friday-night watch party for contemporary cinema and festival favorites.',
    owner: 'olivia',
    categoryKey: 'showcase-film-tv',
    labelKeys: ['showcase-weekly-pick', 'showcase-film-open-to-guests'],
    coverFile: 'friday-cinema.jpg',
    members: [
      'olivia',
      'marcus',
      'maya',
      'theo',
      'nora',
      'ethan',
      'sophie',
      'chloe',
      'daniel',
    ],
  ),
  _RoomSeed(
    key: 'animation-after-dark',
    name: 'Animation After Dark',
    description: 'Late-night animation picks, from independent shorts to modern classics.',
    owner: 'maya',
    categoryKey: 'showcase-animation',
    labelKeys: ['showcase-independent', 'showcase-animation-open-to-guests'],
    coverFile: 'anime-night.jpg',
    members: [
      'maya',
      'olivia',
      'marcus',
      'theo',
      'nora',
      'ava',
      'lucas',
      'sophie',
      'noah',
      'chloe',
      'daniel',
    ],
    primary: true,
  ),
  _RoomSeed(
    key: 'documentary-circle',
    name: 'Documentary Circle',
    description: 'Weekly documentaries followed by an open discussion.',
    owner: 'theo',
    categoryKey: 'showcase-documentary-culture',
    labelKeys: [
      'showcase-documentary-discussion',
      'showcase-documentary-weekly-pick',
    ],
    coverFile: 'documentary.jpg',
    members: ['theo', 'olivia', 'nora', 'ethan', 'ava', 'noah', 'daniel'],
  ),
  _RoomSeed(
    key: 'live-sessions',
    name: 'Live Sessions',
    description: 'Concert films, acoustic sessions, and live performances.',
    owner: 'nora',
    categoryKey: 'showcase-music-live',
    labelKeys: ['showcase-live-music', 'showcase-music-open-to-guests'],
    coverFile: 'live-house.jpg',
    members: ['nora', 'marcus', 'maya', 'ava', 'lucas', 'sophie', 'chloe'],
  ),
  _RoomSeed(
    key: 'classic-cinema-society',
    name: 'Classic Cinema Society',
    description:
        'Restored classics and thoughtful conversations about film history.',
    owner: 'ethan',
    categoryKey: 'showcase-film-tv',
    labelKeys: ['showcase-restored-classics', 'showcase-film-discussion'],
    coverFile: 'classics.jpg',
    members: ['ethan', 'theo', 'nora', 'lucas', 'noah', 'daniel'],
  ),
];

void main() {
  test('seed realistic English showcase content', () async {
    const baseUrl = String.fromEnvironment('SYNCTV_SMOKE_BASE_URL');
    const rootPassword = String.fromEnvironment('SYNCTV_SMOKE_ROOT_PASSWORD');
    const coverDirectory = String.fromEnvironment('SYNCTV_SHOWCASE_COVER_DIR');
    const mediaOrigin = String.fromEnvironment('SYNCTV_SHOWCASE_MEDIA_ORIGIN');
    const allowReset = bool.fromEnvironment('SYNCTV_SHOWCASE_ALLOW_RESET');

    if (baseUrl.isEmpty ||
        rootPassword.isEmpty ||
        mediaOrigin.isEmpty ||
        _password.isEmpty) {
      throw StateError(
        'SYNCTV_SMOKE_BASE_URL, SYNCTV_SMOKE_ROOT_PASSWORD, '
        'SYNCTV_SHOWCASE_MEDIA_ORIGIN, and SYNCTV_SHOWCASE_USER_PASSWORD '
        'are required',
      );
    }

    validateLocalShowcaseConfiguration(
      baseUrl: baseUrl,
      coverDirectory: coverDirectory,
      allowReset: allowReset,
      requiredCoverFiles: _rooms
          .map((room) => room.coverFile)
          .toSet()
          .toList(growable: false),
    );
    SharedPreferences.setMockInitialValues({});
    await SyncTvService.init();
    await SyncTvService.setBaseUrl(baseUrl);
    await _loginRoot(rootPassword);

    await _clearExistingShowcase();
    final taxonomy = await _createTaxonomy();
    await SyncTvService.logout();

    await _createUsers();
    await _loginRoot(rootPassword);
    final usersByName = await _loadUsers();
    await SyncTvService.logout();

    final roomIds = <String, String>{};
    for (final room in _rooms) {
      await _login(room.owner, _password);
      final created = await SyncTvService.createRoom(
        room.name,
        description: room.description,
        categoryId: taxonomy.categories[room.categoryKey]!,
        labelIds: room.labelKeys
            .map((key) => taxonomy.labels[key]!)
            .toList(growable: false),
      );
      roomIds[room.key] = created.roomId;

      await SyncTvService.updateRoomCover(
        created.roomId,
        await _imageUpload('$coverDirectory/${room.coverFile}'),
      );
      for (final username in room.members.where((name) => name != room.owner)) {
        await SyncTvService.addRoomMember(
          created.roomId,
          usersByName[username]!.id,
          notify: false,
        );
      }
      await SyncTvService.favoriteRoom(created.roomId);

      if (room.primary) {
        await _createPrimaryRoomMedia(
          created.roomId,
          '$mediaOrigin/sintel-trailer.mp4',
          '$coverDirectory/${room.coverFile}',
        );
      }
      await SyncTvService.logout();
    }

    await _seedChat(roomIds['animation-after-dark']!);
    await _seedSecondaryRoomChat(roomIds);
    await _seedOliviaFavorites(roomIds);

    print('SHOWCASE_USERNAME=olivia');
    print('SHOWCASE_PRIMARY_ROOM_ID=${roomIds['animation-after-dark']}');
    for (final room in _rooms) {
      print('SHOWCASE_ROOM_${room.key.toUpperCase()}=${roomIds[room.key]}');
    }
  }, timeout: const Timeout(Duration(minutes: 8)));
}

Future<void> _clearExistingShowcase() async {
  final categories = await SyncTvService.adminListRoomCategories(
    includeDisabled: true,
    refresh: true,
  );
  final categoryIds = {
    for (final category in categories) category.key: category.id,
  };
  for (final seed in _rooms) {
    final categoryId = categoryIds[seed.categoryKey];
    if (categoryId == null) continue;
    while (true) {
      final page = await SyncTvService.adminListRoomsPage(
        pageSize: 100,
        search: seed.name,
        categoryId: categoryId,
      );
      final matches = page.rooms
          .where((room) => room.roomName == seed.name)
          .toList(growable: false);
      if (matches.isEmpty) break;
      for (final room in matches) {
        await SyncTvService.adminDeleteRoom(room.roomId);
      }
    }
  }

  for (final username in _users) {
    final page = await SyncTvService.adminListUsersPage(
      pageSize: 20,
      search: username,
    );
    for (final user in page.users.where((user) => user.username == username)) {
      await SyncTvService.adminDeleteUser(user.id);
    }
  }

  final labelKeys = _labelSeeds.map((seed) => seed.$1).toSet();
  final labels = await SyncTvService.adminListRoomLabels(
    includeDisabled: true,
    refresh: true,
  );
  for (final label in labels.where((label) => labelKeys.contains(label.key))) {
    await SyncTvService.adminDeleteRoomLabel(label.id);
  }
  final categoryKeys = _categorySeeds.map((seed) => seed.$1).toSet();
  for (final category in categories.where(
    (category) => categoryKeys.contains(category.key),
  )) {
    await SyncTvService.adminDeleteRoomCategory(category.id);
  }
}

Future<void> _createUsers() async {
  for (final (index, username) in _users.indexed) {
    final result = await _opaqueAuthenticator.register(
      username: username,
      email: '',
      password: _password,
    );
    if (!result.authenticated) {
      throw StateError('OPAQUE registration did not authenticate $username');
    }
    await SyncTvService.logout();
    if (index < _users.length - 1) {
      await Future<void>.delayed(const Duration(seconds: 7));
    }
  }
}

Future<Map<String, SyncTvUser>> _loadUsers() async {
  final users = <String, SyncTvUser>{};
  for (final username in _users) {
    final page = await SyncTvService.adminListUsersPage(
      pageSize: 20,
      search: username,
    );
    users[username] = page.users.singleWhere(
      (user) => user.username == username,
    );
  }
  return users;
}

Future<_Taxonomy> _createTaxonomy() async {
  final categories = <String, String>{};
  for (final entry in _categorySeeds.indexed) {
    final value = entry.$2;
    final category = await SyncTvService.adminUpsertRoomCategory(
      key: value.$1,
      name: value.$2,
      description: value.$3,
      sortOrder: entry.$1 * 10,
      isEnabled: true,
    );
    categories[value.$1] = category.id;
  }

  final labels = <String, String>{};
  for (final entry in _labelSeeds.indexed) {
    final value = entry.$2;
    final label = await SyncTvService.adminUpsertRoomLabel(
      key: value.$1,
      name: value.$2,
      color: value.$3,
      categoryId: value.$4.isEmpty ? '' : categories[value.$4]!,
      sortOrder: entry.$1 * 10,
      isEnabled: true,
    );
    labels[value.$1] = label.id;
  }
  return _Taxonomy(categories: categories, labels: labels);
}

Future<void> _createPrimaryRoomMedia(
  String roomId,
  String videoUrl,
  String coverPath,
) async {
  final playlist = await SyncTvService.createPlaylist(
    roomId,
    name: 'Open Animation Night',
    description: 'Independent animation selected by the room community.',
  );
  await SyncTvService.updatePlaylistCover(
    roomId,
    playlist.id,
    await _imageUpload(coverPath),
  );
  final mediaId = await SyncTvService.addDiscoveredSource(
    roomId,
    playlistId: playlist.id,
    name: 'Sintel — Official Trailer',
    source: provider_common.DiscoveredSource(
      media: source_config.MediaSourceConfig(
        directUrl: source_config.DirectUrlMediaSourceConfig(
          medias: [
            source_config.DirectUrlMediaResourceConfig(
              name: '480p',
              url: videoUrl,
              format: 'mp4',
            ),
          ],
        ),
      ),
    ),
  );
  await SyncTvService.updateVideoCover(
    roomId,
    mediaId,
    await _imageUpload(coverPath),
  );
  await SyncTvService.switchMedia(roomId, mediaId, playlistId: playlist.id);
}

Future<void> _seedChat(String roomId) async {
  const messages = [
    (
      'maya',
      'Welcome in! We’ll start in a minute so everyone has time to settle.',
    ),
    ('marcus', 'Perfect timing. I’ve had this one on my watchlist for ages.'),
    ('olivia', 'The art direction in the opening shot is beautiful.'),
    ('theo', 'Audio is clear on my end.'),
    ('nora', 'Same here. The score is already fantastic.'),
    ('sophie', 'That transition was so smooth.'),
    ('daniel', 'I love how much atmosphere they build in such a short time.'),
    (
      'maya',
      'We’ll stay for a quick discussion after the credits. Everyone is welcome.',
    ),
  ];
  for (final message in messages) {
    await _login(message.$1, _password);
    await SyncTvService.sendChatMessage(roomId, content: message.$2);
    await SyncTvService.logout();
  }
}

Future<void> _seedSecondaryRoomChat(Map<String, String> roomIds) async {
  const messages = [
    (
      'olivia',
      'friday-film-club',
      'This week’s selection is up. I’ll post the start time tomorrow.',
    ),
    (
      'theo',
      'documentary-circle',
      'I added a short reading list for anyone joining Sunday’s discussion.',
    ),
    (
      'nora',
      'live-sessions',
      'Next session is an acoustic set with a great behind-the-scenes interview.',
    ),
    (
      'ethan',
      'classic-cinema-society',
      'The restored print looks wonderful. Details are in the playlist notes.',
    ),
  ];
  for (final message in messages) {
    await _login(message.$1, _password);
    await SyncTvService.sendChatMessage(
      roomIds[message.$2]!,
      content: message.$3,
    );
    await SyncTvService.logout();
  }
}

Future<void> _seedOliviaFavorites(Map<String, String> roomIds) async {
  await _login('olivia', _password);
  for (final roomKey in const ['animation-after-dark', 'documentary-circle']) {
    await SyncTvService.favoriteRoom(roomIds[roomKey]!);
  }
}

Future<void> _login(String username, String password) async {
  final login = await SyncTvService.startLogin(username);
  final result = await _opaqueAuthenticator.login(
    loginSessionId: login.sessionId,
    password: password,
  );
  if (!result.authenticated) {
    throw StateError('OPAQUE login did not authenticate $username');
  }
}

Future<void> _loginRoot(String password) async {
  final login = await SyncTvService.startLogin('root');
  final result = await SyncTvService.loginWithDirectPassword(
    loginSessionId: login.sessionId,
    password: password,
  );
  if (!result.authenticated) {
    throw StateError('Direct password login did not authenticate root');
  }
}

Future<LocalImageUpload> _imageUpload(String path) async {
  final file = File(path);
  final bytes = Uint8List.fromList(await file.readAsBytes());
  return LocalImageUpload(
    bytes: bytes,
    fileName: file.uri.pathSegments.last,
    mimeType: 'image/jpeg',
    width: 1600,
    height: 900,
  );
}

class _RoomSeed {
  const _RoomSeed({
    required this.key,
    required this.name,
    required this.description,
    required this.owner,
    required this.categoryKey,
    required this.labelKeys,
    required this.coverFile,
    required this.members,
    this.primary = false,
  });

  final String key;
  final String name;
  final String description;
  final String owner;
  final String categoryKey;
  final List<String> labelKeys;
  final String coverFile;
  final List<String> members;
  final bool primary;
}

class _Taxonomy {
  const _Taxonomy({required this.categories, required this.labels});

  final Map<String, String> categories;
  final Map<String, String> labels;
}
