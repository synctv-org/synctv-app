import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/twitch.pb.dart'
    as twitch;
import 'package:synctv_app/src/generated/proto/providers/twitch.pbenum.dart'
    as twitch_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/features/media_library/presentation/add_media/twitch_add_media_form.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('Twitch media preview exposes native metadata and qualities', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TwitchAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onResolve: (request) async => twitch.ResolveResponse(
              kind: twitch_enum.ResourceKind.RESOURCE_KIND_VIDEO,
              metadata: twitch.Metadata(
                id: '1234',
                title: 'Twitch VOD',
                author: 'Streamer',
                chapters: [
                  twitch.Chapter(
                    title: 'Chapter',
                    startSeconds: Int64.ZERO,
                    endSeconds: Int64(120),
                  ),
                ],
                storyboardUrl: 'https://img/storyboard.jpg',
              ),
              qualities: [
                twitch.Quality(name: '1080p60'),
                twitch.Quality(name: '720p60'),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('twitch-resource')),
      'https://www.twitch.tv/videos/1234',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('twitch-preview')));
    await tester.pumpAndSettle();

    expect(find.text('Twitch VOD'), findsOneWidget);
    expect(find.textContaining('2 qualities'), findsOneWidget);
    expect(find.textContaining('1 chapters'), findsOneWidget);
    expect(find.textContaining('Storyboard'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.text('Twitch VOD'), findsOneWidget);
  });

  testWidgets('Twitch channel form submits clips playlist and shared scope', (
    tester,
  ) async {
    TwitchAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TwitchAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('twitch-source')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Channel archive').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('twitch-resource')),
      'https://www.twitch.tv/streamer',
    );
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clips').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('twitch-submit')));
    await tester.tap(find.byKey(const Key('twitch-submit')));
    await tester.pumpAndSettle();

    expect(submitted, isNotNull);
    expect(submitted!.playlist, isTrue);
    expect(
      submitted!.content,
      source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_CLIPS,
    );
    expect(submitted!.shared, isTrue);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Twitch followed live previews streams and submits typed mode', (
    tester,
  ) async {
    TwitchAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TwitchAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
            onListFollowedLive: (request) async =>
                twitch.ListFollowedLiveResponse(
                  items: [
                    twitch.StreamItem(
                      channel: 'synctv',
                      displayName: 'SyncTV',
                      title: 'Building SyncTV',
                      categoryName: 'Development',
                      viewerCount: Int64(42),
                    ),
                  ],
                  sourceConfig: source_config.TwitchPlaylistSourceConfig(
                    followedLive:
                        source_config.TwitchPlaylistSourceConfig_FollowedLive(),
                  ),
                ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('twitch-source')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Followed live').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('twitch-preview')));
    await tester.pumpAndSettle();

    expect(find.text('Building SyncTV'), findsOneWidget);
    expect(find.textContaining('42 viewers'), findsOneWidget);

    await tester.tap(find.byKey(const Key('twitch-submit')));
    await tester.pumpAndSettle();
    expect(submitted?.mode, TwitchAddMode.followedLive);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Twitch category discovery selects a native category', (
    tester,
  ) async {
    TwitchAddRequest? previewed;
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TwitchAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onListTopCategories: (request) async =>
                twitch.ListTopCategoriesResponse(
                  items: [
                    twitch.CategoryItem(id: 'game-1', name: 'Development'),
                  ],
                ),
            onListCategoryStreams: (request) async {
              previewed = request;
              return twitch.ListCategoryStreamsResponse(
                items: [
                  twitch.StreamItem(
                    channel: 'synctv',
                    displayName: 'SyncTV',
                    title: 'Rust release',
                    categoryName: 'Development',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('twitch-source')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Category live').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('twitch-load-categories')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('twitch-category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Development').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('twitch-preview')));
    await tester.pumpAndSettle();

    expect(previewed?.categoryId, 'game-1');
    expect(previewed?.categoryName, 'Development');
    expect(find.text('Rust release'), findsOneWidget);
  });

  testWidgets('Twitch live search can preview a broadcaster schedule', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TwitchAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onSearchLiveChannels: (request) async =>
                twitch.SearchLiveChannelsResponse(
                  items: [
                    twitch.SearchChannelItem(
                      userId: 'user-1',
                      channel: 'synctv',
                      displayName: 'SyncTV',
                      title: 'Live now',
                      categoryName: 'Development',
                      isLive: true,
                    ),
                  ],
                ),
            onListSchedule: (request, broadcasterId) async {
              expect(broadcasterId, 'user-1');
              return twitch.ListScheduleResponse(
                broadcasterLogin: 'synctv',
                segments: [
                  twitch.ScheduleSegment(
                    id: 'segment-1',
                    title: 'Release stream',
                    startTime: '2026-07-15T00:00:00Z',
                    categoryName: 'Development',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('twitch-source')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search live').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('twitch-resource')), 'sync');
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('twitch-preview')));
    await tester.tap(find.byKey(const Key('twitch-preview')));
    await tester.pumpAndSettle();
    expect(find.text('Live now'), findsOneWidget);

    await tester.tap(byAppTooltip('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Release stream'), findsOneWidget);
  });
}
