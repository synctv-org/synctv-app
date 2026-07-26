import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/synology_add_media_form.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';

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
                    items: const [
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
                      ),
                    ],
                    total: 1,
                    page: page,
                    hasMore: false,
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
}
