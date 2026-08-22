import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/auth/infrastructure/passkey_authenticator_service.dart';

final class PlatformPasskeyClient implements PasskeyClient {
  const PlatformPasskeyClient();

  @override
  Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  }) => PasskeyAuthenticatorService.isSupported(
    serverBaseUrl: serverBaseUrl,
    rpId: rpId,
  );

  @override
  Future<Map<String, dynamic>> createCredential(
    List<int> options, {
    required String serverBaseUrl,
  }) => PasskeyAuthenticatorService.createCredential(
    options,
    serverBaseUrl: serverBaseUrl,
  );

  @override
  Future<Map<String, dynamic>> getCredential(
    List<int> options, {
    required String serverBaseUrl,
  }) => PasskeyAuthenticatorService.getCredential(
    options,
    serverBaseUrl: serverBaseUrl,
  );
}
