import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart' as date_symbols;
import 'package:intl/intl.dart' as intl;
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
       ) {
    addListener(_syncIntlLocale);
  }

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

  /// Loads the intl date symbols the app can render and points
  /// `Intl.defaultLocale` at the effective app locale, so `DateFormat`
  /// calls render in the user's language everywhere.
  Future<void> ensureDateFormattingInitialized() async {
    await date_symbols.initializeDateFormatting('en');
    await date_symbols.initializeDateFormatting('zh');
    _syncIntlLocale();
  }

  void _syncIntlLocale() {
    final resolved = locale?.languageCode ?? _platformLanguageCode();
    intl.Intl.defaultLocale = resolved.startsWith('zh') ? 'zh' : 'en';
  }

  static String _platformLanguageCode() =>
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
}

final appLocaleController = AppLocaleController();
