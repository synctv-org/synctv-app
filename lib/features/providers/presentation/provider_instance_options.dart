import 'package:synctv_app/l10n/l10n.dart';

Map<String, String> providerInstanceOptions(
  List<String> instanceNames,
  AppLocalizations l10n,
) {
  var localLabel = l10n.localInstance;
  if (instanceNames.contains(localLabel)) {
    final base = '$localLabel (${l10n.defaultProviderInstance})';
    localLabel = base;
    var suffix = 2;
    // Reserve every remote name, including names matching a fallback label.
    final reserved = instanceNames.toSet();
    while (reserved.contains(localLabel)) {
      localLabel = '$base ${suffix++}';
    }
  }
  return {
    for (final name in instanceNames) name.isEmpty ? localLabel : name: name,
  };
}
