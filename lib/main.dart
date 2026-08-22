import 'dart:async';

import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/app_shell/presentation/app_shell.dart';
import 'package:synctv_app/app/app_dependencies.dart';
import 'package:synctv_app/features/auth/data/synctv_auth_gateway.dart';
import 'package:synctv_app/features/auth/infrastructure/native_passkey_client.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/data/synctv_opaque_auth_gateway.dart';
import 'package:synctv_app/features/account/data/synctv_account_gateway.dart';
import 'package:synctv_app/features/admin/data/synctv_admin_gateway.dart';
import 'package:synctv_app/features/content_reports/data/synctv_content_reports_gateway.dart';
import 'package:synctv_app/features/server_settings/data/synctv_server_connection_gateway.dart';
import 'package:synctv_app/features/room/data/synctv_room_creation_gateway.dart';
import 'package:synctv_app/features/room/data/http_danmaku_source.dart';
import 'package:synctv_app/features/room/data/http_subtitle_source.dart';
import 'package:synctv_app/features/room/data/synctv_room_chat_gateway.dart';
import 'package:synctv_app/features/room/data/synctv_room_playback_gateway.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_app/features/room/application/playback_overlay_preferences_controller.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/features/room/data/shared_preferences_realtime_event_log_store.dart';
import 'package:synctv_app/features/room/data/protobuf_room_realtime_protocol.dart';
import 'package:synctv_app/features/room/data/room_realtime_connection.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_mode_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_player_volume_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_overlay_store.dart';
import 'package:synctv_app/features/room/data/synctv_room_session_gateway.dart';
import 'package:synctv_app/features/room/data/synctv_room_management_gateway.dart';
import 'package:synctv_app/features/app_shell/data/synctv_resource_url_resolver.dart';
import 'package:synctv_app/features/home/data/synctv_home_gateway.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_runtime_factory.dart';
import 'package:synctv_app/features/media_p2p/data/shared_preferences_p2p_media_preferences_store.dart';
import 'package:synctv_app/features/media_library/data/synctv_media_library_gateway.dart';
import 'package:synctv_app/features/providers/data/synctv_provider_gateway.dart';
import 'package:synctv_app/features/providers/infrastructure/desktop_web_verification_client.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_callback_service.dart';
import 'package:synctv_app/features/room/infrastructure/picture_in_picture_service.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_chat_manager.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  final p2pMediaPreferences = P2pMediaPreferencesController(
    store: const SharedPreferencesP2pMediaPreferencesStore(),
  );
  final playbackModePreferences = PlaybackModePreferencesController(
    store: const SharedPreferencesPlaybackModeStore(),
  );
  final playerVolumePreferences = PlayerVolumePreferencesController(
    store: const SharedPreferencesPlayerVolumeStore(),
  );
  final playbackOverlayPreferences = PlaybackOverlayPreferencesController(
    store: const SharedPreferencesPlaybackOverlayStore(),
  );
  final realtimeEventLogPreferences = RealtimeEventLogPreferencesController(
    store: const SharedPreferencesRealtimeEventLogStore(),
  );
  await Future.wait([
    appLocaleController.load(),
    SyncTvService.init(),
    p2pMediaPreferences.load(),
    playbackModePreferences.load(),
    playerVolumePreferences.load(),
    playbackOverlayPreferences.load(),
    realtimeEventLogPreferences.load(),
    _configureDesktopWindow(),
  ]);

  const oauth2Callbacks = FlutterWebAuth2CallbackClient();
  final opaqueAuthenticator = OpaqueAuthenticatorService(
    gateway: const SyncTvOpaqueAuthGateway(),
  );
  const roomSessionGateway = SyncTvRoomSessionGateway();

  final dependencies = AppDependencies(
    accountGateway: const SyncTvAccountGateway(),
    adminGateway: const SyncTvAdminGateway(),
    authGateway: const SyncTvAuthGateway(),
    contentReportsGateway: const SyncTvContentReportsGateway(),
    homeGateway: const SyncTvHomeGateway(),
    opaqueAuthenticator: opaqueAuthenticator,
    oauth2Callbacks: oauth2Callbacks,
    nativeAppleSignIn: const PlatformNativeAppleSignInClient(),
    passkeyClient: const NativePasskeyClient(),
    p2pMediaPreferences: p2pMediaPreferences,
    p2pMediaRuntimeFactory: const NativeP2pMediaRuntimeFactory(),
    mediaLibraryGateway: const SyncTvMediaLibraryGateway(),
    providerGateway: const SyncTvProviderGateway(),
    desktopWebVerificationClient: const NativeDesktopWebVerificationClient(),
    resourceUrlResolver: const SyncTvResourceUrlResolver(),
    roomCreationGateway: const SyncTvRoomCreationGateway(),
    danmakuSource: const HttpDanmakuSource(),
    subtitleSource: const HttpSubtitleSource(),
    pictureInPicture: PictureInPictureService.instance,
    playerVolumePreferences: playerVolumePreferences,
    playbackOverlayPreferences: playbackOverlayPreferences,
    realtimeEventLogPreferences: realtimeEventLogPreferences,
    roomRealtimeChannelFactory: const IoRoomRealtimeChannelFactory(
      sessionGateway: roomSessionGateway,
    ),
    roomRealtimeProtocol: const ProtobufRoomRealtimeProtocol(),
    roomChatGateway: const SyncTvRoomChatGateway(),
    roomPlaybackGateway: const SyncTvRoomPlaybackGateway(),
    playbackModePreferences: playbackModePreferences,
    roomSessionGateway: roomSessionGateway,
    roomManagementGateway: const SyncTvRoomManagementGateway(),
    serverConnectionGateway: const SyncTvServerConnectionGateway(),
    voiceChatSessionFactory: const NativeVoiceChatSessionFactory(),
  );
  runApp(MyApp(dependencies: dependencies));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeDeferredRuntime();
  });
}

Future<void> _configureDesktopWindow() async {
  if (kIsWeb ||
      !const {
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      }.contains(defaultTargetPlatform)) {
    return;
  }
  await windowManager.ensureInitialized();
  await windowManager.setTitleBarStyle(
    TitleBarStyle.normal,
    windowButtonVisibility: true,
  );
  await windowManager.setMinimumSize(desktopWindowMinimumSize);
  final windowSize = await windowManager.getSize();
  if (windowSize.width < desktopWindowMinimumSize.width ||
      windowSize.height < desktopWindowMinimumSize.height) {
    await windowManager.setSize(desktopWindowDefaultSize);
    await windowManager.center();
  }
}

void _initializeDeferredRuntime() {
  if (SyncTvService.activeServer != null) {
    unawaited(SyncTvService.syncServerTime());
  }
  try {
    SyncTvVideoPlayerMediaKit.ensureInitialized(
      android: true,
      iOS: false,
      windows: true,
      macOS: true,
      linux: true,
    );
  } catch (error) {
    debugPrint('Failed to initialize media playback: $error');
  }
}

const _enableAccessibilityTools = bool.fromEnvironment(
  'SYNCTV_ENABLE_ACCESSIBILITY_TOOLS',
);

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appLocaleController,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: appLocaleController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final newMediaQueryData = mediaQueryData.copyWith(
            textScaler: mediaQueryData.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.3,
            ),
          );
          Widget appChild = MediaQuery(data: newMediaQueryData, child: child!);
          appChild = ResponsiveBreakpoints.builder(
            breakpoints: AppBreakpoints.values,
            child: appChild,
          );
          if (kDebugMode && _enableAccessibilityTools) {
            appChild = AccessibilityTools(
              checkFontOverflows: true,
              buttonsAlignment: ButtonsAlignment.bottomLeft,
              child: appChild,
            );
          }

          return dependencies.scope(child: appChild);
        },
        home: AppShell(dependencies: dependencies.appShell),
      ),
    );
  }
}
