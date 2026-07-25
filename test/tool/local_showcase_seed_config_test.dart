import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/local_showcase_seed_config.dart';

void main() {
  late Directory coverDirectory;

  setUp(() {
    coverDirectory = Directory.systemTemp.createTempSync(
      'synctv-showcase-config-',
    );
    File.fromUri(coverDirectory.uri.resolve('cover.jpg')).writeAsBytesSync([1]);
  });

  tearDown(() => coverDirectory.deleteSync(recursive: true));

  test('accepts loopback servers with complete cover assets', () {
    for (final baseUrl in const [
      'http://localhost:8080',
      'http://127.0.0.1:8080',
      'https://[::1]:8443',
    ]) {
      expect(
        () => validateLocalShowcaseConfiguration(
          baseUrl: baseUrl,
          coverDirectory: coverDirectory.path,
          allowReset: true,
          requiredCoverFiles: const ['cover.jpg'],
        ),
        returnsNormally,
      );
    }
  });

  test('rejects remote servers before showcase cleanup', () {
    expect(
      () => validateLocalShowcaseConfiguration(
        baseUrl: 'https://syncs.tv',
        coverDirectory: coverDirectory.path,
        allowReset: true,
        requiredCoverFiles: const ['cover.jpg'],
      ),
      throwsArgumentError,
    );
  });

  test('requires explicit authorization before showcase cleanup', () {
    expect(
      () => validateLocalShowcaseConfiguration(
        baseUrl: 'http://127.0.0.1:8080',
        coverDirectory: coverDirectory.path,
        allowReset: false,
        requiredCoverFiles: const ['cover.jpg'],
      ),
      throwsArgumentError,
    );
  });

  test('rejects incomplete cover assets before showcase cleanup', () {
    expect(
      () => validateLocalShowcaseConfiguration(
        baseUrl: 'http://127.0.0.1:8080',
        coverDirectory: coverDirectory.path,
        allowReset: true,
        requiredCoverFiles: const ['missing.jpg'],
      ),
      throwsArgumentError,
    );
  });
}
