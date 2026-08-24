import 'dart:async';
import 'dart:ui' as ui;

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media_dialog.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import '../../../test_app.dart';

void main() {
  testWidgets('slow provider does not block another media source', (
    tester,
  ) async {
    tester.view.physicalSize = const ui.Size(1300, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final gateway = _PartiallyHangingGateway();

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => buildThemedTestApp(
          context,
          DependencyScope<ProviderGateway>(value: gateway, child: child!),
        ),
        home: const Scaffold(
          body: AddMediaDialog(roomId: 'room_nonblocking_test'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.enterText(
      find.byType(TextField).at(1),
      'https://media.example.test/video.mp4',
    );
    expect(find.byKey(const Key('direct-url-preview')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('add-media-source-tile-4')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Directory password'), findsOneWidget);
    expect(find.text('No files'), findsOneWidget);
    expect(find.byType(AppLinearProgress), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('direct links require prepare and support partial selection', (
    tester,
  ) async {
    final gateway = _PrepareGateway();
    await _pumpDialog(tester, gateway);

    expect(find.byKey(const Key('discovery-add-selected')), findsNothing);
    await tester.enterText(
      find.byType(EditableText).first,
      'media.example.test/one.mp4\nhttps://media.example.test/two.m3u8',
    );
    await _tapVisible(tester, find.byKey(const Key('direct-url-preview')));
    await tester.pumpAndSettle();

    expect(gateway.directIntents, hasLength(2));
    expect(gateway.directIntents.first.url, 'media.example.test/one.mp4');
    expect(
      gateway.directIntents.last.url,
      'https://media.example.test/two.m3u8',
    );
    expect(
      gateway.directIntents
          .map((intent) => intent.proxyMode)
          .every(
            (mode) =>
                mode == source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
          ),
      isTrue,
    );
    expect(find.text('Selected 2'), findsOneWidget);
    await _selectProxyMode(tester, 'Proxy only');

    await tester.enterText(find.byType(EditableText).at(1), 'Custom name');
    await tester.pump();
    expect(find.byKey(const Key('discovery-add-selected')), findsOneWidget);

    await _tapVisible(tester, find.text('Live'));
    await tester.pump();
    expect(find.byKey(const Key('discovery-add-selected')), findsNothing);

    await _tapVisible(tester, find.text('On demand'));
    await _tapVisible(tester, find.byKey(const Key('direct-url-preview')));
    await tester.pumpAndSettle();
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('discovery-item-direct-1')),
    );
    await tester.pump();
    expect(find.text('Selected 1'), findsOneWidget);

    await _tapVisible(tester, find.byKey(const Key('discovery-add-selected')));
    await tester.pump();
    expect(gateway.addedSources, hasLength(1));
    expect(
      gateway.addedSources.single.media.directUrl.medias.single.url,
      'media.example.test/one.mp4',
    );
    expect(
      gateway.addedSources.single.media.directUrl.proxyMode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
    );
    expect(gateway.addedNames.single, 'Custom name');
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('RTMP submit uses the media id returned by discovered add', (
    tester,
  ) async {
    final gateway = _PrepareGateway();
    await _pumpDialog(tester, gateway);
    await _selectSource(tester, 1);

    final submit = find.byKey(const Key('rtmp-submit'));
    expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);

    await tester.enterText(find.byType(EditableText).first, 'Studio camera');
    await tester.pump();
    expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);
    await _tapVisible(tester, submit);
    await tester.pump();

    expect(gateway.rtmpModes, [
      source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT,
    ]);
    expect(gateway.publishMediaIds, ['media_server_42']);
    expect(gateway.publishKeyTypes, [
      client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
    ]);
    expect(gateway.publishExpiresAt.single, isNotNull);
    expect(gateway.streamInfoMediaIds, isEmpty);
    expect(gateway.addedNames, ['Studio camera']);
  });

  testWidgets('RTMP permanent key omits expiration', (tester) async {
    final gateway = _PrepareGateway();
    await _pumpDialog(tester, gateway);
    await _selectSource(tester, 1);

    await _tapVisible(tester, find.byKey(const Key('rtmp-publish-key-type')));
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.text('Never expires').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('rtmp-publish-key-expiration')), findsNothing);
    await _tapVisible(tester, find.byKey(const Key('rtmp-submit')));
    await tester.pump();

    expect(gateway.publishKeyTypes, [
      client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT,
    ]);
    expect(gateway.publishExpiresAt, [null]);
  });

  testWidgets('RTMP key failure does not leave a duplicate creation form', (
    tester,
  ) async {
    final gateway = _PrepareGateway(publishKeyError: StateError('offline'));
    await _pumpDialog(tester, gateway);
    await _selectSource(tester, 1);

    await _tapVisible(tester, find.byKey(const Key('rtmp-submit')));
    await tester.pumpAndSettle();

    expect(gateway.addedSources, hasLength(1));
    expect(gateway.publishMediaIds, ['media_server_42']);
    expect(find.byKey(const Key('rtmp-submit')), findsNothing);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('RTMP expired key does not create media', (tester) async {
    final gateway = _PrepareGateway();
    var now = DateTime(2026, 1, 1, 12);
    await _pumpDialog(tester, gateway, now: () => now);
    await _selectSource(tester, 1);

    now = now.add(const Duration(hours: 2));
    await _tapVisible(tester, find.byKey(const Key('rtmp-submit')));
    await tester.pump();

    expect(gateway.addedSources, isEmpty);
    expect(gateway.publishMediaIds, isEmpty);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('live proxy protocol changes invalidate prepared source', (
    tester,
  ) async {
    final gateway = _PrepareGateway();
    await _pumpDialog(tester, gateway);
    await _selectSource(tester, 2);

    final submit = find.byKey(const Key('live-proxy-submit'));
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
    await tester.enterText(
      find.byType(EditableText).first,
      'rtmp://upstream.example.test/live/room',
    );
    await _tapVisible(tester, find.byKey(const Key('live-proxy-preview')));
    await tester.pumpAndSettle();

    expect(gateway.liveIntents, hasLength(1));
    expect(
      gateway.liveIntents.single.rtmp.url,
      'rtmp://upstream.example.test/live/room',
    );
    expect(find.text('Live proxy preview'), findsOneWidget);
    expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);

    await _tapVisible(tester, find.text('RTSP'));
    await tester.pump();
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);
    expect(find.text('Live proxy preview'), findsNothing);
  });

  testWidgets('Bilibili parse playlist lists items before multi-select add', (
    tester,
  ) async {
    final gateway = _BilibiliPolicyGateway();
    await _pumpDialog(tester, gateway);
    await _selectSource(tester, 3);
    expect(find.byKey(const Key('bilibili-playback-proxy-mode')), findsNothing);

    await tester.enterText(
      find.byType(EditableText).first,
      'https://www.bilibili.com/video/BV1typed',
    );
    await _tapVisible(tester, find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    expect(gateway.bilibiliParseResources, [
      'https://www.bilibili.com/video/BV1typed',
    ]);
    expect(
      find.byKey(const Key('bilibili-playback-proxy-mode')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('bilibili-candidate-preview')), findsOneWidget);
    expect(find.byKey(const Key('discovery-add-selected')), findsNothing);

    await _tapVisible(
      tester,
      find.byKey(const Key('bilibili-candidate-preview')),
    );
    await tester.pumpAndSettle();
    expect(
      gateway.bilibiliListIntents.single.mode,
      BilibiliPlaylistListMode.videoParts,
    );
    expect(
      gateway.policySources.any(
        (source) => source.hasPlaylist() && source.playlist.hasBilibili(),
      ),
      isTrue,
    );
    expect(find.text('Selected 0'), findsOneWidget);

    await _tapVisible(tester, find.byKey(const Key('discovery-select-all')));
    await tester.pumpAndSettle();
    expect(find.text('Selected 2'), findsOneWidget);
    expect(
      gateway.policySources.any(
        (source) => source.hasMedia() && source.media.hasBilibili(),
      ),
      isTrue,
    );
    final playbackModeControl = find.byKey(
      const Key('bilibili-playback-proxy-mode'),
      skipOffstage: false,
    );
    await tester.ensureVisible(playbackModeControl);
    await tester.pumpAndSettle();
    expect(playbackModeControl, findsOneWidget);
    expect(find.text('Automatic'), findsOneWidget);
    await _selectProxyMode(tester, 'Proxy only');
    await _tapVisible(tester, find.byKey(const Key('discovery-add-selected')));
    await tester.pump();

    expect(gateway.addedSources, hasLength(2));
    expect(gateway.addedSources.every((source) => source.hasMedia()), isTrue);
    expect(
      gateway.addedSources.map((source) => source.media.bilibili.proxyMode),
      everyElement(source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY),
    );
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Bilibili parse playlist can add the dynamic list source', (
    tester,
  ) async {
    final gateway = _PrepareGateway();
    await _pumpDialog(tester, gateway);
    await _selectSource(tester, 3);
    await tester.enterText(
      find.byType(EditableText).first,
      'https://www.bilibili.com/video/BV1typed',
    );
    await _tapVisible(tester, find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();
    await _tapVisible(
      tester,
      find.byKey(const Key('bilibili-candidate-preview')),
    );
    await tester.pumpAndSettle();

    await _tapVisible(tester, find.text('Dynamic playlist').last);
    await tester.pumpAndSettle();

    await _tapVisible(
      tester,
      find.byKey(const Key('discovery-add-current-list')),
    );
    await tester.pump();
    expect(gateway.addedSources, hasLength(1));
    expect(gateway.addedSources.single.hasPlaylist(), isTrue);
    await tester.pump(const Duration(seconds: 4));
  });
}

Future<void> _pumpDialog(
  WidgetTester tester,
  ProviderGateway gateway, {
  DateTime Function()? now,
}) async {
  tester.view.physicalSize = const ui.Size(430, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => buildThemedTestApp(
        context,
        DependencyScope<ProviderGateway>(value: gateway, child: child!),
      ),
      home: Scaffold(
        body: AddMediaDialog(
          roomId: 'room_prepare_test',
          now: now ?? DateTime.now,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _selectSource(WidgetTester tester, int index) async {
  final selector = find.byKey(const ValueKey('add-media-source-selector-0'));
  final rect = tester.getRect(selector);
  await tester.tapAt(Offset(rect.right - 24, rect.center.dy));
  await tester.pumpAndSettle();
  for (var step = 0; step < index; step += 1) {
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  }
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}

Future<void> _selectProxyMode(WidgetTester tester, String label) async {
  final dropdown = find.byKey(
    const Key('playback-proxy-mode-dropdown'),
    skipOffstage: false,
  );
  if (dropdown.evaluate().isNotEmpty) {
    await _tapVisible(tester, dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
  } else {
    await _tapVisible(tester, find.text(label));
  }
  await tester.pumpAndSettle();
}

class _PrepareGateway implements ProviderGateway {
  _PrepareGateway({this.publishKeyError});

  final Object? publishKeyError;
  final List<provider_common.PrepareDirectUrlRequest> directIntents = [];
  final List<provider_common.PrepareLiveProxyRequest> liveIntents = [];
  final List<source_enum.RtmpStreamMode> rtmpModes = [];
  final List<provider_common.DiscoveredSource> addedSources = [];
  final List<String> addedNames = [];
  final List<String> publishMediaIds = [];
  final List<client_enum.PublishKeyType> publishKeyTypes = [];
  final List<int?> publishExpiresAt = [];
  final List<String> streamInfoMediaIds = [];
  final List<String> bilibiliParseResources = [];
  final List<BilibiliPlaylistListIntent> bilibiliListIntents = [];

  @override
  Future<provider_common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    provider_common.DiscoveredSource source,
  ) async => provider_common.PlaybackProxyPolicy(
    supportedModes: [
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
    ],
    currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
  );

  @override
  Future<provider_common.PreparedMediaSource> prepareDirectUrl(
    provider_common.PrepareDirectUrlRequest intent,
  ) async {
    directIntents.add(intent.deepCopy());
    return provider_common.PreparedMediaSource(
      source: provider_common.DiscoveredSource(
        media: source_config.MediaSourceConfig(
          directUrl: source_config.DirectUrlMediaSourceConfig(
            medias: [
              source_config.DirectUrlMediaResourceConfig(url: intent.url),
            ],
            playbackKind: intent.playbackKind,
            proxyMode: intent.proxyMode,
          ),
        ),
      ),
      suggestedName: intent.url.split('/').last,
      playbackKind: intent.playbackKind,
    );
  }

  @override
  Future<provider_common.PreparedMediaSource> prepareRtmp(
    source_enum.RtmpStreamMode mode,
  ) async {
    rtmpModes.add(mode);
    return provider_common.PreparedMediaSource(
      source: provider_common.DiscoveredSource(
        media: source_config.MediaSourceConfig(
          rtmp: source_config.RtmpMediaSourceConfig(mode: mode),
        ),
      ),
      suggestedName: 'RTMP preview',
      playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
    );
  }

  @override
  Future<provider_common.PreparedMediaSource> prepareLiveProxy(
    provider_common.PrepareLiveProxyRequest intent,
  ) async {
    liveIntents.add(intent.deepCopy());
    return provider_common.PreparedMediaSource(
      source: provider_common.DiscoveredSource(
        media: source_config.MediaSourceConfig(
          liveProxy: source_config.LiveProxyMediaSourceConfig(
            rtmp: source_config.RtmpPullSourceConfig(
              url: intent.rtmp.url,
              mode: intent.rtmp.mode,
            ),
          ),
        ),
      ),
      suggestedName: 'Live proxy preview',
      playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
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
    addedNames.add(name);
    return 'media_server_42';
  }

  @override
  Future<RtmpPublishKeyInfo> createRtmpPublishKeyInfo(
    String roomId,
    String mediaId, {
    required client_enum.PublishKeyType keyType,
    int? expiresAt,
  }) async {
    publishMediaIds.add(mediaId);
    publishKeyTypes.add(keyType);
    publishExpiresAt.add(expiresAt);
    if (publishKeyError case final error?) throw error;
    return const RtmpPublishKeyInfo(
      publishKey: 'publish-key',
      rtmpUrl: 'rtmp://publish.example.test/live',
      streamKey: 'stream-key',
      expiresAt: 1900000000,
      keyType: client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
    );
  }

  @override
  Future<RoomStreamEntryInfo> getRtmpStreamInfo({
    required String roomId,
    required String mediaId,
  }) async {
    streamInfoMediaIds.add(mediaId);
    return RoomStreamEntryInfo(mediaId: mediaId, active: false);
  }

  @override
  Future<BilibiliParseInfo> parseBilibiliInfo(
    String url, {
    String instanceName = '',
    bool shared = false,
  }) async {
    bilibiliParseResources.add(url);
    return BilibiliParseInfo(
      normalizedUrl: url,
      candidates: [
        BilibiliParseCandidateInfo(
          title: 'All video parts',
          description: 'Two prepared parts',
          cover: '',
          actors: const ['Uploader'],
          durationSeconds: null,
          partNumber: null,
          width: null,
          height: null,
          source: _bilibiliPlaylistSource(),
          browse: const BilibiliPlaylistListIntent(
            mode: BilibiliPlaylistListMode.videoParts,
            bvid: 'BV1typed',
          ),
        ),
      ],
    );
  }

  @override
  Future<BilibiliPlaylistListPage> listBilibiliPlaylist(
    BilibiliPlaylistListIntent intent, {
    int page = 1,
    int pageSize = 30,
    String? cursor,
    String search = '',
    String instanceName = '',
    bool shared = false,
  }) async {
    bilibiliListIntents.add(intent);
    return BilibiliPlaylistListPage(
      items: [
        BilibiliPlaylistListItemInfo(
          id: 'part-1',
          title: 'Part 1',
          description: 'First part',
          cover: '',
          isContainer: false,
          source: _bilibiliMediaSource('BV1typed', 1),
          browse: null,
        ),
        BilibiliPlaylistListItemInfo(
          id: 'part-2',
          title: 'Part 2',
          description: 'Second part',
          cover: '',
          isContainer: false,
          source: _bilibiliMediaSource('BV1typed', 2),
          browse: null,
        ),
      ],
      hasMore: false,
      page: page,
      cursor: null,
      source: _bilibiliPlaylistSource(),
    );
  }

  @override
  Future<List<AlistBindInfo>> getAllAlistBindInfos() async => [];
  @override
  Future<List<EmbyBindInfo>> getAllEmbyBindInfos() async => [];
  @override
  Future<List<BilibiliBindInfo>> getAllBilibiliBindInfos() async => [];
  @override
  Future<List<CloudreveBindInfo>> getAllCloudreveBindInfos() async => [];
  @override
  Future<List<TwitchBindInfo>> getAllTwitchBindInfos() async => [];
  @override
  Future<List<FnosBindInfo>> getAllFnosBindInfos() async => [];
  @override
  Future<List<QnapBindInfo>> getAllQnapBindInfos() async => [];
  @override
  Future<List<SynologyBindInfo>> getAllSynologyBindInfos() async => [];
  @override
  Future<List<NextcloudBindInfo>> getAllNextcloudBindInfos() async => [];
  @override
  Future<List<SeafileBindInfo>> getAllSeafileBindInfos() async => [];
  @override
  Future<List<TrueNasBindInfo>> getAllTrueNasBindInfos() async => [];
  @override
  Future<List<YoutubeBindInfo>> getAllYoutubeBindInfos() async => [];
  @override
  Future<List<DouyinBindInfo>> getAllDouyinBindInfos() async => [];
  @override
  Future<List<TikTokBindInfo>> getAllTikTokBindInfos() async => [];
  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async => [];

  @override
  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false}) async =>
      const PublicSettingsInfo(
        roomCreationEnabled: true,
        maxRoomsPerUser: 10,
        defaultMaxMembers: 10,
        roomCreationApprovalRequired: false,
        roomPasswordPolicy:
            common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_OPTIONAL,
        enablePasswordSignup: true,
        passwordSignupNeedReview: false,
        enableEmailSignup: false,
        enableEmail: false,
        enableGuest: true,
        emailSignupNeedReview: false,
        enableWebauthn: false,
        webauthnRpId: '',
        enableWebauthnSignup: false,
        webauthnSignupNeedReview: false,
        emailWhitelistEnabled: false,
        emailWhitelistDomains: [],
        tsDisguisedAsPng: false,
        rtmpAdvertiseAddress: null,
      );

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _PartiallyHangingGateway extends _PrepareGateway {
  final Completer<List<EmbyBindInfo>> _embyBinds = Completer();

  @override
  Future<List<AlistBindInfo>> getAllAlistBindInfos() async => const [
    AlistBindInfo(
      id: 'alist-bind',
      serverId: 'alist-server',
      host: 'https://alist.example.test',
      username: 'tester',
      createdAt: 1,
      providerInstanceName: '',
    ),
  ];

  @override
  Future<List<EmbyBindInfo>> getAllEmbyBindInfos() => _embyBinds.future;

  @override
  Future<AlistListPage> listAlistPage(
    String path, {
    String? keyword,
    int page = 1,
    int max = 20,
    String password = '',
    String serverId = '',
    String instanceName = '',
  }) async => AlistListPage(
    serverId: serverId,
    providerInstanceName: instanceName,
    items: const [],
    total: 0,
    source: null,
  );
}

class _BilibiliPolicyGateway extends _PrepareGateway {
  final List<provider_common.DiscoveredSource> policySources = [];

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
}

provider_common.DiscoveredSource _bilibiliMediaSource(String bvid, int cid) =>
    provider_common.DiscoveredSource(
      media: source_config.MediaSourceConfig(
        bilibili: source_config.BilibiliMediaSourceConfig(
          video: source_config.BilibiliVideoSourceConfig(
            bvid: bvid,
            cid: Int64(cid),
          ),
        ),
      ),
    );

provider_common.DiscoveredSource _bilibiliPlaylistSource() =>
    provider_common.DiscoveredSource(
      playlist: source_config.PlaylistSourceConfig(
        bilibili: source_config.BilibiliPlaylistSourceConfig(
          videoParts: source_config.BilibiliVideoPartsPlaylistSource(
            bvid: 'BV1typed',
          ),
        ),
      ),
    );
