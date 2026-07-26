import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/data/synctv_opaque_auth_gateway.dart';

final _opaqueAuthenticator = OpaqueAuthenticatorService(
  gateway: const SyncTvOpaqueAuthGateway(),
);

Future<AuthResult> loginLocalRoot(String password) async {
  final login = await SyncTvService.startLogin('root');
  return SyncTvService.loginWithDirectPassword(
    loginSessionId: login.sessionId,
    password: password,
  );
}

Future<AuthResult> loginLocalPasswordUser(
  String username,
  String password,
) async {
  final login = await SyncTvService.startLogin(username);
  return _opaqueAuthenticator.login(
    loginSessionId: login.sessionId,
    password: password,
  );
}
