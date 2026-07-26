import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('uses the system locale by default', () async {
    final controller = AppLocaleController();

    await controller.load();

    expect(controller.preference, AppLocalePreference.system);
    expect(controller.locale, isNull);
  });

  test('persists and restores an explicit locale', () async {
    final controller = AppLocaleController();

    await controller.setPreference(AppLocalePreference.english);

    expect(controller.locale, const Locale('en'));
    final restored = AppLocaleController();
    await restored.load();
    expect(restored.preference, AppLocalePreference.english);
    expect(restored.locale, const Locale('en'));
  });

  test('falls back to the system locale for an unknown preference', () async {
    SharedPreferences.setMockInitialValues({
      AppLocaleController.preferenceKey: 'unsupported-locale',
    });
    final controller = AppLocaleController();

    await controller.load();

    expect(controller.preference, AppLocalePreference.system);
    expect(controller.locale, isNull);
  });
}
