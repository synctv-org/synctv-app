import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart'
    as local;

import 'dart:async';

/// 高性能弹幕叠加显示组件 - 使用canvas_danmaku
class DanmakuOverlay extends StatefulWidget {
  final VideoPlayerController? videoController;
  final List<local.DanmakuItem> danmakuList;
  final local.DanmakuOrigin? origin;
  final bool isEnabled;
  final double? opacity;
  final DanmakuOption option;

  DanmakuOption get _effectiveOption =>
      opacity == null ? option : option.copyWith(opacity: opacity);

  const DanmakuOverlay({
    super.key,
    required this.videoController,
    required this.danmakuList,
    this.origin,
    this.isEnabled = true,
    this.opacity,
    this.option = const DanmakuOption(opacity: 0.8),
  });

  @override
  State<DanmakuOverlay> createState() => _DanmakuOverlayState();
}

class _DanmakuOverlayState extends State<DanmakuOverlay> {
  DanmakuController? _danmakuController;
  Timer? _syncTimer;
  Duration _lastVideoPosition = Duration.zero;
  final Set<local.DanmakuItem> _processedDanmaku = Set.identity();

  @override
  void initState() {
    super.initState();
    widget.videoController?.addListener(_syncPlaybackState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVideoSync();
    });
  }

  @override
  void dispose() {
    widget.videoController?.removeListener(_syncPlaybackState);
    _syncTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(DanmakuOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.videoController != oldWidget.videoController) {
      oldWidget.videoController?.removeListener(_syncPlaybackState);
      widget.videoController?.addListener(_syncPlaybackState);
    }

    if (_optionsDiffer(widget._effectiveOption, oldWidget._effectiveOption)) {
      _danmakuController?.updateOption(widget._effectiveOption);
    }

    // 如果弹幕列表变化，重置处理状态
    if (widget.danmakuList != oldWidget.danmakuList) {
      _processedDanmaku.clear();
      _lastVideoPosition = Duration.zero;
      _danmakuController?.clear();
    }

    // 如果启用状态变化，更新弹幕显示
    if (widget.isEnabled != oldWidget.isEnabled) {
      if (widget.isEnabled) {
        _startVideoSync();
      } else {
        _pauseVideoSync();
        _processedDanmaku.clear();
        _danmakuController?.clear();
        _danmakuController = null;
      }
    }
    _syncPlaybackState();
  }

  void _syncPlaybackState() {
    final controller = _danmakuController;
    if (!mounted || controller == null) return;
    final video = widget.videoController?.value;
    final shouldRun =
        widget.isEnabled &&
        video != null &&
        video.isInitialized &&
        video.isPlaying &&
        !video.isBuffering;
    if (shouldRun && !controller.running) {
      controller.resume();
    } else if (!shouldRun && controller.running) {
      controller.pause();
    }
  }

  bool _optionsDiffer(DanmakuOption a, DanmakuOption b) {
    return a.fontSize != b.fontSize ||
        a.fontWeight != b.fontWeight ||
        a.fontFamily != b.fontFamily ||
        a.area != b.area ||
        a.duration != b.duration ||
        a.staticDuration != b.staticDuration ||
        a.opacity != b.opacity ||
        a.hideTop != b.hideTop ||
        a.hideBottom != b.hideBottom ||
        a.hideScroll != b.hideScroll ||
        a.hideSpecial != b.hideSpecial ||
        a.strokeWidth != b.strokeWidth ||
        a.massiveMode != b.massiveMode ||
        a.safeArea != b.safeArea ||
        a.lineHeight != b.lineHeight;
  }

  /// 开始视频同步
  void _startVideoSync() {
    if (!mounted || !widget.isEnabled) return;

    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _syncWithVideo();
    });
  }

  /// 暂停视频同步
  void _pauseVideoSync() {
    _syncTimer?.cancel();
  }

  /// 与视频同步
  void _syncWithVideo() {
    if (!widget.isEnabled ||
        widget.videoController == null ||
        !widget.videoController!.value.isInitialized ||
        _danmakuController == null) {
      return;
    }

    final currentPosition = widget.videoController!.value.position;

    // 检查视频是否在播放
    if (!widget.videoController!.value.isPlaying ||
        widget.videoController!.value.isBuffering) {
      return;
    }

    // 检测视频跳转（快进/快退）
    if ((currentPosition - _lastVideoPosition).abs() >
        const Duration(seconds: 2)) {
      debugPrint('Video seek detected; resetting danmaku state');
      _processedDanmaku.clear();
      _danmakuController!.clear();
    }

    _lastVideoPosition = currentPosition;

    // The controller trims its mutable list in place. Track objects, not slots,
    // and release consumed entries once they leave the current data window.
    final currentItems = Set<local.DanmakuItem>.identity()
      ..addAll(widget.danmakuList);
    _processedDanmaku.retainAll(currentItems);

    int addedCount = 0;
    for (final danmaku in widget.danmakuList) {
      if (widget.origin != null && danmaku.origin != widget.origin) {
        continue;
      }

      // 如果这条弹幕已经处理过，跳过
      if (_processedDanmaku.contains(danmaku)) {
        continue;
      }

      // 检查是否到了显示时间
      if (danmaku.shouldShowAt(currentPosition)) {
        debugPrint(
          'DanmakuOverlay: showing [${danmaku.text}] at ${currentPosition.inSeconds}s (start: ${danmaku.startTime.inSeconds}s)',
        );
        _addDanmakuToScreen(danmaku);
        _processedDanmaku.add(danmaku);
        addedCount++;
      }
    }

    if (addedCount > 0) {
      debugPrint('DanmakuOverlay: added $addedCount items during sync');
    }
  }

  /// 添加弹幕到屏幕
  void _addDanmakuToScreen(local.DanmakuItem danmaku) {
    if (_danmakuController == null) return;

    try {
      // 根据弹幕类型创建不同的弹幕内容
      switch (danmaku.type) {
        case local.DanmakuType.floating:
          // 滚动弹幕
          _danmakuController!.addDanmaku(
            DanmakuContentItem(danmaku.text, color: danmaku.color),
          );
          break;

        case local.DanmakuType.top:
          // 顶部固定弹幕
          _danmakuController!.addDanmaku(
            DanmakuContentItem(
              danmaku.text,
              color: danmaku.color,
              type: DanmakuItemType.top,
            ),
          );
          break;

        case local.DanmakuType.bottom:
          // 底部固定弹幕
          _danmakuController!.addDanmaku(
            DanmakuContentItem(
              danmaku.text,
              color: danmaku.color,
              type: DanmakuItemType.bottom,
            ),
          );
          break;
      }

      debugPrint(
        'Added danmaku: ${danmaku.text} at ${_lastVideoPosition.inSeconds}s',
      );
    } catch (e) {
      debugPrint('Failed to add danmaku: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return DanmakuScreen(
      createdController: (controller) {
        debugPrint('Danmaku controller created');
        _danmakuController = controller;
        _syncPlaybackState();
      },
      option: widget._effectiveOption,
    );
  }
}
