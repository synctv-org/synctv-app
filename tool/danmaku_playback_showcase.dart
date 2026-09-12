import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:synctv_app/features/room/presentation/widgets/danmaku_overlay.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Preview()));

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  final video = VideoPlayerController.networkUrl(
    Uri.parse('https://example.test/video'),
  );
  Timer? timer;
  bool enabled = true;
  double opacity = 1;
  final comments = <DanmakuItem>[
    const DanmakuItem(
      text: 'This comment follows playback',
      startTime: Duration.zero,
      endTime: Duration(seconds: 8),
      color: Colors.white,
    ),
  ];
  int arrival = 0;
  @override
  void initState() {
    super.initState();
    video.value = const VideoPlayerValue(
      duration: Duration(minutes: 1),
      isInitialized: true,
      isPlaying: false,
    );
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (video.value.isPlaying) {
        video.value = video.value.copyWith(
          position: video.value.position + const Duration(milliseconds: 100),
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Danmaku playback sync')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          children: [
            FilledButton(
              onPressed: () => setState(() {
                video.value = video.value.copyWith(
                  isPlaying: !video.value.isPlaying,
                );
              }),
              child: Text(video.value.isPlaying ? 'Pause' : 'Play'),
            ),
            FilledButton(
              onPressed: () => setState(() {
                video.value = video.value.copyWith(
                  position: Duration.zero,
                  isPlaying: true,
                );
              }),
              child: const Text('Restart'),
            ),
          ],
        ),
        SwitchListTile(
          title: const Text('Show comments'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final value in [0.2, 1.0])
              OutlinedButton(
                onPressed: () => setState(() => opacity = value),
                child: Text('Opacity ${(value * 100).round()}%'),
              ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: video,
          builder: (_, value, _) => Text(
            '${value.isPlaying ? 'Playing' : 'Paused'} · ${value.position.inMilliseconds} ms',
          ),
        ),
        OutlinedButton(
          onPressed: () => setState(() {
            comments.removeAt(0);
            comments.add(
              DanmakuItem(
                text: 'New arrival ${++arrival}',
                startTime: video.value.position,
                endTime: video.value.position + const Duration(seconds: 8),
                color: Colors.white,
              ),
            );
          }),
          child: const Text('Trim oldest and add comment'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ColoredBox(
            color: const Color(0xff151820),
            child: DanmakuOverlay(
              videoController: video,
              isEnabled: enabled,
              opacity: opacity,
              danmakuList: comments,
            ),
          ),
        ),
      ],
    ),
  );
}
