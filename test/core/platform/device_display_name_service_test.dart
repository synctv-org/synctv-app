import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/platform/device_display_name_service.dart';

void main() {
  test('normalizes a platform device name for a passkey label', () async {
    final service = DeviceDisplayNameService(
      reader: () async => '  Alice\nMacBook Pro  ',
      platform: TargetPlatform.macOS,
      isWeb: false,
    );

    expect(await service.suggestedPasskeyName(), 'Alice MacBook Pro');
  });

  test(
    'uses a platform fallback when the device name is unavailable',
    () async {
      final service = DeviceDisplayNameService(
        reader: () async => 'localhost',
        platform: TargetPlatform.windows,
        isWeb: false,
      );

      expect(await service.suggestedPasskeyName(), 'Windows PC');
    },
  );

  test(
    'caches device discovery and limits labels to the API maximum',
    () async {
      var reads = 0;
      final service = DeviceDisplayNameService(
        reader: () async {
          reads += 1;
          return List.filled(101, 'a').join();
        },
        platform: TargetPlatform.linux,
        isWeb: false,
      );

      final first = await service.suggestedPasskeyName();
      final second = await service.suggestedPasskeyName();

      expect(first.runes.length, 100);
      expect(second, first);
      expect(reads, 1);
    },
  );
}
