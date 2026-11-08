import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/async/persisted_value_controller.dart';

enum AppThemeModePreference { system, light, dark }

class AppThemeModeController
    extends PersistedValueController<AppThemeModePreference> {
  AppThemeModeController({
    Future<AppThemeModePreference> Function()? read,
    Future<void> Function(AppThemeModePreference)? write,
  }) : super(
         initialValue: AppThemeModePreference.system,
         read: read ?? _readPreference,
         write: write ?? _writePreference,
       );

  static const preferenceKey = 'synctv.theme_mode';

  AppThemeModePreference get preference => value;

  ThemeMode get themeMode => switch (preference) {
    AppThemeModePreference.system => ThemeMode.system,
    AppThemeModePreference.light => ThemeMode.light,
    AppThemeModePreference.dark => ThemeMode.dark,
  };

  Future<void> setPreference(AppThemeModePreference preference) =>
      persist(preference);

  static Future<AppThemeModePreference> _readPreference() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.get(preferenceKey);
    return _decode(raw is String ? raw : null);
  }

  static Future<void> _writePreference(
    AppThemeModePreference preference,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setString(preferenceKey, preference.name)) {
      throw StateError('Could not persist theme mode preference');
    }
  }

  static AppThemeModePreference _decode(String? value) {
    return AppThemeModePreference.values.firstWhere(
      (preference) => preference.name == value,
      orElse: () => AppThemeModePreference.system,
    );
  }
}

final appThemeModeController = AppThemeModeController();
