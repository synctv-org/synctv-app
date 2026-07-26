import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

typedef DeviceDisplayNameReader = Future<String?> Function();

class DeviceDisplayNameService {
  DeviceDisplayNameService({
    DeviceInfoPlugin? deviceInfo,
    this.reader,
    this.platform,
    this.isWeb,
  }) : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _deviceInfo;
  @visibleForTesting
  final DeviceDisplayNameReader? reader;
  @visibleForTesting
  final TargetPlatform? platform;
  @visibleForTesting
  final bool? isWeb;
  Future<String>? _cachedName;

  Future<String> suggestedPasskeyName() =>
      _cachedName ??= _loadSuggestedPasskeyName();

  Future<String> _loadSuggestedPasskeyName() async {
    String? value;
    try {
      value = await (reader?.call() ?? _readPlatformName());
    } catch (error) {
      debugPrint('Failed to read the current device name: $error');
    }
    return normalize(value) ?? _fallbackName;
  }

  Future<String?> _readPlatformName() async {
    if (isWeb ?? kIsWeb) {
      final info = await _deviceInfo.webBrowserInfo;
      final platform = normalize(info.platform);
      final browser = info.browserName.name;
      return platform == null ? browser : '$browser on $platform';
    }

    return switch (_effectivePlatform) {
      TargetPlatform.android => _readAndroidName(),
      TargetPlatform.iOS => _readIosName(),
      TargetPlatform.macOS => _readMacOsName(),
      TargetPlatform.windows => _readWindowsName(),
      TargetPlatform.linux => _readLinuxName(),
      TargetPlatform.fuchsia => null,
    };
  }

  Future<String?> _readAndroidName() async {
    final info = await _deviceInfo.androidInfo;
    final configuredName = normalize(info.name);
    if (configuredName != null) return configuredName;
    return normalize([info.brand, info.model].join(' '));
  }

  Future<String?> _readIosName() async {
    final info = await _deviceInfo.iosInfo;
    return normalize(info.name) ?? normalize(info.modelName);
  }

  Future<String?> _readMacOsName() async {
    final info = await _deviceInfo.macOsInfo;
    return normalize(info.computerName) ??
        normalize(info.modelName) ??
        normalize(info.hostName);
  }

  Future<String?> _readWindowsName() async {
    final info = await _deviceInfo.windowsInfo;
    return normalize(info.computerName);
  }

  Future<String?> _readLinuxName() async {
    final hostname = normalize(Platform.localHostname);
    if (hostname != null) return hostname;
    final info = await _deviceInfo.linuxInfo;
    return normalize(info.prettyName);
  }

  TargetPlatform get _effectivePlatform => platform ?? defaultTargetPlatform;

  String get _fallbackName => switch (_effectivePlatform) {
    TargetPlatform.android => 'Android device',
    TargetPlatform.iOS => 'Apple device',
    TargetPlatform.macOS => 'Mac',
    TargetPlatform.windows => 'Windows PC',
    TargetPlatform.linux => 'Linux PC',
    TargetPlatform.fuchsia => 'This device',
  };

  @visibleForTesting
  static String? normalize(String? value) {
    if (value == null) return null;
    final normalized = value
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'localhost') {
      return null;
    }
    return String.fromCharCodes(normalized.runes.take(100));
  }
}
