import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

void main() {
  test('Flutter logo SVG contains supported structural elements', () {
    final svg = File('assets/icon/logo-notext.svg').readAsStringSync();

    expect(svg, contains('<svg'));
    expect(svg, isNot(contains('<switch')));
    expect(svg, isNot(contains('macos-safe-area-artwork')));
  });

  test('Apple platforms share the generated Icon Composer package', () {
    final iconDirectory = Directory('assets/icon/AppIcon.icon');
    final definition =
        jsonDecode(File('${iconDirectory.path}/icon.json').readAsStringSync())
            as Map<String, dynamic>;

    expect(
      File('${iconDirectory.path}/Assets/background.svg').existsSync(),
      isTrue,
    );
    expect(
      File('${iconDirectory.path}/Assets/foreground.svg').existsSync(),
      isTrue,
    );
    expect(
      definition['supported-platforms'],
      containsPair('squares', 'shared'),
    );

    for (final projectPath in [
      'ios/Runner.xcodeproj/project.pbxproj',
      'macos/Runner.xcodeproj/project.pbxproj',
    ]) {
      final project = File(projectPath).readAsStringSync();
      expect(project, contains('folder.iconcomposer.icon'));
      expect(project, contains('AppIcon.icon in Resources'));
    }

    expect(
      Directory('ios/Runner/Assets.xcassets/AppIcon.appiconset').existsSync(),
      isFalse,
    );
    expect(
      Directory('macos/Runner/Assets.xcassets/AppIcon.appiconset').existsSync(),
      isFalse,
    );
  });

  test('iOS project omits unused legacy resources and capabilities', () {
    expect(Directory('ios/Runner/Assets.xcassets').existsSync(), isFalse);

    final launchScreen = XmlDocument.parse(
      File('ios/Runner/Base.lproj/LaunchScreen.storyboard').readAsStringSync(),
    );
    final backgroundColor = launchScreen
        .findAllElements('color')
        .singleWhere(
          (element) => element.getAttribute('key') == 'backgroundColor',
        );
    expect(
      backgroundColor.getAttribute('systemColor'),
      'systemBackgroundColor',
    );
    expect(launchScreen.findAllElements('image'), isEmpty);

    final infoPlist = XmlDocument.parse(
      File('ios/Runner/Info.plist').readAsStringSync(),
    );
    final keys = infoPlist
        .findAllElements('key')
        .map((element) => element.innerText)
        .toSet();
    final strings = infoPlist
        .findAllElements('string')
        .map((element) => element.innerText)
        .toList(growable: false);
    expect(keys, isNot(contains('NSBonjourServices')));
    expect(strings, contains('audio'));
    expect(strings, isNot(contains('voip')));
  });
}
