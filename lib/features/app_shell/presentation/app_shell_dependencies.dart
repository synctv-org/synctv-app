import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/home/application/home_gateway.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/room/application/room_management_gateway.dart';

final class AppShellDependencies {
  const AppShellDependencies({
    required this.authGateway,
    required this.homeGateway,
    required this.opaqueAuthenticator,
    required this.oauth2Callbacks,
    required this.nativeAppleSignIn,
    required this.passkeyClient,
    required this.p2pMediaPreferences,
    required this.roomManagementGateway,
  });

  final AuthGateway authGateway;
  final HomeGateway homeGateway;
  final OpaqueAuthenticatorService opaqueAuthenticator;
  final OAuth2CallbackClient oauth2Callbacks;
  final NativeAppleSignInClient nativeAppleSignIn;
  final PasskeyClient passkeyClient;
  final P2pMediaPreferencesController p2pMediaPreferences;
  final RoomManagementGateway roomManagementGateway;
}
