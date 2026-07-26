import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

Future<void> showLanguageSelectorDialog(BuildContext context) {
  return showAppBottomSheet<void>(
    context: context,
    constraints: const BoxConstraints(maxWidth: 520),
    builder: (context) => const _LanguageSelectorSheet(),
  );
}

class _LanguageSelectorSheet extends StatelessWidget {
  const _LanguageSelectorSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return AppBottomSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.language_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.languageSettingsTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppIconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.pop(context),
                icon: Icons.close_rounded,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.languageSettingsDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          _LanguageOption(
            preference: AppLocalePreference.system,
            icon: Icons.devices_rounded,
            label: l10n.languageSystem,
          ),
          const SizedBox(height: 8),
          _LanguageOption(
            preference: AppLocalePreference.simplifiedChinese,
            icon: Icons.translate_rounded,
            label: l10n.languageChineseSimplified,
          ),
          const SizedBox(height: 8),
          _LanguageOption(
            preference: AppLocalePreference.english,
            icon: Icons.abc_rounded,
            label: l10n.languageEnglish,
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.preference,
    required this.icon,
    required this.label,
  });

  final AppLocalePreference preference;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final selected = appLocaleController.preference == preference;
    final theme = Theme.of(context);

    return AppInkSurface(
      onTap: () async {
        await appLocaleController.setPreference(preference);
        if (context.mounted) Navigator.pop(context);
      },
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
