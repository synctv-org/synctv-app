import 'package:synctv_app/core/validation/email_address.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';

Future<({String email, String token, String password})?>
showPasswordResetDialog({
  required BuildContext context,
  required AuthGateway gateway,
  String initialEmail = '',
}) => showAppDialog<({String email, String token, String password})>(
  context: context,
  builder: (_) =>
      _PasswordResetDialog(initialEmail: initialEmail, gateway: gateway),
);

class _PasswordResetDialog extends StatefulWidget {
  const _PasswordResetDialog({
    required this.initialEmail,
    required this.gateway,
  });

  final String initialEmail;
  final AuthGateway gateway;

  @override
  State<_PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  late final TextEditingController _emailController;
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _requestResetEmail() async {
    if (_requesting) return;
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.emailRequired);
      return;
    }
    if (!hasValidEmailStructure(email)) {
      AppNotifications.showWarning(context, context.l10n.emailInvalidFormat);
      return;
    }
    setState(() => _requesting = true);
    try {
      final message = await widget.gateway.requestPasswordReset(email);
      if (!mounted) return;
      AppNotifications.showSuccess(
        context,
        message.isEmpty ? context.l10n.passwordResetEmailSent : message,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.passwordResetEmailFailed(e.toString()),
        );
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _submit() {
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || token.isEmpty || password.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.resetFieldsRequired);
      return;
    }
    if (!hasValidEmailStructure(email)) {
      AppNotifications.showWarning(context, context.l10n.emailInvalidFormat);
      return;
    }
    if (password != _confirmController.text) {
      AppNotifications.showWarning(context, context.l10n.newPasswordsMismatch);
      return;
    }
    Navigator.pop(context, (email: email, token: token, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text(context.l10n.resetPassword),
      body: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _emailController,
              label: context.l10n.email,
              labelAbove: true,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: AppActionButton(
                onPressed: _requesting ? null : _requestResetEmail,
                icon: Icons.send_outlined,
                label: context.l10n.send,
                loading: _requesting,
                style: AppActionButtonStyle.outlined,
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _tokenController,
              label: context.l10n.resetCode,
              labelAbove: true,
              prefixIcon: Icons.pin_outlined,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordController,
              label: context.l10n.newPassword,
              labelAbove: true,
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _confirmController,
              label: context.l10n.confirmNewPassword,
              labelAbove: true,
              prefixIcon: Icons.check_circle_outline_rounded,
              obscureText: true,
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        AppActionButton(
          onPressed: () => Navigator.pop(context),
          label: context.l10n.cancel,
          style: AppActionButtonStyle.outlined,
        ),
        AppActionButton(
          onPressed: _submit,
          icon: Icons.lock_reset_rounded,
          label: context.l10n.reset,
        ),
      ],
    );
  }
}
