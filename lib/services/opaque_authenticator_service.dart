import 'dart:typed_data';

import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/passkey_authenticator_service.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

class OpaqueAuthenticatorService {
  OpaqueAuthenticatorService({opaque.SyncTvOpaqueClient? client})
      : _client = client ?? opaque.SyncTvOpaqueClient();

  final opaque.SyncTvOpaqueClient _client;

  Future<AuthResult> login({
    required String identifier,
    required String password,
  }) async {
    final normalized = identifier.trim();
    if (normalized.isEmpty || password.isEmpty) {
      throw const FormatException('请输入账号和密码');
    }

    final start = _client.startLogin(password);
    final challenge = await SyncTvService.startOpaqueLogin(
      username: normalized.contains('@') ? '' : normalized,
      email: normalized.contains('@') ? normalized : '',
      credentialRequest: start.credentialRequest,
    );
    final finish = _client.finishLogin(
      password: password,
      state: start.state,
      credentialResponse: Uint8List.fromList(challenge.credentialResponse),
    );
    return SyncTvService.finishOpaqueLogin(
      sessionId: challenge.sessionId,
      credentialFinalization: finish.credentialFinalization,
    );
  }

  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    final normalizedEmail = email.trim();
    if (normalizedUsername.isEmpty || password.isEmpty) {
      throw const FormatException('请输入用户名和密码');
    }

    final start = _client.startRegistration(password);
    final challenge = await SyncTvService.startOpaqueRegistration(
      username: normalizedUsername,
      email: normalizedEmail,
      registrationRequest: start.registrationRequest,
    );
    final finish = _client.finishRegistration(
      password: password,
      state: start.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return SyncTvService.finishOpaqueRegistration(
      sessionId: challenge.sessionId,
      registrationUpload: finish.registrationUpload,
    );
  }

  Future<SyncTvUser> updateWithCurrentPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      throw const FormatException('请输入当前密码和新密码');
    }

    final loginStart = _client.startLogin(currentPassword);
    final registrationStart = _client.startRegistration(newPassword);
    final challenge = await SyncTvService.startOpaquePasswordUpdate(
      credentialRequest: loginStart.credentialRequest,
      registrationRequest: registrationStart.registrationRequest,
      verificationMethod: client_enum
          .OpaquePasswordUpdateVerificationMethod
          .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD
          .value,
    );
    final loginFinish = _client.finishLogin(
      password: currentPassword,
      state: loginStart.state,
      credentialResponse: Uint8List.fromList(challenge.credentialResponse),
    );
    final registrationFinish = _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return SyncTvService.finishOpaquePasswordUpdate(
      sessionId: challenge.sessionId,
      credentialFinalization: loginFinish.credentialFinalization,
      registrationUpload: registrationFinish.registrationUpload,
    );
  }

  Future<SyncTvUser> updateWithEmailToken({
    required String emailToken,
    required String newPassword,
  }) async {
    final normalizedToken = emailToken.trim();
    if (normalizedToken.isEmpty || newPassword.isEmpty) {
      throw const FormatException('请输入邮箱验证码和新密码');
    }

    final registrationStart = _client.startRegistration(newPassword);
    final challenge = await SyncTvService.startOpaquePasswordUpdate(
      registrationRequest: registrationStart.registrationRequest,
      verificationMethod: client_enum.OpaquePasswordUpdateVerificationMethod
          .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_EMAIL_TOKEN.value,
      emailToken: normalizedToken,
    );
    final registrationFinish = _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return SyncTvService.finishOpaquePasswordUpdate(
      sessionId: challenge.sessionId,
      registrationUpload: registrationFinish.registrationUpload,
    );
  }

  Future<SyncTvUser> updateWithPasskey({required String newPassword}) async {
    if (newPassword.isEmpty) {
      throw const FormatException('请输入新密码');
    }

    final registrationStart = _client.startRegistration(newPassword);
    final challenge = await SyncTvService.startOpaquePasswordUpdate(
      registrationRequest: registrationStart.registrationRequest,
      verificationMethod: client_enum.OpaquePasswordUpdateVerificationMethod
          .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_PASSKEY.value,
    );
    if (challenge.passkeySessionId.isEmpty ||
        challenge.passkeyOptions.isEmpty) {
      throw const FormatException('服务器未返回 Passkey 验证 challenge');
    }
    final credential = await PasskeyAuthenticatorService.getCredential(
      challenge.passkeyOptions,
    );
    final registrationFinish = _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return SyncTvService.finishOpaquePasswordUpdate(
      sessionId: challenge.sessionId,
      registrationUpload: registrationFinish.registrationUpload,
      passkeySessionId: challenge.passkeySessionId,
      passkeyCredential: credential,
    );
  }

  Future<void> resetWithEmailToken({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final normalizedEmail = email.trim();
    final normalizedToken = token.trim();
    if (normalizedEmail.isEmpty ||
        normalizedToken.isEmpty ||
        newPassword.isEmpty) {
      throw const FormatException('请输入邮箱、验证码和新密码');
    }

    final registrationStart = _client.startRegistration(newPassword);
    final challenge = await SyncTvService.startOpaquePasswordReset(
      email: normalizedEmail,
      token: normalizedToken,
      registrationRequest: registrationStart.registrationRequest,
    );
    final registrationFinish = _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    await SyncTvService.finishOpaquePasswordReset(
      sessionId: challenge.sessionId,
      registrationUpload: registrationFinish.registrationUpload,
    );
  }
}
