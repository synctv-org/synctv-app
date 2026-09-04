import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_options_control.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';

void main() {
  testWidgets('route control only exposes playback routes', (tester) async {
    SyncTvPlaybackModeOption? selectedMode;
    int? selectedMediaIndex;
    const modes = [
      SyncTvPlaybackModeOption(
        key: 'main',
        urls: [SyncTvPlaybackUrlOption(name: 'Main DASH', url: 'https://a')],
      ),
      SyncTvPlaybackModeOption(
        key: 'backup_1',
        urls: [SyncTvPlaybackUrlOption(name: 'Backup DASH', url: 'https://b')],
      ),
    ];

    await tester.pumpWidget(
      _testApp(
        PlaybackRouteControl(
          modes: modes,
          selectedModeKey: 'main',
          selectedMediaIndex: 0,
          tooltip: 'Playback route',
          onMediaSelected: (mode, index) async {
            selectedMode = mode;
            selectedMediaIndex = index;
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('playback_route_button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('playback_route_option_backup_1_0')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('adaptive_video_track_auto')), findsNothing);
    expect(find.byKey(const Key('adaptive_audio_track_auto')), findsNothing);
    expect(find.text('Video track'), findsNothing);
    expect(find.text('Audio track'), findsNothing);

    await tester.tap(find.byKey(const Key('playback_route_option_backup_1_0')));
    await tester.pumpAndSettle();
    expect(selectedMode?.key, 'backup_1');
    expect(selectedMediaIndex, 0);
  });

  testWidgets('compact route menu opens above the player control', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const mode = SyncTvPlaybackModeOption(
      key: 'main',
      urls: [SyncTvPlaybackUrlOption(name: 'DASH', url: 'https://a')],
    );

    await tester.pumpWidget(
      _testApp(
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: PlaybackRouteControl(
              modes: const [mode],
              selectedModeKey: 'main',
              selectedMediaIndex: 0,
              tooltip: 'Playback route',
              compact: true,
              onMediaSelected: (_, _) async {},
            ),
          ),
        ),
      ),
    );

    final button = find.byKey(const Key('playback_route_button_compact'));
    expect(tester.getSize(button), const Size.square(40));
    await tester.tap(button);
    await tester.pumpAndSettle();

    final option = find.byKey(const Key('playback_route_option_main_0'));
    expect(option, findsOneWidget);
    expect(
      tester.getRect(option).bottom,
      lessThanOrEqualTo(tester.getRect(button).top),
    );
  });

  testWidgets('video control only exposes sorted manifest video tracks', (
    tester,
  ) async {
    String? selectedTrackId;
    await tester.pumpWidget(
      _testApp(
        AdaptiveVideoTrackControl(
          tracks: const AdaptiveVideoTrackSnapshot(
            selectedTrackId: '720',
            tracks: [
              AdaptiveVideoTrackInfo(id: '720', width: 1280, height: 720),
              AdaptiveVideoTrackInfo(
                id: '1080-hevc',
                width: 1920,
                height: 1080,
                codec: 'hev1.1.6.L120.90',
              ),
            ],
          ),
          tooltip: 'Video track',
          onTrackSelected: (trackId) async => selectedTrackId = trackId,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('adaptive_video_track_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('adaptive_video_track_auto')), findsOneWidget);
    expect(find.textContaining('HEV1.1.6.L120.90'), findsOneWidget);
    expect(
      tester
          .getTopLeft(find.byKey(const Key('adaptive_video_track_1080-hevc')))
          .dy,
      lessThan(
        tester.getTopLeft(find.byKey(const Key('adaptive_video_track_720'))).dy,
      ),
    );
    expect(find.byKey(const Key('playback_route_option_main_0')), findsNothing);
    expect(find.byKey(const Key('adaptive_audio_track_auto')), findsNothing);

    await tester.tap(find.byKey(const Key('adaptive_video_track_1080-hevc')));
    await tester.pumpAndSettle();
    expect(selectedTrackId, '1080-hevc');
  });

  testWidgets('video control honors runtimes without automatic selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AdaptiveVideoTrackControl(
          tracks: const AdaptiveVideoTrackSnapshot(
            automaticSelectionAvailable: false,
            selectedTrackId: 'hls:1:2000',
            tracks: [
              AdaptiveVideoTrackInfo(id: 'hls:0:1000', width: 640),
              AdaptiveVideoTrackInfo(id: 'hls:1:2000', width: 1280),
            ],
          ),
          tooltip: 'Video track',
          onTrackSelected: (_) async {},
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('adaptive_video_track_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('adaptive_video_track_auto')), findsNothing);
    expect(
      find.byKey(const Key('adaptive_video_track_hls:1:2000')),
      findsOneWidget,
    );
  });

  testWidgets('audio control only exposes manifest audio tracks', (
    tester,
  ) async {
    String? selectedTrackId;
    await tester.pumpWidget(
      _testApp(
        AdaptiveAudioTrackControl(
          tracks: const AdaptiveAudioTrackSnapshot(
            automaticSelectionAvailable: false,
            selectedTrackId: 'aac',
            tracks: [
              AdaptiveAudioTrackInfo(
                id: 'aac',
                title: 'AAC',
                codec: 'mp4a.40.2',
                bitrate: 192000,
                channels: 2,
                sampleRate: 48000,
              ),
              AdaptiveAudioTrackInfo(
                id: 'eac3',
                title: 'EAC3',
                codec: 'ec-3',
                bitrate: 448000,
                channels: 6,
                sampleRate: 48000,
              ),
            ],
          ),
          tooltip: 'Audio track',
          onTrackSelected: (trackId) async => selectedTrackId = trackId,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('adaptive_audio_track_button')));
    await tester.pumpAndSettle();

    expect(find.text('EAC3 · EC-3 · 6ch · 48kHz · 448kbps'), findsOneWidget);
    expect(find.byKey(const Key('adaptive_audio_track_auto')), findsNothing);
    expect(find.byKey(const Key('adaptive_video_track_auto')), findsNothing);
    expect(find.byKey(const Key('playback_route_option_main_0')), findsNothing);

    await tester.tap(find.byKey(const Key('adaptive_audio_track_eac3')));
    await tester.pumpAndSettle();
    expect(selectedTrackId, 'eac3');
  });

  testWidgets('route video and audio controls remain separate', (tester) async {
    await tester.pumpWidget(
      _testApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlaybackRouteControl(
              modes: const [
                SyncTvPlaybackModeOption(
                  key: 'direct',
                  urls: [
                    SyncTvPlaybackUrlOption(name: 'Direct', url: 'https://a'),
                  ],
                ),
                SyncTvPlaybackModeOption(
                  key: 'proxy',
                  urls: [
                    SyncTvPlaybackUrlOption(name: 'Proxy', url: 'https://b'),
                  ],
                ),
              ],
              selectedModeKey: 'direct',
              selectedMediaIndex: 0,
              tooltip: 'Playback route',
              compact: true,
              onMediaSelected: (_, _) async {},
            ),
            AdaptiveVideoTrackControl(
              tracks: const AdaptiveVideoTrackSnapshot(
                tracks: [
                  AdaptiveVideoTrackInfo(id: '720', height: 720),
                  AdaptiveVideoTrackInfo(id: '1080', height: 1080),
                ],
              ),
              tooltip: 'Video track',
              compact: true,
              onTrackSelected: (_) async {},
            ),
            AdaptiveAudioTrackControl(
              tracks: const AdaptiveAudioTrackSnapshot(
                tracks: [
                  AdaptiveAudioTrackInfo(id: '64k', bitrate: 64000),
                  AdaptiveAudioTrackInfo(id: '192k', bitrate: 192000),
                ],
              ),
              tooltip: 'Audio track',
              compact: true,
              onTrackSelected: (_) async {},
            ),
          ],
        ),
      ),
    );

    expect(
      find.byKey(const Key('playback_route_button_compact')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('adaptive_video_track_button_compact')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('adaptive_audio_track_button_compact')),
      findsOneWidget,
    );
  });
}

Widget _testApp(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);
