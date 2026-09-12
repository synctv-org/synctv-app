import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

const _mediaBase = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_BASE');

void main() {
  if (Uri.base.queryParameters.containsKey('mse')) {
    final prototype = globalContext
        .getProperty<JSObject>('HTMLVideoElement'.toJS)
        .getProperty<JSObject>('prototype'.toJS);
    final original = prototype.getProperty<JSFunction>('canPlayType'.toJS);
    final probe = web.HTMLVideoElement();
    // Scope the capability override to this fixture page so browsers with
    // native HLS still exercise the production HLS.js loading path.
    prototype.setProperty(
      'canPlayType'.toJS,
      ((JSString type) => type.toDart == 'application/vnd.apple.mpegurl'
              ? ''.toJS
              : original.callAsFunction(probe, type) as JSString)
          .toJS,
    );
  }
  SyncTvVideoPlayerMediaKit.ensureInitialized(web: true);
  runApp(MaterialApp(theme: AppTheme.dark, home: const _PlaybackShowcase()));
}

class _PlaybackShowcase extends StatefulWidget {
  const _PlaybackShowcase();

  @override
  State<_PlaybackShowcase> createState() => _PlaybackShowcaseState();
}

class _PlaybackShowcaseState extends State<_PlaybackShowcase> {
  late final VideoPlayerController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('$_mediaBase/hls/master.m3u8'),
      httpHeaders: {syncTvVideoFormatHeader: 'hls'},
    )..addListener(_changed);
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await _controller.initialize().timeout(const Duration(seconds: 20));
      if (!mounted) return;
      await _controller.setVolume(0);
      if (!mounted) return;
      await _controller.play();
    } on Object catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.value;
    final hls = globalContext.getProperty<JSObject?>('Hls'.toJS);
    final version = hls?.getProperty<JSString>('version'.toJS).toDart;
    return Scaffold(
      appBar: AppBar(title: const Text('SyncTV HLS')),
      body: SafeArea(
        child: AppSingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ColoredBox(
                      color: Colors.black,
                      child: value.isInitialized
                          ? VideoPlayer(_controller)
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(version == null ? 'Native HLS' : 'HLS.js $version'),
                  Text(
                    '${value.isPlaying ? "Playing" : "Paused"} '
                    '${value.position.inMilliseconds} / '
                    '${value.duration.inMilliseconds} ms',
                  ),
                  Text(
                    '${value.size.width.toInt()} x ${value.size.height.toInt()}',
                  ),
                  if (_error ?? value.errorDescription case final error?)
                    Text(error),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      IconButton(
                        tooltip: value.isPlaying ? 'Pause' : 'Play',
                        icon: Icon(
                          value.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: !value.isInitialized
                            ? null
                            : () async {
                                if (value.isPlaying) {
                                  await _controller.pause();
                                } else {
                                  await _controller.play();
                                }
                              },
                      ),
                      IconButton(
                        tooltip: 'Seek to 12 seconds',
                        icon: const Icon(Icons.forward_10),
                        onPressed: !value.isInitialized
                            ? null
                            : () => _controller.seekTo(
                                const Duration(seconds: 12),
                              ),
                      ),
                      IconButton(
                        tooltip: 'Restart',
                        icon: const Icon(Icons.replay),
                        onPressed: !value.isInitialized
                            ? null
                            : () => _controller.seekTo(Duration.zero),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
