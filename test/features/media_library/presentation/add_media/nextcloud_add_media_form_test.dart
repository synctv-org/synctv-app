import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/nextcloud_add_media_form.dart';

import '../../../../test_app.dart';

void main() {
  const bind = NextcloudBindInfo(
    id: '1',
    serverId: 'nextcloud-home',
    endpoint: 'https://cloud.example',
    username: 'alice',
    userId: 'alice-id',
    displayName: 'Alice',
    version: '31.0.7',
    edition: 'community',
    createdAt: 1,
    providerInstanceName: '',
  );

  testWidgets('browses folders and uses native search and favorites modes', (
    tester,
  ) async {
    var requestedMode = NextcloudBrowseMode.folder;
    var requestedPath = '';
    var requestedQuery = '';
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NextcloudAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [bind],
            resourceHeaders: () => const {},
            fileLoader: (_, mode, path, query, page, _) async {
              requestedMode = mode;
              requestedPath = path;
              requestedQuery = query;
              return NextcloudFileListPage(
                items: mode == NextcloudBrowseMode.folder && path.isEmpty
                    ? const [
                        NextcloudFileItemInfo(
                          name: 'Videos',
                          path: '/Videos',
                          fileId: 100,
                          isDir: true,
                          size: 0,
                          modifiedAt: '',
                          contentType: 'httpd/unix-directory',
                          etag: '',
                          permissions: 'RDNVCK',
                          ownerId: 'alice-id',
                          ownerDisplayName: 'Alice',
                          favorite: false,
                          hasPreview: false,
                          blurhash: '',
                          width: null,
                          height: null,
                          durationMillis: null,
                          previewUrl: '',
                        ),
                      ]
                    : const [
                        NextcloudFileItemInfo(
                          name: 'Movie.mkv',
                          path: '/Videos/Movie.mkv',
                          fileId: 9007199254740993,
                          isDir: false,
                          size: 1073741824,
                          modifiedAt: '',
                          contentType: 'video/x-matroska',
                          etag: 'etag',
                          permissions: 'RGDNVW',
                          ownerId: 'alice-id',
                          ownerDisplayName: 'Alice',
                          favorite: true,
                          hasPreview: true,
                          blurhash: '',
                          width: 1920,
                          height: 1080,
                          durationMillis: 7200000,
                          previewUrl: '',
                        ),
                      ],
                total: 1,
                page: page,
                hasMore: false,
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();
    expect(requestedPath, '/Videos');
    expect(find.text('Movie.mkv'), findsOneWidget);
    expect(find.textContaining('1920×1080'), findsOneWidget);

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(requestedMode, NextcloudBrowseMode.favorites);

    await tester.tap(find.text('Search'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'movie');
    await tester.tap(byAppTooltip('Search'));
    await tester.pumpAndSettle();
    expect(requestedMode, NextcloudBrowseMode.search);
    expect(requestedQuery, 'movie');
  });
}
