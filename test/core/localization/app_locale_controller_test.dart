import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  for (final invalid in <Object>[
    true,
    42,
    0.5,
    <String>['english'],
  ]) {
    test('wrong stored locale type recovers and can save: $invalid', () async {
      SharedPreferences.setMockInitialValues({
        AppLocaleController.preferenceKey: invalid,
      });
      final controller = AppLocaleController();
      addTearDown(controller.dispose);
      await controller.load();
      expect(controller.preference, AppLocalePreference.system);
      expect(controller.locale, isNull);
      await controller.setPreference(AppLocalePreference.english);
      final restored = AppLocaleController();
      addTearDown(restored.dispose);
      await restored.load();
      expect(restored.locale, const Locale('en'));
    });
  }

  test('late stored locale does not replace a newer selection', () async {
    final stored = Completer<AppLocalePreference>();
    final writes = <AppLocalePreference>[];
    final controller = AppLocaleController(
      read: () => stored.future,
      write: (value) async => writes.add(value),
    );
    addTearDown(controller.dispose);
    final load = controller.load();
    final save = controller.setPreference(AppLocalePreference.english);
    stored.complete(AppLocalePreference.simplifiedChinese);
    await load;
    await save;
    expect(controller.locale, const Locale('en'));
    expect(writes, [AppLocalePreference.english]);
  });

  test('failed queued selection restores the last durable locale', () async {
    final pending = <Completer<void>>[];
    final writes = <AppLocalePreference>[];
    final controller = AppLocaleController(
      write: (value) {
        writes.add(value);
        final operation = Completer<void>();
        pending.add(operation);
        return operation.future;
      },
    );
    addTearDown(controller.dispose);
    final first = controller.setPreference(AppLocalePreference.english);
    final second = controller.setPreference(
      AppLocalePreference.simplifiedChinese,
    );
    final secondResult = expectLater(second, throwsStateError);
    await Future<void>.delayed(Duration.zero);
    expect(writes, [AppLocalePreference.english]);
    expect(controller.locale, const Locale('zh'));
    pending.first.complete();
    await first;
    await Future<void>.delayed(Duration.zero);
    expect(writes, [
      AppLocalePreference.english,
      AppLocalePreference.simplifiedChinese,
    ]);
    pending.last.completeError(StateError('storage unavailable'));
    await secondResult;
    expect(controller.locale, const Locale('en'));
  });

  test('failed selection restores the stored language and can retry', () async {
    var fail = true;
    final controller = AppLocaleController(
      read: () async => AppLocalePreference.simplifiedChinese,
      write: (_) async {
        if (fail) throw StateError('storage unavailable');
      },
    );
    addTearDown(controller.dispose);
    await controller.load();
    await expectLater(
      controller.setPreference(AppLocalePreference.english),
      throwsStateError,
    );
    expect(controller.locale, const Locale('zh'));
    fail = false;
    await controller.setPreference(AppLocalePreference.english);
    expect(controller.locale, const Locale('en'));
  });

  test(
    'pending storage failure after disposal does not notify listeners',
    () async {
      final pending = Completer<void>();
      final controller = AppLocaleController(write: (_) => pending.future);
      var notifications = 0;
      controller.addListener(() => notifications++);
      final save = controller.setPreference(AppLocalePreference.english);
      final result = expectLater(save, throwsStateError);
      expect(notifications, 1);
      controller.dispose();
      pending.completeError(StateError('late storage failure'));
      await result;
      expect(notifications, 1);
    },
  );

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
