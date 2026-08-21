import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/emby_playlist_form.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import '../../../../test_app.dart';

void main() {
  const bind = EmbyBindInfo(
    id: '1',
    serverId: 'server',
    host: 'https://emby.example.com',
    userId: 'user',
    createdAt: 1,
    providerInstanceName: '',
  );

  testWidgets('lists Emby modes and separates selection from navigation', (
    tester,
  ) async {
    final requests = <(EmbyListMode, String, List<String>)>[];
    await tester.binding.setSurfaceSize(const Size(900, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EmbyPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [bind],
            onDraftChanged: (_) {},
            loader: (_, mode, targetId, itemTypes, _, page, _) async {
              requests.add((mode, targetId, itemTypes));
              if (mode == EmbyListMode.genres) {
                return EmbyListPage(
                  serverId: 'server',
                  providerInstanceName: '',
                  items: [
                    EmbyItemInfo(
                      id: 'genre-1',
                      name: 'Drama',
                      type: 'Genre',
                      isDir: false,
                      parentId: '',
                      seriesName: '',
                      seriesId: '',
                      seasonName: '',
                      thumbnail: '',
                      source: testDiscoveredPlaylistSource(),
                    ),
                  ],
                  total: 1,
                  source: testDiscoveredPlaylistSource(),
                );
              }
              if (mode == EmbyListMode.genreItems) {
                return EmbyListPage(
                  serverId: 'server',
                  providerInstanceName: '',
                  items: [
                    EmbyItemInfo(
                      id: 'movie-1',
                      name: 'Drama Movie',
                      type: 'Movie',
                      isDir: false,
                      parentId: 'genre-1',
                      seriesName: '',
                      seriesId: '',
                      seasonName: '',
                      thumbnail: '',
                      source: testDiscoveredMediaSource(name: 'Drama Movie'),
                    ),
                  ],
                  total: 1,
                  source: testDiscoveredPlaylistSource(),
                );
              }
              return EmbyListPage(
                serverId: 'server',
                providerInstanceName: '',
                items: const [],
                total: 0,
                source: testDiscoveredPlaylistSource(),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Manage connections'), findsNothing);
    expect(find.text('Account binding'), findsNothing);
    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(requests.last.$1, EmbyListMode.continueWatching);

    await _selectMode(tester, 'Recently added');
    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(requests.last.$1, EmbyListMode.recentlyAdded);
    expect(requests.last.$3, containsAll(['Movie', 'Episode', 'Video']));

    await _selectMode(tester, 'Genres');
    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(requests.last.$1, EmbyListMode.genres);
    expect(find.text('Drama'), findsOneWidget);

    await tester.tap(find.text('Drama'));
    await tester.pump();
    expect(find.text('Selected 1'), findsOneWidget);
    expect(requests.last.$1, EmbyListMode.genres);

    await tester.tap(find.byKey(const ValueKey('discovery-open-genre-1')));
    await tester.pumpAndSettle();
    expect(requests.last.$1, EmbyListMode.genreItems);
    expect(requests.last.$2, 'genre-1');
    expect(find.text('Drama Movie'), findsOneWidget);
  });

  testWidgets(
    'treats CollectionFolder discovery items as navigable playlists',
    (tester) async {
      final requests = <(EmbyListMode, String)>[];
      await tester.binding.setSurfaceSize(const Size(900, 850));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: EmbyPlaylistForm(
              roomId: 'room',
              parentId: 'root',
              binds: const [bind],
              onDraftChanged: (_) {},
              loader: (_, mode, targetId, _, _, _, _) async {
                requests.add((mode, targetId));
                return EmbyListPage(
                  serverId: 'server',
                  providerInstanceName: '',
                  items: [
                    EmbyItemInfo(
                      id: 'collection-folder',
                      name: 'SyncTV Dev Media',
                      type: 'CollectionFolder',
                      isDir: true,
                      parentId: '',
                      seriesName: '',
                      seriesId: '',
                      seasonName: '',
                      thumbnail: '',
                      source: testDiscoveredPlaylistSource(),
                    ),
                  ],
                  total: 1,
                  source: testDiscoveredPlaylistSource(),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('emby-preview')));
      await tester.pumpAndSettle();
      expect(find.text('SyncTV Dev Media'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('discovery-open-collection-folder')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('discovery-open-collection-folder')),
      );
      await tester.pumpAndSettle();
      expect(requests.last, (EmbyListMode.folder, 'collection-folder'));
    },
  );

  testWidgets('inherits proxy mode when adding the current dynamic list', (
    tester,
  ) async {
    final gateway = _AddGateway();
    await tester.binding.setSurfaceSize(const Size(900, 850));
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
          body: EmbyPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [bind],
            proxyMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
            onDraftChanged: (_) {},
            loader: (_, mode, _, _, _, _, _) async => EmbyListPage(
              serverId: 'server',
              providerInstanceName: '',
              items: const [],
              total: 0,
              source: testDiscoveredPlaylistSource(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dynamic playlist').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('discovery-add-current-list')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(
      gateway.addedSource?.playlist.alist.proxyMode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
  });

  testWidgets('resolves policy from selected Emby media and writes its mode', (
    tester,
  ) async {
    final gateway = _AddGateway();
    var proxyMode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    final listSource = provider_common.DiscoveredSource(
      playlist: source_config.PlaylistSourceConfig(
        emby: source_config.EmbyPlaylistSourceConfig(
          serverId: 'server',
          recentlyAdded: source_config.EmbyRecentlyAddedPlaylistSource(),
        ),
      ),
    );
    final mediaSource = provider_common.DiscoveredSource(
      media: source_config.MediaSourceConfig(
        emby: source_config.EmbyMediaSourceConfig(
          serverId: 'server',
          itemId: 'movie-1',
        ),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(900, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => buildThemedTestApp(
          context,
          DependencyScope<ProviderGateway>(value: gateway, child: child!),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: EmbyPlaylistForm(
              roomId: 'room',
              parentId: 'root',
              binds: const [bind],
              proxyMode: proxyMode,
              onProxyModeChanged: (value) => setState(() => proxyMode = value),
              onDraftChanged: (_) {},
              loader: (_, _, _, _, _, _, _) async => EmbyListPage(
                serverId: 'server',
                providerInstanceName: '',
                items: [
                  EmbyItemInfo(
                    id: 'movie-1',
                    name: 'Emby Movie',
                    type: 'Movie',
                    isDir: false,
                    parentId: '',
                    seriesName: '',
                    seriesId: '',
                    seasonName: '',
                    thumbnail: '',
                    source: mediaSource,
                  ),
                ],
                total: 1,
                source: listSource,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(gateway.policySources.single.playlist.emby.serverId, 'server');

    await tester.tap(find.text('Emby Movie'));
    await tester.pumpAndSettle();
    expect(gateway.policySources.last.media.emby.itemId, 'movie-1');

    await _selectProxyOnly(tester);
    expect(proxyMode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY);

    await tester.tap(find.byKey(const Key('discovery-add-selected')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    expect(
      gateway.addedSource?.media.emby.proxyMode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
  });

  testWidgets('replaces Emby results when changing pages', (tester) async {
    final requestedPages = <int>[];
    await tester.binding.setSurfaceSize(const Size(900, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EmbyPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [bind],
            onDraftChanged: (_) {},
            loader: (_, _, _, _, _, page, _) async {
              requestedPages.add(page);
              return EmbyListPage(
                serverId: 'server',
                providerInstanceName: '',
                items: [
                  EmbyItemInfo(
                    id: 'movie-$page',
                    name: 'Movie page $page',
                    type: 'Movie',
                    isDir: false,
                    parentId: '',
                    seriesName: '',
                    seriesId: '',
                    seasonName: '',
                    thumbnail: '',
                    source: testDiscoveredMediaSource(name: 'Movie page $page'),
                  ),
                ],
                total: 60,
                source: testDiscoveredPlaylistSource(),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('emby-preview')));
    await tester.pumpAndSettle();
    expect(find.text('Movie page 1'), findsOneWidget);

    final pagination = find.byType(AppPaginationBar);
    await tester.tap(
      find.descendant(
        of: pagination,
        matching: find.byIcon(Icons.chevron_right_rounded),
      ),
    );
    await tester.pumpAndSettle();

    expect(requestedPages, [1, 2]);
    expect(find.text('Movie page 1'), findsNothing);
    expect(find.text('Movie page 2'), findsOneWidget);
  });
}

class _AddGateway implements ProviderGateway {
  provider_common.DiscoveredSource? addedSource;
  final policySources = <provider_common.DiscoveredSource>[];

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
  Future<provider_common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    provider_common.DiscoveredSource source,
  ) async {
    policySources.add(source.deepCopy());
    return provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

Future<void> _selectMode(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(const Key('emby-collection-mode')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _selectProxyOnly(WidgetTester tester) async {
  final dropdown = find.byKey(const Key('playback-proxy-mode-dropdown'));
  if (dropdown.evaluate().isNotEmpty) {
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Proxy only').last);
  } else {
    await tester.tap(find.text('Proxy only'));
  }
  await tester.pumpAndSettle();
}
