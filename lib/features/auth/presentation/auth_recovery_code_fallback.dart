import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class AuthRecoveryCodeFallback extends StatelessWidget {
  const AuthRecoveryCodeFallback({
    super.key,
    required this.active,
    required this.recoveryForm,
    required this.onOpen,
    required this.onBack,
  });

  static const openButtonKey = ValueKey('open-recovery-code-flow');
  static const backButtonKey = ValueKey('back-from-recovery-code-flow');
  static const recoveryPageKey = ValueKey('recovery-code-flow');

  final bool active;
  final Widget recoveryForm;
  final VoidCallback? onOpen;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return Align(
        alignment: Alignment.centerRight,
        child: AppActionButton(
          key: openButtonKey,
          onPressed: onOpen,
          icon: Icons.key_rounded,
          label: context.l10n.useRecoveryCode,
          style: AppActionButtonStyle.text,
        ),
      );
    }

    final theme = Theme.of(context);
    return Column(
      key: recoveryPageKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.key_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.l10n.recoveryCode,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        recoveryForm,
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: AppActionButton(
            key: backButtonKey,
            onPressed: onBack,
            icon: Icons.arrow_back_rounded,
            label: context.l10n.backToVerificationMethods,
            style: AppActionButtonStyle.text,
          ),
        ),
      ],
    );
  }
}
