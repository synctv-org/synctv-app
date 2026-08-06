import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/features/media_library/presentation/add_media/emby_playlist_form.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('previews native Emby home and collection sources', (
    tester,
  ) async {
    final previews = <Map<String, dynamic>>[];
    Map<String, dynamic>? createdSource;
    await tester.binding.setSurfaceSize(const Size(900, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: EmbyPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [
              EmbyBindInfo(
                id: '1',
                serverId: 'server',
                host: 'https://emby.example.com',
                userId: 'user',
                createdAt: 1,
                providerInstanceName: '',
              ),
            ],
            onDraftChanged: (_) {},
            onPreview: (source, _, target) async {
              previews.add(source);
              if ((source['source'] as Map)['type'] == 'genres') {
                return target == null ? _genrePreview : _genreItemsPreview;
              }
              return _emptyPreview;
            },
            onCreate: (_, source, _) async => createdSource = source,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(previews.last['source'], {'type': 'continueWatching'});

    await _selectMode(tester, 'Recently Added');
    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(previews.last['source'], {
      'type': 'recentlyAdded',
      'itemTypes': containsAll(['Movie', 'Episode', 'Video']),
    });

    await _selectMode(tester, 'Collections');
    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(previews.last['source'], {'type': 'collections'});

    await _selectMode(tester, 'Genres');
    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Drama'));
    await tester.pumpAndSettle();
    expect(find.text('Drama'), findsWidgets);

    await tester.tap(find.byKey(const Key('emby-create')));
    await tester.pumpAndSettle();
    expect(createdSource?['source'], {
      'type': 'genreItems',
      'genreId': 'genre-1',
      'itemTypes': containsAll(['Movie', 'Episode', 'Video']),
    });
    await tester.pump(const Duration(seconds: 4));
  });
}

Future<void> _selectMode(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(const Key('emby-collection-mode')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

const _emptyPreview = RoomMediaLibraryPage(
  playlists: [],
  media: [],
  dynamicItems: [],
  currentPath: [],
  total: 0,
  playlistCount: 0,
  fileCount: 0,
  version: '',
  usesCursor: false,
  nextCursor: '',
  page: 1,
);

final _genrePreview = _previewWith([
  RoomDynamicMediaEntry(
    id: 'genre-target',
    name: 'Drama',
    parentId: '',
    subPath: 'Drama',
    isPlaylist: true,
    metadata: const {
      'target_json': {'itemId': 'genre-1'},
    },
    playlistSourceConfig: source_config.PlaylistSourceConfig(
      emby: source_config.EmbyPlaylistSourceConfig(
        serverId: 'server',
        genreItems: source_config.EmbyGenreItemsPlaylistSource(
          genreId: 'genre-1',
          itemTypes: const ['Movie', 'Episode', 'Video'],
        ),
      ),
    ),
  ),
]);

final _genreItemsPreview = _previewWith([
  RoomDynamicMediaEntry(
    id: 'movie-target',
    name: 'Drama Movie',
    parentId: '',
    subPath: 'Drama Movie',
    isPlaylist: false,
  ),
]);

RoomMediaLibraryPage _previewWith(List<RoomDynamicMediaEntry> items) {
  return RoomMediaLibraryPage(
    playlists: const [],
    media: const [],
    dynamicItems: items,
    currentPath: const [],
    total: items.length,
    playlistCount: items.where((item) => item.isPlaylist).length,
    fileCount: items.where((item) => !item.isPlaylist).length,
    version: '',
    usesCursor: false,
    nextCursor: '',
    page: 1,
  );
}
