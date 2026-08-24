import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class AppDialogs {
  static Future<T?> showStyledDialog<T>({
    required BuildContext context,
    required String title,
    required Icon icon,
    required Widget content,
    required List<Widget> actions,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final accent = iconColor ?? theme.colorScheme.primary;

    return showAppDialog<T>(
      context: context,
      builder: (context) => AppDialogFrame(
        maxWidth: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeaderBar(
              title: title,
              icon: icon.icon ?? Icons.info_outline_rounded,
              color: accent,
              onClose: () => Navigator.of(context).pop(),
            ),
            Flexible(
              child: AppSingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                child: Align(alignment: Alignment.centerLeft, child: content),
              ),
            ),
            _DialogActionBar(actions: actions),
          ],
        ),
      ),
    );
  }

  static Widget createCancelButton(BuildContext context) {
    return AppActionButton(
      onPressed: () => Navigator.pop(context),
      label: context.l10n.cancel,
      style: AppActionButtonStyle.outlined,
    );
  }

  static Widget createConfirmButton(
    BuildContext context,
    VoidCallback onTap, {
    String? text,
  }) {
    return AppActionButton(
      onPressed: onTap,
      label: text ?? context.l10n.confirm,
    );
  }

  static Widget createFormField({
    Key? key,
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
    String? helperText,
    bool enabled = true,
    IconData? prefixIcon,
    Widget? suffix,
    int? maxLines = 1,
    TextInputType? keyboardType,
    bool enableSuggestions = true,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    void Function(String)? onSubmitted,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      label: label,
      hintText: hintText,
      helperText: helperText,
      obscureText: obscureText,
      enabled: enabled,
      prefixIcon: prefixIcon,
      suffix: suffix,
      maxLines: maxLines,
      keyboardType: keyboardType,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      onSubmitted: onSubmitted,
    );
  }
}

class _DialogHeaderBar extends StatelessWidget {
  const _DialogHeaderBar({
    required this.title,
    required this.icon,
    required this.color,
    required this.onClose,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.38),
      borderRadius: BorderRadius.zero,
      child: Row(
        children: [
          AppIconBadge(
            icon: icon,
            color: color,
            iconColor: Colors.white,
            backgroundColor: color,
            size: 42,
            iconSize: 22,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          AppIconButton(
            tooltip: context.l10n.close,
            icon: Icons.close_rounded,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _DialogActionBar extends StatelessWidget {
  const _DialogActionBar({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      color: Colors.transparent,
      borderRadius: BorderRadius.zero,
      border: Border(
        top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(spacing: 10, runSpacing: 8, children: actions),
      ),
    );
  }
}
