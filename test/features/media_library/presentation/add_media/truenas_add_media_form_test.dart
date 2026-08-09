import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/truenas_add_media_form.dart';

import '../../../../test_app.dart';

void main() {
  const bind = TrueNasBindInfo(
    id: '1',
    serverId: 'nas-home',
    endpoint: 'https://nas.example',
    hostname: 'storage-node.example',
    version: '25.10',
    systemProduct: 'TrueNAS SCALE',
    createdAt: 1,
    providerInstanceName: '',
  );

  testWidgets('browses /mnt folders and submits native search', (tester) async {
    var requestedPath = '';
    var requestedSearch = '';
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TrueNasAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [bind],
            pageLoader: (_, path, search, page, _) async {
              requestedPath = path;
              requestedSearch = search;
              return TrueNasFileListPage(
                items: path == '/mnt'
                    ? const [
                        TrueNasFileItemInfo(
                          name: 'tank',
                          path: '/mnt/tank',
                          realpath: '/mnt/tank',
                          isDir: true,
                          size: 0,
                          allocationSize: 0,
                          mode: 493,
                          uid: 0,
                          gid: 0,
                          mountId: 1,
                          acl: true,
                          isMountpoint: true,
                          isControlDirectory: false,
                          attributes: [],
                          extendedAttributes: [],
                          zfsAttributes: [],
                        ),
                      ]
                    : const [
                        TrueNasFileItemInfo(
                          name: 'Movie.mkv',
                          path: '/mnt/tank/Movie.mkv',
                          realpath: '/mnt/tank/Movie.mkv',
                          isDir: false,
                          size: 1024,
                          allocationSize: 4096,
                          mode: 420,
                          uid: 1000,
                          gid: 1000,
                          mountId: 1,
                          acl: false,
                          isMountpoint: false,
                          isControlDirectory: false,
                          attributes: [],
                          extendedAttributes: [],
                          zfsAttributes: [],
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

    await tester.tap(find.text('tank'));
    await tester.pumpAndSettle();
    expect(requestedPath, '/mnt/tank');
    expect(find.text('Movie.mkv'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'movie');
    await tester.tap(byAppTooltip('搜索'));
    await tester.pumpAndSettle();
    expect(requestedSearch, 'movie');
  });

  testWidgets('uses the active locale for an unbound account', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(
          body: TrueNasAddMediaForm(
            roomId: 'room_1',
            playlistId: '',
            binds: [],
          ),
        ),
      ),
    );

    expect(find.text('Bind an account to access resources'), findsOneWidget);
  });
}
