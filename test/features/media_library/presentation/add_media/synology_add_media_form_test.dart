import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/synology_add_media_form.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import '../../../../test_app.dart';

void main() {
  const bind = SynologyBindInfo(
    id: '1',
    serverId: 'dsm-home',
    endpoint: 'https://dsm.example',
    username: 'alice',
    videoStationAvailable: true,
    createdAt: 1,
    providerInstanceName: '',
  );

  testWidgets('shows Synology Video Station native media metadata', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      DependencyScope<ResourceUrlResolver>(
        value: const IdentityResourceUrlResolver(),
        child: MaterialApp(
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SynologyAddMediaForm(
              roomId: 'room',
              playlistId: '',
              binds: const [bind],
              fileLoader: (_, _, page, _, _) async => SynologyFileListPage(
                items: const [],
                total: 0,
                page: page,
                hasMore: false,
                source: testDiscoveredPlaylistSource(),
              ),
              libraryLoader: (_) async => const [
                SynologyVideoLibraryInfo(
                  id: 7,
                  title: 'Movies',
                  type: 'movie',
                  isPublic: false,
                  visible: true,
                ),
              ],
              videoLoader: (_, _, _, _, page, _, _) async =>
                  SynologyVideoListPage(
                    items: [
                      SynologyVideoItemInfo(
                        id: 42,
                        libraryId: 7,
                        type: SynologyVideoEntryType.movie,
                        title: 'Native Movie',
                        summary: 'Summary',
                        certificate: 'PG-13',
                        rating: 8,
                        genres: ['Science Fiction'],
                        watchedRatio: 0.5,
                        season: null,
                        episode: null,
                        tvShowId: null,
                        files: [
                          SynologyVideoFileInfo(
                            id: 84,
                            path: '/video/movie.mkv',
                            size: 1,
                            durationSeconds: 7200,
                            progressSeconds: 3600,
                            width: 1920,
                            height: 1080,
                            videoCodec: 'h264',
                            audioCodec: 'aac',
                            container: 'mkv',
                            videoBitrate: 8000000,
                            conversionProduced: true,
                          ),
                        ],
                        posterUrl: '',
                        source: testDiscoveredMediaSource(name: 'Native Movie'),
                      ),
                    ],
                    total: 1,
                    page: page,
                    hasMore: false,
                    source: testDiscoveredPlaylistSource(),
                  ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Video Station'));
    await tester.pumpAndSettle();

    expect(find.text('Native Movie'), findsOneWidget);
    expect(find.textContaining('Science Fiction'), findsOneWidget);
    expect(find.textContaining('Rating 8'), findsOneWidget);
    expect(find.textContaining('50% watched'), findsOneWidget);
    expect(find.textContaining('1920×1080'), findsOneWidget);
    expect(find.textContaining('H264'), findsOneWidget);
    expect(find.textContaining('8.0 Mbps'), findsOneWidget);
    expect(find.textContaining('Converted'), findsOneWidget);
  });

  testWidgets('writes selected mode onto the current Video Station list', (
    tester,
  ) async {
    final gateway = _SynologyAddGateway();
    final listSource = provider_common.DiscoveredSource(
      playlist: source_config.PlaylistSourceConfig(
        synology: source_config.SynologyPlaylistSourceConfig(
          serverId: 'dsm-home',
          movies: source_config.SynologyMoviesPlaylistSourceConfig(),
        ),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      DependencyScope<ResourceUrlResolver>(
        value: const IdentityResourceUrlResolver(),
        child: DependencyScope<ProviderGateway>(
          value: gateway,
          child: MaterialApp(
            builder: buildThemedTestApp,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SynologyAddMediaForm(
                roomId: 'room',
                playlistId: '',
                binds: const [bind],
                fileLoader: (_, _, page, _, _) async => SynologyFileListPage(
                  items: const [],
                  total: 0,
                  page: page,
                  hasMore: false,
                  source: listSource,
                ),
                libraryLoader: (_) async => const [
                  SynologyVideoLibraryInfo(
                    id: 7,
                    title: 'Movies',
                    type: 'movie',
                    isPublic: false,
                    visible: true,
                  ),
                ],
                videoLoader: (_, _, _, _, page, _, _) async =>
                    SynologyVideoListPage(
                      items: [
                        SynologyVideoItemInfo(
                          id: 42,
                          libraryId: 7,
                          type: SynologyVideoEntryType.movie,
                          title: 'Current list movie',
                          summary: '',
                          certificate: '',
                          rating: 0,
                          genres: const [],
                          watchedRatio: 0,
                          season: null,
                          episode: null,
                          tvShowId: null,
                          files: const [],
                          posterUrl: '',
                          source: testDiscoveredMediaSource(),
                        ),
                      ],
                      total: 0,
                      page: page,
                      hasMore: false,
                      source: listSource,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Video Station'));
    await tester.pumpAndSettle();
    expect(gateway.policySources.single.playlist.synology.serverId, 'dsm-home');

    await _selectProxyOnly(tester);
    await tester.tap(find.text('Dynamic playlist'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('discovery-add-current-list')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(
      gateway.addedSource?.playlist.synology.proxyMode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
  });
}

class _SynologyAddGateway implements ProviderGateway {
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
