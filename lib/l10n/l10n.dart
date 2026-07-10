import 'package:flutter/widgets.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

export 'package:synctv_app/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
