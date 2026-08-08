import 'package:flutter/widgets.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/content_reports/application/content_reports_gateway.dart';
import 'package:synctv_app/features/app_shell/presentation/app_shell_dependencies.dart';
import 'package:synctv_app/features/home/application/home_gateway.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_library/application/media_library_gateway.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/application/desktop_web_verification_client.dart';
import 'package:synctv_app/features/room/application/room_creation_gateway.dart';
import 'package:synctv_app/features/room/application/danmaku_source.dart';
import 'package:synctv_app/features/room/application/subtitle_source.dart';
import 'package:synctv_app/features/room/application/picture_in_picture_controller.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/application/room_realtime_protocol.dart';
import 'package:synctv_app/features/room/application/room_chat_gateway.dart';
import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/features/room/application/room_management_gateway.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/features/voice/application/voice_chat_session.dart';

final class AppDependencies {
  const AppDependencies({
    required this.accountGateway,
    required this.adminGateway,
    required this.authGateway,
    required this.contentReportsGateway,
    required this.homeGateway,
    required this.opaqueAuthenticator,
    required this.oauth2Callbacks,
    required this.nativeAppleSignIn,
    required this.passkeyClient,
    required this.p2pMediaPreferences,
    required this.p2pMediaRuntimeFactory,
    required this.mediaLibraryGateway,
    required this.providerGateway,
    required this.desktopWebVerificationClient,
    required this.resourceUrlResolver,
    required this.roomCreationGateway,
    required this.danmakuSource,
    required this.subtitleSource,
    required this.pictureInPicture,
    required this.playerVolumePreferences,
    required this.realtimeEventLogPreferences,
    required this.roomRealtimeChannelFactory,
    required this.roomRealtimeProtocol,
    required this.roomChatGateway,
    required this.roomPlaybackGateway,
    required this.playbackModePreferences,
    required this.roomSessionGateway,
    required this.roomManagementGateway,
    required this.serverConnectionGateway,
    required this.voiceChatSessionFactory,
  });

  final AccountGateway accountGateway;
  final AdminGateway adminGateway;
  final AuthGateway authGateway;
  final ContentReportsGateway contentReportsGateway;
  final HomeGateway homeGateway;
  final OpaqueAuthenticatorService opaqueAuthenticator;
  final OAuth2CallbackClient oauth2Callbacks;
  final NativeAppleSignInClient nativeAppleSignIn;
  final PasskeyClient passkeyClient;
  final P2pMediaPreferencesController p2pMediaPreferences;
  final P2pMediaRuntimeFactory p2pMediaRuntimeFactory;
  final MediaLibraryGateway mediaLibraryGateway;
  final ProviderGateway providerGateway;
  final DesktopWebVerificationClient desktopWebVerificationClient;
  final ResourceUrlResolver resourceUrlResolver;
  final RoomCreationGateway roomCreationGateway;
  final DanmakuSource danmakuSource;
  final SubtitleSource subtitleSource;
  final PictureInPictureController pictureInPicture;
  final PlayerVolumePreferencesController playerVolumePreferences;
  final RealtimeEventLogPreferencesController realtimeEventLogPreferences;
  final RoomRealtimeChannelFactory roomRealtimeChannelFactory;
  final RoomRealtimeProtocol roomRealtimeProtocol;
  final RoomChatGateway roomChatGateway;
  final RoomPlaybackGateway roomPlaybackGateway;
  final PlaybackModePreferencesController playbackModePreferences;
  final RoomSessionGateway roomSessionGateway;
  final RoomManagementGateway roomManagementGateway;
  final ServerConnectionGateway serverConnectionGateway;
  final VoiceChatSessionFactory voiceChatSessionFactory;

  AppShellDependencies get appShell => AppShellDependencies(
    authGateway: authGateway,
    homeGateway: homeGateway,
    opaqueAuthenticator: opaqueAuthenticator,
    oauth2Callbacks: oauth2Callbacks,
    nativeAppleSignIn: nativeAppleSignIn,
    passkeyClient: passkeyClient,
    p2pMediaPreferences: p2pMediaPreferences,
    roomManagementGateway: roomManagementGateway,
  );

  Widget scope({required Widget child}) {
    return DependencyRegistryScope(
      values: <Type, Object>{
        AccountGateway: accountGateway,
        AdminGateway: adminGateway,
        ContentReportsGateway: contentReportsGateway,
        MediaLibraryGateway: mediaLibraryGateway,
        OpaqueAuthenticatorService: opaqueAuthenticator,
        OAuth2CallbackClient: oauth2Callbacks,
        NativeAppleSignInClient: nativeAppleSignIn,
        PasskeyClient: passkeyClient,
        P2pMediaRuntimeFactory: p2pMediaRuntimeFactory,
        PlaybackModePreferencesController: playbackModePreferences,
        ProviderGateway: providerGateway,
        DesktopWebVerificationClient: desktopWebVerificationClient,
        ResourceUrlResolver: resourceUrlResolver,
        RoomChatGateway: roomChatGateway,
        PictureInPictureController: pictureInPicture,
        PlayerVolumePreferencesController: playerVolumePreferences,
        RealtimeEventLogPreferencesController: realtimeEventLogPreferences,
        RoomRealtimeChannelFactory: roomRealtimeChannelFactory,
        RoomRealtimeProtocol: roomRealtimeProtocol,
        RoomCreationGateway: roomCreationGateway,
        DanmakuSource: danmakuSource,
        SubtitleSource: subtitleSource,
        RoomManagementGateway: roomManagementGateway,
        RoomPlaybackGateway: roomPlaybackGateway,
        RoomSessionGateway: roomSessionGateway,
        ServerConnectionGateway: serverConnectionGateway,
        VoiceChatSessionFactory: voiceChatSessionFactory,
      },
      child: child,
    );
  }
}
