import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/features/media_library/presentation/add_media/bilibili_playlist_form.dart';

void main() {
  testWidgets('builds a live-area playlist from the provider area hierarchy', (
    tester,
  ) async {
    Map<String, dynamic>? previewSource;
    Map<String, dynamic>? createdSource;
    String? createdName;
    await tester.binding.setSurfaceSize(const Size(900, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            onLoadLiveAreas: (_) async => const [
              BilibiliLiveAreaInfo(
                id: 10,
                parentId: 1,
                name: 'Indie',
                parentName: 'Games',
                picture: 'https://example.com/indie.jpg',
                hot: true,
              ),
              BilibiliLiveAreaInfo(
                id: 20,
                parentId: 2,
                name: 'Rock',
                parentName: 'Music',
                picture: 'https://example.com/rock.jpg',
                hot: false,
              ),
            ],
            onPreview: (sourceConfig, _) async {
              previewSource = sourceConfig;
              return _emptyPreview;
            },
            onCreate: (name, sourceConfig, _) async {
              createdName = name;
              createdSource = sourceConfig;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Live Area').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bilibili-live-parent-area')), findsOneWidget);
    expect(find.byKey(const Key('bilibili-live-area')), findsOneWidget);
    expect(find.text('Games'), findsOneWidget);
    expect(find.text('Indie · Hot'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bilibili-live-parent-area')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Music').last);
    await tester.pumpAndSettle();
    expect(find.text('Rock'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();

    expect(previewSource?['source'], {
      'type': 'liveArea',
      'parentAreaId': 2,
      'areaId': 20,
    });

    await tester.enterText(
      find.byKey(const Key('bilibili-playlist-name')),
      'Music Live',
    );
    await tester.tap(find.byKey(const Key('bilibili-playlist-create')));
    await tester.pumpAndSettle();

    expect(createdName, 'Music Live');
    expect(createdSource, previewSource);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('selects an authenticated favorite folder for preview', (
    tester,
  ) async {
    Map<String, dynamic>? previewSource;
    await tester.binding.setSurfaceSize(const Size(900, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            onLoadFavoriteFolders: (_) async => [
              BilibiliFavoriteFolderInfo(
                mediaId: 99,
                title: 'Private favorites',
                mediaCount: 12,
                isPrivate: true,
                isDefault: false,
                sourceConfig: source_config.PlaylistSourceConfig(
                  bilibili: source_config.BilibiliPlaylistSourceConfig(
                    favoriteVideos:
                        source_config.BilibiliFavoriteVideosPlaylistSource(
                          mediaId: Int64(99),
                        ),
                  ),
                ),
              ),
            ],
            onPreview: (source, _) async {
              previewSource = source;
              return _emptyPreview;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorite Videos').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bilibili-favorite-folder')), findsOneWidget);
    expect(find.text('Private favorites (12) · Private'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();
    expect(previewSource?['source'], {'type': 'favoriteVideos', 'mediaId': 99});
  });

  testWidgets('loads followed anime pages and builds a season playlist', (
    tester,
  ) async {
    Map<String, dynamic>? previewSource;
    await tester.binding.setSurfaceSize(const Size(900, 1050));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    BilibiliFollowedPgcInfo season(int id, String title) {
      return BilibiliFollowedPgcInfo(
        seasonId: id,
        title: title,
        cover: '',
        description: '',
        latestEpisode: 'Updated',
        sourceConfig: source_config.PlaylistSourceConfig(
          bilibili: source_config.BilibiliPlaylistSourceConfig(
            pgcSeason: source_config.BilibiliPgcSeasonPlaylistSource(
              seasonId: Int64(id),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            onLoadFollowedPgc: (_, page, _) async => BilibiliFollowedPgcPage(
              items: [
                if (page == 1) season(41, 'Season one'),
                if (page == 2) season(42, 'Season two'),
              ],
              total: 2,
              hasMore: page == 1,
            ),
            onPreview: (source, _) async {
              previewSource = source;
              return _emptyPreview;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Followed Anime').last);
    await tester.pumpAndSettle();

    expect(find.text('Season one · Updated'), findsOneWidget);
    await tester.tap(find.byKey(const Key('bilibili-followed-load-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bilibili-followed-pgc')));
    await tester.pumpAndSettle();
    expect(find.text('Season two · Updated'), findsOneWidget);
    await tester.tap(find.text('Season one · Updated').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();
    expect(previewSource?['source'], {'type': 'pgcSeason', 'seasonId': 41});
  });

  testWidgets('previews playback history with a native history filter', (
    tester,
  ) async {
    Map<String, dynamic>? previewSource;
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            onPreview: (source, _) async {
              previewSource = source;
              return _emptyPreview;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Playback History').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();

    expect(previewSource?['source'], {
      'type': 'history',
      'historyType': 'archive',
    });
  });

  testWidgets('previews PGC timeline status and creates its typed source', (
    tester,
  ) async {
    Map<String, dynamic>? createdSource;
    await tester.binding.setSurfaceSize(const Size(900, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final timelineSource = source_config.PlaylistSourceConfig(
      bilibili: source_config.BilibiliPlaylistSourceConfig(
        pgcTimeline: source_config.BilibiliPgcTimelinePlaylistSource(
          type: source_config
              .BilibiliPgcTimelineType
              .BILIBILI_PGC_TIMELINE_TYPE_ANIME,
          beforeDays: 3,
          afterDays: 7,
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            onLoadPgcTimeline: (type, before, after, instance) async {
              expect(type, BilibiliPgcTimelineKind.anime);
              expect(before, 3);
              expect(after, 7);
              return BilibiliPgcTimelineInfo(
                sourceConfig: timelineSource,
                items: const [
                  BilibiliPgcTimelineItemInfo(
                    episodeId: 101,
                    seasonId: 11,
                    title: 'Published show',
                    episodeTitle: 'Episode 1',
                    cover: '',
                    episodeCover: '',
                    publishAt: 1700000000,
                    published: true,
                    date: '2026-07-14',
                    dayOfWeek: 2,
                    delayed: false,
                    delayReason: '',
                    sourceConfig: null,
                  ),
                  BilibiliPgcTimelineItemInfo(
                    episodeId: 102,
                    seasonId: 12,
                    title: 'Delayed show',
                    episodeTitle: 'Episode 3',
                    cover: '',
                    episodeCover: '',
                    publishAt: 1700003600,
                    published: false,
                    date: '2026-07-15',
                    dayOfWeek: 3,
                    delayed: true,
                    delayReason: 'Delayed until Friday',
                    sourceConfig: null,
                  ),
                ],
              );
            },
            onCreate: (_, source, _) async => createdSource = source,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PGC Timeline').last);
    await tester.pumpAndSettle();

    expect(find.text('Published show · Episode 1'), findsOneWidget);
    expect(find.text('Published'), findsOneWidget);
    expect(find.text('Delayed until Friday'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('bilibili-playlist-name')),
      'Anime schedule',
    );
    await tester.ensureVisible(
      find.byKey(const Key('bilibili-playlist-create')),
    );
    await tester.tap(find.byKey(const Key('bilibili-playlist-create')));
    await tester.pumpAndSettle();

    expect(createdSource, {
      'source': {
        'type': 'pgcTimeline',
        'timelineType': 'anime',
        'beforeDays': 3,
        'afterDays': 7,
      },
    });
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('filters PGC index and previews a selected season source', (
    tester,
  ) async {
    Map<String, dynamic>? previewSource;
    BilibiliPgcSeasonKind? requestedKind;
    BilibiliPgcSeasonOrder? requestedOrder;
    String? requestedYear;
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    BilibiliPgcSeasonInfo season(int id, String title) {
      return BilibiliPgcSeasonInfo(
        seasonId: id,
        mediaId: id + 100,
        firstEpisodeId: id + 200,
        title: title,
        subtitle: 'Subtitle',
        cover: '',
        firstEpisodeCover: '',
        badge: 'Exclusive',
        progress: '12 episodes',
        score: '9.8',
        finished: true,
        type: BilibiliPgcSeasonKind.anime,
        sourceConfig: source_config.PlaylistSourceConfig(
          bilibili: source_config.BilibiliPlaylistSourceConfig(
            pgcSeason: source_config.BilibiliPgcSeasonPlaylistSource(
              seasonId: Int64(id),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            onLoadPgcSeasons:
                (
                  kind,
                  page,
                  order,
                  ascending,
                  finished,
                  area,
                  year,
                  styleId,
                  instance,
                ) async {
                  requestedKind = kind;
                  requestedOrder = order;
                  requestedYear = year;
                  return BilibiliPgcSeasonPage(
                    items: [
                      if (page == 1) season(51, 'Indexed season'),
                      if (page == 2) season(52, 'Second page season'),
                    ],
                    total: 2,
                    hasMore: page == 1,
                  );
                },
            onPreview: (source, _) async {
              previewSource = source;
              return _emptyPreview;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PGC Index').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('bilibili-pgc-index-kind')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movie').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bilibili-pgc-index-order')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Score').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('bilibili-pgc-index-year')),
      '2020-2026',
    );
    await tester.tap(find.byKey(const Key('bilibili-pgc-index-search')));
    await tester.pumpAndSettle();

    expect(requestedKind, BilibiliPgcSeasonKind.movie);
    expect(requestedOrder, BilibiliPgcSeasonOrder.score);
    expect(requestedYear, '2020-2026');
    expect(find.text('Indexed season'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('bilibili-pgc-index-load-more')),
    );
    await tester.tap(find.byKey(const Key('bilibili-pgc-index-load-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('bilibili-pgc-season-52')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const Key('bilibili-playlist-preview')),
    );
    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();

    expect(previewSource?['source'], {'type': 'pgcSeason', 'seasonId': 52});
  });
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
