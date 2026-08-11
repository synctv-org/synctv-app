import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/fnos_add_media_form.dart';

import '../../../../test_app.dart';

void main() {
  const bind = FnosBindInfo(
    id: '1',
    serverId: 'server',
    endpoint: 'https://fnos.example',
    webdavEndpoint: 'https://fnos.example/webdav',
    mediaEndpoint: 'https://fnos.example',
    username: 'user',
    createdAt: 1,
    providerInstanceName: '',
    mediaAvailable: true,
  );

  testWidgets('switches between FNOS files and media libraries', (
    tester,
  ) async {
    var mediaSearch = '';
    FnosMediaCollection? loadedCollection;
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FnosAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [bind],
            fileLoader: (_, _, page, _, _) async => FnosFileListPage(
              items: [
                FnosFileItemInfo(
                  name: 'Movie.mkv',
                  path: '/Movie.mkv',
                  size: 1024,
                  modifiedAt: null,
                  createdAt: null,
                  isDir: false,
                  storageId: 1,
                  source: testDiscoveredMediaSource(name: 'Movie.mkv'),
                ),
              ],
              total: 1,
              page: page,
              hasMore: false,
              source: testDiscoveredPlaylistSource(),
            ),
            libraryLoader: (_) async => const [
              FnosMediaLibraryInfo(
                guid: 'library',
                title: 'Movies',
                poster: '',
                posters: [],
                category: 'Movie',
                viewType: 0,
                posterType: 0,
              ),
            ],
            mediaItemLoader: (_, collection, _, page, _, search) async {
              loadedCollection = collection;
              mediaSearch = search;
              return FnosMediaListPage(
                items: [
                  FnosMediaItemInfo(
                    guid: 'movie',
                    title: 'Interstellar',
                    itemType: 'Movie',
                    poster: '',
                    mediaGuid: 'media',
                    parentGuid: 'library',
                    overview: '',
                    durationSeconds: 100,
                    progressSeconds: 100,
                    watched: true,
                    seasonNumber: 0,
                    episodeNumber: 0,
                    isFolder: false,
                    isPlayable: true,
                    favorite: true,
                    source: testDiscoveredMediaSource(name: 'Interstellar'),
                  ),
                ],
                total: 0,
                page: page,
                hasMore: false,
                source: testDiscoveredPlaylistSource(),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Movie.mkv'), findsOneWidget);

    await tester.tap(find.text('Media'));
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Movie.mkv'), findsNothing);

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(loadedCollection, FnosMediaCollection.favorites);
    expect(find.text('Interstellar'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Movies'), findsOneWidget);

    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();
    expect(find.text('Interstellar'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'space');
    await tester.tap(byAppTooltip('Search'));
    await tester.pumpAndSettle();
    expect(mediaSearch, 'space');
  });
}
