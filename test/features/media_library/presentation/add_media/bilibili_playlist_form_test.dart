import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/bilibili_playlist_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
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
  testWidgets('shares the media creator credential with discovered sources', (
    tester,
  ) async {
    bool? requestedShared;
    await tester.binding.setSurfaceSize(const Size(900, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedShared = shared;
              return _emptyPage;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Popular').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bilibili-playlist-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share my credentials'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();

    expect(requestedShared, isTrue);
  });

  testWidgets(
    'loads popular results on entry and gives browsing primary space',
    (tester) async {
      BilibiliPlaylistListIntent? requestedIntent;
      await tester.binding.setSurfaceSize(const Size(900, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BilibiliPlaylistForm(
              roomId: 'room',
              parentId: 'root',
              binds: const [],
              onDraftChanged: (_) {},
              loader: (intent, page, pageSize, cursor, instance, shared) async {
                requestedIntent = intent;
                return _pageWithItem('Popular result');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(requestedIntent?.mode, BilibiliPlaylistListMode.popular);
      expect(find.text('Popular result'), findsOneWidget);
      expect(
        tester.getRect(find.byType(DiscoveryBrowser)).height,
        greaterThan(400),
      );
    },
  );

  testWidgets('switching to recommended refreshes the browsing results', (
    tester,
  ) async {
    final requestedModes = <BilibiliPlaylistListMode>[];
    await tester.binding.setSurfaceSize(const Size(900, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedModes.add(intent.mode);
              return _pageWithItem('${intent.mode.name} result');
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recommended').last);
    await tester.pumpAndSettle();

    expect(requestedModes.last, BilibiliPlaylistListMode.recommended);
    expect(find.text('recommended result'), findsOneWidget);
  });

  testWidgets('switches back to popular while recommended is loading', (
    tester,
  ) async {
    final requestedModes = <BilibiliPlaylistListMode>[];
    final recommended = Completer<BilibiliPlaylistListPage>();
    await tester.binding.setSurfaceSize(const Size(900, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 260),
              child: SizedBox(
                width: 450,
                height: 700,
                child: BilibiliPlaylistForm(
                  roomId: 'room',
                  parentId: 'root',
                  binds: const [],
                  onDraftChanged: (_) {},
                  loader: (intent, page, pageSize, cursor, instance, shared) {
                    requestedModes.add(intent.mode);
                    if (intent.mode == BilibiliPlaylistListMode.recommended) {
                      return recommended.future;
                    }
                    return Future.value(
                      _pageWithItem('${intent.mode.name} result'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recommended').last);
    await tester.pump();

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pump();
    final popularMenuItem = find.ancestor(
      of: find.text('Popular').last,
      matching: find.byType(PopupMenuItem<BilibiliPlaylistMode>),
    );
    Navigator.of(tester.element(popularMenuItem))
        .pop(BilibiliPlaylistMode.popular);
    await tester.pumpAndSettle();

    expect(requestedModes.last, BilibiliPlaylistListMode.popular);
    expect(find.text('popular result'), findsOneWidget);

    recommended.complete(_pageWithItem('recommended result'));
    await tester.pumpAndSettle();

    expect(find.text('popular result'), findsOneWidget);
    expect(find.text('recommended result'), findsNothing);
  });

  testWidgets('builds a live-area playlist from the provider area hierarchy', (
    tester,
  ) async {
    BilibiliPlaylistListIntent? requestedIntent;
    await tester.binding.setSurfaceSize(const Size(900, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            target: ProviderAddTarget.playlist,
            onDraftChanged: (_) {},
            onLoadLiveAreas: (_) async => [
              BilibiliLiveAreaInfo(
                id: 10,
                parentId: 1,
                name: 'Indie',
                parentName: 'Games',
                picture: 'https://example.com/indie.jpg',
                hot: true,
                source: testDiscoveredPlaylistSource(),
              ),
              BilibiliLiveAreaInfo(
                id: 20,
                parentId: 2,
                name: 'Rock',
                parentName: 'Music',
                picture: 'https://example.com/rock.jpg',
                hot: false,
                source: testDiscoveredPlaylistSource(),
              ),
            ],
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedIntent = intent;
              return _emptyPage;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Live category').last);
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

    expect(requestedIntent?.mode, BilibiliPlaylistListMode.liveArea);
    expect(requestedIntent?.parentAreaId, 2);
    expect(requestedIntent?.areaId, 20);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('discovery-add-current-list')),
          )
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('selects an authenticated favorite folder for preview', (
    tester,
  ) async {
    BilibiliPlaylistListIntent? requestedIntent;
    await tester.binding.setSurfaceSize(const Size(900, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
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
                source: testDiscoveredPlaylistSource(),
              ),
            ],
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedIntent = intent;
              return _emptyPage;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorite videos').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bilibili-favorite-folder')), findsOneWidget);
    expect(find.text('Private favorites (12) · Private'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();
    expect(requestedIntent?.mode, BilibiliPlaylistListMode.favoriteVideos);
    expect(requestedIntent?.mediaId, 99);
  });

  testWidgets('loads followed anime pages and builds a season playlist', (
    tester,
  ) async {
    BilibiliPlaylistListIntent? requestedIntent;
    await tester.binding.setSurfaceSize(const Size(900, 1050));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    BilibiliFollowedPgcInfo season(int id, String title) {
      return BilibiliFollowedPgcInfo(
        seasonId: id,
        title: title,
        cover: '',
        description: '',
        latestEpisode: 'Updated',
        source: testDiscoveredPlaylistSource(),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
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
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedIntent = intent;
              return _emptyPage;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Followed anime').last);
    await tester.pumpAndSettle();

    expect(find.text('Season one · Updated'), findsOneWidget);
    final followedPagination = find.byKey(
      const Key('bilibili-followed-pagination'),
    );
    await tester.ensureVisible(followedPagination);
    await tester.tap(
      find.descendant(
        of: followedPagination,
        matching: find.byIcon(Icons.chevron_right_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Season one · Updated'), findsNothing);
    await tester.tap(find.byKey(const Key('bilibili-followed-pgc')));
    await tester.pumpAndSettle();
    expect(find.text('Season two · Updated'), findsWidgets);
    await tester.tap(find.text('Season two · Updated').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();
    expect(requestedIntent?.mode, BilibiliPlaylistListMode.pgcSeason);
    expect(requestedIntent?.seasonId, 42);
  });

  testWidgets('previews playback history with a native history filter', (
    tester,
  ) async {
    BilibiliPlaylistListIntent? requestedIntent;
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BilibiliPlaylistForm(
            roomId: 'room',
            parentId: 'root',
            binds: const [],
            onDraftChanged: (_) {},
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedIntent = intent;
              return _emptyPage;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('History').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();

    expect(requestedIntent?.mode, BilibiliPlaylistListMode.history);
    expect(requestedIntent?.historyType, BilibiliPlaylistHistoryType.archive);
  });

  testWidgets('previews PGC timeline status and lists its typed intent', (
    tester,
  ) async {
    BilibiliPlaylistListIntent? requestedIntent;
    await tester.binding.setSurfaceSize(const Size(900, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
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
                source: testDiscoveredPlaylistSource(),
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
                    source: null,
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
                    source: null,
                  ),
                ],
              );
            },
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedIntent = intent;
              return _emptyPage;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PGC timeline').last);
    await tester.pumpAndSettle();

    expect(find.text('Published show · Episode 1'), findsOneWidget);
    expect(find.text('Published'), findsOneWidget);
    expect(find.text('Delayed until Friday'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('bilibili-playlist-preview')),
    );
    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();

    expect(requestedIntent?.mode, BilibiliPlaylistListMode.pgcTimeline);
    expect(requestedIntent?.timelineType, BilibiliPgcTimelineKind.anime);
    expect(requestedIntent?.beforeDays, 3);
    expect(requestedIntent?.afterDays, 7);
  });

  testWidgets('filters PGC index and previews a selected season source', (
    tester,
  ) async {
    BilibiliPlaylistListIntent? requestedIntent;
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
        source: testDiscoveredPlaylistSource(),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
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
            loader: (intent, page, pageSize, cursor, instance, shared) async {
              requestedIntent = intent;
              return _emptyPage;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-playlist-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PGC index').last);
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

    final pgcPagination = find.byKey(
      const Key('bilibili-pgc-index-pagination'),
    );
    await tester.ensureVisible(pgcPagination);
    await tester.tap(
      find.descendant(
        of: pgcPagination,
        matching: find.byIcon(Icons.chevron_right_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Indexed season'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('bilibili-pgc-season-52')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const Key('bilibili-playlist-preview')),
    );
    await tester.tap(find.byKey(const Key('bilibili-playlist-preview')));
    await tester.pumpAndSettle();

    expect(requestedIntent?.mode, BilibiliPlaylistListMode.pgcSeason);
    expect(requestedIntent?.seasonId, 52);
  });

  testWidgets('uses the dynamic playlist policy and saves its selected mode', (
    tester,
  ) async {
    final gateway = _BilibiliPolicyGateway();
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    final playlistSource = _bilibiliPlaylistSource();

    await tester.binding.setSurfaceSize(const Size(900, 1000));
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
            body: BilibiliPlaylistForm(
              roomId: 'room',
              parentId: 'root',
              binds: const [],
              target: ProviderAddTarget.playlist,
              proxyMode: mode,
              onProxyModeChanged: (value) => setState(() => mode = value),
              onDraftChanged: (_) {},
              loader: (_, _, _, _, _, _) async => BilibiliPlaylistListPage(
                items: const [],
                hasMore: false,
                page: 1,
                cursor: null,
                source: playlistSource,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('bilibili-playback-proxy-mode')),
      findsOneWidget,
    );
    expect(gateway.policySources, contains(playlistSource));

    await _selectProxyOnly(tester);
    await tester.tap(find.byKey(const Key('discovery-add-current-list')));
    await tester.pump();

    expect(
      gateway.addedSources.single.playlist.bilibili.proxyMode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('uses a selected media source for policy lookup and submission', (
    tester,
  ) async {
    final gateway = _BilibiliPolicyGateway();
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    final playlistSource = _bilibiliPlaylistSource();
    final mediaSource = _bilibiliMediaSource();

    await tester.binding.setSurfaceSize(const Size(900, 1000));
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
            body: BilibiliPlaylistForm(
              roomId: 'room',
              parentId: 'root',
              binds: const [],
              target: ProviderAddTarget.media,
              proxyMode: mode,
              onProxyModeChanged: (value) => setState(() => mode = value),
              onDraftChanged: (_) {},
              loader: (_, _, _, _, _, _) async => BilibiliPlaylistListPage(
                items: [
                  BilibiliPlaylistListItemInfo(
                    id: 'current-video',
                    title: 'Current video',
                    description: '',
                    cover: '',
                    isContainer: false,
                    source: mediaSource,
                    browse: null,
                  ),
                ],
                hasMore: false,
                page: 1,
                cursor: null,
                source: playlistSource,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(gateway.policySources, contains(playlistSource));
    await tester.tap(
      find.byKey(const ValueKey('discovery-item-current-video')),
    );
    await tester.pumpAndSettle();
    expect(gateway.policySources, contains(mediaSource));

    await _selectProxyOnly(tester);
    await tester.tap(find.byKey(const Key('discovery-add-selected')));
    await tester.pump();

    expect(
      gateway.addedSources.single.media.bilibili.proxyMode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
    await tester.pump(const Duration(seconds: 4));
  });
}

class _BilibiliPolicyGateway implements ProviderGateway {
  final List<provider_common.DiscoveredSource> policySources = [];
  final List<provider_common.DiscoveredSource> addedSources = [];

  @override
  Future<provider_common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    provider_common.DiscoveredSource source,
  ) async {
    policySources.add(source);
    return provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );
  }

  @override
  Future<String> addDiscoveredSource(
    String roomId, {
    required provider_common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) async {
    addedSources.add(source.deepCopy());
    return 'media-id';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

provider_common.DiscoveredSource _bilibiliPlaylistSource() =>
    provider_common.DiscoveredSource(
      playlist: source_config.PlaylistSourceConfig(
        bilibili: source_config.BilibiliPlaylistSourceConfig(
          popular: source_config.BilibiliPopularPlaylistSource(),
        ),
      ),
    );

provider_common.DiscoveredSource _bilibiliMediaSource() =>
    provider_common.DiscoveredSource(
      media: source_config.MediaSourceConfig(
        bilibili: source_config.BilibiliMediaSourceConfig(
          video: source_config.BilibiliVideoSourceConfig(
            bvid: 'BV1policytest',
            cid: Int64(1),
          ),
        ),
      ),
    );

Future<void> _selectProxyOnly(WidgetTester tester) async {
  final selector = find.byKey(const Key('playback-proxy-mode-dropdown'));
  await tester.ensureVisible(selector);
  await tester.tap(selector);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Proxy only').last);
  await tester.pumpAndSettle();
}

final _emptyPage = BilibiliPlaylistListPage(
  items: const [],
  hasMore: false,
  page: 1,
  cursor: null,
  source: testDiscoveredPlaylistSource(),
);

BilibiliPlaylistListPage _pageWithItem(String title) =>
    BilibiliPlaylistListPage(
      items: [
        BilibiliPlaylistListItemInfo(
          id: title,
          title: title,
          description: 'Description',
          cover: '',
          isContainer: false,
          source: testDiscoveredPlaylistSource(),
          browse: null,
        ),
      ],
      hasMore: false,
      page: 1,
      cursor: null,
      source: testDiscoveredPlaylistSource(),
    );
