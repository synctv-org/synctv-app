import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/seafile_add_media_form.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

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
                          source: testDiscoveredPlaylistSource(),
                        ),
                      ]
                    : [
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
                          source: testDiscoveredMediaSource(name: 'Movie.mkv'),
                        ),
                      ],
                total: 1,
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

    await tester.tap(byAppTooltip('Unlock'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'secret');
    await tester.tap(find.text('Unlock').last);
    await tester.pumpAndSettle();
    expect(unlocked, isTrue);

    await tester.tap(find.byKey(const ValueKey('discovery-open-repo-1:/')));
    await tester.pumpAndSettle();
    expect(requestedRepository, 'repo-1');
    expect(find.text('Movie.mkv'), findsOneWidget);
    expect(find.text('1.0 GB · Alice · Starred'), findsOneWidget);
  });

  testWidgets('applies the current proxy mode to an earlier selection', (
    tester,
  ) async {
    final gateway = _AddGateway();
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => buildThemedTestApp(
          context,
          DependencyScope<ProviderGateway>(value: gateway, child: child!),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SeafileAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [bind],
            resourceHeaders: () => const {},
            pageLoader: (_, _, _, _, _, page, _) async => SeafileFileListPage(
              items: [
                SeafileFileItemInfo(
                  repositoryId: 'repo-1',
                  repositoryName: 'Movies',
                  path: '/Movie.mkv',
                  name: 'Movie.mkv',
                  objectId: 'object-id',
                  isDir: false,
                  size: 1024,
                  modifiedAt: '',
                  permission: 'rw',
                  modifierName: 'Alice',
                  starred: false,
                  hasThumbnail: false,
                  repositoryEncrypted: false,
                  passwordRequired: false,
                  thumbnailUrl: '',
                  source: provider_common.DiscoveredSource(
                    media: source_config.MediaSourceConfig(
                      seafile: source_config.SeafileMediaSourceConfig(
                        serverId: bind.serverId,
                        repositoryId: 'repo-1',
                        path: '/Movie.mkv',
                        objectId: 'object-id',
                      ),
                    ),
                  ),
                ),
              ],
              total: 1,
              page: page,
              hasMore: false,
              source: null,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('discovery-item-repo-1:/Movie.mkv')),
    );
    await tester.pumpAndSettle();
    final proxyModeDropdown = find.byKey(
      const Key('playback-proxy-mode-dropdown'),
    );
    await tester.ensureVisible(proxyModeDropdown);
    await tester.tap(proxyModeDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Proxy only').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('discovery-add-selected')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));

    expect(
      gateway.addedSource?.media.seafile.proxyMode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
  });
}

class _AddGateway implements ProviderGateway {
  provider_common.DiscoveredSource? addedSource;

  @override
  Future<provider_common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    provider_common.DiscoveredSource source,
  ) async => provider_common.PlaybackProxyPolicy(
    supportedModes: [
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    ],
    currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
  );

  @override
  Future<String> addDiscoveredSource(
    String roomId, {
    required provider_common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) async {
    addedSource = source.deepCopy();
    return 'media-id';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
