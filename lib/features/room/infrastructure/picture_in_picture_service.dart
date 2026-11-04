import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:window_manager/window_manager.dart';
import 'package:synctv_app/features/room/application/picture_in_picture_controller.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:video_player/video_player.dart';

enum PictureInPictureBackend { unavailable, web, android, desktopWindow }

const desktopWindowMinimumSize = Size(600, 400);
const desktopWindowDefaultSize = Size(1100, 720);

PictureInPictureBackend pictureInPictureBackendForPlatform(
  TargetPlatform platform, {
  bool isWeb = false,
}) {
  if (isWeb) return PictureInPictureBackend.web;
  return switch (platform) {
    TargetPlatform.android => PictureInPictureBackend.android,
    TargetPlatform.iOS => PictureInPictureBackend.unavailable,
    TargetPlatform.macOS ||
    TargetPlatform.windows ||
    TargetPlatform.linux => PictureInPictureBackend.desktopWindow,
    TargetPlatform.fuchsia => PictureInPictureBackend.unavailable,
  };
}

class PictureInPictureService implements PictureInPictureController {
  PictureInPictureService._() {
    _androidChannel.setMethodCallHandler(_handleAndroidMethodCall);
  }

  static final PictureInPictureService instance = PictureInPictureService._();
  static const MethodChannel _androidChannel = MethodChannel(
    'org.synctv.app/picture_in_picture',
  );

  @override
  final ValueNotifier<bool> active = ValueNotifier(false);
  bool _available = false;
  bool _initialized = false;
  bool _restoringDesktopWindow = false;
  StreamSubscription<bool>? _webStateSubscription;
  VideoPlayerController? _webVideoController;
  Window? _desktopWindow;
  Rect? _desktopOriginalBounds;
  bool _desktopWasAlwaysOnTop = false;
  bool _desktopWasMaximized = false;

  @override
  bool get available => _available;

  @override
  bool get supportsWindowDragging =>
      backend == PictureInPictureBackend.desktopWindow;
  @override
  bool get usesCompactApplicationSurface =>
      backend == PictureInPictureBackend.android ||
      backend == PictureInPictureBackend.desktopWindow;
  PictureInPictureBackend get backend =>
      pictureInPictureBackendForPlatform(defaultTargetPlatform, isWeb: kIsWeb);

  @override
  Future<bool> initialize() async {
    if (_initialized) return _available;
    _initialized = true;
    try {
      switch (backend) {
        case PictureInPictureBackend.web:
          _available =
              CancellableMediaKitVideoPlayer.browserPictureInPictureAvailable;
        case PictureInPictureBackend.android:
          _available =
              await _androidChannel.invokeMethod<bool>('isAvailable') ?? false;
        case PictureInPictureBackend.desktopWindow:
          final window = WindowManager.instance.getCurrent();
          if (window != null) {
            _desktopWindow = window;
            window.addListener(_onDesktopWindowEvent);
            _available = true;
          }
        case PictureInPictureBackend.unavailable:
          _available = false;
      }
    } on PlatformException {
      _available = false;
    } on MissingPluginException {
      _available = false;
    }
    return _available;
  }

  @override
  Future<bool> enter({
    required double aspectRatio,
    VideoPlayerController? videoController,
  }) async {
    if (!_available) return false;
    final ratio = aspectRatio.isFinite && aspectRatio > 0
        ? aspectRatio.clamp(1 / 2.39, 2.39)
        : 16 / 9;
    try {
      return switch (backend) {
        PictureInPictureBackend.web => await _enterWeb(videoController),
        PictureInPictureBackend.android =>
          await _androidChannel.invokeMethod<bool>('enter', {
                'width': (ratio * 1000).round(),
                'height': 1000,
              }) ??
              false,
        PictureInPictureBackend.desktopWindow => await _enterDesktopWindow(
          ratio.toDouble(),
        ),
        PictureInPictureBackend.unavailable => false,
      };
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<void> exit({bool restoreDesktopBounds = true}) async {
    if (!active.value) return;
    try {
      switch (backend) {
        case PictureInPictureBackend.web:
          await _exitWeb();
        case PictureInPictureBackend.android:
          await _androidChannel.invokeMethod<void>('exit');
        case PictureInPictureBackend.desktopWindow:
          await _exitDesktopWindow(restoreBounds: restoreDesktopBounds);
        case PictureInPictureBackend.unavailable:
          active.value = false;
      }
    } on PlatformException {
      active.value = false;
    } on MissingPluginException {
      active.value = false;
    }
  }

  @override
  void startDragging() {
    if (backend == PictureInPictureBackend.desktopWindow && active.value) {
      _desktopWindow?.startDragging();
    }
  }

  Future<bool> _enterWeb(VideoPlayerController? controller) async {
    if (controller == null) return false;
    try {
      await _webStateSubscription?.cancel();
      _webVideoController = controller;
      _webStateSubscription = controller.browserPictureInPictureEvents.listen(
        (value) => active.value = value,
        onDone: () {
          active.value = false;
          _webVideoController = null;
        },
      );
      final entered = await controller.enterBrowserPictureInPicture();
      active.value = entered;
      if (!entered) {
        await _webStateSubscription?.cancel();
        _webStateSubscription = null;
        _webVideoController = null;
      }
      return entered;
    } on Object {
      active.value = false;
      return false;
    }
  }

  Future<void> _exitWeb() async {
    try {
      await _webVideoController?.exitBrowserPictureInPicture();
    } on Object {
      // Browser policy and document lifecycle can revoke PiP asynchronously.
    } finally {
      active.value = false;
      await _webStateSubscription?.cancel();
      _webStateSubscription = null;
      _webVideoController = null;
    }
  }

  Future<bool> _enterDesktopWindow(double aspectRatio) async {
    if (active.value) return true;
    final window = _desktopWindow ?? WindowManager.instance.getCurrent();
    if (window == null) return false;
    _desktopWindow = window;
    _desktopWasMaximized = window.isMaximized;
    if (_desktopWasMaximized) {
      window.unmaximize();
      if (defaultTargetPlatform == TargetPlatform.macOS) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    }
    _desktopOriginalBounds = window.bounds.toRect();
    _desktopWasAlwaysOnTop = window.isAlwaysOnTop;

    const width = 360.0;
    final height = width / aspectRatio;
    final size = Size(width, height);
    try {
      window.minimumSize = Size.zero.toNative();
      window.isAlwaysOnTop = true;
      window.titleBarStyle = TitleBarStyle.hidden;
      window.isWindowControlButtonsVisible = false;
      window.aspectRatio = aspectRatio;
      final position = _bottomRightPosition(size);
      window.animateBounds(
        Rect.fromLTWH(
          position.dx,
          position.dy,
          size.width,
          size.height,
        ).toNative(),
      );
      active.value = true;
      return true;
    } on Object {
      await _exitDesktopWindow(restoreBounds: true);
      rethrow;
    }
  }

  /// Bottom-right corner of the work area of the display under the cursor,
  /// falling back to the primary display.
  Offset _bottomRightPosition(Size size) {
    final displayManager = nativeapi.DisplayManager.instance;
    final cursor = displayManager.getCursorPosition().toOffset();
    nativeapi.Display? display;
    for (final candidate in displayManager.getAll()) {
      final bounds = candidate.position.toOffset() & candidate.size.toSize();
      if (bounds.contains(cursor)) {
        display = candidate;
        break;
      }
    }
    display ??= displayManager.getPrimary();
    if (display == null) return Offset.zero;
    final workArea = display.workArea.toRect();
    return Offset(workArea.right - size.width, workArea.bottom - size.height);
  }

  Future<void> _exitDesktopWindow({required bool restoreBounds}) async {
    if (_restoringDesktopWindow) return;
    _restoringDesktopWindow = true;
    active.value = false;
    try {
      final window = _desktopWindow;
      if (window == null) return;
      window.aspectRatio = 0;
      window.titleBarStyle = TitleBarStyle.normal;
      window.isWindowControlButtonsVisible = true;
      window.minimumSize = desktopWindowMinimumSize.toNative();
      window.isAlwaysOnTop = _desktopWasAlwaysOnTop;
      if (restoreBounds && _desktopOriginalBounds != null) {
        if (_desktopWasMaximized) {
          window.maximize();
        } else {
          window.animateBounds(_desktopOriginalBounds!.toNative());
        }
      }
    } finally {
      _desktopOriginalBounds = null;
      _restoringDesktopWindow = false;
    }
  }

  Future<void> _handleAndroidMethodCall(MethodCall call) async {
    if (call.method == 'onPictureInPictureChanged') {
      active.value = call.arguments == true;
    }
  }

  Future<void> _onDesktopWindowEvent(WindowEvent event) {
    if (event is WindowMaximizedEvent &&
        backend == PictureInPictureBackend.desktopWindow &&
        active.value &&
        !_restoringDesktopWindow) {
      return _exitDesktopWindow(restoreBounds: false);
    }
    return Future.value();
  }
}
