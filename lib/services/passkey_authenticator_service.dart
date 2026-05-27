import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

class PasskeyUnavailableException implements Exception {
  final String message;

  const PasskeyUnavailableException(this.message);

  @override
  String toString() => message;
}

class PasskeyAuthenticatorService {
  static final PasskeyAuthenticator _authenticator = PasskeyAuthenticator(
    debugMode: kDebugMode,
  );

  static Future<bool> isSupported() async {
    if (Platform.isAndroid) {
      final availability = await _authenticator.getAvailability().android();
      return availability.hasPasskeySupport;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      final availability = await _authenticator.getAvailability().iOS();
      return availability.hasPasskeySupport;
    }
    if (Platform.isWindows) {
      final availability = await _authenticator.getAvailability().windows();
      return availability.hasPasskeySupport;
    }
    return false;
  }

  static Future<Map<String, dynamic>> createCredential(
    List<int> optionsJson,
  ) async {
    await _ensureSupported();
    final request = RegisterRequestType.fromJson(
      _decodeOptions(optionsJson),
    );
    return _wrapAuthenticatorErrors(() async {
      final response = await _authenticator.register(request);
      return response.toJson();
    });
  }

  static Future<Map<String, dynamic>> getCredential(
    List<int> optionsJson,
  ) async {
    await _ensureSupported();
    final request = AuthenticateRequestType.fromJson(
      _decodeOptions(optionsJson),
      mediation: MediationType.Required,
      preferImmediatelyAvailableCredentials: false,
    );
    return _wrapAuthenticatorErrors(() async {
      final response = await _authenticator.authenticate(request);
      return response.toJson();
    });
  }

  static Map<String, dynamic> _decodeOptions(List<int> optionsJson) {
    final decoded = jsonDecode(utf8.decode(optionsJson));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Passkey challenge is not a JSON object');
    }
    return decoded;
  }

  static Future<void> _ensureSupported() async {
    try {
      if (await isSupported()) return;
    } on MissingPluginException {
      throw const PasskeyUnavailableException('当前平台暂不支持 Passkey');
    } on UnimplementedError {
      throw const PasskeyUnavailableException('当前平台暂不支持 Passkey');
    } on PlatformException catch (e) {
      throw PasskeyUnavailableException(_platformErrorMessage(e));
    }
    throw const PasskeyUnavailableException('当前设备暂不支持 Passkey');
  }

  static Future<T> _wrapAuthenticatorErrors<T>(Future<T> Function() action) {
    return action()
        .onError<PasskeyAuthCancelledException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '已取消 Passkey 验证',
          ),
        )
        .onError<NoCredentialsAvailableException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '没有可用的 Passkey',
          ),
        )
        .onError<ExcludeCredentialsCanNotBeRegisteredException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '此设备已经绑定过 Passkey',
          ),
        )
        .onError<MissingGoogleSignInException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '请先在系统中登录 Google 账号后再使用 Passkey',
          ),
        )
        .onError<SyncAccountNotAvailableException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '系统暂时无法访问 Passkey 同步账号',
          ),
        )
        .onError<DomainNotAssociatedException>(
          (error, stackTrace) => throw PasskeyUnavailableException(
            '当前应用未关联 ${error.message?.isNotEmpty == true ? error.message : '服务器域名'}',
          ),
        )
        .onError<DeviceNotSupportedException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '当前设备暂不支持 Passkey',
          ),
        )
        .onError<PasskeyUnsupportedException>(
          (error, stackTrace) => throw PasskeyUnavailableException(
            error.message?.isNotEmpty == true
                ? error.message!
                : '当前设备暂不支持 Passkey',
          ),
        )
        .onError<NoCreateOptionException>(
          (error, stackTrace) => throw PasskeyUnavailableException(
            error.message?.isNotEmpty == true
                ? error.message!
                : '系统没有可用的 Passkey 提供方',
          ),
        )
        .onError<TimeoutException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            'Passkey 验证超时，请重试',
          ),
        )
        .onError<MalformedBase64Url>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '服务器返回的 Passkey challenge 无效',
          ),
        )
        .onError<PlatformException>(
          (error, stackTrace) => throw PasskeyUnavailableException(
            _platformErrorMessage(error),
          ),
        );
  }

  static String _platformErrorMessage(PlatformException error) {
    final message = error.message;
    if (message != null && message.trim().isNotEmpty) {
      return message.trim();
    }
    return 'Passkey 操作失败';
  }
}
