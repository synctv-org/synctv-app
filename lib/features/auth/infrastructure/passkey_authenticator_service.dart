import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
import 'package:synctv_app/features/auth/infrastructure/passkey_native_association_service.dart';

class PasskeyUnavailableException implements Exception {
  final String message;

  const PasskeyUnavailableException(this.message);

  @override
  String toString() => message;
}

class PasskeyAuthenticatorService {
  static const _platformAvailabilityTimeout = Duration(seconds: 2);
  static const _associationTimeout = Duration(seconds: 3);
  static final PasskeyAuthenticator _authenticator = PasskeyAuthenticator(
    debugMode: false,
  );

  static Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  }) async {
    final normalizedRpId = rpId.trim().toLowerCase();
    if (!_isValidRpId(normalizedRpId)) return false;
    if (!_serverCanUseRpId(serverBaseUrl, normalizedRpId)) return false;
    if (kDebugMode) {
      debugPrint(
        'Checking Passkey capability for ${defaultTargetPlatform.name}',
      );
    }
    final platformAvailable = await _platformAvailable();
    if (kDebugMode) {
      debugPrint('Passkey platform capability: $platformAvailable');
    }
    final associated = kIsWeb
        ? true
        : await PasskeyNativeAssociationService.isAssociated(
            serverBaseUrl: serverBaseUrl,
            rpId: normalizedRpId,
          ).timeout(_associationTimeout, onTimeout: () => false);
    if (kDebugMode) {
      debugPrint(
        'Passkey capability: platform=$platformAvailable, '
        'associated=$associated, platform=${defaultTargetPlatform.name}',
      );
    }
    return platformAvailable && associated;
  }

  static Future<bool> _platformAvailable() async {
    if (kIsWeb) {
      return _authenticator
          .getAvailability()
          .web()
          .then((availability) => availability.hasPasskeySupport)
          .timeout(_platformAvailabilityTimeout, onTimeout: () => false);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _authenticator
          .getAvailability()
          .android()
          .then((availability) => availability.hasPasskeySupport)
          .timeout(_platformAvailabilityTimeout, onTimeout: () => false);
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return _authenticator
          .getAvailability()
          .iOS()
          .then((availability) => availability.hasPasskeySupport)
          .timeout(_platformAvailabilityTimeout, onTimeout: () => false);
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return _authenticator
          .getAvailability()
          .windows()
          .then((availability) => availability.hasPasskeySupport)
          .timeout(_platformAvailabilityTimeout, onTimeout: () => false);
    }
    return false;
  }

  static Future<Map<String, dynamic>> createCredential(
    List<int> optionsJson, {
    required String serverBaseUrl,
  }) async {
    final options = _decodeOptions(optionsJson);
    final rp = options['rp'];
    final rpId = rp is Map ? rp['id']?.toString() ?? '' : '';
    await _ensureSupported(serverBaseUrl: serverBaseUrl, rpId: rpId);
    final request = RegisterRequestType.fromJson(options);
    return _wrapAuthenticatorErrors(() async {
      final response = await _authenticator.register(request);
      return _credentialResponseJson(
        response.toJson(),
        response.clientExtensionResults,
      );
    });
  }

  static Future<Map<String, dynamic>> getCredential(
    List<int> optionsJson, {
    required String serverBaseUrl,
  }) async {
    final options = _decodeOptions(optionsJson);
    await _ensureSupported(
      serverBaseUrl: serverBaseUrl,
      rpId: options['rpId']?.toString() ?? '',
    );
    final request = AuthenticateRequestType.fromJson(
      options,
      mediation: _mediationFromOptions(options),
      preferImmediatelyAvailableCredentials: false,
    );
    return _wrapAuthenticatorErrors(() async {
      final response = await _authenticator.authenticate(request);
      return _credentialResponseJson(
        response.toJson(),
        response.clientExtensionResults,
      );
    });
  }

  static MediationType _mediationFromOptions(Map<String, dynamic> options) {
    return switch (options['mediation']) {
      'conditional' => MediationType.Conditional,
      'optional' => MediationType.Optional,
      'silent' => MediationType.Silent,
      _ => MediationType.Required,
    };
  }

  static Map<String, dynamic> _credentialResponseJson(
    Map<String, dynamic> response,
    Map<String?, Object?>? extensionResults,
  ) {
    if (extensionResults == null || extensionResults.isEmpty) return response;
    return {...response, 'clientExtensionResults': _jsonMap(extensionResults)};
  }

  static Map<String, dynamic> _jsonMap(Map<Object?, Object?> values) {
    return {
      for (final entry in values.entries)
        if (entry.key != null)
          entry.key.toString(): switch (entry.value) {
            final Map<Object?, Object?> nested => _jsonMap(nested),
            final Iterable<Object?> entries =>
              entries
                  .map(
                    (entry) => switch (entry) {
                      final Map<Object?, Object?> nested => _jsonMap(nested),
                      _ => entry,
                    },
                  )
                  .toList(growable: false),
            _ => entry.value,
          },
    };
  }

  static Map<String, dynamic> _decodeOptions(List<int> optionsJson) {
    final decoded = jsonDecode(utf8.decode(optionsJson));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Passkey challenge is not a JSON object');
    }
    return decoded;
  }

  static Future<void> _ensureSupported({
    required String serverBaseUrl,
    required String rpId,
  }) async {
    try {
      if (await isSupported(serverBaseUrl: serverBaseUrl, rpId: rpId)) return;
    } on MissingPluginException {
      throw const PasskeyUnavailableException('当前平台暂不支持 Passkey');
    } on UnimplementedError {
      throw const PasskeyUnavailableException('当前平台暂不支持 Passkey');
    } on PlatformException catch (e) {
      throw PasskeyUnavailableException(_platformErrorMessage(e));
    }
    throw const PasskeyUnavailableException('当前设备暂不支持 Passkey');
  }

  static bool _serverCanUseRpId(String serverBaseUrl, String rpId) {
    final server = Uri.tryParse(serverBaseUrl.trim());
    if (server == null || !_hostCanUseRpId(server.host, rpId)) return false;
    return server.scheme == 'https' ||
        (server.scheme == 'http' && _isLoopbackHost(server.host));
  }

  static bool _hostCanUseRpId(String host, String rpId) {
    final normalizedHost = host.trim().toLowerCase();
    return normalizedHost == rpId || normalizedHost.endsWith('.$rpId');
  }

  static bool _isValidRpId(String rpId) =>
      rpId.isNotEmpty && !rpId.contains('/') && !rpId.contains(':');

  static bool _isLoopbackHost(String host) {
    final normalized = host.toLowerCase();
    return normalized == 'localhost' ||
        normalized == '127.0.0.1' ||
        normalized == '::1' ||
        normalized == '[::1]';
  }

  static Future<T> _wrapAuthenticatorErrors<T>(Future<T> Function() action) {
    return action()
        .onError<PasskeyAuthCancelledException>(
          (error, stackTrace) =>
              throw const PasskeyUnavailableException('已取消 Passkey 验证'),
        )
        .onError<NoCredentialsAvailableException>(
          (error, stackTrace) =>
              throw const PasskeyUnavailableException('没有可用的 Passkey'),
        )
        .onError<ExcludeCredentialsCanNotBeRegisteredException>(
          (error, stackTrace) =>
              throw const PasskeyUnavailableException('此设备已经绑定过 Passkey'),
        )
        .onError<MissingGoogleSignInException>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '请先在系统中登录 Google 账号后再使用 Passkey',
          ),
        )
        .onError<SyncAccountNotAvailableException>(
          (error, stackTrace) =>
              throw const PasskeyUnavailableException('系统暂时无法访问 Passkey 同步账号'),
        )
        .onError<DomainNotAssociatedException>(
          (error, stackTrace) => throw PasskeyUnavailableException(
            '当前应用未关联 ${error.message?.isNotEmpty == true ? error.message : '服务器域名'}',
          ),
        )
        .onError<DeviceNotSupportedException>(
          (error, stackTrace) =>
              throw const PasskeyUnavailableException('当前设备暂不支持 Passkey'),
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
          (error, stackTrace) =>
              throw const PasskeyUnavailableException('Passkey 验证超时，请重试'),
        )
        .onError<MalformedBase64Url>(
          (error, stackTrace) => throw const PasskeyUnavailableException(
            '服务器返回的 Passkey challenge 无效',
          ),
        )
        .onError<PlatformException>(
          (error, stackTrace) =>
              throw PasskeyUnavailableException(_platformErrorMessage(error)),
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
