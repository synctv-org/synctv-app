import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/presentation/admin_gateway_scope.dart';
import 'package:synctv_app/l10n/l10n.dart';

class EditUserDialog extends StatefulWidget {
  const EditUserDialog.rename({
    super.key,
    required this.userId,
    required this.username,
  }) : resetPassword = false;
  const EditUserDialog.password({super.key, required this.userId})
    : resetPassword = true,
      username = '';

  final String userId;
  final String username;
  final bool resetPassword;

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late final _value = TextEditingController(text: widget.username);
  final _reason = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _saving = false;
  bool _closing = false;

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;

  @override
  void dispose() {
    _value.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _finish(bool saved) {
    if (!_active) return;
    _closing = true;
    Navigator.pop(context, saved);
  }

  Future<void> _submit() async {
    if (!_active || _saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (widget.resetPassword) {
        await context.adminGateway.adminUpdatePassword(
          widget.userId,
          _value.text,
          reason: _reason.text.trim(),
        );
      } else {
        await context.adminGateway.adminUpdateUsername(
          widget.userId,
          _value.text.trim(),
        );
      }
      _finish(true);
    } catch (error) {
      if (mounted && _active) {
        final l10n = context.l10n;
        AppNotifications.showError(
          context,
          widget.resetPassword
              ? l10n.resetPasswordFailed('$error')
              : l10n.changeUsernameFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final password = widget.resetPassword;
    return AppDialog(
      title: Text(password ? l10n.resetPassword : l10n.changeUsername),
      icon: Icon(
        password
            ? Icons.lock_reset_rounded
            : Icons.drive_file_rename_outline_rounded,
      ),
      body: Form(
        key: _form,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _value,
                label: password ? l10n.newPassword : l10n.newUsername,
                labelAbove: true,
                hintText: password
                    ? l10n.passwordMinimumLength(8)
                    : l10n.usernameLengthHint,
                prefixIcon: password
                    ? Icons.lock_outline
                    : Icons.person_outline,
                obscureText: password,
                autocorrect: false,
                enabled: !_saving,
                validator: (value) =>
                    (password ? value ?? '' : value?.trim() ?? '').isEmpty
                    ? (password ? l10n.passwordRequired : l10n.usernameRequired)
                    : null,
                onSubmitted: (_) => _submit(),
              ),
              if (password) ...[
                const SizedBox(height: 12),
                AppTextField(
                  controller: _reason,
                  label: l10n.auditReason,
                  labelAbove: true,
                  hintText: l10n.optional,
                  prefixIcon: Icons.edit_note_rounded,
                  enabled: !_saving,
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppActionButton(
          onPressed: () => _finish(false),
          label: l10n.cancel,
          style: AppActionButtonStyle.outlined,
          wrapLabel: true,
        ),
        AppActionButton(
          onPressed: _saving ? null : _submit,
          label: password ? l10n.reset : l10n.save,
          loading: _saving,
          wrapLabel: true,
        ),
      ],
    );
  }
}
