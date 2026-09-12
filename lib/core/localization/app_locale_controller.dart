import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/async/persisted_value_controller.dart';

enum AppLocalePreference { system, simplifiedChinese, english }

class AppLocaleController
    extends PersistedValueController<AppLocalePreference> {
  AppLocaleController({
    Future<AppLocalePreference> Function()? read,
    Future<void> Function(AppLocalePreference)? write,
  }) : super(
         initialValue: AppLocalePreference.system,
         read: read ?? _readPreference,
         write: write ?? _writePreference,
       );

  static const preferenceKey = 'synctv.locale';

  AppLocalePreference get preference => value;

  Locale? get locale => switch (preference) {
    AppLocalePreference.system => null,
    AppLocalePreference.simplifiedChinese => const Locale('zh'),
    AppLocalePreference.english => const Locale('en'),
  };

  Future<void> setPreference(AppLocalePreference preference) =>
      persist(preference);

  static Future<AppLocalePreference> _readPreference() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.get(preferenceKey);
    return _decode(raw is String ? raw : null);
  }

  static Future<void> _writePreference(AppLocalePreference preference) async {
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setString(preferenceKey, preference.name)) {
      throw StateError('Could not persist language preference');
    }
  }

  static AppLocalePreference _decode(String? value) {
    return AppLocalePreference.values.firstWhere(
      (preference) => preference.name == value,
      orElse: () => AppLocalePreference.system,
    );
  }
}

final appLocaleController = AppLocaleController();
