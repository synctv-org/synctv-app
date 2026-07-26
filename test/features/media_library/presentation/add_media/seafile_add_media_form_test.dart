import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/seafile_add_media_form.dart';

import '../../../../test_app.dart';

void main() {
  const bind = SeafileBindInfo(
    id: '1',
    serverId: 'seafile-home',
    endpoint: 'https://seafile.example',
    username: 'alice@example.com',
    version: '11.0.12',
    features: ['seafile-basic'],
    createdAt: 1,
    providerInstanceName: '',
  );

  testWidgets('unlocks an encrypted library and browses its files', (
    tester,
  ) async {
    var unlocked = false;
    var requestedRepository = '';
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SeafileAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [bind],
            resourceHeaders: () => const {},
            libraryUnlocker: (_, repositoryId, password) async {
              expect(repositoryId, 'repo-1');
              expect(password, 'secret');
              unlocked = true;
            },
            pageLoader: (_, _, repositoryId, _, _, page, _) async {
              requestedRepository = repositoryId;
              return SeafileFileListPage(
                items: repositoryId.isEmpty
                    ? [
                        SeafileFileItemInfo(
                          repositoryId: 'repo-1',
                          repositoryName: 'Movies',
                          path: '/',
                          name: 'Movies',
                          objectId: '',
                          isDir: true,
                          size: 1024,
                          modifiedAt: '',
                          permission: 'rw',
                          modifierName: '',
                          starred: false,
                          hasThumbnail: false,
                          repositoryEncrypted: true,
                          passwordRequired: !unlocked,
                          thumbnailUrl: '',
                        ),
                      ]
                    : const [
                        SeafileFileItemInfo(
                          repositoryId: 'repo-1',
                          repositoryName: 'Movies',
                          path: '/Movie.mkv',
                          name: 'Movie.mkv',
                          objectId: 'object-id',
                          isDir: false,
                          size: 1073741824,
                          modifiedAt: '',
                          permission: 'rw',
                          modifierName: 'Alice',
                          starred: true,
                          hasThumbnail: true,
                          repositoryEncrypted: true,
                          passwordRequired: false,
                          thumbnailUrl: '',
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

    await tester.tap(byAppTooltip('Unlock library'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'secret');
    await tester.tap(find.text('Unlock').last);
    await tester.pumpAndSettle();
    expect(unlocked, isTrue);

    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();
    expect(requestedRepository, 'repo-1');
    expect(find.text('Movie.mkv'), findsOneWidget);
    expect(find.text('1.0 GB · Alice · Starred'), findsOneWidget);
  });
}
