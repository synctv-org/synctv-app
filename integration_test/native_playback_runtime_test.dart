import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

const _mediaUrl = String.fromEnvironment('SYNCTV_NATIVE_MEDIA_TEST_URL');
const _mediaFormat = String.fromEnvironment(
  'SYNCTV_NATIVE_MEDIA_TEST_FORMAT',
  defaultValue: 'mpeg-ts',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  SyncTvVideoPlayerMediaKit.ensureInitialized(
    android: true,
    iOS: true,
    macOS: true,
    windows: true,
    linux: true,
  );

  testWidgets('native media_kit plays and seeks the media fixture', (
    tester,
  ) async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(_mediaUrl),
      httpHeaders: {syncTvVideoFormatHeader: _mediaFormat},
    );
    addTearDown(controller.dispose);

    final initializing = controller.initialize();
    await tester.pumpWidget(
      MaterialApp(home: Center(child: VideoPlayer(controller))),
    );
    await tester.pump();
    await initializing.timeout(const Duration(seconds: 20));
    await controller.play();
    await Future<void>.delayed(const Duration(seconds: 2));
    final playedPosition = await VideoPlayerPlatform.instance.getPosition(
      // ignore: invalid_use_of_visible_for_testing_member
      controller.playerId,
    );
    expect(playedPosition, greaterThan(const Duration(seconds: 1)));

    await controller.seekTo(const Duration(seconds: 6));
    await Future<void>.delayed(const Duration(seconds: 1));
    final seekedPosition = await VideoPlayerPlatform.instance.getPosition(
      // ignore: invalid_use_of_visible_for_testing_member
      controller.playerId,
    );
    expect(seekedPosition, greaterThan(const Duration(seconds: 6)));
  }, skip: _mediaUrl.isEmpty);
}
