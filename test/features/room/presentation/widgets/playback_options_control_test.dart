import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_options_control.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';

void main() {
  testWidgets('opens playback options above the player control', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const mode = SyncTvPlaybackModeOption(
      key: 'main',
      urls: [SyncTvPlaybackUrlOption(name: '1080P', url: 'https://a')],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PlaybackOptionsControl(
                modes: const [mode],
                selectedModeKey: 'main',
                selectedMediaIndex: 0,
                adaptiveTracks: const AdaptiveVideoTrackSnapshot(),
                tooltip: 'Playback route',
                compact: true,
                onMediaSelected: (_, _) async {},
                onAdaptiveTrackSelected: (_) async {},
              ),
            ),
          ),
        ),
      ),
    );

    final button = find.byKey(const Key('playback_route_button_compact'));
    expect(tester.getSize(button), const Size.square(40));
    expect(
      find.descendant(of: button, matching: find.byType(DecoratedBox)),
      findsNothing,
    );
    await tester.tap(button);
    await tester.pumpAndSettle();

    final option = find.byKey(const Key('playback_media_option_main_0'));
    expect(option, findsOneWidget);
    expect(
      tester.getRect(option).bottom,
      lessThanOrEqualTo(tester.getRect(button).top),
    );
  });

  testWidgets('opens the route page and selects a route default media', (
    tester,
  ) async {
    SyncTvPlaybackModeOption? selectedMode;
    int? selectedMediaIndex;
    const modes = [
      SyncTvPlaybackModeOption(
        key: 'main',
        urls: [SyncTvPlaybackUrlOption(name: '1080P', url: 'https://a')],
      ),
      SyncTvPlaybackModeOption(
        key: 'backup_1',
        urls: [
          SyncTvPlaybackUrlOption(name: '720P', url: 'https://b/720'),
          SyncTvPlaybackUrlOption(name: '1080P', url: 'https://b/1080'),
        ],
        defaultUrlIndex: 1,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: PlaybackOptionsControl(
              modes: modes,
              selectedModeKey: 'main',
              selectedMediaIndex: 0,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(),
              tooltip: 'Playback route',
              onMediaSelected: (mode, mediaIndex) async {
                selectedMode = mode;
                selectedMediaIndex = mediaIndex;
              },
              onAdaptiveTrackSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();
    expect(find.text('Route'), findsOneWidget);
    expect(find.text('Quality and media links'), findsOneWidget);

    await tester.tap(find.byKey(const Key('playback_route_selector')));
    await tester.pumpAndSettle();
    expect(find.text('Choose route'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('playback_route_back_button')),
        matching: find.byIcon(Icons.arrow_back_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('playback_route_option_backup_1')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('playback_route_back_button')));
    await tester.pumpAndSettle();
    expect(find.text('Route'), findsOneWidget);
    expect(find.text('Quality and media links'), findsOneWidget);

    await tester.tap(find.byKey(const Key('playback_route_selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('playback_route_option_backup_1')));
    await tester.pumpAndSettle();
    expect(selectedMode?.key, 'backup_1');
    expect(selectedMediaIndex, 1);
  });

  testWidgets('selects a quality parsed from an adaptive manifest', (
    tester,
  ) async {
    String? selectedTrackId;
    const mode = SyncTvPlaybackModeOption(
      key: 'hls',
      urls: [
        SyncTvPlaybackUrlOption(name: 'HLS', url: 'https://a/master.m3u8'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: PlaybackOptionsControl(
              modes: const [mode],
              selectedModeKey: 'hls',
              selectedMediaIndex: 0,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(
                selectedTrackId: '720',
                tracks: [
                  AdaptiveVideoTrackInfo(id: '720', width: 1280, height: 720),
                  AdaptiveVideoTrackInfo(id: '1080', width: 1920, height: 1080),
                ],
              ),
              tooltip: 'Playback route',
              onMediaSelected: (_, _) async {},
              onAdaptiveTrackSelected: (trackId) async {
                selectedTrackId = trackId;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();
    expect(find.text('Manifest qualities'), findsOneWidget);
    expect(find.text('1920x1080'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const Key('adaptive_video_track_1080'))).dy,
      lessThan(
        tester.getTopLeft(find.byKey(const Key('adaptive_video_track_720'))).dy,
      ),
    );

    await tester.tap(find.byKey(const Key('adaptive_video_track_1080')));
    await tester.pumpAndSettle();
    expect(selectedTrackId, '1080');
  });

  testWidgets(
    'hides automatic quality when the runtime selects fixed HLS variants',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PlaybackOptionsControl(
              modes: const [
                SyncTvPlaybackModeOption(
                  key: 'hls',
                  urls: [
                    SyncTvPlaybackUrlOption(
                      name: 'HLS',
                      url: 'https://a/master.m3u8',
                    ),
                  ],
                ),
              ],
              selectedModeKey: 'hls',
              selectedMediaIndex: 0,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(
                automaticSelectionAvailable: false,
                selectedTrackId: 'hls:1:2000',
                tracks: [
                  AdaptiveVideoTrackInfo(id: 'hls:0:1000', width: 640),
                  AdaptiveVideoTrackInfo(id: 'hls:1:2000', width: 1280),
                ],
              ),
              tooltip: 'Playback route',
              onMediaSelected: (_, _) async {},
              onAdaptiveTrackSelected: (_) async {},
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('playback_route_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('adaptive_video_track_auto')), findsNothing);
      expect(
        find.byKey(const Key('adaptive_video_track_hls:1:2000')),
        findsOne,
      );
    },
  );

  testWidgets('shows multiple manifest URLs beside qualities within one URL', (
    tester,
  ) async {
    const mode = SyncTvPlaybackModeOption(
      key: 'hls',
      urls: [
        SyncTvPlaybackUrlOption(
          name: '主链接',
          url: 'https://a/main/master.m3u8',
          format: 'm3u8',
        ),
        SyncTvPlaybackUrlOption(
          name: '备用链接',
          url: 'https://a/backup/master.m3u8',
          format: 'm3u8',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: PlaybackOptionsControl(
              modes: const [mode],
              selectedModeKey: 'hls',
              selectedMediaIndex: 0,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(
                tracks: [
                  AdaptiveVideoTrackInfo(id: '360', width: 640, height: 360),
                  AdaptiveVideoTrackInfo(id: '720', width: 1280, height: 720),
                ],
              ),
              tooltip: 'Playback route',
              onMediaSelected: (_, _) async {},
              onAdaptiveTrackSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();

    expect(find.text('Quality and media links'), findsOneWidget);
    expect(find.text('主链接 · HLS'), findsOneWidget);
    expect(find.text('备用链接 · HLS'), findsOneWidget);
    expect(find.text('Manifest qualities'), findsOneWidget);
    expect(find.text('640x360'), findsOneWidget);
    expect(find.text('1280x720'), findsOneWidget);
  });

  testWidgets('shows the selected media format in the route summary', (
    tester,
  ) async {
    const mode = SyncTvPlaybackModeOption(
      key: 'direct',
      format: 'mp4',
      urls: [
        SyncTvPlaybackUrlOption(
          name: 'MP4',
          url: 'https://a/video.mp4',
          format: 'mp4',
        ),
        SyncTvPlaybackUrlOption(
          name: 'HLS',
          url: 'https://a/master.m3u8',
          format: 'hls',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: PlaybackOptionsControl(
              modes: const [
                mode,
                SyncTvPlaybackModeOption(
                  key: 'proxy_direct',
                  urls: [
                    SyncTvPlaybackUrlOption(
                      name: 'Proxy MP4',
                      url: 'https://proxy/video.mp4',
                      format: 'mp4',
                    ),
                  ],
                ),
              ],
              selectedModeKey: 'direct',
              selectedMediaIndex: 1,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(),
              tooltip: 'Playback route',
              onMediaSelected: (_, _) async {},
              onAdaptiveTrackSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Original · HLS'), findsOneWidget);

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();

    expect(find.text('Original · HLS'), findsNWidgets(2));
  });

  testWidgets('labels codec-specific Bilibili routes', (tester) async {
    const modes = [
      SyncTvPlaybackModeOption(
        key: 'h264',
        urls: [
          SyncTvPlaybackUrlOption(name: 'H.264', url: 'https://a/h264.mpd'),
        ],
      ),
      SyncTvPlaybackModeOption(
        key: 'av1',
        urls: [SyncTvPlaybackUrlOption(name: 'AV1', url: 'https://a/av1.mpd')],
      ),
      SyncTvPlaybackModeOption(
        key: 'hevc',
        urls: [
          SyncTvPlaybackUrlOption(name: 'HEVC', url: 'https://a/hevc.mpd'),
        ],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: PlaybackOptionsControl(
              modes: modes,
              selectedModeKey: 'h264',
              selectedMediaIndex: 0,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(),
              tooltip: 'Playback route',
              onMediaSelected: (_, _) async {},
              onAdaptiveTrackSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('playback_route_selector')));
    await tester.pumpAndSettle();

    expect(find.text('H.264'), findsWidgets);
    expect(find.text('AV1'), findsWidgets);
    expect(find.text('HEVC'), findsWidgets);
  });

  testWidgets('keeps the selected resource when switching proxy routes', (
    tester,
  ) async {
    SyncTvPlaybackModeOption? selectedMode;
    int? selectedMediaIndex;
    const direct = SyncTvPlaybackModeOption(
      key: 'direct',
      urls: [
        SyncTvPlaybackUrlOption(
          name: 'MP4 Faststart',
          url: 'https://origin/video.mp4',
          format: 'mp4',
          p2pDelivery: P2pResourceDelivery(
            swarmId: 'mp4-swarm',
            swarmTicket: 'direct-mp4',
          ),
        ),
        SyncTvPlaybackUrlOption(
          name: 'HLS VOD',
          url: 'https://origin/master.m3u8',
          format: 'hls',
          p2pDelivery: P2pResourceDelivery(
            swarmId: 'hls-swarm',
            swarmTicket: 'direct-hls',
          ),
        ),
        SyncTvPlaybackUrlOption(
          name: 'DASH VOD',
          url: 'https://origin/manifest.mpd',
          format: 'dash',
          p2pDelivery: P2pResourceDelivery(
            swarmId: 'dash-swarm',
            swarmTicket: 'direct-dash',
          ),
        ),
      ],
    );
    const proxy = SyncTvPlaybackModeOption(
      key: 'proxy_direct',
      urls: [
        SyncTvPlaybackUrlOption(
          name: 'MP4 Faststart',
          url: 'https://proxy/video.mp4',
          format: 'mp4',
          p2pDelivery: P2pResourceDelivery(
            swarmId: 'mp4-swarm',
            swarmTicket: 'proxy-mp4',
          ),
        ),
        SyncTvPlaybackUrlOption(
          name: 'HLS VOD',
          url: 'https://proxy/master.m3u8',
          format: 'hls',
          p2pDelivery: P2pResourceDelivery(
            swarmId: 'hls-swarm',
            swarmTicket: 'proxy-hls',
          ),
        ),
        SyncTvPlaybackUrlOption(
          name: 'DASH VOD',
          url: 'https://proxy/manifest.mpd',
          format: 'dash',
          p2pDelivery: P2pResourceDelivery(
            swarmId: 'dash-swarm',
            swarmTicket: 'proxy-dash',
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: PlaybackOptionsControl(
              modes: const [direct, proxy],
              selectedModeKey: 'direct',
              selectedMediaIndex: 2,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(),
              tooltip: 'Playback route',
              onMediaSelected: (mode, mediaIndex) async {
                selectedMode = mode;
                selectedMediaIndex = mediaIndex;
              },
              onAdaptiveTrackSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('playback_route_selector')));
    await tester.pumpAndSettle();

    expect(find.text('Original · DASH'), findsNWidgets(2));
    expect(find.text('Proxy · DASH'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('playback_route_option_proxy_direct')),
    );
    await tester.pumpAndSettle();
    expect(selectedMode?.key, 'proxy_direct');
    expect(selectedMediaIndex, 2);
  });

  testWidgets('preserves route identity for proxied live routes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const modes = [
      SyncTvPlaybackModeOption(
        key: 'proxy_main',
        urls: [
          SyncTvPlaybackUrlOption(
            name: 'Original',
            url: 'https://proxy/main.m3u8',
            format: 'm3u8',
          ),
        ],
      ),
      SyncTvPlaybackModeOption(
        key: 'proxy_backup_1',
        urls: [
          SyncTvPlaybackUrlOption(
            name: 'Original',
            url: 'https://proxy/backup.m3u8',
            format: 'm3u8',
          ),
        ],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: PlaybackOptionsControl(
              modes: modes,
              selectedModeKey: 'proxy_main',
              selectedMediaIndex: 0,
              adaptiveTracks: const AdaptiveVideoTrackSnapshot(),
              tooltip: 'Playback route',
              onMediaSelected: (_, _) async {},
              onAdaptiveTrackSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Main route · Proxy · HLS'), findsOneWidget);

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('playback_route_selector')));
    await tester.pumpAndSettle();

    expect(find.text('Main route · Proxy · HLS'), findsNWidgets(2));
    expect(find.text('Backup route 1 · Proxy · HLS'), findsOneWidget);
    expect(modes[0].label, '主线路 · 代理');
    expect(modes[1].label, '备用线路 1 · 代理');
  });
}
