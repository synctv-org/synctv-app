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
    expect(keys, contains('NSMicrophoneUsageDescription'));
    expect(keys, contains('NSLocalNetworkUsageDescription'));
    expect(keys, contains('NSCameraUsageDescription'));
    expect(keys, isNot(contains('NSPhotoLibraryUsageDescription')));
    expect(strings, contains('audio'));
    expect(strings, isNot(contains('voip')));
  });

  test('Apple privacy descriptions cover packaged native capabilities', () {
    const privacyKeys = [
      'NSCameraUsageDescription',
      'NSMicrophoneUsageDescription',
      'NSLocalNetworkUsageDescription',
    ];

    for (final platform in ['ios', 'macos']) {
      final infoPlist = XmlDocument.parse(
        File('$platform/Runner/Info.plist').readAsStringSync(),
      );
      final keys = infoPlist
          .findAllElements('key')
          .map((element) => element.innerText)
          .toSet();

      for (final key in privacyKeys) {
        expect(keys, contains(key), reason: '$platform is missing $key');
      }

      for (final locale in ['en', 'zh-Hans']) {
        final localizedDescriptions = File(
          '$platform/Runner/$locale.lproj/InfoPlist.strings',
        ).readAsStringSync();
        for (final key in privacyKeys) {
          expect(
            localizedDescriptions,
            contains('"$key" = '),
            reason: '$platform/$locale is missing $key',
          );
        }
      }
    }
  });

  test('Android launcher uses adaptive and monochrome icon resources', () {
    const androidNamespace = 'http://schemas.android.com/apk/res/android';
    final manifest = XmlDocument.parse(
      File('android/app/src/main/AndroidManifest.xml').readAsStringSync(),
    );
    final application = manifest.findAllElements('application').single;
    expect(
      application.getAttribute('icon', namespaceUri: androidNamespace),
      '@mipmap/ic_launcher',
    );
    expect(
      application.getAttribute('roundIcon', namespaceUri: androidNamespace),
      '@mipmap/ic_launcher',
    );

    final adaptiveIcon = XmlDocument.parse(
      File(
        'android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml',
      ).readAsStringSync(),
    );
    expect(adaptiveIcon.rootElement.name.local, 'adaptive-icon');
    expect(
      adaptiveIcon
          .findAllElements('background')
          .single
          .getAttribute('drawable', namespaceUri: androidNamespace),
      '@color/ic_launcher_background',
    );

    for (final layer in ['foreground', 'monochrome']) {
      final inset = adaptiveIcon
          .findAllElements(layer)
          .single
          .findElements('inset')
          .single;
      expect(
        inset.getAttribute('drawable', namespaceUri: androidNamespace),
        '@drawable/ic_launcher_$layer',
      );
      expect(
        inset.getAttribute('inset', namespaceUri: androidNamespace),
        '12%',
      );
    }

    for (final density in ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']) {
      for (final layer in ['foreground', 'monochrome']) {
        expect(
          File(
            'android/app/src/main/res/drawable-$density/'
            'ic_launcher_$layer.png',
          ).existsSync(),
          isTrue,
        );
      }
      expect(
        File(
          'android/app/src/main/res/mipmap-$density/ic_launcher.png',
        ).existsSync(),
        isTrue,
      );
    }
  });
}
