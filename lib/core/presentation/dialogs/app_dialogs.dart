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
        child: AppSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeaderBar(
                title: title,
                icon: icon.icon ?? Icons.info_outline_rounded,
                color: accent,
                onClose: () => _closeCurrentRoute(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                child: Align(alignment: Alignment.centerLeft, child: content),
              ),
              _DialogActionBar(actions: actions),
            ],
          ),
        ),
      ),
    );
  }

  static Widget createCancelButton(BuildContext context) {
    final label = context.l10n.cancel;
    return Builder(
      builder: (buttonContext) => AppActionButton(
        wrapLabel: true,
        onPressed: () => _closeCurrentRoute(buttonContext),
        label: label,
        style: AppActionButtonStyle.outlined,
      ),
    );
  }

  static void _closeCurrentRoute(BuildContext context) {
    if (!context.mounted || ModalRoute.of(context)?.isCurrent != true) return;
    Navigator.of(context).pop();
  }

  static Widget createConfirmButton(
    BuildContext context,
    VoidCallback onTap, {
    String? text,
  }) {
    final label = text ?? context.l10n.confirm;
    return Builder(
      builder: (buttonContext) => AppActionButton(
        wrapLabel: true,
        onPressed: () {
          if (!buttonContext.mounted ||
              ModalRoute.of(buttonContext)?.isCurrent != true) {
            return;
          }
          onTap();
        },
        label: label,
      ),
    );
  }

  static Widget createFormField({
    Key? key,
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    bool labelAbove = false,
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
      labelAbove: labelAbove,
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
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
    );
    final titleText = Text(title, style: titleStyle);
    final iconBadge = AppIconBadge(
      icon: icon,
      color: color,
      iconColor: Colors.white,
      backgroundColor: color,
      size: 42,
      iconSize: 22,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    );
    final closeButton = AppIconButton(
      tooltip: context.l10n.close,
      icon: Icons.close_rounded,
      onPressed: onClose,
    );
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.38),
      borderRadius: BorderRadius.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = titleStyle?.fontSize ?? 22;
          final stacked =
              constraints.maxWidth < 360 ||
              MediaQuery.textScalerOf(context).scale(fontSize) > fontSize * 1.5;
          if (stacked) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [iconBadge, const Spacer(), closeButton]),
                const SizedBox(height: 12),
                titleText,
              ],
            );
          }
          return Row(
            children: [
              iconBadge,
              const SizedBox(width: 14),
              Expanded(child: titleText),
              closeButton,
            ],
          );
        },
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
