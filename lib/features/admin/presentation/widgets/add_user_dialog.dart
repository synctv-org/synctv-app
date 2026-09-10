import 'package:synctv_app/core/validation/email_address.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/presentation/admin_gateway_scope.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _role = common.UserRole.USER_ROLE_USER;
  var _status = common.UserStatus.USER_STATUS_ACTIVE;
  var _saving = false;
  var _closing = false;

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _finish(bool created) {
    if (!_active) return;
    _closing = true;
    Navigator.pop(context, created);
  }

  Future<void> _submit() async {
    if (!_active || _saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await context.adminGateway.adminAddUser(
        _username.text.trim(),
        _password.text,
        _role,
        email: _email.text.trim(),
        status: _status,
      );
      _finish(true);
    } catch (error) {
      if (mounted && _active) {
        AppNotifications.showError(
          context,
          context.l10n.createUserFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppDialog(
      title: Text(l10n.addUser),
      icon: const Icon(Icons.person_add_outlined),
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _username,
                label: l10n.username,
                labelAbove: true,
                prefixIcon: Icons.person_outline,
                enabled: !_saving,
                autocorrect: false,
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.usernameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _email,
                label: l10n.email,
                labelAbove: true,
                hintText: l10n.optional,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                enabled: !_saving,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return null;
                  return hasValidEmailStructure(email)
                      ? null
                      : l10n.emailInvalidFormat;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _password,
                label: l10n.password,
                labelAbove: true,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                enabled: !_saving,
                validator: (value) => value == null || value.isEmpty
                    ? l10n.passwordRequired
                    : null,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              AppSelect<common.UserRole>(
                value: _role,
                label: l10n.role,
                labelAbove: true,
                wrapText: true,
                options: {
                  l10n.user: common.UserRole.USER_ROLE_USER,
                  l10n.administrator: common.UserRole.USER_ROLE_ADMIN,
                },
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) setState(() => _role = value);
                      },
              ),
              const SizedBox(height: 12),
              AppSelect<common.UserStatus>(
                value: _status,
                label: l10n.status,
                labelAbove: true,
                wrapText: true,
                options: {
                  l10n.active: common.UserStatus.USER_STATUS_ACTIVE,
                  l10n.banned: common.UserStatus.USER_STATUS_BANNED,
                },
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) setState(() => _status = value);
                      },
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppActionButton(
          onPressed: () => _finish(false),
          label: l10n.cancel,
          wrapLabel: true,
          style: AppActionButtonStyle.outlined,
        ),
        AppActionButton(
          onPressed: _saving ? null : _submit,
          label: l10n.create,
          wrapLabel: true,
          loading: _saving,
        ),
      ],
    );
  }
}
