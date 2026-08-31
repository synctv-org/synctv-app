import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_diagnostics.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

PlaybackDiagnosticsSnapshot _snapshot({String? errorDescription}) {
  return PlaybackDiagnosticsSnapshot(
    capturedAt: DateTime.utc(2026, 8, 7, 12),
    title: 'Movie',
    isLive: false,
    isInitialized: true,
    isPlaying: true,
    isBuffering: false,
    isCompleted: false,
    isLooping: false,
    position: const Duration(seconds: 20),
    duration: const Duration(minutes: 2),
    buffered: const [
      PlaybackBufferRange(start: Duration.zero, end: Duration(seconds: 35)),
    ],
    viewportSize: const Size(1200, 700),
    videoSize: const Size(1920, 1080),
    volume: 0.75,
    playbackSpeed: 1.25,
    errorDescription: errorDescription,
    context: const PlaybackDiagnosticsContext(
      roomId: 'room_1',
      mediaId: 'med_1',
      targetHash: 'safe-resource-hash',
      provider: 'bilibili',
      providerInstance: 'default',
      resourceType: 'hls',
      playbackRoute: '1080P',
      codec: 'avc1',
      bitrate: 4000000,
      roomPlaybackVersion: 9,
      playMode: 'shuffle',
      serverLatency: Duration(milliseconds: 42),
      playbackDeviationSeconds: 0.018,
      httpBytes: 1024,
      p2pDownloadBytes: 3072,
      p2pDownloadRate: 2048,
      connectedPeers: 2,
      cacheBytes: 8192,
      cacheHits: 9,
      cacheMisses: 1,
    ),
  );
}

void main() {
  test('debug payload is structured and excludes transport secrets', () {
    final text = _snapshot().toPrettyJson();

    expect(text, contains('"schemaVersion": 1'));
    expect(text, contains('"mediaId": "med_1"'));
    expect(text, contains('"bufferHealthMs": 15000'));
    expect(text, isNot(contains('https://')));
    expect(text, isNot(contains('Authorization')));
    expect(text, isNot(contains('Cookie')));
  });

  test('debug payload redacts URLs and credentials from text fields', () {
    final text = _snapshot(
      errorDescription: 'GET https://media.example.test/live.m3u8 Authorization: Bearer secret Cookie: sid=private',
    ).toPrettyJson();

    expect(text, contains('[redacted-url]'));
    expect(text, contains('[redacted-header]'));
    expect(text, isNot(contains('https://')));
    expect(text, isNot(contains('Bearer secret')));
    expect(text, isNot(contains('sid=private')));
  });

  testWidgets('statistics panel renders metrics and closes', (tester) async {
    var closed = false;
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 460,
              height: 410,
              child: PlaybackStatisticsPanel(
                snapshot: _snapshot(),
                onClose: () => closed = true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Detailed playback statistics'), findsOneWidget);
    expect(find.text('1200x700 / 1920x1080'), findsOneWidget);
    expect(find.textContaining('2 peers'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(
      find.byKey(const Key('close_playback_detailed_statistics')),
    );
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  });
}
