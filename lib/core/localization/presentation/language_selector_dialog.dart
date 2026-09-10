import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';

Future<void> showLanguageSelectorDialog(
  BuildContext context, {
  AppLocaleController? controller,
}) {
  return showAppBottomSheet<void>(
    context: context,
    constraints: const BoxConstraints(maxWidth: 520),
    builder: (context) =>
        _LanguageSelectorSheet(controller: controller ?? appLocaleController),
  );
}

class _LanguageSelectorSheet extends StatefulWidget {
  const _LanguageSelectorSheet({required this.controller});

  final AppLocaleController controller;

  @override
  State<_LanguageSelectorSheet> createState() => _LanguageSelectorSheetState();
}

class _LanguageSelectorSheetState extends State<_LanguageSelectorSheet> {
  bool _saving = false;
  bool _closing = false;

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;

  void _close() {
    if (!_active) return;
    _closing = true;
    Navigator.pop(context);
  }

  Future<void> _select(AppLocalePreference preference) async {
    if (!_active || _saving) return;
    setState(() => _saving = true);
    try {
      await widget.controller.setPreference(preference);
      if (!mounted || _closing) return;
      setState(() => _saving = false);
      _close();
    } catch (error) {
      if (!mounted || _closing) return;
      setState(() => _saving = false);
      if (!_active) return;
      AppNotifications.showError(
        context,
        context.l10n.operationFailed(error.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => _buildSheet(context),
  );

  Widget _buildSheet(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return AppBottomSheetFrame(
      child: AppSingleChildScrollView(
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
                  onPressed: _close,
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
            SizedBox(
              height: 4,
              child: _saving ? const AppLinearProgress() : null,
            ),
            const SizedBox(height: 8),
            _LanguageOption(
              selected:
                  widget.controller.preference == AppLocalePreference.system,
              onTap: _saving ? null : () => _select(AppLocalePreference.system),
              icon: Icons.devices_rounded,
              label: l10n.languageSystem,
            ),
            const SizedBox(height: 8),
            _LanguageOption(
              selected:
                  widget.controller.preference ==
                  AppLocalePreference.simplifiedChinese,
              onTap: _saving
                  ? null
                  : () => _select(AppLocalePreference.simplifiedChinese),
              icon: Icons.translate_rounded,
              label: l10n.languageChineseSimplified,
            ),
            const SizedBox(height: 8),
            _LanguageOption(
              selected:
                  widget.controller.preference == AppLocalePreference.english,
              onTap: _saving
                  ? null
                  : () => _select(AppLocalePreference.english),
              icon: Icons.abc_rounded,
              label: l10n.languageEnglish,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final bool selected;
  final VoidCallback? onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        enabled: onTap != null,
        button: true,
        child: AppInkSurface(
          onTap: onTap,
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
        ),
      ),
    );
  }
}
