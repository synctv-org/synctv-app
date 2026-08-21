import 'dart:typed_data';

import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

enum OpaquePasswordVerification { currentPassword, emailToken, passkey }

abstract interface class OpaqueAuthGateway {
  Future<OpaqueLoginStart> startLogin({
    required String loginSessionId,
    required List<int> credentialRequest,
  });

  Future<AuthResult> finishLogin({
    required String sessionId,
    required List<int> credentialFinalization,
  });

  Future<OpaqueRegistrationStart> startRegistration({
    required String username,
    required String email,
    required List<int> registrationRequest,
  });

  Future<AuthResult> finishRegistration({
    required String sessionId,
    required List<int> registrationUpload,
  });

  Future<OpaquePasswordUpdateStart> startPasswordUpdate({
    required List<int> registrationRequest,
    List<int> credentialRequest = const [],
    required OpaquePasswordVerification verification,
    String emailToken = '',
  });

  Future<SyncTvUser> finishPasswordUpdate({
    required String sessionId,
    required List<int> registrationUpload,
    List<int> credentialFinalization = const [],
    String passkeySessionId = '',
    Object? passkeyCredential,
  });

  Future<Map<String, dynamic>> getPasskeyCredential(List<int> options);

  Future<OpaquePasswordResetStart> startPasswordReset({
    required String email,
    required String token,
    required List<int> registrationRequest,
  });

  Future<void> finishPasswordReset({
    required String sessionId,
    required List<int> registrationUpload,
  });
}

class OpaqueAuthenticatorService {
  OpaqueAuthenticatorService({
    required this._gateway,
    opaque.SyncTvOpaqueClient? client,
  }) : _client = client ?? opaque.SyncTvOpaqueClient();

  final OpaqueAuthGateway _gateway;
  final opaque.SyncTvOpaqueClient _client;

  Future<AuthResult> login({
    required String loginSessionId,
    required String password,
  }) async {
    if (loginSessionId.isEmpty || password.isEmpty) {
      throw const FormatException('请输入账号和密码');
    }

    final start = await _client.startLogin(password);
    final challenge = await _gateway.startLogin(
      loginSessionId: loginSessionId,
      credentialRequest: start.credentialRequest,
    );
    final finish = await _client.finishLogin(
      password: password,
      state: start.state,
      credentialResponse: Uint8List.fromList(challenge.credentialResponse),
    );
    return _gateway.finishLogin(
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

    final start = await _client.startRegistration(password);
    final challenge = await _gateway.startRegistration(
      username: normalizedUsername,
      email: normalizedEmail,
      registrationRequest: start.registrationRequest,
    );
    final finish = await _client.finishRegistration(
      password: password,
      state: start.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return _gateway.finishRegistration(
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

    final loginStart = await _client.startLogin(currentPassword);
    final registrationStart = await _client.startRegistration(newPassword);
    final challenge = await _gateway.startPasswordUpdate(
      credentialRequest: loginStart.credentialRequest,
      registrationRequest: registrationStart.registrationRequest,
      verification: OpaquePasswordVerification.currentPassword,
    );
    final loginFinish = await _client.finishLogin(
      password: currentPassword,
      state: loginStart.state,
      credentialResponse: Uint8List.fromList(challenge.credentialResponse),
    );
    final registrationFinish = await _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return _gateway.finishPasswordUpdate(
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

    final registrationStart = await _client.startRegistration(newPassword);
    final challenge = await _gateway.startPasswordUpdate(
      registrationRequest: registrationStart.registrationRequest,
      verification: OpaquePasswordVerification.emailToken,
      emailToken: normalizedToken,
    );
    final registrationFinish = await _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return _gateway.finishPasswordUpdate(
      sessionId: challenge.sessionId,
      registrationUpload: registrationFinish.registrationUpload,
    );
  }

  Future<SyncTvUser> updateWithPasskey({required String newPassword}) async {
    if (newPassword.isEmpty) {
      throw const FormatException('请输入新密码');
    }

    final registrationStart = await _client.startRegistration(newPassword);
    final challenge = await _gateway.startPasswordUpdate(
      registrationRequest: registrationStart.registrationRequest,
      verification: OpaquePasswordVerification.passkey,
    );
    if (challenge.passkeySessionId.isEmpty ||
        challenge.passkeyOptions.isEmpty) {
      throw const FormatException('服务器未返回 Passkey 验证 challenge');
    }
    final credential = await _gateway.getPasskeyCredential(
      challenge.passkeyOptions,
    );
    final registrationFinish = await _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    return _gateway.finishPasswordUpdate(
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

    final registrationStart = await _client.startRegistration(newPassword);
    final challenge = await _gateway.startPasswordReset(
      email: normalizedEmail,
      token: normalizedToken,
      registrationRequest: registrationStart.registrationRequest,
    );
    final registrationFinish = await _client.finishRegistration(
      password: newPassword,
      state: registrationStart.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    await _gateway.finishPasswordReset(
      sessionId: challenge.sessionId,
      registrationUpload: registrationFinish.registrationUpload,
    );
  }
}
