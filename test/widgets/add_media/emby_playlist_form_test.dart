import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/models/provider_models.dart';
import 'package:synctv_app/models/room_media_models.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/widgets/add_media/emby_playlist_form.dart';

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
  folderCount: 0,
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
    isFolder: true,
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
    isFolder: false,
  ),
]);

RoomMediaLibraryPage _previewWith(List<RoomDynamicMediaEntry> items) {
  return RoomMediaLibraryPage(
    playlists: const [],
    media: const [],
    dynamicItems: items,
    currentPath: const [],
    total: items.length,
    folderCount: items.where((item) => item.isFolder).length,
    fileCount: items.where((item) => !item.isFolder).length,
    version: '',
    usesCursor: false,
    nextCursor: '',
    page: 1,
  );
}
