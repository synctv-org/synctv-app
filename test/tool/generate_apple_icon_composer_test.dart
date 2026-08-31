import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

void main() {
  test(
    'Icon Composer layers are generated without changing the source',
    () async {
      final source = File('assets/icon/logo-notext.svg');
      final sourceBefore = source.readAsStringSync();
      final outputDirectory = await Directory.systemTemp.createTemp(
        'synctv-apple-icon-test-',
      );
      addTearDown(() => outputDirectory.delete(recursive: true));
      final output = Directory('${outputDirectory.path}/AppIcon.icon');

      final result = await Process.run('dart', [
        'run',
        'tool/generate_apple_icon_composer.dart',
        source.path,
        output.path,
      ]);

      expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
      expect(source.readAsStringSync(), sourceBefore);

      final definition = jsonDecode(
        File('${output.path}/icon.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      expect(definition['fill'], 'automatic');
      expect(definition['groups'], hasLength(1));
      expect(
        definition['supported-platforms'],
        containsPair('squares', 'shared'),
      );

      final background = XmlDocument.parse(
        File('${output.path}/Assets/background.svg').readAsStringSync(),
      );
      final foreground = XmlDocument.parse(
        File('${output.path}/Assets/foreground.svg').readAsStringSync(),
      );
      for (final layer in [background, foreground]) {
        expect(layer.rootElement.getAttribute('width'), '1024');
        expect(layer.rootElement.getAttribute('height'), '1024');
        expect(
          layer.rootElement.getAttribute('viewBox'),
          '0 0 686.002 686.003',
        );
      }

      const screenPath = 'M218.321 188.894H461.13v120.255H218.321z';
      expect(background.toXmlString(), contains('linearGradient'));
      expect(background.toXmlString(), isNot(contains(screenPath)));
      expect(foreground.toXmlString(), contains(screenPath));
      expect(foreground.toXmlString(), isNot(contains('linearGradient')));
    },
  );
}
