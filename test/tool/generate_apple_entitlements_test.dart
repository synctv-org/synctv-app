import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Apple entitlement generator', () {
    test(
      'adds both services required by an HTTPS OAuth callback',
      () async {
        final domains = await _generateAssociatedDomains(
          oauth2Origin: 'https://syncs.tv',
        );

        expect(domains, contains('applinks:syncs.tv'));
        expect(domains, contains('webcredentials:syncs.tv'));
      },
      skip: Platform.isWindows,
    );

    test(
      'deduplicates OAuth and passkey web credential domains',
      () async {
        final domains = await _generateAssociatedDomains(
          oauth2Origin: 'https://syncs.tv',
          passkeyRpIds: 'syncs.tv',
        );

        expect(
          domains.where((domain) => domain == 'webcredentials:syncs.tv'),
          hasLength(1),
        );
      },
      skip: Platform.isWindows,
    );
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
  final defines = [
    'SYNCTV_OAUTH2_APP_LINK_ORIGIN=$oauth2Origin',
    'SYNCTV_PASSKEY_RP_IDS=$passkeyRpIds',
  ].map((value) => base64Encode(utf8.encode(value))).join(',');

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

  final document = XmlDocument.parse(await output.readAsString());
  return document
      .findAllElements('string')
      .map((element) => element.innerText)
      .toList(growable: false);
}
