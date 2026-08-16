import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('lists a playlist URL before submitting the discovered source', (
    tester,
  ) async {
    YoutubeAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: YoutubeAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [
              YoutubeBindInfo(
                id: '1',
                serverId: 'youtube-default',
                label: 'Browser',
                hasVisitorData: true,
                hasPoToken: true,
                hasCookie: true,
                createdAt: 1,
                providerInstanceName: '',
              ),
            ],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
            onList: (request) async {
              expect(
                request.playlist.resource,
                contains('playlist?list=PL123'),
              );
              return youtube.ListResponse(source: _youtubePlaylistSource());
            },
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('youtube-value')),
      'dQw4w9WgXcQ',
    );
    await _selectTarget(tester, 'Dynamic playlist');
    await _selectMode(tester, 'Playlist');
    expect(
      tester
          .widget<AppTextField>(find.byKey(const Key('youtube-value')))
          .controller
          .text,
      isEmpty,
    );
    await tester.enterText(
      find.byKey(const Key('youtube-value')),
      'https://www.youtube.com/playlist?list=PL123',
    );
    await tester.enterText(find.byKey(const Key('youtube-name')), 'Favorites');
    await tester.tap(find.text('Share my credentials'));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('youtube-submit')))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byKey(const Key('youtube-preview')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('youtube-submit')));
    await tester.pumpAndSettle();

    expect(submitted, isNotNull);
    expect(submitted!.mode, YoutubeAddMode.playlist);
    expect(submitted!.value, 'https://www.youtube.com/playlist?list=PL123');
    expect(submitted!.name, 'Favorites');
    expect(submitted!.shared, isTrue);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('requires a Cookie capability for personal feeds', (
    tester,
  ) async {
    YoutubeAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: YoutubeAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [
              YoutubeBindInfo(
                id: '1',
                serverId: 'visitor-only',
                label: 'Visitor only',
                hasVisitorData: true,
                hasPoToken: false,
                hasCookie: false,
                createdAt: 1,
                providerInstanceName: '',
              ),
            ],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
            onList: (_) async =>
                youtube.ListResponse(source: _youtubePlaylistSource()),
          ),
        ),
      ),
    );

    await _selectTarget(tester, 'Dynamic playlist');
    await _selectMode(tester, 'Subscriptions');
    final submit = tester.widget<FilledButton>(
      find.byKey(const Key('youtube-submit')),
    );
    expect(submit.onPressed, isNull);

    await tester.tap(find.text('Share my credentials'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('youtube-preview')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('youtube-submit')));
    await tester.pumpAndSettle();
    expect(submitted?.mode, YoutubeAddMode.subscriptions);
    expect(submitted?.shared, isTrue);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('submits a specific channel tab', (tester) async {
    YoutubeAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: YoutubeAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
            onList: (request) async {
              expect(request.channel.resource, contains('/channel/'));
              return youtube.ListResponse(source: _youtubePlaylistSource());
            },
          ),
        ),
      ),
    );

    await _selectTarget(tester, 'Dynamic playlist');
    await _selectMode(tester, 'Channel');
    await tester.tap(find.text('Shorts'));
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('youtube-value')),
      'https://www.youtube.com/channel/UC1234567890123456789012/shorts',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('youtube-preview')));
    await tester.tap(find.byKey(const Key('youtube-preview')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('youtube-submit')));
    await tester.tap(find.byKey(const Key('youtube-submit')));
    await tester.pumpAndSettle();
    expect(submitted?.mode, YoutubeAddMode.channel);
    expect(submitted?.channelMode, YoutubeChannelMode.shorts);
    expect(
      submitted?.value,
      'https://www.youtube.com/channel/UC1234567890123456789012/shorts',
    );
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('invalidates a video preview when credential scope changes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: YoutubeAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onResolve: (request) async => youtube.ResolveResponse(
              metadata: youtube.Metadata(
                videoId: request.value,
                title: 'YouTube video',
                channelName: 'Creator',
                thumbnailUrl: 'https://img.example/video.jpg',
              ),
              formats: [youtube.Format(name: '1080p')],
              subtitleCount: 1,
              source: _youtubeMediaSource(request.value),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('youtube-value')),
      'https://youtu.be/abcdefghijk',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('youtube-preview')));
    await tester.tap(find.byKey(const Key('youtube-preview')));
    await tester.pumpAndSettle();

    expect(find.text('YouTube video'), findsOneWidget);
    expect(find.textContaining('1 formats'), findsOneWidget);
    expect(find.textContaining('1 subtitles'), findsOneWidget);

    await tester.tap(find.text('Share my credentials'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('YouTube video'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('youtube-submit')))
          .onPressed,
      isNull,
    );
  });
}

provider_common.DiscoveredSource _youtubeMediaSource(String videoId) =>
    provider_common.DiscoveredSource(
      media: source_config.MediaSourceConfig(
        youtube: source_config.YoutubeMediaSourceConfig(videoId: videoId),
      ),
    );

provider_common.DiscoveredSource _youtubePlaylistSource() =>
    provider_common.DiscoveredSource(
      playlist: source_config.PlaylistSourceConfig(
        youtube: source_config.YoutubePlaylistSourceConfig(
          search: source_config.YoutubePlaylistSourceConfig_Search(
            query: 'test',
          ),
        ),
      ),
    );

Future<void> _selectMode(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(const Key('youtube-mode')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _selectTarget(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}
