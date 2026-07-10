import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLocalePreference { system, simplifiedChinese, english }

class AppLocaleController extends ChangeNotifier {
  static const preferenceKey = 'synctv.locale';

  AppLocalePreference _preference = AppLocalePreference.system;

  AppLocalePreference get preference => _preference;

  Locale? get locale => switch (_preference) {
    AppLocalePreference.system => null,
    AppLocalePreference.simplifiedChinese => const Locale('zh'),
    AppLocalePreference.english => const Locale('en'),
  };

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    _preference = _decode(preferences.getString(preferenceKey));
  }

  Future<void> setPreference(AppLocalePreference preference) async {
    if (_preference == preference) return;
    _preference = preference;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(preferenceKey, preference.name);
  }

  static AppLocalePreference _decode(String? value) {
    return AppLocalePreference.values.firstWhere(
      (preference) => preference.name == value,
      orElse: () => AppLocalePreference.system,
    );
  }
}

final appLocaleController = AppLocaleController();
