import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Apple entitlement generator', () {
    test('adds both services required by an HTTPS OAuth callback', () async {
      final domains = await _generateAssociatedDomains(
        oauth2Origin: 'https://syncs.tv',
      );

      expect(domains, contains('applinks:syncs.tv'));
      expect(domains, contains('webcredentials:syncs.tv'));
    }, skip: Platform.isWindows);

    test('deduplicates OAuth and passkey web credential domains', () async {
      final domains = await _generateAssociatedDomains(
        oauth2Origin: 'https://syncs.tv',
        passkeyRpIds: 'syncs.tv',
      );

      expect(
        domains.where((domain) => domain == 'webcredentials:syncs.tv'),
        hasLength(1),
      );
    }, skip: Platform.isWindows);

    test('preserves an unchanged entitlement file timestamp', () async {
      final outputDirectory = await Directory.systemTemp.createTemp(
        'synctv-entitlements-idempotence-test-',
      );
      addTearDown(() => outputDirectory.delete(recursive: true));
      final output = File('${outputDirectory.path}/Generated.entitlements');
      final defines = _encodeDefines(
        oauth2Origin: 'https://syncs.tv',
        passkeyRpIds: 'syncs.tv',
      );

      await _runGenerator(output: output, defines: defines);
      final fixedTimestamp = DateTime.utc(2000);
      await output.setLastModified(fixedTimestamp);
      await _runGenerator(output: output, defines: defines);

      expect(
        (await output.lastModified()).millisecondsSinceEpoch,
        fixedTimestamp.millisecondsSinceEpoch,
      );
    }, skip: Platform.isWindows);

    test(
      'omits native Apple entitlement for Developer ID macOS builds',
      () async {
        final outputDirectory = await Directory.systemTemp.createTemp(
          'synctv-entitlements-developer-id-test-',
        );
        addTearDown(() => outputDirectory.delete(recursive: true));
        final output = File('${outputDirectory.path}/Generated.entitlements');

        await _runGenerator(
          output: output,
          defines: _encodeDefines(
            oauth2Origin: '',
            passkeyRpIds: '',
            nativeAppleSignIn: false,
          ),
        );

        final document = XmlDocument.parse(await output.readAsString());
        final keys = document
            .findAllElements('key')
            .map((element) => element.innerText)
            .toList(growable: false);
        expect(keys, isNot(contains('com.apple.developer.applesignin')));
      },
      skip: Platform.isWindows,
    );

    test('includes native Apple entitlement when explicitly enabled', () async {
      final outputDirectory = await Directory.systemTemp.createTemp(
        'synctv-entitlements-native-apple-test-',
      );
      addTearDown(() => outputDirectory.delete(recursive: true));
      final output = File('${outputDirectory.path}/Generated.entitlements');

      await _runGenerator(
        output: output,
        defines: _encodeDefines(
          oauth2Origin: '',
          passkeyRpIds: '',
          nativeAppleSignIn: true,
        ),
      );

      final document = XmlDocument.parse(await output.readAsString());
      final keys = document
          .findAllElements('key')
          .map((element) => element.innerText)
          .toList(growable: false);
      expect(keys, contains('com.apple.developer.applesignin'));
    }, skip: Platform.isWindows);
  });
}

Future<List<String>> _generateAssociatedDomains({
  required String oauth2Origin,
  String passkeyRpIds = '',
}) async {
  final outputDirectory = await Directory.systemTemp.createTemp(
    'synctv-entitlements-test-',
  );
  addTearDown(() => outputDirectory.delete(recursive: true));
  final output = File('${outputDirectory.path}/Generated.entitlements');
  final defines = _encodeDefines(
    oauth2Origin: oauth2Origin,
    passkeyRpIds: passkeyRpIds,
  );

  await _runGenerator(output: output, defines: defines);

  final document = XmlDocument.parse(await output.readAsString());
  return document
      .findAllElements('string')
      .map((element) => element.innerText)
      .toList(growable: false);
}

String _encodeDefines({
  required String oauth2Origin,
  required String passkeyRpIds,
  bool? nativeAppleSignIn,
}) {
  final values = [
    'SYNCTV_OAUTH2_APP_LINK_ORIGIN=$oauth2Origin',
    'SYNCTV_PASSKEY_RP_IDS=$passkeyRpIds',
  ];
  if (nativeAppleSignIn != null) {
    values.add(
      'SYNCTV_NATIVE_APPLE_SIGN_IN=${nativeAppleSignIn ? 'true' : 'false'}',
    );
  }
  return values.map((value) => base64Encode(utf8.encode(value))).join(',');
}

Future<void> _runGenerator({
  required File output,
  required String defines,
}) async {
  final result = await Process.run(
    '/bin/bash',
    [
      'tool/generate_apple_entitlements.sh',
      'macos',
      output.path,
      'Release',
      '85KBWFQ6F6',
    ],
    environment: {...Platform.environment, 'DART_DEFINES': defines},
  );
  expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
}
